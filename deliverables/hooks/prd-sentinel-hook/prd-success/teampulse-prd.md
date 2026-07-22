# TeamPulse: Product Requirements Document

## Product Overview

### Problem Statement

Engineering managers lack visibility into team health and morale without creating surveillance or attribution concerns. Traditional pulse surveys either expose individual responses (raising privacy concerns) or lack sufficient granularity to identify trends. Managers need a lightweight, recurring mechanism to understand team sentiment and engagement patterns while maintaining engineer anonymity and trust.

### Goals

1. **Enable managers to monitor team health trends** over time with weekly or bi-weekly frequency
2. **Maintain engineer anonymity** by ensuring no individual responses are ever attributed or surfaced
3. **Reduce survey friction** through mobile-accessible forms completable in under 3 minutes
4. **Support multi-team organizations** with isolated data per manager and no cross-team visibility
5. **Provide actionable insights** through trend visualization and period-over-period comparisons

---

## Features

### Personas

#### Persona 1: Engineering Manager
- **Role**: Team lead responsible for team health, performance, and morale
- **Access Scope**: 
  - Can create and configure pulse surveys for their team
  - Can view aggregated, anonymized team-level results and trends
  - Can only access data for teams they manage
  - Cannot see individual responses or engineer identities
  - Cannot view other managers' team data
- **Key Needs**: Quick visibility into team sentiment without creating a surveillance culture

#### Persona 2: Engineer
- **Role**: Individual contributor on an engineering team
- **Access Scope**:
  - Can receive and complete survey invitations
  - Cannot view results, dashboards, or other engineers' responses
  - Cannot access any manager or configuration features
- **Key Needs**: Simple, quick survey experience without friction or privacy concerns

---

### Use Cases & User Stories

#### Use Case 1: Manager Configures a Pulse Survey

**User Story 1.1: Manager Creates a New Survey**
- **As a** manager
- **I want to** create a new pulse survey for my team
- **So that** I can begin collecting team health data

**Acceptance Criteria:**
- Manager can specify survey name and description
- Manager can select frequency: weekly or bi-weekly
- Manager can select team members to include in the survey
- Manager can choose a predefined question set or create a custom set (5–7 questions)
- Survey configuration is saved and persists across sessions
- Manager receives confirmation that the survey is active

**User Story 1.2: Manager Configures Survey Questions**
- **As a** manager
- **I want to** customize the questions in my pulse survey
- **So that** I can measure the specific aspects of team health that matter to my organization

**Acceptance Criteria:**
- Manager can add, edit, or remove questions (minimum 5, maximum 7)
- Each question supports a Likert scale (1–5) or yes/no response format
- Manager can preview the survey form before activation
- Changes to questions only apply to future survey rounds, not retroactively
- Manager can view a history of question changes per survey

#### Use Case 2: Engineer Completes a Survey

**User Story 2.1: Engineer Receives Survey Invitation**
- **As an** engineer
- **I want to** receive a notification with a link to complete the pulse survey
- **So that** I can provide feedback on team health

**Acceptance Criteria:**
- Engineer receives notification via email or Slack (configurable by manager)
- Notification includes a single-use, time-limited tokenized link
- Link expires after 7 days or after one successful submission, whichever comes first
- Engineer can click the link and access the survey form
- No login required to access the survey (token-based access only)
- Survey form displays the team name and survey period but no identifying information

**User Story 2.2: Engineer Completes Survey Form**
- **As an** engineer
- **I want to** quickly answer survey questions on any device
- **So that** I can provide feedback without disrupting my work

**Acceptance Criteria:**
- Survey form is mobile-responsive and renders without horizontal scrolling at viewport widths from 320px to 2560px
- Survey form is completable in under 3 minutes (5–7 questions with Likert or yes/no responses)
- Form includes clear instructions and question text
- Engineer can submit responses with a single click
- Engineer receives confirmation that their response was recorded
- No confirmation email or follow-up communication is sent (to avoid creating attribution patterns)
- After submission, the token is invalidated and cannot be reused

