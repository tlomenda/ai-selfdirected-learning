## Test Case [1]: PRD Content Quality and Completeness

**Input:** A developer-ready PRD goes well beyond a feature list, a quality PRD should include sections that developers can use to build the best-fit product."

**Expected Output Criteria:**
- PRD contains a problem statement and goals to understand the why behind the product.
- PRD contains, personas, use cases, user stories, and acceptance criteria to understand the who and what behind the product.
- PRD contains technical requirements and constraints to understand the how behind the product.
- PRD contains non-functional requirements and constraints to understand the quality and performance expectations.
- PRD contains scope and boundaries to understand what is in and out of scope.
- PRD contains success metrics and KPIs to understand the measure of success.
- PRD contains open questions and assumptions to understand the unknowns.
- PRD contains dependencies and constraints to understand the dependencies and constraints.
- PRD contains changelog to understand the history of changes.

**Failure Criteria (must NOT occur):**
- The PRD should not specify implementation details or technical solutions.

## Test Case [2]: Timer Precision & Accuracy Specification

**Input:** Build a Pomodoro timer with 25-minute work sessions and 5-minute breaks.

**Expected Output Criteria:**
- PRD explicitly defines acceptable timer drift tolerance (e.g., ±2 seconds over a 25-minute session)
- PRD specifies wall-clock anchoring (Date.now()) as the timing mechanism, not tick counting
- PRD addresses background tab throttling behavior and defines the required mitigation (Web Worker or visibility API recompute)
- PRD names the Page Visibility API (visibilitychange) as a required dependency
- Acceptance criteria are written as testable statements a QA engineer can execute

**Failure Criteria (must NOT occur):**
- PRD says "accurate timing" without defining what accuracy means numerically
- PRD specifies setInterval as the timer implementation without addressing drift
- PRD is silent on what happens when the user switches tabs for 10 minutes

## Test Case [3]: Heat Map Data Model Completeness

**Input:** Include a weekly productivity heat map showing session history.

**Expected Output Criteria:**
- PRD defines the unit of each heat map cell (day, hour-block, or per-session slot)
- PRD specifies what the color scale encodes (session count, total minutes, completion rate)
- PRD defines the color scale range — fixed (0–8 sessions) or relative to user's personal max
- PRD specifies a concrete storage schema with field names and types (e.g., { id, startTime, endTime, completed: boolean, type: 'work' | 'break' })
- PRD defines storage location (localStorage vs. IndexedDB vs. server), data retention limit, and behavior when storage is unavailable (incognito mode)
- PRD defines what the heat map displays before any data exists (empty state)

**Failure Criteria (must NOT occur):**
- PRD says "store session data" without specifying the schema
- PRD says "weekly heat map" without defining what "week" means (calendar week? rolling 7 days?)
- PRD is silent on data persistence across browser restarts
- PRD assumes a backend exists without listing it as a dependency or scope decision

## Test Case [4]: Non-Functional Requirements Specificity

**Input:** The Pomodoro timer should be responsive, fast, and easy to use across all modern browsers.

**Expected Output Criteria:**
- PRD translates "responsive" into a measurable layout requirement (e.g., "UI must render without horizontal scrolling at viewport widths from 320px to 2560px")
- PRD translates "fast" into specific, testable performance budgets (e.g., "application must reach First Contentful Paint in under 1.5 seconds on a simulated 4G connection; timer tick must update the display within 50ms of the 1-second wall-clock interval")
- PRD translates "easy to use" into observable, testable criteria — either a usability benchmark ("a first-time user must be able to start a session within 10 seconds without instructions") or a specific accessibility standard ("must meet WCAG 2.1 AA compliance")
- PRD defines "all modern browsers" as an explicit, versioned support matrix (e.g., "Chrome 120+, Firefox 121+, Safari 17+, Edge 120+; IE not supported")
- Each non-functional requirement names the tool or method used to verify it (e.g., Lighthouse for performance budgets, axe or WAVE for accessibility, BrowserStack for cross-browser)

**Failure Criteria (must NOT occur):**
- PRD uses the word "responsive" without specifying a minimum viewport width, breakpoint behavior, or layout target
- PRD uses the word "fast" without a numeric threshold tied to a specific, named metric (FCP, TTI, tick latency, etc.)
- PRD uses "easy to use," "intuitive," or "user-friendly" as standalone requirements with no measurable proxy
- PRD defines browser support as "all modern browsers," "major browsers," or "evergreen browsers" without a named version floor
- PRD lists non-functional requirements without specifying how each one will be tested or what tool produces the measurement
- NFRs appear only in a bullet list without acceptance criteria, making it impossible to determine pass/fail at QA

## Test Case [5]: Notification & Audio Permission Flows

**Input:** Notify the user when a work session ends and a break begins.

**Expected Output Criteria:**
- PRD distinguishes between in-app visual alerts, Web Notifications API alerts, and audio alerts as three separate mechanisms
- PRD specifies when and how Notification.requestPermission() is triggered (e.g., after the user starts their first session, not on page load)
- PRD defines the complete fallback chain: what the user sees/hears if notification permission is denied, if audio context is suspended due to no prior user gesture, and if the tab is closed
- PRD defines the exact copy for each notification (work-end message, break-end message)
- PRD explicitly states whether audio is required, optional with a default, or out of scope

**Failure Criteria (must NOT occur):**
- PRD says "send a notification" without specifying the browser API or permission flow
- PRD is silent on the user experience when notification permission is denied
- PRD does not address the browser requirement for a prior user gesture before AudioContext can play sound
- PRD conflates browser push notifications (requires Service Worker + server) with in-session Web Notifications API alerts

## Test Case [6]: Scope Boundaries & Open Questions

**Input:** Build a Pomodoro timer application with session tracking and a weekly productivity heat map.

**Expected Output Criteria:**
- PRD contains a dedicated Out-of-Scope section that explicitly names at least: user accounts, cloud sync, mobile native apps, team/shared sessions, calendar integrations, and data export
- PRD contains an Open Questions section with at least 3 unresolved decisions, each with an owner and a resolution deadline
- PRD specifies supported browsers and minimum versions as a testable constraint
- PRD states whether the long break (traditionally after 4 Pomodoros) is in or out of scope — not silent on it
- PRD includes a success metric for the heat map feature that is measurable (e.g., "heat map renders correct session count after browser restart in 100% of manual test cases")

**Failure Criteria (must NOT occur):**
- PRD lists only features without any out-of-scope declarations
- PRD has no open questions section, implying all decisions are resolved when they are not
- PRD defines success only in terms of feature delivery ("heat map is built") rather than behavior ("heat map survives browser restart with correct data")
- PRD is silent on the traditional 4-session long-break rule, leaving the developer to decide whether to implement it