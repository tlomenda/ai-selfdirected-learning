# Product Requirements Document — TeamPulse

---

## 1. Product Overview

### Problem Statement

Engineering managers lack a structured, low-friction mechanism for tracking team health trends over time. Existing alternatives — ad hoc 1:1s, infrequent engagement surveys, or informal check-ins — are inconsistent, non-comparative, and fail to surface patterns early. Engineers may also hesitate to share honest feedback if responses are identifiable.

### Goals

1. Provide engineering managers with team-level health trend data through lightweight, recurring anonymous pulse surveys.
2. Guarantee zero individual attribution — engineers can respond honestly knowing their individual responses are never linked to their identity in any system view.
3. Keep survey participation friction low: completable in under 3 minutes on any device, including mobile, without requiring engineer login.
4. Support multiple isolated engineering teams with no cross-team data visibility.
5. Integrate into existing engineer workflows via email or Slack notifications.

### Success Metrics (V1)

- A manager can launch a fully configured survey in under 5 minutes from first login.
- Survey completion rate of ≥ 60% is achievable when notification delivery succeeds.
- Dashboard renders trend data for up to 12 periods (team of ≤ 20 engineers) within 3 seconds on a broadband connection (≥ 25 Mbps).

---

## 2. Features

### 2.1 Personas

#### Persona 1: Engineering Manager

- **Authentication:** Entra ID / OIDC (company SSO); no local credential login.
- **Access Scope:**
  - Create, configure, and activate pulse surveys for their assigned team only.
  - Set the question set (5–7 questions), survey frequency (weekly or bi-weekly), and team member roster.
  - View their team's aggregated trend dashboard with period-over-period comparisons per question.
  - View participation count (number of submissions) per period — never individual identities.
  - **Cannot** access any other team's dashboard or data.
  - **Cannot** view individual response records in any view, including any debug or admin interface.

#### Persona 2: Engineer (Survey Respondent)

- **Authentication:** None required. Access via single-use, time-limited tokenized link delivered by email or Slack.
- **Access Scope:**
  - Submit one survey response per survey cycle via the tokenized link.
  - No login, no dashboard, no access to team data, no submission history.
  - Cannot reuse a token or submit multiple responses for the same period.

---

### 2.2 Use Cases and User Stories

---

#### UC-01: Manager Configures a Pulse Survey

**User Story:** As an Engineering Manager, I want to configure a recurring pulse survey so that I can start collecting weekly or bi-weekly team health data from my team.

**Acceptance Criteria:**

- AC-01.1: Manager can log in exclusively via Entra ID / OIDC SSO. No local username/password login form is presented.
- AC-01.2: After login, manager can create a new survey configuration with the following required fields:
  - Question set: select or compose 5–7 questions (question format per OQ-04)
  - Frequency: weekly or bi-weekly
  - Team member notification list (email addresses and/or Slack handles depending on configured channel)
  - Notification channel: email, Slack, or both
- AC-01.3: The system rejects saving a survey with fewer than 5 or more than 7 questions, displaying an inline validation error.
- AC-01.4: Manager can edit survey configuration before activation; changes to an active survey take effect on the next cycle (current cycle is unaffected).
- AC-01.5: Manager can deactivate a running survey at any time; no further notifications are dispatched after deactivation.
- AC-01.6: The survey configuration UI is only accessible to authenticated managers; unauthenticated requests receive HTTP 401.

---

#### UC-02: Engineer Receives Notification and Submits Survey

**User Story:** As an Engineer, I want to receive a simple notification link so that I can submit my team health feedback quickly, without logging in, and without fear that my response is linked to my identity.

**Acceptance Criteria:**

- AC-02.1: At each survey cycle start, the system sends a notification (via the configured channel: email and/or Slack) to each team member. Each notification contains a distinct single-use, time-limited tokenized survey link.
- AC-02.2: The tokenized link expires after the configured token lifetime (default: 48 hours; see OQ-03). An expired token returns an appropriate error state — not the survey form.
- AC-02.3: The survey form renders without horizontal scrolling at viewport widths from 320px to 2560px.
- AC-02.4: The survey presents exactly the 5–7 questions configured by the manager for that cycle.
- AC-02.5: On successful submission, the token is immediately invalidated server-side. A subsequent attempt to use the same token returns an "already submitted or expired" error state — not the survey form.
- AC-02.6: The submitted response record contains no user identifier of any kind: no name, email address, SSO subject, session ID, IP address, or device fingerprint. Only the following are stored alongside answer values: `survey_id`, `period_id`, `team_id`, `question_id`, `response_value`, `submitted_at`.
- AC-02.7: The survey is completable in 3 minutes or fewer from page load to submission confirmation, validated by usability testing with ≥ 5 representative users.
- AC-02.8: After submission, the engineer sees a confirmation message. No team results, personal history, or other team data is displayed.

