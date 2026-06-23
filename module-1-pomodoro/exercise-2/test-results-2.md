# Test Results: prd.md v1.1 (Implementation Environment removed)

**PRD under test:** `exercise-2/prd.md` (v1.1)
**Test cases source:** `exercise-1/create-prd-tests.md`
**Date:** 2026-06-08
**Change from v1.0:** `create-prd.md` prompt removed `Implementation Environment` from required sections; `prd.md` updated accordingly (§4 removed, TC5 gaps resolved via new ACs, sections renumbered).

---

## Summary

| Test Case | v1.0 Result | v1.1 Result | Change |
|---|---|---|---|
| 1 — Content Quality & Completeness | ⚠️ PARTIAL PASS | ✅ PASS | Improved |
| 2 — Timer Precision & Accuracy | ✅ PASS | ⚠️ PARTIAL PASS | Regressed |
| 3 — Heat Map Data Model | ✅ PASS | ❌ FAIL | Regressed |
| 4 — NFR Specificity | ✅ PASS | ✅ PASS | Unchanged |
| 5 — Notification & Audio Flows | ⚠️ PARTIAL PASS | ✅ PASS | Improved |
| 6 — Scope & Open Questions | ✅ PASS | ✅ PASS | Unchanged |

**Overall: 4 PASS, 1 PARTIAL PASS, 1 FAIL** (same count as v1.0, but different distribution)

---

## Test Case [1]: PRD Content Quality and Completeness — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Problem statement and goals | ✅ | §1.1 Problem Statement + §1.2 Goals |
| Personas, use cases, user stories, and acceptance criteria | ✅ | §2.1 Personas, §2.2 Use Cases, §2.3 User Stories with ACs |
| Technical requirements and constraints | ✅ | §6 Dependencies & Constraints names required browser APIs and architectural constraints |
| Non-functional requirements | ✅ | §3 NFRs with measurable criteria and named verification methods |
| Scope and boundaries | ✅ | §4 Scope Boundaries (in-scope §4.1, out-of-scope §4.2) |
| Success metrics and KPIs | ✅ | §1.3 Success Metrics table |
| Open questions and assumptions | ✅ | §5 Open Questions (5 items with owner + deadline) |
| Dependencies and constraints | ✅ | §6 Dependencies & Constraints |
| Changelog | ✅ | Changelog table with v1.0 and v1.1 entries |

### Failure Criteria

| Criterion | Triggered? | Notes |
|---|---|---|
| PRD should not specify implementation details or technical solutions | No | The §4 Implementation Environment section — which contained the typed schema, timing algorithm walkthrough, and explicit API implementation prescriptions — has been removed. Remaining API names appear in §6 Dependencies (listing constraints, not prescriptions) and §3 NFR verification columns (describing test methodology, not implementation). |

**Verdict: PASS** — Removing the Implementation Environment section resolved the v1.0 conflict. All 9 expected criteria are still met via other sections.

---

## Test Case [2]: Timer Precision & Accuracy Specification — ⚠️ PARTIAL PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Defines drift tolerance numerically | ✅ | §3.1 NFR: ±2 seconds; AC-1.3, AC-2.3, AC-7.1 all reference ±2 seconds |
| Specifies wall-clock anchoring (Date.now()) as the mechanism | ⚠️ Partial | ACs and NFRs consistently reference "wall-clock time" as the baseline (AC-1.2, AC-1.3, AC-2.3, AC-7.1), but the mechanism for measuring wall-clock time (e.g., recording a start timestamp and computing delta) is no longer stated. `Date.now()` is not named anywhere in the document. |
| Addresses background tab throttling and defines required mitigation | ⚠️ Partial | AC-7.1/7.2 define the behavioral requirement. §3.1 NFR defines the ±2-second background-tab drift tolerance. However, the explicit statement that `setInterval`/`setTimeout` throttling is the cause and wall-clock anchoring is the required remedy (previously in §4.2) has been removed. |
| Names the Page Visibility API (`visibilitychange`) | ✅ | §3.1 NFR verification references the Page Visibility API `visibilitychange` event as the test mechanism. §6 Dependencies lists it as a required dependency. |
| Acceptance criteria written as testable QA statements | ✅ | AC-1.3, AC-2.3, AC-7.1 are all executable by a QA engineer with concrete pass/fail conditions |

