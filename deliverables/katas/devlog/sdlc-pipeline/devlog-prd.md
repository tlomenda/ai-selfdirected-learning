# DevLog: Product Requirements Document

## Product Overview

### Problem Statement
Individual contributors and their managers lack a lightweight, frictionless mechanism to recap daily work and share progress with their team. Current solutions either require significant time investment (lengthy status reports) or lack visibility (no centralized view). This creates information silos and makes it difficult for managers to understand team progress and blockers at a glance.

### Goals
1. **Reduce status reporting friction**: Enable developers to log their daily work in ≤2 minutes
2. **Improve team visibility**: Provide managers with a centralized, rolling view of team progress
3. **Enable asynchronous communication**: Deliver daily digests to team channels without requiring synchronous standup meetings
4. **Support opt-in/opt-out preferences**: Respect developer privacy while maintaining team transparency

---

## Features

### Personas

#### Persona 1: Developer (Individual Contributor)
- **Role**: Software engineer, data scientist, or technical contributor
- **Access Scope**: Can create and view their own daily logs; can view team digest in Slack; can configure personal preferences
- **Key Needs**: Quick data entry, minimal friction, privacy controls

#### Persona 2: Manager
- **Role**: Engineering manager or team lead
- **Access Scope**: Can view a rolling 30-day history of their team's logs in a web dashboard; cannot edit logs created by others
- **Key Needs**: Visibility into team progress, blocker identification, historical trends

#### Persona 3: System Administrator (Out of Scope for V1)
- **Role**: DevOps or infrastructure team member
- **Access Scope**: Deployment, configuration, monitoring
- **Key Needs**: Not defined in V1

---

### Use Cases & User Stories

#### Use Case 1: Developer Completes Daily Log

**User Story 1.1: Developer Submits Daily Log via Web Form**
- **As a** developer
- **I want to** fill out a short daily log form at the end of my workday
- **So that** my team knows what I accomplished and what I'm working on next

**Acceptance Criteria:**
- [ ] Form is accessible via a web URL (no authentication required beyond Entra ID/OIDC)
- [ ] Form contains exactly 4 fields: "What I worked on today," "What I completed," "Blockers," "What I plan tomorrow"
- [ ] All fields are optional (user can submit an empty form)
- [ ] Form submission completes in ≤3 seconds (measured from submit button click to success confirmation)
- [ ] User receives a confirmation message upon successful submission
- [ ] Form is mobile-responsive and renders without horizontal scrolling on viewport widths 320px–2560px
- [ ] Form submission is idempotent: submitting the same data twice does not create duplicate entries

**User Story 1.2: Developer Submits Daily Log via Slack Shortcut**
- **As a** developer
- **I want to** submit my daily log directly from Slack using a shortcut
- **So that** I don't need to navigate to a separate web form

**Acceptance Criteria:**
- [ ] Slack shortcut is available in the workspace and labeled "Log Daily Work"
- [ ] Shortcut opens a modal form with the same 4 fields as the web form
- [ ] Form submission from Slack modal completes in ≤3 seconds
- [ ] User receives a confirmation message in Slack upon successful submission
- [ ] Slack shortcut is available only to authenticated workspace members

**User Story 1.3: Developer Configures Personal Preferences**
- **As a** developer
- **I want to** configure my display name and opt out of the team digest
- **So that** I can control how my information is shared

**Acceptance Criteria:**
- [ ] Developer can access a preferences page via the web form (link provided after submission or in a separate URL)
- [ ] Developer can set a custom display name (default: their Slack display name)
- [ ] Developer can toggle "Include in team digest" on/off (default: on)
- [ ] Preferences are saved immediately upon change
- [ ] Preferences are persistent across sessions

---

#### Use Case 2: Team Receives Daily Digest

**User Story 2.1: Nightly Job Aggregates and Posts Team Digest**
- **As a** team member
- **I want to** receive a formatted summary of my team's daily logs in Slack
- **So that** I can stay informed about team progress without reading individual logs

**Acceptance Criteria:**
- [ ] Nightly job runs at a configurable time (default: 5 PM UTC on business days)
- [ ] Job aggregates all logs submitted that day from developers who have not opted out
- [ ] Summary is posted to a configurable Slack channel
- [ ] Summary is readable in Slack without clicking through to another page (all content visible in message thread or as a single message)
- [ ] Summary includes: date, list of developers and their entries (grouped by developer), count of entries
- [ ] Summary does not include entries from developers who have opted out
- [ ] Job runs only on business days (Monday–Friday, excluding configured holidays)
- [ ] Job execution is logged; failures trigger an alert to a configured Slack channel or email

**User Story 2.2: Digest Format is Consistent and Scannable**
- **As a** team member
- **I want to** quickly scan the daily digest to find relevant information
- **So that** I can stay informed without spending significant time reading

**Acceptance Criteria:**
- [ ] Digest uses consistent formatting: headers, bullet points, and line breaks for readability
- [ ] Each developer's entry is clearly labeled with their name
- [ ] Entries are grouped by developer, not by field type
- [ ] Digest includes a timestamp (date and time of posting)
- [ ] Digest includes a link to the manager dashboard for detailed historical view

