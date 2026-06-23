# Test Results: prd.md (Generated from create-prd.md prompt)

**PRD under test:** `exercise-2/prd.md`
**Test cases source:** `exercise-1/create-prd-tests.md`
**Date:** 2026-06-08

---

## Summary

| Test Case | Result |
|---|---|
| 1 — Content Quality & Completeness | ⚠️ PARTIAL PASS |
| 2 — Timer Precision & Accuracy | ✅ PASS |
| 3 — Heat Map Data Model | ✅ PASS |
| 4 — NFR Specificity | ✅ PASS |
| 5 — Notification & Audio Permission Flows | ⚠️ PARTIAL PASS |
| 6 — Scope Boundaries & Open Questions | ✅ PASS |

**Overall: 4 PASS, 2 PARTIAL PASS, 0 FAIL**

---

## Test Case [1]: PRD Content Quality and Completeness — ⚠️ PARTIAL PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Problem statement and goals | ✅ | §1.1 Problem Statement + §1.2 Goals |
| Personas, use cases, user stories, and acceptance criteria | ✅ | §2.1 Personas, §2.2 Use Cases, §2.3 User Stories with detailed ACs per story |
| Technical requirements and constraints | ✅ | §4 Implementation Environment (required APIs, timing constraint, schema) |
| Non-functional requirements | ✅ | §3 NFRs with measurable criteria and verification methods |
| Scope and boundaries | ✅ | §5 Scope Boundaries (in-scope §5.1, out-of-scope §5.2) |
| Success metrics and KPIs | ✅ | §1.3 Success Metrics table |
| Open questions and assumptions | ✅ | §6 Open Questions (5 items with owner + deadline) |
| Dependencies and constraints | ✅ | §7 Dependencies & Constraints |
| Changelog | ✅ | Changelog table at top of document |

### Failure Criteria

| Criterion | Triggered? | Notes |
|---|---|---|
| PRD should not specify implementation details or technical solutions | ⚠️ YES — but unavoidable | §4 names specific APIs (`Date.now` anchoring, Page Visibility API, `localStorage`, `AudioContext`) and includes a typed data schema. This technically triggers the failure criterion. However, this content is *required* by the `create-prd.md` prompt (which mandates an "Implementation Environment" section) and is also required to pass TC2, TC3, and TC5. The conflict is inherent in the test suite, not a deficiency of the prompt. |

**Verdict: PARTIAL PASS** — All 9 expected criteria are present. The failure criterion is triggered, but only because it directly conflicts with the prompt's required "Implementation Environment" section and the specificity demanded by TC2–TC5. This tension exposes an open design question: does a developer-ready PRD for a browser application require naming browser APIs and data contracts, and if so, does that constitute "implementation detail"?

---

## Test Case [2]: Timer Precision & Accuracy Specification — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Defines acceptable timer drift tolerance numerically | ✅ | §3.1 NFR: "must not deviate from wall-clock time by more than ±2 seconds over any complete 25-minute session"; AC-1.3, AC-2.3, AC-7.1 |
| Specifies wall-clock anchoring (not tick counting) | ✅ | §4.2: "anchoring to wall-clock time… rather than by counting discrete timer callbacks" |
| Addresses background tab throttling + required mitigation | ✅ | §4.2 explicitly explains why throttling makes tick-counting unreliable; §4.1 names Page Visibility API as the mitigation mechanism |
| Names the Page Visibility API (`visibilitychange`) | ✅ | §4.1 Required Browser APIs table; §3.1 NFR verification |
| Acceptance criteria written as testable QA statements | ✅ | AC-1.3 ("assert difference is 1,500,000ms ± 2,000ms"), AC-7.1, AC-7.2 — each is executable by a QA engineer |

### Failure Criteria

| Criterion | Triggered? |
|---|---|
| "accurate timing" without numeric definition | No |
| Specifies `setInterval` without addressing drift | No |
| Silent on tab switching for 10 minutes | No — AC-7.1/7.2 and §4.2 explicitly address this |

