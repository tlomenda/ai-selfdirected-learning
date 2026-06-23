# Initial Test Results: prd-bare.md

Graded against each test case in `create-prd-tests.md`.

```
"Write a product requirements document for a Pomodoro timer application with 25-minute work intervals, 5-minute break intervals, session tracking, and a weekly productivity heat map."
```

## Summary

| Test Case | Result |
|---|---|
| 1 — Content Quality & Completeness | ❌ FAIL |
| 2 — Timer Precision & Accuracy | ❌ FAIL |
| 3 — Heat Map Data Model | ❌ FAIL |
| 4 — NFR Specificity | ❌ FAIL |
| 5 — Notification & Audio Flows | ❌ FAIL |
| 6 — Scope & Open Questions | ❌ FAIL |

**Overall: 0 / 6 passed.**

The PRD reads as a solid high-level/feature-level document, but it fails every test because the tests demand engineering-grade specificity: numeric drift tolerances, named browser APIs (Date.now, Page Visibility, Web Notifications), a concrete storage schema, a versioned browser matrix, verification tooling, permission/fallback flows, an Open Questions section, and explicit long-break scoping. These are exactly the "bare prompt" gaps the exercise is designed to expose.

---

## Test Case [1]: PRD Content Quality and Completeness — ❌ FAIL

| Criterion | Result |
|---|---|
| Problem statement and goals | ⚠️ Partial — has Goals, but no explicit problem statement |
| Personas, use cases, user stories, acceptance criteria | ⚠️ Partial — has Target Users + User Stories, but no acceptance criteria |
| Technical requirements and constraints | ❌ Missing |
| Non-functional requirements | ✅ Present (§7) |
| Scope and boundaries | ✅ Present (§9) |
| Success metrics and KPIs | ✅ Present (§8) |
| Open questions and assumptions | ❌ Missing |
| Dependencies and constraints | ❌ Missing |
| Changelog | ❌ Missing |

**Verdict: FAIL** — Missing acceptance criteria, technical requirements, open questions/assumptions, dependencies, and changelog.

## Test Case [2]: Timer Precision & Accuracy Specification — ❌ FAIL

| Criterion | Result |
|---|---|
| Defines drift tolerance numerically | ⚠️ Says "±1 second" but not tied to session duration/QA testability |
| Specifies wall-clock anchoring (Date.now()) | ❌ Silent |
| Addresses background tab throttling + mitigation | ❌ Silent |
| Names Page Visibility API dependency | ❌ Silent |
| Acceptance criteria as testable QA statements | ❌ Missing |

**Failure criteria triggered:** Silent on tab-switching behavior; no drift mitigation mechanism specified.

**Verdict: FAIL**

## Test Case [3]: Heat Map Data Model Completeness — ❌ FAIL

| Criterion | Result |
|---|---|
| Defines heat map cell unit | ⚠️ Vague — "day/time block" (ambiguous) |
| Specifies what color scale encodes | ⚠️ Partial — "number of completed sessions" |
| Defines color scale range (fixed vs. relative) | ❌ Missing |
| Concrete storage schema with field names/types | ❌ Missing |
| Storage location + retention + unavailable behavior | ❌ Missing |
| Empty state definition | ❌ Missing |

**Failure criteria triggered:** Says "store session data" without schema; "week" defined ambiguously ("past 7 days or calendar week"); silent on incognito/storage-unavailable.

**Verdict: FAIL**

## Test Case [4]: Non-Functional Requirements Specificity — ❌ FAIL

| Criterion | Result |
|---|---|
| "Responsive" → measurable viewport requirement | ❌ Not addressed |
| "Fast" → testable performance budgets (FCP/TTI/tick latency) | ⚠️ Vague — "without noticeable delay" |
| "Easy to use" → benchmark or WCAG standard | ⚠️ Vague — "single interaction" |
| Versioned browser support matrix | ❌ Missing |
| Each NFR names verification tool/method | ❌ Missing |

**Failure criteria triggered:** Uses "noticeable delay" with no numeric threshold; uses usability claim with no measurable proxy; NFRs are a bullet list with no acceptance criteria.

**Verdict: FAIL**

## Test Case [5]: Notification & Audio Permission Flows — ❌ FAIL

| Criterion | Result |
|---|---|
| Distinguishes in-app / Web Notifications / audio alerts | ❌ Conflated as "audible/visual notification" |
| Specifies Notification.requestPermission() timing | ❌ Silent |
| Defines fallback chain (denied permission, suspended audio, closed tab) | ❌ Silent |
| Exact notification copy | ❌ Missing |
| States whether audio is required/optional/out of scope | ❌ Silent |

**Failure criteria triggered:** Says "notification" without API/permission flow; silent on denied permission; no AudioContext user-gesture handling.

**Verdict: FAIL**

## Test Case [6]: Scope Boundaries & Open Questions — ❌ FAIL

| Criterion | Result |
|---|---|
| Out-of-Scope names accounts, cloud sync, mobile, team, calendar, data export | ⚠️ Partial — covers team/sync/calendar, but missing user accounts & data export explicitly |
| Open Questions section (≥3, with owner + deadline) | ❌ Missing entirely |
| Supported browsers + min versions | ❌ Missing |
| Long-break (after 4 Pomodoros) in/out of scope | ❌ Silent in main scope (only vaguely mentioned in "Future Considerations") |
| Measurable heat map success metric | ❌ Missing (metrics are generic, not heat-map-specific behavior) |

**Failure criteria triggered:** No Open Questions section; success defined by feature delivery, not behavior; silent on the 4-session long-break rule as an explicit scope decision.

**Verdict: FAIL**
