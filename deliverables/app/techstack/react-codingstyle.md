# React + Vite + TypeScript Coding Style Guide for AI Coding Agents

**Target stack:** React 18+, Vite, TypeScript 5+
**Audience:** AI coding agents (Claude Code, Copilot, Cursor, etc.) generating or modifying code

This document defines conventions an AI agent should follow by default unless the repository's existing code clearly establishes a different pattern — in which case, match the existing pattern.

---

## 1. TypeScript Usage

- **`strict: true`** in `tsconfig.json` (implies `strictNullChecks`, `noImplicitAny`, etc.) — never weaken this to make code compile; fix the types instead.
- **Never use `any`.** Use `unknown` and narrow it, or define a proper type/interface. If a third-party type is genuinely unknown, isolate it behind a typed adapter function rather than letting `any` spread.
- Prefer **`type`** for unions, intersections, and function signatures; prefer **`interface`** for object shapes that might be extended (component props, entity models). Pick one convention per repo and stay consistent.
- Use **discriminated unions** for state that has distinct variants (loading/error/success) instead of multiple optional booleans.
  ```ts
  type FetchState<T> =
    | { status: "idle" }
    | { status: "loading" }
    | { status: "success"; data: T }
    | { status: "error"; error: Error };
  ```
- Avoid non-null assertions (`!`) — narrow the type properly or handle the `undefined`/`null` case explicitly.
- Co-locate types with the module that owns them (`OrderCard.tsx` + its `Order` type in the same file or an adjacent `types.ts`) rather than one giant global `types.ts`.
- Use `satisfies` to validate object literals against a type without widening the inferred type, e.g. for config objects.

---

## 2. Project Structure

- Organize by **feature**, not by technical type-only folder:
  ```
  src/
    features/
      orders/
        OrderList.tsx
        OrderCard.tsx
        useOrders.ts
        orders.api.ts
        orders.types.ts
    components/        # shared, cross-feature UI primitives only
    hooks/              # shared, cross-feature hooks only
    lib/                # framework-agnostic utilities, API client setup
    routes/             # route definitions / pages
  ```
  Avoid a single flat `components/` folder holding every component in the app once the project grows past a handful of screens.
- One component per file; filename matches the component name (`OrderCard.tsx` exports `OrderCard`).
- Barrel files (`index.ts` re-exporting a folder) are optional — use them for public feature boundaries, not for every folder, since they can hurt tree-shaking and build performance if overused.

---

## 3. Component Style

- **Function components only** — no class components, ever, even for error boundaries (use a small, well-tested library like `react-error-boundary` or a documented pattern, since error boundaries are the one case that still requires a class under the hood).
- Props are typed via an explicit `interface`/`type`, not inline object types repeated across files:
  ```tsx
  interface OrderCardProps {
    order: Order;
    onSelect?: (orderId: string) => void;
  }

  export function OrderCard({ order, onSelect }: OrderCardProps) {
    // ...
  }
  ```
- Prefer **named exports** over default exports for components — improves refactor/rename safety and autocomplete. Exception: the entry point required by a framework convention (e.g., a page file that a router expects to default-export).
- Keep components small and focused; extract a child component or a hook once a component mixes more than one concern (data fetching + complex layout + business logic in one file is a signal to split).
- Destructure props in the function signature rather than accessing `props.x` throughout the body.
- Avoid prop-drilling more than 2–3 levels — reach for context, composition (children props), or a state library instead.

---

## 4. Hooks

- Custom hooks encapsulate reusable stateful logic and always start with `use` (`useOrders`, `useDebouncedValue`).
- Follow the Rules of Hooks strictly — enforce via `eslint-plugin-react-hooks` (`rules-of-hooks`, `exhaustive-deps`) and do not disable `exhaustive-deps` inline without a comment explaining why.
- Keep `useEffect` usage minimal and purposeful — most "sync state to prop" or "derived state" use cases should be plain computation during render, not an effect. Reach for `useEffect` for actual side effects (subscriptions, imperative DOM APIs, syncing with non-React systems), not as a general-purpose lifecycle hook.
- Memoize (`useMemo`/`useCallback`) only when there's a measured performance reason (expensive computation, stable reference required by a memoized child or effect dependency array) — don't wrap everything reflexively.

---

## 5. State Management

- Local component state: `useState`/`useReducer`.
- Cross-component/shared client state: pick one deliberate solution (Context + `useReducer` for simple cases, Zustand/Redux Toolkit for larger apps) — don't mix multiple global state libraries in the same app without a clear reason.
- **Server state (data fetched from an API) is not the same as client state** — use TanStack Query (React Query) or SWR for fetching/caching/invalidation instead of manually managing `useState` + `useEffect` fetch logic. This eliminates most manual loading/error/race-condition boilerplate.
  ```tsx
  const { data, isLoading, error } = useQuery({
    queryKey: ["orders", customerId],
    queryFn: () => fetchOrders(customerId),
  });
  ```
- Keep global state minimal — most state should live as close as possible to where it's used.

---

## 6. Data Fetching & API Layer