---

#### Use Case 3: Manager Views Team Progress

**User Story 3.1: Manager Accesses Rolling 30-Day History**
- **As a** manager
- **I want to** view a rolling 30-day history of my team's daily logs
- **So that** I can identify trends, blockers, and progress over time

**Acceptance Criteria:**
- [ ] Manager can access a web dashboard via authenticated login (Entra ID/OIDC)
- [ ] Dashboard displays logs for the past 30 days (rolling window)
- [ ] Dashboard shows only logs from developers on the manager's team
- [ ] Dashboard respects developer opt-out preferences (does not display opted-out logs)
- [ ] Dashboard displays entries in reverse chronological order (most recent first)
- [ ] Dashboard is responsive and renders without horizontal scrolling on viewport widths 320px–2560px
- [ ] Dashboard loads in ≤2 seconds (measured from page load to full content render)
- [ ] Manager can filter by developer name or date range
- [ ] Manager cannot edit logs created by developers

**User Story 3.2: Manager Identifies Blockers and Trends**
- **As a** manager
- **I want to** quickly identify recurring blockers and trends in my team's work
- **So that** I can proactively address issues and support my team

**Acceptance Criteria:**
- [ ] Dashboard highlights entries containing the word "blocker" or "blocked" (case-insensitive)
- [ ] Dashboard provides a simple count of entries per developer over the 30-day period
- [ ] Dashboard does not provide AI-powered summarization or sentiment analysis (V1 scope)

---

## Non-Functional Requirements

### Performance

| Requirement | Threshold | Verification Method |
|---|---|---|
| Web form submission latency | ≤3 seconds from submit button click to success confirmation | Load testing with 100 concurrent users; measure p95 latency using Apache JMeter or similar tool |
| Dashboard page load time | ≤2 seconds from page load to full content render | Lighthouse performance audit; measure First Contentful Paint (FCP) and Largest Contentful Paint (LCP) |
| Nightly digest job execution | ≤5 minutes to aggregate and post digest for up to 100 developers | Measure job execution time in CloudWatch logs; alert if execution exceeds 5 minutes |
| API response time (all endpoints) | ≤500 ms for p95 latency | Application Performance Monitoring (APM) tool (e.g., AWS X-Ray); measure response time per endpoint |

### Availability & Reliability

| Requirement | Threshold | Verification Method |
|---|---|---|
| System uptime | 99.5% monthly availability | Monitor using AWS CloudWatch; alert on downtime; track in monthly incident reports |
| Nightly digest job success rate | 99% of scheduled jobs complete successfully | Log job execution status in CloudWatch; alert on failures; track success rate in weekly reports |
| Data persistence | Zero data loss after successful form submission | Automated backup verification; test restore procedures quarterly |

### Security & Authentication

| Requirement | Threshold | Verification Method |
|---|---|---|
| Authentication | All endpoints require Entra ID/OIDC authentication except public health check | Verify via manual testing and automated security tests; attempt unauthenticated access to protected endpoints |
| Authorization | Developers can only view/edit their own logs; managers can only view their team's logs | Implement role-based access control (RBAC); test with multiple user roles; verify in automated integration tests |
| Data encryption in transit | All API communication uses HTTPS/TLS 1.2 or higher | Verify via SSL Labs test; enforce in load balancer configuration |
| Data encryption at rest | PostgreSQL data encrypted using AWS RDS encryption | Verify in AWS RDS configuration; document encryption key management |
| Secrets management | No secrets (API keys, database credentials) hardcoded in source code | Scan codebase with git-secrets or similar tool; use AWS Secrets Manager for runtime secrets |

### Data Privacy & Retention

| Requirement | Threshold | Verification Method |
|---|---|---|
| Opt-out enforcement | Opted-out logs are never included in team digest or manager dashboard | Automated test: submit log, opt out, verify log does not appear in digest or dashboard |
| Data retention | Logs are retained for 30 days; older logs are automatically deleted | Implement automated cleanup job; verify in database; test retention policy quarterly |
| Audit logging | All log access (view, create, delete) is recorded with timestamp and user ID | Implement audit logging in application; verify logs are written to CloudWatch; test with automated audit log verification |

### Scalability

| Requirement | Threshold | Verification Method |
|---|---|---|
| Concurrent users | Support 100 concurrent form submissions without degradation | Load testing with 100 concurrent users; measure response time and error rate |
| Database query performance | Dashboard queries complete in ≤500 ms for 30-day history of 100 developers | Database query profiling; add indexes as needed; measure query time in production monitoring |

### Usability

| Requirement | Threshold | Verification Method |
|---|---|---|
| Form completion time | Average developer completes form in ≤2 minutes | Measure via form submission timestamps; track average time in analytics |
| Mobile responsiveness | Form and dashboard render without horizontal scrolling on viewport widths 320px–2560px | Manual testing on devices (iPhone SE, iPad, 1920px desktop, 2560px ultrawide); automated visual regression testing |
| Accessibility | WCAG 2.1 AA compliance for web form and dashboard | Automated accessibility testing with axe or similar tool; manual testing with screen reader |

