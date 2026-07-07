# TeamPulse Product Requirements Document

## Product Overview

### Problem Statement
Engineering managers lack a lightweight, privacy-preserving mechanism to understand team health and sentiment at regular intervals. Existing HR tools are often heavyweight, require individual attribution, or lack the anonymity necessary for engineers to provide candid feedback. TeamPulse solves this by enabling managers to run recurring anonymous pulse surveys and view aggregated team-level trends without ever seeing individual responses or attributions.

### Goals
1. Enable engineering managers to collect team health feedback on a recurring schedule (weekly or bi-weekly) with minimal friction
2. Provide managers with actionable trend data while preserving engineer anonymity
3. Ensure survey completion is fast (under 3 minutes) and accessible across devices
4. Maintain strict data isolation: each manager sees only their own team's aggregated data
5. Eliminate individual attribution at all layers: storage, API, and UI

---

## Features

### Personas

#### Persona 1: Engineering Manager
- **Role**: Team lead or engineering manager responsible for 3–15+ engineers
- **Primary Goal**: Understand team health, morale, and sentiment trends over time without compromising individual privacy
- **Access Scope**: 
  - Configure surveys (questions, frequency, team membership)
  - View aggregated team dashboards and trend lines
  - View only their own team's data; no cross-team visibility
  - Cannot see individual responses or any identifying information
- **Technical Context**: Uses web browser; may access from desktop or mobile; authenticated via company SSO (Entra ID/OIDC)

#### Persona 2: Engineer
- **Role**: Individual contributor on an engineering team
- **Primary Goal**: Provide honest feedback on team health without fear of attribution or retaliation
- **Access Scope**:
  - Receive survey notification (email or Slack)
  - Access survey form via single-use, time-limited tokenized link
  - Submit anonymous response
  - No access to dashboards, results, or other engineers' responses
- **Technical Context**: Uses web browser on desktop or mobile; receives notifications via email or Slack; authenticated via single-use token (not SSO)

---

### Use Cases & User Stories

#### Use Case 1: Manager Configures a New Pulse Survey

**User Story 1.1: Manager Creates a Survey**
- **As a** manager
- **I want to** create a new pulse survey for my team with custom questions
- **So that** I can gather feedback on topics relevant to my team's current challenges

**Acceptance Criteria:**
- Manager can define 5–7 questions (text input, required)
- Manager can select survey frequency: weekly or bi-weekly
- Manager can assign team members to the survey (by email or SSO identity)
- Manager can set a start date and time for the first survey
- Survey configuration is saved and persisted
- Manager receives confirmation that the survey was created
- No survey is sent until the configured start date/time

**User Story 1.2: Manager Edits Survey Configuration**
- **As a** manager
- **I want to** modify an existing survey's questions, frequency, or team membership
- **So that** I can adjust the survey if requirements change

**Acceptance Criteria:**
- Manager can edit questions, frequency, and team membership for future survey runs
- Changes apply only to future survey runs, not retroactively to past responses
- Manager receives confirmation of changes
- If a survey is currently active (notification sent but response window still open), edits do not affect the current run

**User Story 1.3: Manager Deactivates a Survey**
- **As a** manager
- **I want to** stop a recurring survey
- **So that** I no longer collect feedback on that topic

**Acceptance Criteria:**
- Manager can deactivate a survey with one action
- Deactivated surveys no longer send notifications
- Historical data from deactivated surveys remains accessible in the dashboard

---

#### Use Case 2: Engineer Receives and Completes Survey

**User Story 2.1: Engineer Receives Survey Notification**
- **As an** engineer
- **I want to** receive a notification with a link to the survey
- **So that** I know when and where to provide feedback

**Acceptance Criteria:**
- Notification is sent via email or Slack (manager configures delivery method)
- Notification includes a single-use, time-limited tokenized link (valid for 7 days)
- Link is unique per engineer per survey run
- Notification is sent at the configured survey start time
- If engineer does not complete the survey within 7 days, the link expires and a new link must be requested