**Verdict: PASS**

---

## Test Case [3]: Heat Map Data Model Completeness — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Defines unit of each heat map cell | ✅ | AC-6.1: "one cell per calendar day, rolling 7-day window (today minus 6 days through today)" |
| Specifies what color scale encodes | ✅ | AC-6.2: "count of completed work sessions for that day" |
| Defines color scale range (fixed vs. relative) | ✅ | AC-6.2: "fixed scale of 0 to 8+ sessions; 8 or more renders at maximum intensity" |
| Concrete storage schema with field names and types | ✅ | §4.3: full typed schema (`id: string`, `type: 'work' \| 'break'`, `startTime: number`, `endTime: number`, `completed: boolean`) |
| Storage location, retention limit, unavailable behavior | ✅ | §4.3: `localStorage`, key `pomodoro_sessions`, 30-day retention; §3.6 NFR: incognito banner + timer still works |
| Empty state defined | ✅ | AC-6.3: "0 sessions renders in lowest-intensity color, labeled '0'"; AC-6.5: "No error message appears in empty state" |

### Failure Criteria

| Criterion | Triggered? |
|---|---|
| "store session data" without schema | No — §4.3 provides a typed schema |
| "weekly heat map" without defining "week" | No — AC-6.1 explicitly defines rolling 7-day window |
| Silent on data persistence across browser restarts | No — §3.6 and AC-5.3, AC-6.4 each address this |
| Assumes a backend without declaring it | No — §7 explicitly states "no backend / no server" |

**Verdict: PASS**

---

## Test Case [4]: Non-Functional Requirements Specificity — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| "Responsive" → measurable viewport requirement | ✅ | §3.2: "320px (iPhone SE) to 2560px (wide desktop); no horizontal scrollbar" |
| "Fast" → specific testable performance budgets | ✅ | §3.3: FCP ≤1.5s on simulated 4G; tick display ≤50ms; heat map render ≤200ms |
| "Easy to use" → WCAG standard or usability benchmark | ✅ | §3.4: WCAG 2.1 Level AA; first-time user starts session within 10 seconds (3-user usability test) |
| "All modern browsers" → explicit versioned support matrix | ✅ | §3.5: Chrome 120+, Firefox 121+, Safari 17+, Edge 120+; IE explicitly not supported |
| Each NFR names verification tool/method | ✅ | Lighthouse (FCP, heat map), Chrome DevTools Performance panel (tick latency), axe/WAVE (WCAG), BrowserStack (cross-browser), moderated usability test (first-time use) |

### Failure Criteria

| Criterion | Triggered? |
|---|---|
| "responsive" without viewport width | No |
| "fast" without numeric threshold | No |
| "easy to use" without measurable proxy | No |
| "all modern browsers" without named version floor | No |
| NFRs without testing method | No |
| NFRs only in bullet list without acceptance criteria | No — each NFR is in a table with its own testable requirement and named verification method |

**Verdict: PASS**

---

## Test Case [5]: Notification & Audio Permission Flows — ⚠️ PARTIAL PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Distinguishes in-app visual, Web Notifications API, and audio as three separate mechanisms | ✅ | AC-3.1 (in-app visual banner), AC-3.2 (Web Notifications API), AC-3.4 (Web Audio API / `AudioContext`) — each defined separately |
| Specifies when/how `Notification.requestPermission()` is triggered | ✅ | §4.1: "Permission must be requested after the user's first explicit interaction with the timer (Start button click), not on page load" |
| Defines complete fallback chain for denied permission and suspended audio | ✅ | AC-3.3: denied permission → in-app visual only, no error shown; AC-3.4: no prior gesture → audio silently skipped |
| Fallback when the tab is closed | ⚠️ NOT addressed | The PRD covers backgrounded tabs (AC-7.2) but does not explicitly state what happens when the tab (or browser) is closed while a timer is running. Given that a Service Worker is explicitly out of scope (§5.2), no notification can fire when the tab is closed — but this is not stated as a behavior. |
| Defines exact copy for each notification | ✅ | §4.4: exact title and body for work-end and break-end events, and in-app banner fallback copy |
| States whether audio is required, optional with default, or out of scope | ✅ | §5.1: "Optional audio tone"; AC-3.4: "optional... silently skipped if no prior gesture" |

