# TeamPulse — Product Requirements Document

**Version:** 1.0
**Date:** 2026-06-23
**Status:** Draft

---

## 1. Product Overview

### Problem Statement

Engineering managers lack a lightweight, privacy-preserving way to track team health over time. Existing tools are either too heavyweight (full HR platforms), too informal (ad-hoc Slack polls), or compromise anonymity by exposing individual responses. Managers need reliable trend data without creating a surveillance dynamic that discourages honest responses.

### Goals

- Enable engineering managers to run recurring anonymous pulse surveys with minimal configuration overhead.
- Aggregate and visualize team health trends without ever surfacing individual engineer responses.
- Integrate into existing authentication (Entra ID / OIDC) and notification infrastructure (email or Slack) to minimize adoption friction.
- Be completable by engineers in under 3 minutes on any device, including mobile.

---

## 2. Features

### 2.1 Personas

**Persona A: Engineering Manager**
- **Role:** Configures surveys, views aggregated trend dashboards.
- **Access scope:** Can configure question sets, survey frequency, and team membership for their own team only. Can view trend dashboards for their own team only. Cannot view individual responses in any view, including raw data exports. Cannot view other teams' data.

**Persona B: Engineer (Survey Respondent)**
- **Role:** Receives survey notifications and submits responses.
- **Access scope:** Can access and submit the survey form via a link. Cannot access the manager dashboard, configuration settings, or any other engineer's responses.

---

### 2.2 Use Cases & User Stories with Acceptance Criteria

#### UC-1: Survey Notification Delivery

**User Story:** As an Engineer, I want to receive a timely notification with a survey link so I can complete my pulse check without having to remember to navigate to a separate application.

**Acceptance Criteria:**
- AC-1.1: Engineers receive a notification via email or Slack (as configured by their manager) on the scheduled survey day within a 15-minute window of the configured send time.
- AC-1.2: The notification contains a direct, unique link to the survey form.
- AC-1.3: The link expires after the survey period closes (e.g., 7 days for weekly surveys).
- AC-1.4: An engineer who has already submitted a response for the current period cannot re-submit via the same link; they see a confirmation message instead.

---

#### UC-2: Survey Form Completion

**User Story:** As an Engineer, I want to complete a brief survey form on my phone or laptop so I can provide honest feedback without it taking significant time.

**Acceptance Criteria:**
- AC-2.1: The survey form renders without horizontal scrolling at viewport widths from 320px to 2560px.
- AC-2.2: The form contains between 5 and 7 questions as configured by the manager.
- AC-2.3: A user completing the form from link click to submission can do so in under 3 minutes (validated by usability testing with representative question sets).
- AC-2.4: Form submission succeeds without requiring the engineer to log in or authenticate beyond clicking the unique link.
- AC-2.5: Upon submission, the engineer sees a confirmation message. No response data is displayed back to them.
- AC-2.6: No user identifier (name, email, employee ID, or any other PII) is stored alongside the submitted response. Only the team identifier, survey period identifier, and question/answer data are persisted.

---

#### UC-3: Manager Dashboard — Trend Visualization

**User Story:** As an Engineering Manager, I want to view trend lines per question over time so I can identify areas of concern or improvement in my team's health.

**Acceptance Criteria:**
- AC-3.1: The dashboard displays one trend line per survey question showing aggregated scores across all completed survey periods.
- AC-3.2: The dashboard includes a period-over-period comparison view (e.g., current week vs. prior week, or current bi-weekly vs. prior bi-weekly).
- AC-3.3: The dashboard is accessible only to authenticated managers (via Entra ID / OIDC).
- AC-3.4: A manager's dashboard displays data exclusively for their own team; no other team's data is accessible.
- AC-3.5: No individual engineer's identity or response is surfaced in any dashboard view, drill-down, or tooltip — including when team size would make attribution trivially deducible (see Open Questions, OQ-1).
- AC-3.6: Aggregated data is displayed at the team + survey period level only.

---

#### UC-4: Survey Configuration

**User Story:** As an Engineering Manager, I want to configure the question set, frequency, and team membership so the survey reflects my team's current context.

**Acceptance Criteria:**
- AC-4.1: The manager can select survey frequency: weekly or bi-weekly.
- AC-4.2: The manager can add or remove questions from a predefined question library, resulting in a survey with 5–7 active questions.
- AC-4.3: The manager can add or remove team members (engineers) from their team roster, which determines who receives survey notifications.
- AC-4.4: Configuration changes take effect for the next survey period; in-progress periods are not retroactively altered.
- AC-4.5: Configuration UI is accessible only to authenticated managers via Entra ID / OIDC.

---

#### UC-5: Manager Authentication & Authorization

**User Story:** As a Manager, I want to log in via my company SSO so I don't need a separate credential to access the system.