**User Story 2.2: Engineer Completes Survey**
- **As an** engineer
- **I want to** answer survey questions quickly on any device
- **So that** I can provide feedback without significant time investment

**Acceptance Criteria:**
- Survey form is mobile-responsive and renders without horizontal scrolling at viewport widths 320px–2560px
- Survey form displays all 5–7 questions on a single page or logical multi-step flow
- Survey is completable in under 3 minutes (measured: average time from form load to submission ≤ 180 seconds)
- Each question uses appropriate input type (e.g., Likert scale, multiple choice, or short text)
- Engineer can submit response with a single action (Submit button)
- Engineer receives confirmation that response was submitted
- No user identifier, email, or SSO identity is captured or displayed in the form
- Response is stored anonymously (see Key Implementation Details)

**User Story 2.3: Engineer Requests a New Survey Link**
- **As an** engineer
- **I want to** request a new survey link if my original link expired
- **So that** I can still submit feedback after the initial window closes

**Acceptance Criteria:**
- Engineer can request a new link via a simple form (email input only)
- New link is generated and sent within 1 minute
- New link is valid for 7 days from generation
- System prevents link spam (max 3 new link requests per engineer per survey run)

---

#### Use Case 3: Manager Views Team Health Dashboard

**User Story 3.1: Manager Views Trend Dashboard**
- **As a** manager
- **I want to** see trend lines for each survey question over time
- **So that** I can identify patterns and changes in team health

**Acceptance Criteria:**
- Dashboard displays one trend line per question
- Each trend line shows aggregated responses over time (e.g., average Likert score per survey run)
- X-axis shows survey run dates; Y-axis shows aggregated metric (e.g., 1–5 scale average)
- Dashboard includes at least 4 weeks of historical data (or all available data if fewer than 4 weeks)
- Trend lines are updated within 1 hour of survey close (survey response window ends)
- No individual response data is visible; only aggregated metrics are shown
- Manager can hover over data points to see the exact aggregated value and response count for that run

**User Story 3.2: Manager Views Period-over-Period Comparison**
- **As a** manager
- **I want to** compare team health metrics between two survey periods
- **So that** I can assess whether recent changes or initiatives have had an impact

**Acceptance Criteria:**
- Dashboard includes a comparison view showing side-by-side metrics for two selected survey runs
- Manager can select two survey runs from a dropdown or date picker
- Comparison displays aggregated scores and response counts for each question
- Comparison shows percentage change (↑/↓) between periods
- No individual response data is visible

**User Story 3.3: Manager Filters Dashboard by Date Range**
- **As a** manager
- **I want to** view trend data for a specific date range
- **So that** I can focus on a particular period of interest

**Acceptance Criteria:**
- Dashboard includes a date range picker
- Manager can select start and end dates
- Trend lines update to show only data within the selected range
- Default range is the last 12 weeks of data

---

#### Use Case 4: Data Isolation & Authorization

**User Story 4.1: Manager Can Only View Own Team's Data**
- **As a** manager
- **I want to** see only my team's aggregated survey data
- **So that** I cannot access other teams' confidential information

**Acceptance Criteria:**
- Manager's dashboard displays only surveys and data for teams they manage
- API endpoints return 403 Forbidden if manager attempts to access another team's data
- No cross-team data is visible in any view, including admin views
- Each manager's session is isolated; logging in as a different manager shows a different set of teams and surveys

**User Story 4.2: Engineer Cannot Access Dashboard or Other Responses**
- **As an** engineer
- **I want to** know that my response is anonymous and I cannot see other engineers' responses
- **So that** I can provide honest feedback without fear of attribution

**Acceptance Criteria:**
- Engineer's survey link grants access only to the survey form, not to any dashboard or results
- Engineer cannot navigate to dashboard URLs; access returns 403 Forbidden
- No API endpoint exposes individual response data to engineers
- Survey form does not display any identifying information about the engineer or other respondents

