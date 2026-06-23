# Product Requirements Document: Pomodoro Timer (Web Application)

**Version:** 1.2
**Date:** 2026-06-08
**Status:** Draft

---

## Changelog

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.2 | 2026-06-08 | Product Manager | Replaced Implementation Environment with Key Implementation Details section (scoped to necessary data contracts and timing constraint only); renumbered sections |
| 1.1 | 2026-06-08 | Product Manager | Removed Implementation Environment section per prompt update; moved notification permission-timing and tab-closed fallback into User Story ACs; renumbered sections |
| 1.0 | 2026-06-08 | Product Manager | Initial draft |

---

## 1. Product Overview

### 1.1 Problem Statement

Knowledge workers and students frequently struggle to sustain focus during long work sessions, leading to fatigue, diminished output quality, and difficulty estimating how much focused time they actually invest. Without an external structure for managing attention, it is easy to work in an unfocused, reactive mode with no awareness of actual productive time. Users also lack a lightweight way to visualize whether their productivity habits are consistent across days and weeks.

### 1.2 Goals

- **G1:** Give users a reliable, low-friction mechanism to structure work into focused 25-minute intervals separated by 5-minute breaks.
- **G2:** Provide persistent session tracking so users always know how many focused intervals they have completed today.
- **G3:** Surface weekly productivity patterns through a visual heat map so users can identify high-output and low-output days and adjust habits accordingly.

### 1.3 Success Metrics

| Metric | Definition | Target |
|--------|-----------|--------|
| Sessions completed per active user per week | Count of completed work sessions logged in session store, averaged per active user | Baseline TBD after launch |
| Heat map data accuracy | Heat map renders the correct session count after a full browser close and reopen | 100% of manual test cases |
| Daily active users (DAU) | Unique users who complete ≥1 session per day | Baseline TBD after launch |
| Week-over-week retention | % of users who return and complete ≥1 session in the following calendar week | ≥40% by week 4 post-launch |

---

## 2. Features

### 2.1 Personas

**Persona A — The Student**
- Name: Maya, 21, undergraduate student
- Goal: Complete study sessions without distraction; track how many sessions she does per day
- Pain point: Loses track of time; studies for hours without breaks and loses focus

**Persona B — The Remote Knowledge Worker**
- Name: David, 34, software developer working from home
- Goal: Maintain deep focus blocks and avoid burnout; see productivity trends over the week
- Pain point: Context switching and notifications interrupt long tasks; hard to know if he had a "good" week

### 2.2 Use Cases

| ID | Use Case | Actor |
|----|----------|-------|
| UC-1 | Start a 25-minute work session | Any user |
| UC-2 | Pause and resume a work session | Any user |
| UC-3 | Receive a notification when a session ends | Any user |
| UC-4 | Begin a 5-minute break after a work session | Any user |
| UC-5 | View session count for the current day | Any user |
| UC-6 | View the weekly productivity heat map | Any user |
| UC-7 | Reset the timer mid-session | Any user |

### 2.3 User Stories & Acceptance Criteria

**US-1: Start a Work Session**
As a user, I want to start a 25-minute work timer so that I can focus on a task.
- AC-1.1: When the user clicks/taps Start, a countdown displaying MM:SS begins at 25:00.
- AC-1.2: The timer display updates within 50ms of each elapsed 1-second wall-clock interval.
- AC-1.3: After 25 minutes ± 2 seconds of wall-clock time, the timer reaches 00:00 and triggers the session-end event.

**US-2: Pause and Resume**
As a user, I want to pause and resume the timer so that I can handle interruptions without abandoning my session.
- AC-2.1: Clicking Pause halts the countdown; the display freezes at the current remaining time.
- AC-2.2: Clicking Resume restarts the countdown from the frozen remaining time.
- AC-2.3: Total elapsed wall-clock time across pause/resume cycles does not deviate from the target 25-minute duration by more than ±2 seconds.