### Failure Criteria

| Criterion | Triggered? |
|---|---|
| "accurate timing" without numeric definition | No — ±2 seconds is defined |
| Specifies `setInterval` without addressing drift | No |
| Silent on tab switching | No — AC-7.1 and AC-7.2 address this |

**Verdict: PARTIAL PASS** — All failure criteria avoided. Drift tolerance is numerically defined and the Page Visibility API is named. However, the explicit statement that elapsed time must be measured via wall-clock anchoring (rather than tick counting) is gone with §4.2, and `Date.now()` is not named. The PRD tells QA *what* the timer must achieve but no longer tells the developer *how* the timing mechanism must work to achieve it.

---

## Test Case [3]: Heat Map Data Model Completeness — ❌ FAIL

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Defines unit of each heat map cell | ✅ | AC-6.1: one cell per calendar day, rolling 7-day window |
| Specifies what color scale encodes | ✅ | AC-6.2: count of completed work sessions |
| Defines color scale range (fixed vs. relative) | ✅ | AC-6.2: fixed scale of 0 to 8+ sessions |
| Concrete storage schema with field names and types | ❌ | §4.3 (typed schema) was removed with the Implementation Environment section. No schema exists in the document. |
| Storage location, retention limit, and unavailable behavior | ⚠️ Partial | Storage location (`localStorage`) is named in §3.6, §4.1, §4.2, and §6. Unavailable behavior (incognito banner) is in §3.6. However, the 30-day retention policy was in §4.3 and is now gone. |
| Empty state defined | ✅ | AC-6.3 and AC-6.5 |

### Failure Criteria

| Criterion | Triggered? | Notes |
|---|---|---|
| "store session data" without specifying the schema | ✅ YES — TRIGGERED | The PRD requires session data to persist (AC-5.3, AC-6.4, §3.6) but no longer specifies a storage schema with field names and types. A developer must infer or decide the data model independently. |
| "weekly heat map" without defining "week" | No — rolling 7-day window is defined in AC-6.1 | |
| Silent on data persistence across restarts | No — AC-5.3, AC-6.4, §3.6 | |
| Assumes a backend | No — §4.2 Out of Scope explicitly excludes server-side storage | |

**Verdict: FAIL** — The typed session data schema (previously in §4.3) was removed with the Implementation Environment section. The retention policy (30 days) is also gone. A developer cannot determine what fields to store, their types, or how long to keep records. This is a direct consequence of removing the Implementation Environment section and represents an unresolved trade-off with TC1.

---

## Test Case [4]: Non-Functional Requirements Specificity — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| "Responsive" → measurable viewport requirement | ✅ | §3.2: 320px to 2560px, no horizontal scrollbar |
| "Fast" → testable performance budgets | ✅ | §3.3: FCP ≤1.5s on 4G; tick display ≤50ms; heat map ≤200ms |
| "Easy to use" → WCAG or usability benchmark | ✅ | §3.4: WCAG 2.1 AA; first-time user starts session within 10 seconds |
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
| NFRs only in bullet list without ACs | No |

**Verdict: PASS** — No changes to NFR section; all criteria remain satisfied.

---