---

### Feature Summary Table

| Feature | Owner | Priority | Status |
|---------|-------|----------|--------|
| Manager creates/edits/deactivates surveys | Manager | P0 | In Scope |
| Engineer receives survey notification (email/Slack) | Engineer | P0 | In Scope |
| Engineer completes anonymous survey form | Engineer | P0 | In Scope |
| Manager views trend dashboard | Manager | P0 | In Scope |
| Manager views period-over-period comparison | Manager | P1 | In Scope |
| Manager filters dashboard by date range | Manager | P1 | In Scope |
| Data isolation & authorization | Both | P0 | In Scope |
| Engineer requests new survey link | Engineer | P1 | In Scope |
| ML-based sentiment analysis | N/A | N/A | Out of Scope |
| Cross-team comparison | N/A | N/A | Out of Scope |
| HR system integration | N/A | N/A | Out of Scope |
| Mobile native apps | N/A | N/A | Out of Scope |

---

## Non-Functional Requirements

### NFR-1: Performance – Survey Form Load Time
- **Requirement**: Survey form must load and render in under 2 seconds on a 4G connection (measured at 4 Mbps download, 1.5 Mbps upload, 50ms latency)
- **Verification Method**: 
  - Use WebPageTest or Lighthouse CI to measure form load time under 4G throttling
  - Measure Time to Interactive (TTI) for the survey form
  - Target: TTI ≤ 2 seconds
  - Run tests on every deployment to main branch

### NFR-2: Performance – Dashboard Load Time
- **Requirement**: Manager dashboard must load and display trend data in under 3 seconds on a standard broadband connection (measured at 25 Mbps download, 5 Mbps upload, 10ms latency)
- **Verification Method**:
  - Use Lighthouse CI or WebPageTest to measure dashboard load time
  - Measure Time to Interactive (TTI) for the dashboard
  - Target: TTI ≤ 3 seconds
  - Run tests on every deployment to main branch

### NFR-3: Responsiveness – Mobile & Desktop Compatibility
- **Requirement**: Survey form and dashboard must render without horizontal scrolling at viewport widths from 320px to 2560px
- **Verification Method**:
  - Automated visual regression tests using Playwright or Cypress with viewport sizes: 320px, 768px, 1024px, 1440px, 2560px
  - Manual testing on physical devices (iPhone SE, iPad, MacBook)
  - Run tests on every deployment to main branch
  - No horizontal scrollbar should appear at any tested viewport width

### NFR-4: Availability & Uptime
- **Requirement**: System must maintain 99.5% uptime (measured monthly; excludes planned maintenance windows)
- **Verification Method**:
  - Use uptime monitoring service (e.g., Datadog, New Relic, or AWS CloudWatch)
  - Monitor HTTP status codes for API and web endpoints
  - Alert on any downtime exceeding 5 minutes
  - Publish monthly uptime report

### NFR-5: Data Privacy – Anonymous Storage
- **Requirement**: No user identifier (email, SSO ID, name, or any personally identifiable information) is stored alongside individual survey responses in the database
- **Verification Method**:
  - Code review: inspect database schema and ORM models to confirm no user identifier columns exist in response tables
  - Database audit: query response tables to confirm no PII is present
  - Run automated schema validation on every deployment: verify response tables contain only question_id, response_value, survey_run_id, and created_at (no user identifiers)
  - Document schema design in SCHEMA.md with explicit rationale for anonymity

### NFR-6: Data Privacy – API Response Anonymity
- **Requirement**: No API endpoint returns individual response data or any user identifier linked to responses
- **Verification Method**:
  - API contract tests: verify all endpoints that return response data return only aggregated metrics (e.g., average, count, distribution)
  - Manual testing: attempt to fetch individual responses via API; confirm 403 Forbidden or no data is returned
  - Code review: inspect API response serializers to confirm no user identifier fields are included
  - Run tests on every deployment to main branch