**US-3: Receive End-of-Session Notification**
As a user, I want to be notified when my work session ends so that I know to take a break.
- AC-3.1: An in-app visual alert (highlighted banner) appears immediately at session end, regardless of notification permission.
- AC-3.2: If the user has granted notification permission, a Web Notifications API alert fires with the title "Pomodoro complete!" and body "Time for a break. Your 5-minute break has started."
- AC-3.3: If notification permission is denied or not yet granted, only the in-app visual alert fires; no error or warning is shown to the user.
- AC-3.4: If a prior user gesture has occurred in the current browser context, an audio tone plays at session end. If no prior gesture has occurred, audio is silently skipped and no error is shown.
- AC-3.5: The application must not request notification permission on page load. Permission may only be requested after the user has explicitly clicked the Start button at least once in the current session.

**US-4: Automatic Break Transition**
As a user, I want a 5-minute break timer to begin immediately after a work session so that I take a structured rest.
- AC-4.1: Immediately after the work session-end event, the display transitions to a 5-minute break countdown beginning at 05:00.
- AC-4.2: When the break countdown reaches 00:00, a Web Notifications API alert fires (if permitted) with title "Break over!" and body "Ready for another Pomodoro? Click to start."
- AC-4.3: At break end, the application returns to the ready state for the next work session.