#### Use Case 3: Manager Views Survey Results

**User Story 3.1: Manager Views Aggregated Results Dashboard**
- **As a** manager
- **I want to** view aggregated survey results for my team
- **So that** I can understand team sentiment and identify trends

**Acceptance Criteria:**
- Dashboard displays one row per survey question
- Each row shows a trend line over time (minimum 4 data points for trend visualization)
- Trend line displays responses from the most recent 12 survey rounds
- Each question displays the current period's aggregate response (e.g., "4.2 / 5.0" for Likert scale)
- Dashboard displays period-over-period comparison (e.g., "↑ 0.3 from last period")
- Dashboard shows the number of responses received vs. team size (e.g., "8 of 10 responses")
- Manager can filter by date range (minimum 1 week, maximum 12 months)
- Dashboard updates within 1 hour of survey close
- No individual responses, engineer names, or identifying information is visible

**User Story 3.2: Manager Exports Survey Results**
- **As a** manager
- **I want to** export survey results for analysis or reporting
- **So that** I can share insights with leadership or conduct deeper analysis

**Acceptance Criteria:**
- Manager can export aggregated results as CSV or JSON
- Export includes question text, response aggregates, and timestamps
- Export does not include any individual responses or engineer identifiers
- Export is available for any date range within the survey history
- Export completes within 10 seconds

#### Use Case 4: Multi-Manager Organization

**User Story 4.1: Multiple Managers Manage Separate Teams**
- **As a** manager in a multi-team organization
- **I want to** manage surveys for only my team
- **So that** I can focus on my team's health without seeing other teams' data

**Acceptance Criteria:**
- Each manager can only view and configure surveys for teams they manage
- Manager can see a list of their assigned teams
- No manager can view another manager's team data, survey results, or configuration
- System supports at least 50 managers and 500 engineers
- Each manager's dashboard is isolated and shows only their team's data

---

## Non-Functional Requirements

### Performance

| Requirement | Threshold | Verification Method |
|---|---|---|
| Survey form load time | ≤ 2 seconds (p95) on 4G mobile connection | Use Lighthouse or WebPageTest with 4G throttling; measure from link click to form render |
| Dashboard load time | ≤ 3 seconds (p95) for a team with 12 months of history | Use browser DevTools or APM tool; measure from page load to all charts rendered |
| Survey submission latency | ≤ 500ms from click to confirmation | Use browser DevTools Network tab; measure from submit button click to success message |
| Export generation | ≤ 10 seconds for 12 months of data | Time export API endpoint with curl or Postman; measure from request to file download |

### Availability & Reliability

| Requirement | Threshold | Verification Method |
|---|---|---|
| System uptime | ≥ 99.5% monthly | Monitor with uptime monitoring service (e.g., Pingdom, DataDog); track monthly SLA |
| Survey link validity | 100% of tokens must be valid for 7 days or until first use | Automated test: generate token, verify it works immediately and after 6 days; verify it fails after 7 days or after first use |
| Data durability | 100% of submitted responses must be persisted | Automated test: submit response, query database, verify record exists with correct data |

### Security & Privacy

| Requirement | Threshold | Verification Method |
|---|---|---|
| No user identifiers in response storage | 0 user IDs, emails, or SSO identities stored with any survey response record | Schema audit: inspect database schema and verify no user_id, email, or identity columns exist in response table; code review of response insertion logic |
| Token-based survey access | 100% of survey access must use single-use, time-limited tokens | Code review: verify all survey endpoints require valid token; automated test: attempt access without token (should fail); attempt reuse of token (should fail) |
| HTTPS encryption | 100% of traffic must use TLS 1.2 or higher | SSL Labs test or similar; verify no HTTP endpoints exist; monitor for mixed content warnings |
| Authentication enforcement | 100% of manager endpoints require Entra ID / OIDC authentication | Automated test: attempt to access manager endpoints without authentication (should redirect to login); verify all manager routes have auth middleware |
| Authorization isolation | Managers can only access their own team data; no cross-team data leakage | Automated test: create two managers with separate teams; verify Manager A cannot query Manager B's team data via API |
| Survey response anonymity | No correlation between survey response and engineer identity is possible | Code review: verify response table has no foreign key to user/engineer table; verify no timestamps or metadata that could enable correlation; verify audit logs do not record engineer identity with responses |