---

#### UC-03: Manager Views Trend Dashboard

**User Story:** As an Engineering Manager, I want to view trend lines for each survey question over time so that I can identify patterns in team health across periods.

**Acceptance Criteria:**

- AC-03.1: Dashboard displays one trend line per question showing aggregate scores across available survey periods (minimum 12 periods displayed when data exists).
- AC-03.2: Dashboard includes a period-over-period delta indicator per question (e.g., score change from the immediately preceding period).
- AC-03.3: Dashboard displays the submission count (not identities) per period, allowing the manager to gauge participation rate.
- AC-03.4: Manager can filter the dashboard by date range or view all available history.
- AC-03.5: Dashboard is accessible only to the authenticated manager of that team. API endpoints return HTTP 403 for any cross-team data access attempt, regardless of authentication status.
- AC-03.6: No individual response records, per-respondent scores, or user identifiers are surfaced in any dashboard view or in any API response payload.
- AC-03.7: If a period's submission count falls below the minimum anonymity threshold (see OQ-05), aggregate results for that period are suppressed and a "Insufficient responses to display results" message is shown instead.

---

#### UC-04: Manager Manages Team Membership

**User Story:** As an Engineering Manager, I want to add or remove team members from the survey notification list so that the roster reflects my current team.

**Acceptance Criteria:**

- AC-04.1: Manager can add or remove team members from the notification list at any time via the survey configuration interface.
- AC-04.2: Roster changes take effect on the next survey cycle's notification dispatch.
- AC-04.3: Removing a member stops future notifications to that member but does not alter historical aggregate data.
- AC-04.4: A removed member receives no new tokens. Any previously issued, unexpired tokens from prior cycles remain valid until their expiration timestamp, but submission data from those tokens is already stored anonymously and cannot be attributed.

---

## 3. Non-Functional Requirements

### NFR-01: Privacy — No Individual Attribution in Storage

- **Requirement:** The survey response table must not contain any column that links a response row to an individual user.
- **Threshold:** Zero user-identifiable columns (name, email, `user_id`, SSO subject, session ID, IP address, device fingerprint) in the response storage schema.
- **Verification:**
  - Database schema review confirming no identifiable column exists in the response table.
  - Automated integration test: submit a survey response via the API, then query the response table and assert that no user-identifying fields are present in the returned record.
  - Code review of the survey submission API endpoint to confirm no user identifier is extracted from the token and written to the response record.

---

### NFR-02: Privacy — No Individual Attribution in API Responses

- **Requirement:** All API endpoints serving dashboard or survey data must return only team-level aggregates. No endpoint may return individual response records.
- **Threshold:** Every dashboard API response payload contains only aggregate fields (e.g., mean score, response count, distribution). No endpoint returns a collection of per-respondent rows.
- **Verification:**
  - API contract tests (e.g., Supertest or Postman/Newman) asserting that dashboard response payloads match an aggregate-only schema.
  - Negative test confirming that no URL pattern exists that returns a list of individual response records, even when the caller is an authenticated manager.

---

### NFR-03: Authentication and Authorization — Manager Isolation

- **Requirement:** A manager can only retrieve data for their own team. Cross-team data access is rejected at the API layer, not only the UI layer.
- **Threshold:** All data queries are scoped to the authenticated manager's `team_id`. HTTP 403 is returned for any request where the queried team ID does not match the authenticated manager's team ID.
- **Verification:**
  - Automated integration tests using two distinct manager accounts: Manager A's OIDC token must receive HTTP 403 when requesting Manager B's team dashboard data.
  - API authorization middleware unit tests confirming that the team scope filter is applied before any data is retrieved from the database.

---

### NFR-04: Token Security — Single-Use and Time-Limited Enforcement

- **Requirement:** Each tokenized survey link must be cryptographically unique, single-use, and time-limited.
- **Threshold:** (a) A token can be used to submit exactly one survey response; a second use returns HTTP 410 Gone. (b) A token past its expiration timestamp returns HTTP 410 Gone. (c) Token values must not be guessable; tokens must be generated with at least 128 bits of entropy (e.g., UUID v4 or CSPRNG-generated hex string).
- **Verification:**
  - Automated tests: (a) submit a response with token T, then attempt a second submission with the same T — assert HTTP 410; (b) create a token with a past expiration timestamp and attempt submission — assert HTTP 410.
  - Code review confirming token generation uses a cryptographically secure random source.

---

### NFR-05: Mobile Accessibility — Survey Form Responsiveness

- **Requirement:** The survey form must render correctly on mobile and desktop viewports.
- **Threshold:** No horizontal scrollbar and no clipped/obscured content at viewport widths: 320px, 375px, 768px, 1280px, and 2560px.
- **Verification:**
  - Automated Playwright (or equivalent) tests asserting no horizontal overflow (`document.documentElement.scrollWidth <= window.innerWidth`) at each specified viewport width.
  - Visual regression snapshots at each viewport width to catch regressions on subsequent changes.