### NFR-7: Data Privacy – UI Anonymity
- **Requirement**: No dashboard, admin view, or UI surface displays individual response data or any user identifier linked to responses
- **Verification Method**:
  - Visual regression tests: verify dashboard displays only aggregated metrics (trend lines, averages, counts)
  - Manual testing: inspect browser DevTools (Network, Storage) to confirm no individual response data is transmitted or cached
  - Code review: inspect frontend components to confirm no individual response data is rendered
  - Run tests on every deployment to main branch

### NFR-8: Security – Token Expiration
- **Requirement**: Survey access tokens must expire after 7 days of inactivity or 7 days from generation, whichever comes first
- **Verification Method**:
  - Unit tests: verify token expiration logic (e.g., `token.expires_at < now()` returns true after 7 days)
  - Integration tests: attempt to use an expired token; confirm 401 Unauthorized
  - Automated cleanup: verify expired tokens are deleted from the database daily
  - Run tests on every deployment to main branch

### NFR-9: Security – OIDC Authentication (Manager)
- **Requirement**: Manager authentication must use Entra ID / OIDC (company SSO); no local credential storage
- **Verification Method**:
  - Code review: verify no password hashing, credential storage, or local login form exists
  - Integration tests: verify manager login redirects to Entra ID / OIDC provider
  - Verify session tokens are issued only after successful OIDC callback
  - Run tests on every deployment to main branch

### NFR-10: Security – CSRF Protection
- **Requirement**: All state-changing endpoints (POST, PUT, DELETE) must include CSRF token validation
- **Verification Method**:
  - Code review: verify CSRF middleware is enabled and applied to all state-changing routes
  - Integration tests: attempt POST/PUT/DELETE without CSRF token; confirm 403 Forbidden
  - Run tests on every deployment to main branch

### NFR-11: Scalability – Concurrent Users
- **Requirement**: System must support at least 100 concurrent survey form submissions without degradation (response time ≤ 2 seconds per request)
- **Verification Method**:
  - Load testing using Apache JMeter or k6: simulate 100 concurrent users submitting survey responses
  - Measure response time distribution (p50, p95, p99)
  - Target: p95 response time ≤ 2 seconds
  - Run load tests before each major release

### NFR-12: Scalability – Data Volume
- **Requirement**: System must support at least 10,000 survey responses per month without performance degradation
- **Verification Method**:
  - Database performance testing: insert 10,000 responses and measure query performance for trend dashboard
  - Measure dashboard query time (aggregation queries)
  - Target: dashboard query time ≤ 1 second for 10,000 responses
  - Run performance tests before each major release

### NFR-13: Accessibility – WCAG 2.1 Level AA
- **Requirement**: Survey form and dashboard must meet WCAG 2.1 Level AA accessibility standards
- **Verification Method**:
  - Automated testing: use axe-core or WAVE to scan for accessibility violations
  - Manual testing: keyboard navigation, screen reader testing (NVDA, JAWS)
  - Run automated tests on every deployment to main branch
  - Conduct manual accessibility audit quarterly

### NFR-14: Localization – Language Support
- **Requirement**: System must support English and at least one additional language (e.g., Spanish, French, German) for survey forms and dashboards
- **Verification Method**:
  - Code review: verify i18n library is integrated (e.g., react-i18next, i18next)
  - Manual testing: verify all UI text is translated and displays correctly in both languages
  - Run tests on every deployment to main branch

---

## Key Implementation Details

### Technology Stack
- **Frontend**: React (as specified in product description)
- **Backend**: Node.js (as specified in product description)
- **Database**: PostgreSQL (as specified in product description)
- **Authentication**: Entra ID / OIDC (company SSO; no local credential storage)
- **Version Control**: GitHub
- **Issue Tracking**: Jira

### Database Schema Constraints for Anonymity
The database schema must enforce anonymity at the storage layer:

1. **Survey Responses Table** (`survey_responses`):
   - `id` (UUID, primary key)
   - `survey_run_id` (foreign key to survey_runs)
   - `question_id` (foreign key to questions)
   - `response_value` (text or numeric, depending on question type)
   - `created_at` (timestamp)
   - **NO user identifier columns** (no user_id, email, SSO_id, name, etc.)

2. **Survey Runs Table** (`survey_runs`):
   - `id` (UUID, primary key)
   - `survey_id` (foreign key to surveys)
   - `start_time` (timestamp)
   - `end_time` (timestamp)
   - `response_count` (integer, for dashboard aggregation)

3. **Survey Access Tokens Table** (`survey_access_tokens`):
   - `id` (UUID, primary key)
   - `survey_run_id` (foreign key to survey_runs)
   - `token` (unique, hashed)
   - `created_at` (timestamp)
   - `expires_at` (timestamp)
   - `used_at` (timestamp, nullable; set when token is used)
   - **NO user identifier columns**

4. **Surveys Table** (`surveys`):
   - `id` (UUID, primary key)
   - `manager_id` (foreign key to managers; identifies who owns the survey)
   - `team_id` (foreign key to teams)
   - `frequency` (enum: 'weekly' or 'bi-weekly')
   - `status` (enum: 'active' or 'inactive')
   - `created_at` (timestamp)
   - `updated_at` (timestamp)

5. **Questions Table** (`questions`):
   - `id` (UUID, primary key)
   - `survey_id` (foreign key to surveys)
   - `text` (text)
   - `question_type` (enum: 'likert', 'multiple_choice', 'short_text')
   - `order` (integer, for display order)

### Notification Delivery
- **Email**: Use a transactional email service (e.g., SendGrid, AWS SES) to send survey links
- **Slack**: Use Slack API to send direct messages to engineers (requires Slack workspace integration)
- **Manager Configuration**: Manager selects email or Slack (or both) when creating a survey
- **Token Generation**: Generate a unique, single-use token per engineer per survey run; embed token in survey link

### API Design Principles
1. **No Individual Response Data**: All API endpoints that return response data must return only aggregated metrics (average, count, distribution)
2. **Authorization**: All endpoints must validate that the requesting user (manager) owns the team/survey being accessed
3. **Error Handling**: Return 403 Forbidden for unauthorized access; do not leak information about other teams' data

### Frontend State Management
- Use React Context or a state management library (e.g., Redux, Zustand) to manage:
  - Manager authentication state
  - Survey configuration state
  - Dashboard filter state (date range, selected survey run)
  - Engineer survey form state (current question, responses)

---

## Scope Boundaries

### In Scope for V1
- Manager survey creation, editing, and deactivation
- Engineer survey notification (email or Slack)
- Engineer survey form (5–7 questions, mobile-responsive, under 3 minutes)
- Manager trend dashboard (trend lines, period-over-period comparison, date range filtering)
- Anonymous data storage and API responses
- OIDC authentication for managers
- Single-use, time-limited survey tokens for engineers
- Data isolation: each manager sees only their own team's data

### Out of Scope for V1
1. **ML-based sentiment analysis**: Natural language processing or sentiment scoring of open-ended responses is not included
2. **Cross-team comparison**: Managers cannot compare their team's metrics with other teams' metrics
3. **HR system integration**: No integration with HR platforms (e.g., Workday, BambooHR) for data export or synchronization
4. **Mobile native apps**: No iOS or Android native applications; web-based survey form and dashboard only
5. **Survey branching logic**: Conditional questions (e.g., "if response to Q1 is X, show Q2") are not supported
6. **Custom question types**: Only Likert scale, multiple choice, and short text questions are supported; no file uploads, date pickers, or matrix questions
7. **Real-time notifications**: Dashboard updates are not real-time; data is refreshed on page load or manual refresh
8. **Export functionality**: Managers cannot export survey data to CSV or other formats
9. **Survey templates**: Pre-built survey templates are not provided; managers must create surveys from scratch
10. **Multi-language survey questions**: Survey questions are created in a single language; no translation of questions by managers