- Isolate all HTTP calls in a dedicated API layer per feature (`orders.api.ts`), returning typed responses — components never call `fetch`/`axios` directly.
- Define request/response types matching the backend contract; if the backend exposes an OpenAPI spec, prefer generating types from it (`openapi-typescript`) over hand-maintaining duplicate types.
- Centralize the base HTTP client (base URL, auth header injection, error normalization) in one place (`lib/apiClient.ts`), not reimplemented per feature.
- Handle errors at the API layer boundary — throw typed errors that calling code (or React Query's `error` state) can handle, not raw unchecked exceptions surfaced straight from `fetch`.

---

## 7. Styling

- Pick one styling approach per project and apply it consistently — CSS Modules, Tailwind CSS, or a CSS-in-JS library (vanilla-extract, styled-components) — don't mix multiple approaches for new code in the same codebase.
- If using Tailwind: use utility classes directly in JSX; extract a component (not a CSS abstraction) when a utility combination repeats across the app.
- If using CSS Modules: co-locate `Component.module.css` next to `Component.tsx`.
- Avoid inline `style={{ ... }}` except for genuinely dynamic values (computed positions, dynamic colors) that can't be expressed as a class.

---

## 8. Routing

- Use a single routing library consistently (React Router or TanStack Router) — define routes declaratively in a dedicated `routes/` structure rather than scattering `<Route>` definitions across the app.
- Lazy-load route-level components (`React.lazy` + `Suspense`, or the router's built-in lazy loading) to keep initial bundle size down, especially for larger apps.
- Co-locate route-specific data loading with the route definition where the router supports it (loaders), rather than fetching inside the component's `useEffect` after mount.

---

## 9. Performance & Bundle

- Rely on Vite's default code-splitting (dynamic `import()`) for route- and feature-level chunks rather than one large bundle.
- Avoid importing an entire library when only a small part is used (e.g., import specific date-fns functions, not the whole library as a namespace) to keep tree-shaking effective.
- Use the `key` prop correctly on list items — a stable, unique ID from the data, never the array index for lists that can reorder/filter/insert.
- Avoid unnecessary re-renders from inline object/array/function literals passed as props to memoized children — this is a case where `useMemo`/`useCallback` earn their cost (see §4).

---

## 10. Testing

- **Unit/component tests**: Vitest (Vite-native, Jest-compatible API) + React Testing Library. Test behavior from the user's perspective (`getByRole`, `getByText`) — not implementation details (no testing internal state or calling private component methods).
- **E2E tests**: Playwright, in a separate top-level directory (`e2e/`), run against a built/served app rather than in the unit test runner.
- Avoid over-mocking in component tests — mock network calls (via `msw` — Mock Service Worker — for realistic request interception) rather than mocking the API layer's functions directly, so tests exercise real component + fetching-library behavior.
- Naming: `ComponentName.test.tsx` co-located next to the component, or a mirrored `__tests__/` structure — pick one convention per repo.
- No arbitrary `setTimeout`/`sleep` waits in tests — use Testing Library's `findBy*`/`waitFor` (auto-retrying) or Playwright's auto-waiting.

---

## 11. Linting & Formatting

- ESLint with `@typescript-eslint`, `eslint-plugin-react`, `eslint-plugin-react-hooks`, and `eslint-plugin-jsx-a11y` at minimum.
- Prettier for formatting, run via a pre-commit hook (`lint-staged` + `husky`) or CI check — don't hand-format to match Prettier; let the tool do it.
- Follow whatever ESLint config already exists in the repo over this guide's defaults where they conflict; don't silently add `// eslint-disable` comments to work around a rule — fix the underlying issue or discuss changing the rule.

---

## 12. Accessibility

- Use semantic HTML elements (`<button>`, `<nav>`, `<label>`) before reaching for ARIA attributes — ARIA supplements semantics, it doesn't replace them.
- Every interactive element must be keyboard-operable and have an accessible name (visible text, `aria-label`, or associated `<label>`).
- Images require meaningful `alt` text (or `alt=""` if purely decorative) — never omit `alt` entirely.
- Run `eslint-plugin-jsx-a11y` as part of linting (see §11) rather than relying on manual review alone.

---

## 13. Vite Configuration

- Keep `vite.config.ts` typed and minimal; use `defineConfig` for editor autocomplete.
- Use environment variables via Vite's `import.meta.env`, prefixed `VITE_` for anything exposed to client code — never put secrets in `VITE_`-prefixed variables since they're bundled into client-visible code.
- Configure path aliases (`@/` → `src/`) in both `vite.config.ts` and `tsconfig.json` `paths` so they stay in sync — a mismatch here is a common source of "works in editor, fails at build" bugs.

---

## 14. What AI Agents Should Do Before Generating Code

1. Check `tsconfig.json`, `.eslintrc`/`eslint.config.js`, and `vite.config.ts` before assuming strictness level, path aliases, or plugin availability.
2. Check `package.json` for the state management, styling, routing, and data-fetching libraries already installed — follow the existing choice rather than introducing a competing library for the same concern.
3. Match existing component patterns (props typing style, export style, file organization) in neighboring files before introducing a new pattern.
4. Do not introduce new dependencies (a new state library, a new styling approach, a new date library, etc.) without flagging it — check what's already in `package.json` first.
5. Confirm the React version (`react` in `package.json`) before using version-specific APIs (e.g., `use()`, Actions, `useOptimistic`, Server Components) since these are not all available or meaningful outside a framework like Next.js/Remix that supports RSC.