## Test Case [5]: Notification & Audio Permission Flows — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Distinguishes in-app visual, Web Notifications API, and audio as three separate mechanisms | ✅ | AC-3.1 (in-app visual banner), AC-3.2 (Web Notifications API with exact copy), AC-3.4 (audio tone) — each defined separately |
| Specifies when and how `Notification.requestPermission()` is triggered | ✅ | AC-3.5 (new in v1.1): "must not request notification permission on page load; permission may only be requested after the user has explicitly clicked the Start button at least once" |
| Defines complete fallback chain | ✅ | AC-3.3: denied permission → in-app only, no error; AC-3.4: no prior gesture → audio silently skipped; AC-7.3 (new in v1.1): tab/browser closed → no notification delivered, documented as known limitation |
| Defines exact notification copy | ✅ | AC-3.2: "Pomodoro complete!" / "Time for a break. Your 5-minute break has started."; AC-4.2: "Break over!" / "Ready for another Pomodoro? Click to start." |
| States whether audio is required, optional, or out of scope | ✅ | §4.1 In Scope: "Optional audio tone at session and break end"; AC-3.4: silently skipped when unavailable |

### Failure Criteria

| Criterion | Triggered? |
|---|---|
| "send a notification" without API/permission flow | No |
| Silent on denied permission UX | No — AC-3.3 |
| No `AudioContext` user-gesture requirement | No — AC-3.4 |
| Conflates push notifications with in-session alerts | No — §4.2 Out of Scope excludes Service Workers |

**Verdict: PASS** — The two gaps from v1.0 (permission timing and tab-closed fallback) are resolved by AC-3.5 and AC-7.3. All five expected criteria are now met and no failure criteria are triggered.

---

## Test Case [6]: Scope Boundaries & Open Questions — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Out-of-Scope names: user accounts, cloud sync, mobile native, team sessions, calendar, data export | ✅ | §4.2: all six listed plus additional exclusions |
| Open Questions ≥3 with owner and resolution deadline | ✅ | §5: 5 OQs, each with Owner and Resolution Deadline |
| Browser versions as testable constraint | ✅ | §3.5 NFR browser support table |
| Long break explicitly in or out of scope | ✅ | §4.2: "Long break… Out of scope for v1; see OQ-1"; OQ-1 flags it as unresolved |
| Measurable heat map success metric | ✅ | §1.3: "Heat map renders correct session count after a full browser close and reopen — 100% of manual test cases" |

### Failure Criteria

| Criterion | Triggered? |
|---|---|
| Only features, no out-of-scope declarations | No |
| No open questions section | No |
| Success defined only by feature delivery | No |
| Silent on the 4-session long-break rule | No |

**Verdict: PASS** — No changes to Scope or Open Questions sections; all criteria remain satisfied.

---

## Key Findings: The TC1 vs. TC2/TC3 Trade-Off

Removing the Implementation Environment section made the results shift — not uniformly improve:

| What improved | Why |
|---|---|
| TC1 now fully passes | No more implementation prescriptions (algorithm, typed schema, API usage patterns) |
| TC5 now fully passes | New ACs (AC-3.5, AC-7.3) closed the permission-timing and tab-closed gaps independently of the removed section |

| What regressed | Why |
|---|---|
| TC2 now partial | Wall-clock anchoring as an explicit mechanism statement is gone (§4.2 removed); `Date.now()` no longer named |
| TC3 now fails | Typed session data schema (§4.3) is gone; retention policy is gone; a developer has no data contract |

### Root cause: an unresolvable tension in the test suite

TC1 prohibits implementation details. TC2 requires naming a specific timing mechanism (`Date.now()`). TC3 requires a concrete typed schema with field names. TC5 required naming `Notification.requestPermission()` (resolved via behavioral ACs). These test cases pull in opposite directions:

- A PRD without an Implementation Environment section fully satisfies TC1 but cannot satisfy TC2's mechanism requirement or TC3's schema requirement.
- A PRD with an Implementation Environment section satisfies TC2 and TC3 but triggers TC1's failure criterion.

The remaining gap (TC3 schema, TC2 mechanism) can only be resolved by one of:
1. Accepting that developer-ready PRDs for browser apps must include a data contract and timing constraint section — and softening TC1's failure criterion to permit "data contracts" and "required API constraints" as distinct from "implementation details."
2. Adding the schema and timing constraint back as a `Data Requirements` or `Technical Constraints` section with a narrower scope than the removed Implementation Environment.