### In-Scope Clarifications
1. **Anonymous Storage is Enforced at the Database Layer**: The database schema does not include user identifier columns in response tables. This is not a UI-level privacy measure; it is a structural constraint that prevents accidental PII leakage.
2. **Managers Cannot Identify Individual Respondents**: Even if a manager has access to raw database exports or logs, no individual response can be attributed to a specific engineer. The system does not track which engineer submitted which response.
3. **Survey Frequency is Recurring**: Once a manager creates a survey with weekly or bi-weekly frequency, the system automatically sends notifications and creates survey runs on the configured schedule until the manager deactivates the survey.

---

## Open Questions

1. **Survey Response Window Duration**: How long should the response window remain open for each survey run before results are aggregated and the dashboard is updated? (Currently assumed: 7 days, but this should be confirmed.)

2. **Notification Retry Logic**: If an engineer's email or Slack notification fails to deliver, should the system retry? If so, how many retries and at what intervals?

3. **Team Membership Management**: How should team membership be managed? Should managers manually add/remove engineers, or should team membership be synced from an external directory (e.g., Azure AD, Okta)?

4. **Minimum Response Count for Dashboard Display**: Should the dashboard display trend data if fewer than N engineers respond to a survey run? (This could prevent small teams from being identified by response patterns.) If so, what is the minimum threshold?

5. **Survey Question Limits**: Is the 5–7 question range a hard limit, or can managers create surveys with more or fewer questions? If flexible, what are the min/max bounds?

6. **Likert Scale Range**: For Likert scale questions, should the scale be 1–5, 1–7, or configurable by the manager?

7. **Historical Data Retention**: How long should survey responses be retained in the database? (E.g., 1 year, 2 years, indefinitely?) After retention period expires, should responses be deleted or archived?

8. **Slack Integration Scope**: If Slack is selected as the notification method, should the system request any specific OAuth scopes beyond sending direct messages? (E.g., read user list, read team info?)

9. **Manager Offboarding**: When a manager is removed from the company or changes roles, what happens to their surveys and historical data? Should surveys be deactivated, transferred to another manager, or deleted?

10. **Survey Anonymity Verification**: Should the system provide managers with a way to verify that responses are truly anonymous? (E.g., a report showing that no PII is stored?) If so, what format should this report take?

---

## Change Log

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-06-28 | Product Manager | Initial PRD for TeamPulse V1. Defined personas, use cases, acceptance criteria, non-functional requirements with verification methods, key implementation details, scope boundaries, and open questions. |

---

## Appendix: Verification Checklist for Development Team

Before marking TeamPulse V1 as complete, verify the following:

- [ ] All user stories have passing acceptance criteria tests
- [ ] Survey form loads in under 2 seconds on 4G connection (Lighthouse CI)
- [ ] Dashboard loads in under 3 seconds on broadband (Lighthouse CI)
- [ ] Survey form renders without horizontal scrolling at 320px–2560px viewport widths (Playwright)
- [ ] System uptime is 99.5% (monitored via Datadog/New Relic)
- [ ] Database schema contains no user identifiers in response tables (schema audit)
- [ ] API endpoints return only aggregated response data (API contract tests)
- [ ] Dashboard displays only aggregated metrics (visual regression tests)
- [ ] Survey tokens expire after 7 days (unit tests)
- [ ] Manager authentication uses Entra ID / OIDC (integration tests)
- [ ] CSRF protection is enabled on all state-changing endpoints (integration tests)
- [ ] System supports 100 concurrent survey submissions (load testing)
- [ ] Dashboard queries complete in under 1 second for 10,000 responses (performance testing)
- [ ] WCAG 2.1 Level AA accessibility standards are met (axe-core, manual testing)
- [ ] UI supports English and at least one additional language (manual testing)
- [ ] All open questions have been resolved and documented