**Acceptance Criteria:**
- AC-5.1: All manager-facing pages (dashboard, configuration) require a valid Entra ID / OIDC session. Unauthenticated requests are redirected to the SSO login flow.
- AC-5.2: No passwords or local credentials are stored by TeamPulse for any user.
- AC-5.3: Authorization is enforced server-side: API endpoints returning dashboard or configuration data validate that the authenticated user is the designated manager for the requested team. Requests for another team's data return HTTP 403.
- AC-5.4: The system supports multiple managers with independent team configurations. Manager A cannot see, configure, or enumerate Manager B's team.

---

## 3. Non-Functional Requirements

| ID | Requirement | Measurable Threshold | Verification Method |
|----|-------------|---------------------|---------------------|
| NFR-1 | **Survey form load performance** | Survey form page reaches Largest Contentful Paint (LCP) ≤ 2.5s on a simulated 4G mobile connection (Lighthouse Fast 4G throttling profile). | Automated Lighthouse CI audit run on each build against the survey form route. Fail threshold: LCP > 2.5s. |
| NFR-2 | **Dashboard load performance** | Dashboard initial data load completes (data visible in UI) within 3 seconds for datasets covering up to 52 survey periods and 50 team members. | Load test using k6 or Artillery with a seeded dataset of 52 periods × 50 members. Assertion: p95 response time ≤ 3000ms. |
| NFR-3 | **Mobile responsiveness** | All pages render without horizontal scrolling at viewport widths from 320px to 2560px. No interactive element is clipped or unreachable at minimum width. | Playwright automated tests covering 320px, 768px, 1280px, and 2560px viewports. Visual regression snapshots compared on CI. |
| NFR-4 | **Anonymity enforcement in storage** | No user identifier (email, name, employee ID, SSO subject claim, or any other PII) is stored in the responses table. Only `team_id`, `survey_period_id`, `question_id`, and `answer_value` columns exist on the response record. | PostgreSQL schema inspection (automated migration test asserts column list); integration test that submits a response and queries the responses table to assert no PII columns are present. |
| NFR-5 | **Anonymity enforcement in API responses** | No API endpoint returns individual response records that include any user identifier. | Automated API contract test (e.g., Pact or supertest) asserting that `/api/results/*` endpoints return only aggregated shapes. Penetration test: authenticated manager token cannot retrieve raw, per-user response rows via any documented or undocumented endpoint. |
| NFR-6 | **Survey completion time** | 80% of engineers complete the survey (from page load to confirmation) in ≤ 3 minutes with a 5-question default set. | Moderated usability test with ≥ 5 representative participants using production-equivalent form. Median and p80 completion time recorded. |
| NFR-7 | **Notification delivery reliability** | ≥ 95% of survey notifications are delivered within 15 minutes of the scheduled send time under normal system load. | Canary/observability test: log notification dispatch timestamp and delivery confirmation timestamp (for email, use delivery receipt hooks; for Slack, use API response timestamp). Alert if p95 delivery latency > 15 minutes. |
| NFR-8 | **Session & token security** | Manager sessions expire after ≤ 8 hours of inactivity. OIDC tokens are not persisted in localStorage or sessionStorage. | Automated test: assert session cookie `Max-Age` / expiry; assert no token strings in localStorage after login flow completes (via Playwright `page.evaluate`). |
| NFR-9 | **Authorization isolation** | A manager's authenticated API token cannot retrieve data belonging to a different team. | Automated integration test: create two managers with separate teams; assert Manager A's token returns HTTP 403 for all Manager B's team endpoints. |
| NFR-10 | **Availability** | System uptime ≥ 99.5% measured monthly, excluding planned maintenance windows communicated ≥ 24 hours in advance. | Uptime monitoring via an external synthetic monitor (e.g., Checkly, Datadog Synthetics) pinging the survey form and dashboard health endpoints every 60 seconds. Monthly SLA report generated from monitor data. |

---

## 4. Key Implementation Details

### 4.1 Authentication & Authorization
- Authentication is exclusively via **Entra ID / OIDC**. No local user table with passwords. The backend validates OIDC JWTs on every authenticated API request.
- The database must store a manager record linked to their Entra ID subject claim (`sub`), mapping them to their team(s). This is the sole authorization mechanism for team-scoped data access.
- Engineers do **not** authenticate via SSO. Survey access is via single-use or period-scoped token links. The token must encode only the `team_id` and `survey_period_id`, not any engineer identifier.

### 4.2 Anonymity Architecture
- The `responses` table must be designed such that a row contains **no user identifier column**. The row should contain: `id`, `team_id`, `survey_period_id`, `question_id`, `answer_value`, `submitted_at`.
- The survey link token must not encode or log the engineer's identity. If the token is derived from a notification record (to prevent double submission), the notification record linking token to engineer must be stored in a separate table that is **never joined** to the responses table in any query path.
- No admin interface, database view, or API endpoint should permit retrieval of individual responses with any associated identity signal.

### 4.3 Tech Stack (as specified)
- **Frontend:** React
- **Backend:** Node.js
- **Database:** PostgreSQL
- **Authentication:** Entra ID / OIDC
- **Version control:** GitHub
- **Issue tracking:** Jira

