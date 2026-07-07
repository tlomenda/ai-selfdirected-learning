## Test Case [1]: Code Quality Assessment

**Input**: A clear, actionable technical implementation plan to implement a user story

**Expected Output Criteria**

- TypeScript: Type Safety. All types (eg: db row shapes, API request/response shapes) are explicitly types (no 'any')
- TypeScript: Types are shared/reused between backend and frontend (not redefined twice)
- Error handling: All incoming request bodies/params/query strings are validated before use
- Error Handling: DB/constraint errors map to correct HTTP status codes (400/404/409/500), not generic 500s
- Error Handling: React UI has explicit loading / error / empty / success states for every fetch
- Data: Multi-step writes use a transaction
- Data: Schema changes are captured in a migration file
- Data: All SQL queries are parameterized (no string-interpolated values)

**Failure Criteria (must NOT occur):**

- Uses any for database row types.
- Uses any for API request or response payloads.
- Database query results are not assigned to explicit interfaces or types.
- API request bodies, query parameters, or path parameters are untyped.
- API responses are returned without an explicit type definition.
- Types are inferred from unvalidated external data rather than defined or validated schemas.
- Type assertions (e.g., as any) are used to bypass type checking without justification.
- TypeScript cannot detect invalid property access due to missing or overly broad types.

---

## Test Case [2]: Testing Practices

**Input**: A clear, actionable technical implementation plan to implement a user story

**Expected Output Criteria**

- Each API route has a test for its success case AND its main failure case
- Non-trivial logic (validation, query building, reducers) has a unit test
- Tests assert on behavior/output, not internal implementation
- Every acceptance criterion has at least one test mapped to it (traceable — not just "some tests exist somewhere")
- Happy path: the expected/valid input produces the expected output or state change
- At least one error path per criterion — e.g. invalid input, missing resource, unauthorized, conflict, or DB failure
- Edge cases inherent to the story are covered (empty list, boundary values, duplicate submission) — not just generic try/catch tests
- Tests fail if the behavior regresses (assert on real output/status/state, not that a function was "called")
- No acceptance criterion is covered only indirectly through an unrelated test

**Failure Criteria (must NOT occur):**

- Tests are flaky, non-deterministic, or intermittently fail.
- External dependencies are not isolated or appropriately mocked/stubbed in unit tests.
- Tests are tightly coupled to implementation details, making them brittle to refactoring.
- No automated tests exist for new or modified functionality.
- Tests do not cover expected behavior and key edge cases.

---

## Test Case [3]: Technology Stack Compliance

**Input**: A clear, actionable technical implementation plan to implement a user story

**Expected Output Criteria**

- **Postgres**: schema changes via migrations; queries use parameterization; relational integrity (FKs, constraints) used instead of app-level checks where Postgres can enforce it natively
- **Express/Node**: routes follow the project's existing router/middleware structure (e.g. shared error-handling middleware, not per-route try/catch reinventing the same logic); async errors are passed to `next()` or handled by an async wrapper, not left to crash the process
- **React**: data fetching follows the project's established pattern (e.g. existing hooks/context/query library) rather than a one-off `useEffect` + `fetch`; component structure matches existing conventions (file layout, state management approach, styling method)
- No "generic" implementation was substituted where the stack already has an idiomatic way to do it (e.g. hand-rolled validation instead of the project's validation library, raw SQL string building instead of the query builder already in use)
- Naming, file organization, and error-response shape match what's already established elsewhere in the codebase — a reviewer shouldn't be able to tell this was written differently from the rest of the app

**Failure Criteria (must NOT occur):**

- Unapproved dependency or framework added.
- Unsupported runtime or language version used.
- Required platform SDK or shared library bypassed.

