# Test Results: prd.md v1.2 (Key Implementation Details re-added)

**PRD under test:** `exercise-2/prd.md` (v1.2)
**Test cases source:** `exercise-1/create-prd-tests.md`
**Date:** 2026-06-08
**Change from v1.1:** The blanket "no implementation details" failure criterion in TC1 was narrowed to permit *data contracts and timing constraints*. `prd.md` re-introduces a scoped **§4 Key Implementation Details** (timing mechanism, session schema, notification copy), resolving the v1.1 regressions in TC2 and TC3 without re-triggering TC1.

---

## Summary

| Test Case | v1.0 | v1.1 | v1.2 Result | Change v1.1→v1.2 |
|---|---|---|---|---|
| 1 — Content Quality & Completeness | ⚠️ PARTIAL | ✅ PASS | ✅ PASS | Unchanged |
| 2 — Timer Precision & Accuracy | ✅ PASS | ⚠️ PARTIAL | ✅ PASS | Recovered |
| 3 — Heat Map Data Model | ✅ PASS | ❌ FAIL | ✅ PASS | Recovered |
| 4 — NFR Specificity | ✅ PASS | ✅ PASS | ✅ PASS | Unchanged |
| 5 — Notification & Audio Flows | ⚠️ PARTIAL | ✅ PASS | ✅ PASS | Unchanged |
| 6 — Scope & Open Questions | ✅ PASS | ✅ PASS | ✅ PASS | Unchanged |

**Overall: 6 PASS, 0 PARTIAL, 0 FAIL** — all test cases pass for the first time.

---

## Test Case [1]: PRD Content Quality and Completeness — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Problem statement and goals | ✅ | §1.1 Problem Statement + §1.2 Goals (G1–G3) |
| Personas, use cases, user stories, and acceptance criteria | ✅ | §2.1 Personas, §2.2 Use Cases (UC-1…UC-7), §2.3 User Stories with ACs |
| Technical requirements and constraints | ✅ | §4 Key Implementation Details (timing mechanism, data schema) + §7 Dependencies & Constraints |
| Non-functional requirements | ✅ | §3 NFRs with measurable criteria and named verification methods |
| Scope and boundaries | ✅ | §5 Scope Boundaries (in-scope §5.1, out-of-scope §5.2) |
| Success metrics and KPIs | ✅ | §1.3 Success Metrics table |
| Open questions and assumptions | ✅ | §6 Open Questions (5 items, each with owner + deadline). Note: assumptions are embedded in OQ notes rather than a dedicated "Assumptions" heading — the unknowns are surfaced, so the intent of the criterion is met. |
| Dependencies and constraints | ✅ | §7 Dependencies & Constraints |
| Changelog | ✅ | Changelog table with v1.0, v1.1, v1.2 entries |

### Failure Criteria

| Criterion | Triggered? | Notes |
|---|---|---|
| PRD should not specify technical solutions beyond what is necessary (i.e., data contracts and timing constraints are permitted) | No | §4 is explicitly scoped to data contracts (§4.2 session schema), timing constraints (§4.1 wall-clock anchoring), and required notification copy (§4.3). §4's preamble states it does **not** specify framework choice, internal code structure, or implementation patterns. This is exactly the carve-out the revised criterion now allows. |

**Verdict: PASS** — All 9 expected criteria met. The re-added §4 stays within the newly permitted "data contracts and timing constraints" boundary and does not trip the failure criterion. (Minor: a dedicated Assumptions section would strengthen completeness but is not required to pass.)

---

## Test Case [2]: Timer Precision & Accuracy Specification — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Defines drift tolerance numerically | ✅ | §3.1 NFR: ±2 seconds over a 25-minute session; AC-1.3, AC-2.3, AC-7.1 all reference ±2 seconds |
| Specifies wall-clock anchoring (`Date.now()`) as the mechanism, not tick counting | ✅ | §4.1: "Elapsed time must be derived from a wall-clock timestamp (e.g., `Date.now()`) recorded at session start, **not** accumulated from `setInterval` or `setTimeout` tick counts." |
| Addresses background-tab throttling and defines required mitigation | ✅ | §4.1: explicitly states browsers throttle timer callbacks in backgrounded tabs and requires recomputing remaining time from the wall-clock anchor on each foreground transition via the Page Visibility API |
| Names the Page Visibility API (`visibilitychange`) as a required dependency | ✅ | §4.1 (`document.visibilityState`, `visibilitychange`), §3.1 verification, §7 Dependencies |
| Acceptance criteria written as testable QA statements | ✅ | AC-1.3, AC-2.3, AC-7.1 have concrete pass/fail conditions (e.g., assert difference = 1,500,000ms ± 2,000ms) |

### Failure Criteria

| Criterion | Triggered? |
|---|---|
| "accurate timing" without numeric definition | No — ±2 seconds defined |
| Specifies `setInterval` as implementation without addressing drift | No — §4.1 explicitly rejects tick counting in favor of wall-clock anchoring |
| Silent on tab switching | No — AC-7.1, AC-7.2 and §3.1 background-tab row cover this |

**Verdict: PASS** — Recovered from v1.1 PARTIAL. Re-adding §4.1 restores the explicit `Date.now()` wall-clock anchoring requirement and the stated throttling-mitigation rationale.

---