### Scalability

| Requirement | Threshold | Verification Method |
|---|---|---|
| Concurrent survey submissions | ≥ 1,000 concurrent submissions without data loss | Load test using k6 or JMeter: simulate 1,000 concurrent POST requests to survey submission endpoint; verify all responses recorded correctly |
| Team size support | ≥ 500 engineers per team | Load test: create team with 500 members, send 500 survey invitations, verify all can submit responses; verify dashboard renders in ≤ 3 seconds |
| Organization scale | ≥ 50 managers, ≥ 500 engineers total | Load test: create 50 manager accounts, distribute 500 engineers across teams, verify each manager dashboard loads in ≤ 3 seconds |

### Accessibility

| Requirement | Threshold | Verification Method |
|---|---|---|
| WCAG 2.1 Level AA compliance | 100% of survey form and dashboard must meet WCAG 2.1 Level AA | Automated scan using axe DevTools or WAVE; manual keyboard navigation test; screen reader test (NVDA or JAWS) |
| Mobile responsiveness | Survey form renders without horizontal scrolling at 320px–2560px viewport widths | Responsive design test: verify form at 320px (iPhone SE), 768px (iPad), 1920px (desktop), 2560px (ultrawide) using Chrome DevTools |

### Maintainability

| Requirement | Threshold | Verification Method |
|---|---|---|
| Code test coverage | ≥ 80% line coverage for critical paths (auth, response submission, data access) | Run test suite with coverage tool (e.g., Jest, NYC); generate coverage report; verify critical paths meet threshold |
| API documentation | 100% of endpoints documented with request/response examples | Automated check: use OpenAPI/Swagger schema; verify all endpoints have descriptions, parameters, and example responses |

---

## Key Implementation Details

### Technology Stack
- **Frontend**: React (TypeScript recommended for type safety)
- **Backend**: Node.js with Express or similar framework
- **Database**: PostgreSQL
- **Authentication**: Entra ID / OIDC (company SSO)
- **Version Control**: GitHub
- **Issue Tracking**: Jira

### Database Schema Considerations
- **Survey responses must be stored anonymously**: No user_id, email, or SSO identity should be stored alongside response data
- **Response table structure**: Should include survey_id, question_id, response_value, timestamp, team_id — but NOT user_id or engineer identity
- **Manager-team mapping**: Separate table to track which managers own which teams (for authorization)
- **Token storage**: Tokens should be hashed and stored with expiration timestamps; invalidated after use

### Authentication & Authorization
- **Manager authentication**: Use Entra ID / OIDC for login; store manager identity in session/JWT
- **Survey access**: Use single-use, time-limited tokens (no authentication required); tokens are opaque identifiers with no embedded user data
- **Authorization checks**: All manager endpoints must verify the requesting manager owns the requested team before returning data

### Notification System
- **Email or Slack**: Manager configures notification channel per survey
- **Token generation**: Create single-use token with 7-day expiration; include token in notification link
- **No follow-up**: Do not send confirmation emails or follow-up messages after submission (to avoid creating attribution patterns)

### Data Retention & Cleanup
- **Response retention**: Retain anonymized responses indefinitely (or per company policy)
- **Token cleanup**: Delete expired tokens after 7 days
- **Audit logs**: Do not log engineer identity with survey responses; log only team_id and timestamp

---

## Scope Boundaries

### In Scope for V1