---

### NFR-06: Survey Completion Time

- **Requirement:** A user must be able to complete and submit the survey from page load to submission confirmation within 3 minutes.
- **Threshold:** ≤ 180 seconds from initial page load to submission confirmation message, measured with ≥ 5 representative users completing a 5–7 question survey.
- **Verification:**
  - Moderated usability test with ≥ 5 participants; median and 90th-percentile completion time recorded.
  - Optionally: client-side instrumentation logging time-to-submit at the aggregate level (no user identity stored with timing data).

---

### NFR-07: Dashboard Load Performance

- **Requirement:** The manager dashboard must render fully (all trend charts visible and interactive) within a defined time threshold.
- **Threshold:** ≤ 3 seconds time-to-interactive, measured on a simulated broadband connection (≥ 25 Mbps), with up to 12 periods of data and a team of up to 20 engineers.
- **Verification:**
  - Lighthouse performance audit (simulated throttled network) run in CI on the dashboard page.
  - Playwright end-to-end test measuring time from navigation to chart render completion under a seeded data fixture of 12 periods × 20 respondents × 7 questions.

---

### NFR-08: Manager Authentication via SSO Only

- **Requirement:** Manager authentication must use Entra ID / OIDC exclusively. No local username/password credential storage is permitted.
- **Threshold:** No password, password hash, or local credential column exists in any database table. All manager authentication flows redirect to the Entra ID identity provider.
- **Verification:**
  - Database schema review confirming absence of any password-related column.
  - Automated authentication flow test asserting that a direct API call without a valid OIDC bearer token returns HTTP 401 and does not return any protected resource.

---

### NFR-09: Notification Scheduling Accuracy

- **Requirement:** Survey notifications must be dispatched on the configured schedule with bounded latency.
- **Threshold:** Notification dispatch initiated within ±15 minutes of the scheduled survey cycle start time. Failed delivery attempts are logged with error details (delivery failure reason, target identifier — not the response content). At least one retry attempt is made for transient failures.
- **Verification:**
  - Integration test: trigger a survey cycle programmatically and assert that notification jobs are enqueued within the threshold window.
  - Log assertion test confirming that a simulated delivery failure produces an error log entry with the required fields.

---

## 4. Key Implementation Details

### Authentication

- **Required mechanism:** Entra ID / OIDC (company SSO).
- Manager identity and team association are resolved from the OIDC token or from an internal mapping resolved at login time.
- No local credential storage of any kind is permitted.
- How manager accounts are initially provisioned in the system is an open question (see OQ-01); the authentication integration itself must be implemented against Entra ID.

### Required Tech Stack

The following are required constraints, not recommendations. Framework and library choices within each tier are left to the development team.

| Tier | Required Technology |
|------|---------------------|
| Frontend | React |
| Backend | Node.js |
| Database | PostgreSQL |
| Version Control | GitHub |
| Issue Tracking | Jira |

### Privacy-Critical Database Schema Constraint

The survey response table must contain **only** the following column types (or a subset):

| Column | Description |
|--------|-------------|
| `survey_id` | References the survey configuration |
| `period_id` | References the survey cycle period |
| `team_id` | Team identifier (aggregate grouping key) |
| `question_id` | References the question definition |
| `response_value` | The engineer's answer (numeric scale or coded value) |
| `submitted_at` | Timestamp of submission |

**Prohibited columns in the response table:** `user_id`, `email`, `name`, `sso_subject`, `session_id`, `ip_address`, `device_id`, `token_id`, or any other column that could link a row to an individual.

### Tokenized Survey Links

- Each survey invitation generates a unique, cryptographically random token (minimum 128 bits of entropy).
- The token is stored server-side and maps to `(team_id, period_id, survey_id)` — **not** to a specific engineer's identity.
- On submission, the token is used only to authorize one write to the response table; the token is then invalidated. The token value is **not** written to the response record.
- The token-to-engineer mapping used for deduplication (preventing re-submission) must be stored separately from the response record and may need to be designed carefully to avoid creating a linkable side-channel (see OQ-05 and the schema constraint above).

### Multi-Tenant Manager Isolation

- Each manager's team is a strict isolation boundary.
- All backend service methods that retrieve survey or response data must accept `team_id` as a required, authenticated parameter — derived from the OIDC token, not from a client-supplied query parameter.
- Cross-team isolation must be enforced at the data/service layer, not solely at the UI or routing layer.

### Notification Channels

- Email and Slack are the two supported notification channels for V1.
- Each team can be configured to use email, Slack, or both.
- Slack integration mechanism is an open question (see OQ-02); the implementation must avoid storing Slack user IDs alongside response records.