### 4.4 Notification Channels
- The system must support **email** and **Slack** as notification channels. The manager configures which channel is used for their team.
- Notification delivery must be handled asynchronously (e.g., via a job queue) to avoid blocking survey period creation and to allow retries on transient delivery failure.

### 4.5 Multi-Manager Tenancy
- Team data is strictly scoped. Queries for dashboard data and configuration must always filter by `team_id` where that `team_id` is derived from the authenticated manager's record, not from a client-supplied query parameter without server-side validation.

---

## 5. Scope Boundaries

### In Scope (V1)
- Anonymous pulse survey form (5–7 questions) accessible via a unique link sent by email or Slack.
- Trend dashboard for managers showing aggregated results per question over time, with period-over-period comparison.
- Manager configuration of: question set (from a predefined library), survey frequency (weekly/bi-weekly), and team member roster.
- Authentication via Entra ID / OIDC for all manager-facing surfaces.
- Support for multiple independent managers with separate teams.
- **Clarification — what "anonymous" means in V1:** No user identifier is ever stored with a response. The prevention-of-double-submission mechanism (if implemented) must use a separate, non-joined record. If double-submission prevention is omitted in V1, that is an explicit decision to document (see OQ-2).

### Out of Scope (V1) — Items a Developer Might Reasonably Assume Are Included

| Out-of-Scope Item | Why It Might Be Assumed | Explicit Exclusion |
|---|---|---|
| ML-based sentiment analysis | Survey text responses are common; NLP analysis is a natural extension. | Explicitly excluded. V1 stores and displays only structured question/answer data. |
| Cross-team comparison or benchmarking | Managers might expect to benchmark against org-wide norms. | Explicitly excluded. No manager has visibility into another team's data in any form. |
| Integration with HR systems (e.g., Workday, BambooHR) | Team membership management often integrates with HRIS. | Explicitly excluded. Team membership is managed manually within TeamPulse by the manager. |
| Native mobile apps (iOS / Android) | "Mobile-accessible" could be interpreted as requiring native apps. | Explicitly excluded. V1 is a mobile-optimized web application only. |
| Admin / super-admin role with org-wide visibility | A system admin might be expected to have cross-team oversight. | Explicitly excluded. No role in V1 has cross-team data access, including system operators (see OQ-6). |
| Custom question authoring (free-text questions) | Managers might expect to write their own questions. | V1 uses a predefined question library. Free-text custom question authoring is out of scope. |
| Engineer-facing response history or trend view | Engineers might expect to see their own past responses. | Explicitly excluded. Engineers see only the current survey form and a submission confirmation. |
| Automated offboarding / team membership sync | As engineers leave teams, automatic roster updates might be assumed. | Explicitly excluded. Team membership is updated manually by the manager. |

---

## 6. Open Questions

**OQ-1 — Small team anonymity threshold**
If a team has fewer than N members (e.g., 3 engineers), aggregated results may still allow a manager to attribute responses to individuals by elimination. What is the minimum team size required before survey results are displayed? What happens to a survey period's results if fewer than the threshold number of engineers responded? *(Requires policy decision before implementation of the results display logic.)*

**OQ-2 — Double-submission prevention**
Should the system prevent an engineer from submitting the same survey period's form more than once? If yes, some linkage between the submission token and an "already submitted" state is required. How is this record stored without creating a path to re-identify responses? If no, the system must tolerate and aggregate duplicate submissions. *(Requires architectural decision before designing the responses table and token model.)*

**OQ-3 — Question library content and ownership**
Who defines and maintains the predefined question library? Is it a fixed set shipped with the product, or is it editable by a super-admin role post-deployment? If editable, how are changes to questions handled for in-progress or historical survey periods (to preserve trend comparability)? *(Requires product/stakeholder decision before the question library schema can be finalized.)*

**OQ-4 — Survey period close behavior**
What happens to a survey period that has not been responded to by all team members when the next period begins? Does it remain accessible? Does it close automatically? What is the display behavior for periods with partial response rates? *(Requires decision before implementing the scheduler and notification logic.)*

**OQ-5 — Notification channel configuration granularity**
Is the notification channel (email vs. Slack) configured once per team by the manager, or can individual engineers select their preferred channel? If per-engineer, how is engineer contact information (email or Slack user ID) collected and stored given that engineers do not log in to the system? *(Requires decision before designing the notification delivery architecture.)*

**OQ-6 — System operator / support access**
How do system operators (e.g., the engineering team deploying and maintaining TeamPulse) handle operational issues that require database or log access? Are there any guardrails on production data access for operators, given the anonymity requirement? *(Requires a documented operational security policy before go-live.)*

**OQ-7 — Survey link expiry and late submissions**
After a survey period closes, can engineers still submit via the original link, or are late submissions blocked? If the link expires, what does the engineer see? *(Requires decision before implementing the token validation logic.)*

---

## 7. Change Log

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0 | 2026-06-23 | AI-assisted (create-prd prompt) | Initial draft generated from TeamPulse product description. |