1. **Core survey functionality**: Create, configure, and run pulse surveys with 5–7 questions
2. **Anonymous response collection**: Collect and store responses without user attribution
3. **Aggregated dashboard**: Display team-level trends and period-over-period comparisons
4. **Multi-manager support**: Isolated data per manager with no cross-team visibility
5. **Mobile-accessible survey form**: Responsive design for 320px–2560px viewports
6. **Token-based survey access**: Single-use, time-limited links for engineers
7. **Entra ID / OIDC authentication**: Manager login via company SSO
8. **Email or Slack notifications**: Configurable notification channel per survey
9. **CSV/JSON export**: Export aggregated results for analysis

### Explicitly Out of Scope for V1

1. **ML-based sentiment analysis**: No natural language processing or sentiment scoring
2. **Comparison across teams**: No cross-team benchmarking or team-vs-team analytics
3. **Integration with HR systems**: No sync with Workday, BambooHR, or similar
4. **Mobile native apps**: No iOS or Android native applications
5. **Custom question logic**: No branching, conditional questions, or skip logic
6. **Real-time notifications**: No Slack bot or real-time alerts for low scores
7. **Survey scheduling automation**: Managers must manually trigger each survey round (or use simple weekly/bi-weekly recurrence)
8. **Response anonymization post-collection**: All responses are anonymous from collection; no retroactive anonymization
9. **Multi-language support**: All UI and surveys are in English only
10. **Advanced reporting**: No custom dashboards, drill-down analysis, or ad-hoc queries beyond the standard dashboard

### In-Scope Clarifications

1. **"Anonymous" means**: No user identifier, email, name, or SSO identity is stored with any survey response record. The database schema must not include a user_id column in the response table. Managers can never see which engineer gave which response.
2. **"Trend dashboard" means**: A line chart per question showing aggregate responses over the most recent 12 survey rounds, with period-over-period comparison (e.g., "↑ 0.3 from last period") and response count (e.g., "8 of 10 responses").
3. **"Team membership" means**: Managers can add or remove engineers from their team roster, which determines who receives survey invitations. Changes take effect for the next survey round.

---

## Open Questions

1. **Survey recurrence automation**: Should the system automatically send survey invitations on a weekly/bi-weekly schedule, or should managers manually trigger each round? (Affects implementation complexity and operational overhead.)

2. **Question set library**: Should there be a predefined library of vetted questions that managers can choose from, or should all questions be custom? (Affects onboarding experience and consistency across teams.)

3. **Response aggregation threshold**: Should the dashboard display results if fewer than N engineers respond (e.g., only show if ≥ 50% response rate)? Or should all results be displayed regardless of response count? (Affects data reliability and interpretation.)

4. **Notification retry logic**: If an email or Slack notification fails to send, should the system retry, and if so, how many times and at what interval? (Affects delivery reliability and operational complexity.)

5. **Manager self-service onboarding**: Should managers be able to self-serve (create teams, add engineers, configure surveys) or should an admin provision teams and managers? (Affects access control complexity and operational model.)

6. **Survey history retention**: Should managers be able to view historical surveys and results indefinitely, or should there be a retention limit (e.g., 24 months)? (Affects database size and compliance requirements.)

7. **Engineer opt-out**: Should engineers be able to opt out of surveys, or is participation mandatory? (Affects privacy model and legal compliance.)

8. **Response edit/retract**: Can engineers edit or retract a response after submission, or is submission final? (Affects data integrity and UX complexity.)

---

## Change Log

| Version | Date | Changes |
|---|---|---|
| 1.0 | 2026-07-22 | Initial PRD: Core survey functionality, anonymous response collection, aggregated dashboard, multi-manager support, mobile-accessible form, token-based access, Entra ID authentication, email/Slack notifications, CSV/JSON export. Out-of-scope: ML sentiment analysis, cross-team comparison, HR integration, mobile native apps. |

---