---

## 5. Scope Boundaries

### In Scope (V1)

- Recurring pulse surveys with weekly or bi-weekly frequency; 5–7 questions per survey cycle.
- Anonymous tokenized survey submission via email or Slack notification link; no engineer login required.
- Manager trend dashboard: trend lines per question, period-over-period comparison, participation count per period.
- Manager configuration of question set, survey frequency, and team membership.
- Entra ID / OIDC SSO for manager authentication.
- Multiple isolated manager/team instances; no cross-team visibility.
- Strict anonymity enforcement: no individual attribution in storage, API responses, or any UI view.
- Mobile-accessible survey form (viewport widths 320px–2560px, no horizontal scroll required).
- Response count (participation indicator) per period displayed on the dashboard (this is a team-level aggregate, not individual attribution, and is explicitly in scope).

### Out of Scope (V1)

The following items are **explicitly excluded from V1**. A developer might reasonably assume these are included; they are not:

1. **ML-based sentiment analysis:** No natural language processing, sentiment scoring, or keyword extraction. All aggregations are numeric/scale-based only.
2. **Cross-team comparison:** No feature for comparing results between teams, departments, or the broader organization. Each manager sees only their own team's data.
3. **Integration with HR systems:** No data sync with Workday, BambooHR, or any HRIS. Team membership is managed manually within TeamPulse.
4. **Mobile native apps (iOS / Android):** The survey form is a mobile-accessible web page only. No native app is in scope for V1.
5. **Admin panel or super-admin role:** No system-wide administration UI for managing all managers or all teams is in scope. Manager account provisioning is out of scope for V1 (see OQ-01).
6. **Open-ended / free-text survey questions:** Survey questions use structured response formats only (see OQ-04). Free-text entry fields are not in scope for V1.
7. **Engineer-facing history or results:** Engineers have no view of past submissions, personal response history, or team aggregate results.

### In-Scope Clarification

- **Participation count on the dashboard is in scope.** The dashboard displays how many responses were received per survey period (e.g., "7 of 10 team members responded"). This is a team-level aggregate count and does not constitute individual attribution. It does not reveal which specific engineers responded or abstained.

---

## 6. Open Questions

The following questions require a judgment call or external decision before or during implementation. They are not answerable from the provided product description.

**OQ-01: Manager Account Provisioning**
After a user authenticates via Entra ID / OIDC, how does the system determine whether they are an authorized manager? Is the manager role conveyed in the OIDC token (e.g., an Entra group claim), managed via a seed configuration, or provisioned via a separate admin process? This must be resolved before implementing the authorization layer, as it directly affects how the role check is performed at login.

**OQ-02: Slack Integration Mechanism**
What Slack integration model is required for V1 — a Slack bot (OAuth app with user/channel targeting), a per-channel incoming webhook, or another approach? The choice affects required Slack app scopes, how team members are mapped to Slack user IDs, and how Slack user IDs are handled (they must not be stored alongside response records). This must be resolved before implementing the notification subsystem.

**OQ-03: Token Expiration Window**
What is the required expiration window for a survey tokenized link? A 48-hour default (covering engineers who do not check communications immediately on cycle start) is a reasonable starting point, but the appropriate window depends on team norms and survey frequency. This affects both the UX (how long engineers have to respond) and the data collection window for a given period.

**OQ-04: Survey Question Format and Answer Scale**
What answer format do survey questions use — Likert scale (e.g., 1–5), numeric rating (1–10), binary (yes/no), multiple choice, or a combination? The format directly determines how response values are stored, how aggregates are computed, and how trend lines are visualized. This must be decided before designing the data model and dashboard visualizations.

**OQ-05: Minimum Anonymity Threshold (k-Anonymity)**
If a team has very few engineers (e.g., 2–3), displaying aggregate results could effectively de-anonymize individual responses. What is the minimum response count below which the system must suppress aggregate results and show a "Insufficient responses" message instead? This is a privacy engineering decision that must be resolved before implementing the aggregation and dashboard display logic. A threshold of k ≥ 3 is a common starting point, but the appropriate value requires product and privacy input.

**OQ-06: Question Library vs. Manager-Authored Questions**
Can managers compose their own question text freely, or must they select from a predefined library of validated questions? If both are allowed, what constraints apply to custom question text (character limits, prohibited content, approval workflow)? This affects the manager configuration UI and the question definition data model.

**OQ-07: Notification Delivery Failure Handling**
If a notification delivery attempt fails (e.g., Slack webhook timeout, email bounce), what is the expected behavior: silent log, retry with backoff, or alert the manager? What is the maximum retry attempt count and retry interval? This must be confirmed before implementing the notification subsystem's error handling and monitoring strategy.

---

## 7. Change Log

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 0.1 | 2026-06-24 | Product Manager | Initial draft created from TeamPulse product description |