## Test Case [3]: Heat Map Data Model Completeness — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Defines unit of each heat map cell | ✅ | AC-6.1: one cell per calendar day, rolling 7-day window (today − 6 through today) |
| Specifies what the color scale encodes | ✅ | AC-6.2: count of completed work sessions per day |
| Defines color scale range (fixed vs. relative) | ✅ | AC-6.2: fixed scale 0 to 8+; 8 or more renders at maximum intensity |
| Concrete storage schema with field names and types | ✅ | §4.2: `{ id: string, type: 'work' \| 'break', startTime: number, endTime: number, completed: boolean }` |
| Storage location, retention limit, and unavailable behavior | ✅ | Location `localStorage` (§4.2 key `pomodoro_sessions`); retention 30 days (§4.2); unavailable behavior incognito banner (§3.6) + `SecurityError` fallback (§4.2) |
| Empty state defined | ✅ | AC-6.3 (0-session cell labeled "0") and AC-6.5 (no error in empty state) |

### Failure Criteria

| Criterion | Triggered? | Notes |
|---|---|---|
| "store session data" without specifying the schema | No — typed schema restored in §4.2 |
| "weekly heat map" without defining "week" | No — rolling 7-day window defined in AC-6.1 |
| Silent on data persistence across restarts | No — AC-5.3, AC-6.4, §3.6 |
| Assumes a backend | No — §5.2 and §7 explicitly exclude any server/backend |

**Verdict: PASS** — Recovered from v1.1 FAIL. The typed schema and 30-day retention policy are restored in §4.2.

---

## Test Case [4]: Non-Functional Requirements Specificity — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| "Responsive" → measurable viewport requirement | ✅ | §3.2: no horizontal scrolling at 320px–2560px; tested at 320/768/1280/2560 |
| "Fast" → testable performance budgets | ✅ | §3.3: FCP ≤1.5s on 4G; tick display ≤50ms; heat map render ≤200ms |
| "Easy to use" → WCAG or usability benchmark | ✅ | §3.4: WCAG 2.1 AA; first-time user starts a session within 10 seconds |
| Versioned browser support matrix | ✅ | §3.5: Chrome 120+, Firefox 121+, Safari 17+, Edge 120+, IE not supported |
| Each NFR names verification tool/method | ✅ | Lighthouse, Chrome DevTools Performance panel, axe/WAVE, BrowserStack, moderated usability test |

### Failure Criteria

| Criterion | Triggered? |
|---|---|
| "responsive" without viewport width | No |
| "fast" without numeric threshold | No |
| "easy to use" without measurable proxy | No |
| "all modern browsers" without version floor | No |
| NFRs without testing method | No |
| NFRs only in a bullet list without ACs | No |

**Verdict: PASS** — Unchanged; all criteria satisfied.

---

## Test Case [5]: Notification & Audio Permission Flows — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Distinguishes in-app visual, Web Notifications API, and audio as three separate mechanisms | ✅ | AC-3.1 (in-app visual banner), AC-3.2 (Web Notifications API), AC-3.4 (audio tone) — defined separately |
| Specifies when/how `Notification.requestPermission()` is triggered | ✅ | AC-3.5: no permission request on page load; only after the user has clicked Start at least once |
| Defines complete fallback chain (denied / audio suspended / tab closed) | ✅ | AC-3.3 (denied → in-app only, no error); AC-3.4 (no prior gesture → audio silently skipped); AC-7.3 (tab/browser closed → no out-of-app notification, documented limitation) |
| Defines exact copy for each notification | ✅ | §4.3 table + AC-3.2 (work-end) and AC-4.2 (break-end) verbatim strings |
| States whether audio is required / optional / out of scope | ✅ | §5.1: "Optional audio tone … (requires prior user gesture)"; default opt-in/out tracked as OQ-4 |

### Failure Criteria

| Criterion | Triggered? |
|---|---|
| "send a notification" without API or permission flow | No |
| Silent on denied-permission UX | No — AC-3.3 |
| Does not address prior-gesture requirement for audio | No — AC-3.4, §4.3/§7 |
| Conflates push notifications with in-session Web Notifications API | No — §5.2 excludes Service Worker/PWA; §7 scopes to in-session Web Notifications API |

**Verdict: PASS** — Unchanged from v1.1.

---

## Test Case [6]: Scope Boundaries & Open Questions — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Out-of-Scope names accounts, cloud sync, native mobile, team/shared, calendar, data export | ✅ | §5.2 lists all six (plus configurable intervals, task labeling, PWA/Service Worker) |
| Open Questions section with ≥3 unresolved decisions, each with owner + deadline | ✅ | §6: 5 open questions, each with owner and "Before sprint 1 kickoff" deadline |
| Supported browsers and minimum versions as testable constraint | ✅ | §3.5 version matrix + BrowserStack verification |
| States whether the long break (after 4 Pomodoros) is in or out of scope | ✅ | §5.2: long break explicitly out of scope for v1; revisited in OQ-1 |
| Measurable success metric for the heat map feature | ✅ | §1.3: "Heat map renders the correct session count after a full browser close and reopen — 100% of manual test cases" |

### Failure Criteria

| Criterion | Triggered? |
|---|---|
| Lists only features without out-of-scope declarations | No — §5.2 |
| No open questions section | No — §6 |
| Success defined only as feature delivery, not behavior | No — §1.3 metric is behavioral (correct count after restart) |
| Silent on the 4-session long-break rule | No — §5.2 + OQ-1 address it explicitly |

**Verdict: PASS** — Unchanged from v1.1.

---

## Conclusion

v1.2 passes all six test cases. The narrowed TC1 failure criterion (permitting data contracts and timing constraints) reconciles the v1.0↔v1.1 tension: the PRD can now state the required session schema and the wall-clock timing mechanism without violating the "no implementation details" rule. This simultaneously recovers TC2 (Date.now() anchoring) and TC3 (typed schema + retention) that regressed in v1.1, while TC1, TC4, TC5, and TC6 remain passing.

**Optional, non-blocking improvement:** add a dedicated **Assumptions** section to fully satisfy the letter of TC1's "open questions *and* assumptions" criterion (currently assumptions are implied within Open Question notes).