### Failure Criteria

| Criterion | Triggered? |
|---|---|
| "send a notification" without API/permission flow | No — API and permission flow fully specified |
| Silent on denied permission UX | No — AC-3.3 addresses this |
| No `AudioContext` user-gesture requirement | No — AC-3.4 addresses this |
| Conflates push notifications with in-session Web Notifications alerts | No — §5.2 explicitly excludes Service Workers; §4.1 names Web Notifications API (not push) |

**Verdict: PARTIAL PASS** — All expected criteria met except the behavior when the tab is closed mid-session. The PRD addresses backgrounded tabs (AC-7.2) but is silent on tab/browser close. Since a Service Worker is out of scope, no notification can fire in that case — this should be explicitly stated as a known limitation.

---

## Test Case [6]: Scope Boundaries & Open Questions — ✅ PASS

### Expected Output Criteria

| Criterion | Result | Evidence |
|---|---|---|
| Dedicated Out-of-Scope section naming: user accounts, cloud sync, mobile native, team/shared sessions, calendar integrations, data export | ✅ | §5.2: all six explicitly listed, plus additional exclusions (configurable durations, long break, task labels, PWA) |
| Open Questions section with ≥3 items, each with owner and resolution deadline | ✅ | §6: 5 open questions, each with Owner and Resolution Deadline columns |
| Supported browsers and minimum versions as testable constraint | ✅ | §3.5 NFR browser support table |
| Long break (after 4 Pomodoros) explicitly in or out of scope — not silent | ✅ | §5.2: "Long break… Out of scope for v1; see OQ-1"; OQ-1 flags it as an unresolved question |
| Measurable heat map success metric | ✅ | §1.3: "Heat map renders correct session count after a full browser close and reopen — 100% of manual test cases" |

### Failure Criteria

| Criterion | Triggered? |
|---|---|
| Only features listed with no out-of-scope declarations | No |
| No open questions section | No |
| Success defined only by feature delivery ("heat map is built") | No — success is defined by observable behavior after browser restart |
| Silent on the traditional 4-session long-break rule | No — explicitly addressed in §5.2 and OQ-1 |

**Verdict: PASS**

---

## Key Findings

### Improvements Over prd-bare.md (0/6 pass)

The RTCC prompt (`create-prd.md`) produced significant improvements over the bare prompt:

| Area | prd-bare.md | prd.md |
|------|------------|--------|
| Acceptance criteria | None | Full set per user story |
| Timer drift spec | Vague "±1 second" | ±2 seconds, wall-clock anchored, background-tab tested |
| Storage schema | None | Typed schema with field names, key, and retention policy |
| Heat map definition | Ambiguous "7 days or calendar week" | Explicit rolling 7-day window, fixed 0–8+ color scale, empty state |
| NFR measurability | Vague ("noticeable delay") | Numeric budgets with named verification tools |
| Browser support | Not addressed | Versioned matrix with named testing tool |
| Notification flows | Conflated ("audible/visual") | Three distinct mechanisms with permission timing and fallback chain |
| Out-of-scope list | Partial | All six required items plus additional exclusions |
| Open questions | None | 5 questions with owner and deadline |
| Changelog + dependencies | None | Both present |

### Remaining Gaps (causes of partial passes)

1. **TC1 failure criterion conflict:** TC1 requires no implementation details, but the prompt mandates an "Implementation Environment" section, and TC2–TC5 require naming specific APIs and data contracts. These requirements are mutually exclusive as written.

2. **TC5 — "tab closed" fallback:** The PRD addresses backgrounded tabs but does not explicitly state the behavior when the tab or browser is closed while a timer is running (i.e., no notification fires because no Service Worker is in scope). This should be added as a stated limitation in §5.2 or §4.4.