---

## Key Implementation Details

### Technology Stack
- **Frontend**: React (as specified in product description)
- **Backend**: Python with FastAPI (as specified in product description)
- **Database**: PostgreSQL (as specified in product description)
- **Slack Integration**: Slack Bolt for Python (as specified in product description)
- **Infrastructure**: Docker-based deployment on AWS ECS Fargate (as specified in product description)
- **Authentication**: Entra ID / OIDC (as specified in product description)

### Architecture Considerations
- **Web Form**: React single-page application (SPA) or server-rendered form; must support both desktop and mobile
- **Slack Integration**: Use Slack Bolt for Python to handle shortcut interactions and message posting
- **Nightly Job**: Implement as a scheduled Lambda function or ECS task (triggered by EventBridge/CloudWatch Events)
- **Manager Dashboard**: React SPA with backend API for data retrieval
- **Database Schema**: Design tables for logs (id, developer_id, date, fields), developers (id, slack_id, display_name, opt_out), and teams (id, name, manager_id)

### Deployment & Configuration
- **Environment Variables**: Slack workspace token, Slack channel ID, database connection string, Entra ID client ID/secret, nightly job schedule
- **Database Migrations**: Use a migration tool (e.g., Alembic for SQLAlchemy) to manage schema changes
- **Monitoring**: CloudWatch logs for application logs; CloudWatch metrics for performance; SNS/email for alerting

---

## Scope Boundaries

### In Scope for V1
- Web form for daily log submission (4 fields)
- Slack shortcut for daily log submission
- Developer preference configuration (display name, opt-out toggle)
- Nightly digest job (aggregation and Slack posting)
- Manager dashboard with 30-day rolling history
- Basic blocker highlighting (keyword matching)
- Entra ID/OIDC authentication
- Docker-based deployment on AWS ECS Fargate

### Out of Scope for V1
- **AI summarization**: No automatic summarization of logs or intelligent grouping
- **Sentiment analysis**: No analysis of emotional tone or team morale
- **Cross-team comparisons**: No comparative analytics between teams
- **Integrations other than Slack**: No email, Teams, Discord, or other integrations
- **Advanced filtering**: No complex query builders or saved filters in manager dashboard
- **Notifications**: No push notifications, email digests, or SMS alerts (Slack digest only)
- **Audit trail UI**: No user-facing audit log viewer (audit logs exist but are not exposed in UI)
- **Bulk operations**: No bulk import/export of logs or bulk user management
- **Custom fields**: Form fields are fixed; no custom field configuration per team
- **Recurring logs**: No templates or recurring log entries

### In-Scope Clarifications
- **Team membership**: Team membership is determined by Entra ID group membership or a manually configured mapping in the database; a developer can only view logs for their own team
- **Business day definition**: Business days are Monday–Friday, excluding US federal holidays (configurable list in environment variables)
- **Nightly job timing**: Job runs at a configurable time (default: 5 PM UTC); if the scheduled time falls on a weekend or holiday, the job does not run

---

## Open Questions

1. **Team membership model**: How is team membership determined? Should the system read from Entra ID groups, or should teams be manually configured in a database? What happens if a developer changes teams?

2. **Manager access control**: Can a manager view logs for developers outside their direct team (e.g., cross-functional projects)? Should there be a concept of "team hierarchy" or "multiple team membership"?

3. **Nightly job timezone**: Should the nightly job run at a fixed UTC time, or should it respect each team's local timezone? If multiple timezones, how should the digest be aggregated?

4. **Slack channel configuration**: Should each team have its own digest channel, or should all teams post to a single company-wide channel? How is the channel ID configured?

5. **Historical data migration**: If this system replaces an existing status reporting process, should historical logs be migrated? If so, what is the source format and migration strategy?

6. **Blocker escalation**: When a blocker is identified in a log, should the system automatically notify a manager or escalate to a ticket system? Or is the digest the only notification mechanism?

7. **Developer identification in Slack**: Should the digest use Slack display names, real names, or a custom display name configured by the developer? How should the system handle name changes?

8. **Empty logs**: Should developers be required to fill at least one field, or can they submit completely empty logs? Should empty logs be included in the digest?

9. **Rate limiting**: Should there be a limit on how many logs a developer can submit per day? Should the system prevent duplicate submissions within a certain time window?

10. **Preferences storage**: Should developer preferences (display name, opt-out status) be stored in the application database, or should they be read from Entra ID/Slack on each request?

---

## Change Log

| Version | Date | Author | Changes |
|---|---|---|---|
| 1.0 | 2026-07-13 | Product Manager | Initial PRD created from product devlog. Includes all required sections: personas, use cases with acceptance criteria, non-functional requirements with verification methods, key implementation details, scope boundaries, and open questions. |

---

**Document Status**: Ready for development team review and implementation planning