**US-5: View Daily Session Count**
As a user, I want to see how many sessions I have completed today so that I can track my daily progress.
- AC-5.1: The session counter increments by 1 each time a 25-minute work session reaches 00:00.
- AC-5.2: The count reflects only sessions completed in the current calendar day (midnight to midnight in the user's local timezone).
- AC-5.3: The count persists after a page refresh or full browser close and reopen.

**US-6: View Weekly Heat Map**
As a user, I want to view a weekly productivity heat map so that I can identify my most and least productive days.
- AC-6.1: The heat map renders exactly 7 cells, one per day, covering a rolling 7-day window (today minus 6 days through today, inclusive).
- AC-6.2: Each cell color encodes the count of completed work sessions for that day on a fixed scale of 0 to 8+ sessions; 8 or more sessions renders at maximum intensity.
- AC-6.3: A cell with 0 sessions renders in the lowest-intensity color, labeled "0"; this is the empty state for all cells before any sessions are recorded.
- AC-6.4: The heat map renders correct session counts after a full browser close and reopen.
- AC-6.5: No error message appears when the heat map is in the empty state.

**US-7: Background Tab Accuracy**
As a user, I want the timer to remain accurate even when I switch to another browser tab so that tab switching does not corrupt my session.
- AC-7.1: When the user returns to the app after any duration of tab backgrounding, the displayed remaining time is within ±2 seconds of the true wall-clock elapsed time.
- AC-7.2: If the tab was backgrounded when the timer reached 00:00, the session-end event fires immediately upon the tab becoming visible again.
- AC-7.3: If the browser tab is closed or the browser is quit while a timer is running, no out-of-app notification is delivered. This is a known limitation of a client-side-only application with no Service Worker; it must be documented in the UI as a tooltip or help text.

---

## 3. Non-Functional Requirements

Each NFR includes a measurable acceptance criterion and a named verification method.

### 3.1 Timer Accuracy

| Attribute | Requirement | Verification |
|-----------|------------|--------------|
| Drift tolerance | Timer must not deviate from wall-clock time by more than ±2 seconds over any complete 25-minute session, including sessions where the tab is backgrounded for any duration. | Manual test: capture timestamp at session start and session end; assert the difference is 1,500,000ms ± 2,000ms. |
| Background-tab drift | When the tab is backgrounded for ≥30 seconds and then foregrounded, displayed remaining time must be within ±2 seconds of true wall-clock elapsed time. | Manual test using the Page Visibility API `visibilitychange` event and DevTools timeline. |

### 3.2 Responsiveness (Layout)

| Attribute | Requirement | Verification |
|-----------|------------|--------------|
| Viewport range | The UI must render without horizontal scrolling at all viewport widths from 320px (iPhone SE) to 2560px (wide desktop). | Chrome DevTools responsive mode at 320px, 768px, 1280px, and 2560px; assert no horizontal scrollbar appears. |
| Touch target size | All interactive controls must have a minimum touch target size of 44×44 CSS pixels (WCAG 2.5.5). | axe DevTools audit plus manual measurement in Chrome DevTools. |

### 3.3 Performance

| Attribute | Requirement | Verification |
|-----------|------------|--------------|
| First Contentful Paint (FCP) | FCP must be ≤1.5 seconds on a simulated 4G connection (10 Mbps download, 40ms RTT). | Lighthouse performance audit, mobile preset, simulated throttling. |
| Timer tick display latency | The countdown display must update within 50ms of each elapsed 1-second wall-clock interval. | Chrome DevTools Performance panel; measure time between wall-clock second elapsed and DOM text update. |
| Heat map render time | The heat map must render within 200ms of page load becoming interactive. | Lighthouse time-to-interactive measurement. |

### 3.4 Accessibility

| Attribute | Requirement | Verification |
|-----------|------------|--------------|
| WCAG compliance | The application must meet WCAG 2.1 Level AA. | axe or WAVE automated audit; manual keyboard-navigation check across all controls. |
| First-time usability | A first-time user with no prior instructions must be able to start a work session within 10 seconds of opening the application. | Moderated usability test with a minimum of 3 first-time users; all must succeed within 10 seconds. |

### 3.5 Browser Support

The minimum supported browser versions are listed below. Versions below these floors are explicitly not supported and need not be tested.

| Browser | Minimum Version |
|---------|----------------|
| Chrome | 120 |
| Firefox | 121 |
| Safari | 17 |
| Edge | 120 |
| Internet Explorer | Not supported |

Verification: BrowserStack manual and automated test suite covering the minimum version listed for each browser.

### 3.6 Data Persistence

| Attribute | Requirement | Verification |
|-----------|------------|--------------|
| Persistence across restarts | All session records must survive a full browser close and reopen. | Manual test: complete 2 sessions, close the browser completely, reopen, assert session count and heat map reflect both sessions. |
| Storage unavailable (incognito / private browsing) | If `localStorage` is unavailable, the application must display the in-app banner: "Session history is unavailable in private browsing mode." Timer start, pause, resume, and reset must still function. | Manual test in Chrome incognito and Firefox Private Window. |

---

## 4. Key Implementation Details

This section defines the data contracts and technical constraints that are necessary for the developer to build the product correctly. It does not specify framework choice, internal code structure, or implementation patterns beyond what the behavioral requirements in §2 and §3 strictly require.

### 4.1 Timer Timing Mechanism

To satisfy the ±2-second drift tolerance in NFR 3.1, the timer must measure elapsed time using wall-clock anchoring rather than counting discrete callback intervals:

- Elapsed time must be derived from a wall-clock timestamp (e.g., `Date.now()`) recorded at session start, not accumulated from `setInterval` or `setTimeout` tick counts.
- The Page Visibility API (`document.visibilityState`, `visibilitychange` event) must be used to detect when the tab is backgrounded or foregrounded, and remaining time must be recomputed from the wall-clock anchor on each foreground transition.

This is required because browsers throttle timer callbacks in backgrounded tabs, making tick-counting insufficient to meet the ±2-second tolerance.

### 4.2 Session Data Schema

Each session record persisted in `localStorage` must conform to the following schema:

```
{
  id:        string,    // unique identifier, generated at session start
  type:      'work' | 'break',
  startTime: number,    // Unix timestamp in milliseconds (wall-clock time at session start)
  endTime:   number,    // Unix timestamp in milliseconds (wall-clock time at session end or reset)
  completed: boolean    // true if the timer reached 00:00; false if reset early
}
```

- **Storage key:** `pomodoro_sessions`
- **Format:** JSON-serialized array of session records
- **Retention:** Records with `startTime` older than 30 days are pruned on application start
- **Storage failure:** If `localStorage` throws a `SecurityError` (incognito mode or quota exceeded), the application must fall back to the in-session-only state described in NFR 3.6 and must not crash.

### 4.3 Notification Copy

The exact copy required for each notification event is defined below. These strings must be used verbatim in both the Web Notifications API alert and the in-app visual banner.

| Event | Title | Body |
|-------|-------|------|
| Work session ends | "Pomodoro complete!" | "Time for a break. Your 5-minute break has started." |
| Break ends | "Break over!" | "Ready for another Pomodoro? Click to start." |

---

## 5. Scope Boundaries

### 5.1 In Scope

- 25-minute work interval timer with start, pause, resume, and reset controls
- 5-minute break interval timer with automatic transition from work session
- In-app visual notifications at session and break end (always shown)
- Web Notifications API alerts at session and break end (with permission flow)
- Optional audio tone at session and break end (requires prior user gesture)
- Session completion tracking: persistent per-day count stored in `localStorage`
- Rolling 7-day weekly productivity heat map (one cell per calendar day)
- Incognito/private browsing fallback banner with timer functionality preserved

### 5.2 Out of Scope

The following are explicitly excluded from this version and must not be built:

| Item | Notes |
|------|-------|
| User accounts / authentication | No login; all data is local to the device and browser |
| Cloud sync / server-side storage | No backend; all persistence via `localStorage` |
| Mobile native applications (iOS / Android) | Web application only |
| Team or shared sessions | Single-user only |
| Calendar integrations (Google Calendar, Outlook, etc.) | Not in scope |
| Data export (CSV, JSON download, etc.) | Not in scope |
| Configurable interval lengths | 25-minute work and 5-minute break durations are fixed in this version |
| Long break (traditionally 15–30 minutes after every 4 completed work sessions) | Out of scope for v1; see OQ-1 |
| Task labeling / project tagging | Not in scope |
| Progressive Web App (PWA) install / offline Service Worker | Not in scope |

---

## 6. Open Questions

The following decisions are unresolved and must be answered before implementation begins.

| # | Question | Owner | Resolution Deadline |
|---|---------|-------|-------------------|
| OQ-1 | Should the traditional long break (15–30 minutes after every 4 completed work sessions) be included in v1 or deferred to v2? Omitting it may confuse users already familiar with the Pomodoro Technique. | Product Manager | Before sprint 1 kickoff |
| OQ-2 | Should the heat map cell granularity be the full calendar day or an hour-block within the day? Day-level is simpler; hour-level provides finer insight but requires a larger data model and a different visual design. | Product Manager + Developer | Before sprint 1 kickoff |
| OQ-3 | Should session records be pruned automatically after 30 days (current spec), or should the user control the retention window? Automatic pruning is simpler but may surprise users. | Product Manager | Before sprint 1 kickoff |
| OQ-4 | Should the optional audio tone be enabled by default (opt-out) or disabled by default (opt-in)? This choice affects the notification permission flow design and the browser's requirement for a prior user gesture before audio can play. | Product Manager | Before sprint 1 kickoff |
| OQ-5 | Is WCAG 2.1 AA sufficient, or is WCAG 2.2 AA required? WCAG 2.2 adds new success criteria relevant to mobile touch interactions. | Product Manager | Before sprint 1 kickoff |

---

## 7. Dependencies & Constraints

| Dependency | Type | Notes |
|-----------|------|-------|
| Page Visibility API | Browser API | Required for accurate background-tab timing; supported in all target browsers (Chrome 120+, Firefox 121+, Safari 17+, Edge 120+) |
| Web Notifications API | Browser API | Requires explicit user permission; behavior on iOS Safari 17 must be confirmed during development |
| Web Audio API (`AudioContext`) | Browser API | Requires prior user gesture; confirmed available in all target browsers |
| `localStorage` | Browser API | Required for session persistence; may be unavailable in incognito mode; no server or backend dependency |
| No backend / no server | Architectural constraint | The application is fully client-side; there are no API calls, no server-side session storage, and no user authentication |
