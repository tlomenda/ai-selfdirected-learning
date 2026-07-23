# TeamPulse Product Requirements Document

## Product Overview

### Problem Statement

Engineering organizations lack a lightweight, recurring way to measure team health and spot trends before they become problems. Ad-hoc surveys are inconsistent, responses are rarely anonymous enough for honest feedback, and managers cannot easily see how sentiment, workload, or clarity change over time. Existing tools are either too heavy, not privacy-preserving, or require manual aggregation.

### Goals

1. Enable engineering managers to run recurring, anonymous pulse surveys with minimal configuration.
2. Allow engineers to complete surveys quickly and honestly, knowing responses cannot be attributed to them.
3. Provide managers with a trend dashboard that surfaces team-level patterns over time without exposing any individual response.
4. Ensure data isolation between managers and teams, with authentication handled by company SSO.

## Features

### Personas

| Persona | Role | Access Scope |
|---------|------|--------------|
| Engineering Manager | Configures surveys, manages team membership, views own team's dashboard | Manager dashboard, configuration, own team's aggregated results |
| Engineer | Receives survey links and submits responses | Survey form only (no dashboard or result access) |

### Use Cases

1. **Manager configures a pulse survey**
   - Manager signs in via company SSO.
   - Manager selects a question set (5–7 questions), frequency (weekly or bi-weekly), and team membership.
   - System saves the configuration and schedules the next pulse.

2. **System sends survey invitations**
   - On the scheduled date and time, the system generates single-use, time-limited tokenized links.
   - Engineers receive invitations by email or Slack.
   - Each token is unique and expires before the next pulse begins.

3. **Engineer completes a survey**
   - Engineer clicks the tokenized link on any device.
   - Survey form loads in under 3 seconds on a mobile browser.
   - Engineer answers 5–7 questions and submits within 3 minutes.
   - System records responses with no individual attribution.

4. **Manager reviews trend dashboard**
   - Manager opens the dashboard for their own team only.
   - Dashboard displays trend lines per question and period-over-period comparisons.
   - Dashboard never displays individual responses or any identifying metadata.

### User Stories

#### Manager Stories

- **M1**: As a manager, I want to configure a pulse survey so that my team receives a recurring health check.
  - **Acceptance Criteria**:
    - Manager can select exactly 5, 6, or 7 questions from the configured question bank.
    - Manager can set frequency to weekly or bi-weekly.
    - Manager can add and remove team members by email or SSO identifier, but only for their own team.
    - Configuration persists and takes effect for the next scheduled pulse.

- **M2**: As a manager, I want to view a trend dashboard so that I can see how team health changes over time.
  - **Acceptance Criteria**:
    - Dashboard displays one trend line per survey question.
    - Dashboard supports period-over-period comparisons (current period vs. previous period).
    - Dashboard aggregates at least 5 historical periods when available.
    - Dashboard updates within 5 minutes of a pulse closing.

#### Engineer Stories

- **E1**: As an engineer, I want to receive a survey invitation so that I can participate in the team health check.
  - **Acceptance Criteria**:
    - Engineer receives the invitation within 15 minutes of the scheduled pulse time.
    - Invitation contains a single-use, time-limited tokenized link.
    - Token expires at the earlier of: link use, 7 days, or the start of the next pulse.

- **E2**: As an engineer, I want to complete the survey quickly on my phone so that it does not disrupt my work.
  - **Acceptance Criteria**:
    - Survey form is usable on viewport widths from 320px to 2560px without horizontal scrolling.
    - Survey contains 5–7 questions and can be completed in under 3 minutes in testing.
    - Submit button is reachable without scrolling more than two screen lengths on a standard mobile device.

## Non-Functional Requirements

| ID | Requirement | Verification Method |
|----|-------------|---------------------|
| NFR-1 | Survey form initial load completes in under 3 seconds on a simulated 3G connection. | Automated Lighthouse or WebPageTest mobile audit; median of 10 runs must be under 3.0s. |
| NFR-2 | Dashboard renders without horizontal scrolling at viewport widths from 320px to 2560px. | Automated responsive layout tests using Playwright or equivalent across 320px, 768px, 1440px, and 2560px viewports. |
| NFR-3 | Survey form can be completed by a first-time user in under 3 minutes. | Time-on-task usability test with 5 participants; the 90th percentile must be under 180 seconds. |
| NFR-4 | Authentication and authorization use Entra ID / OIDC; no local credentials are stored. | Security review of authentication middleware; confirm no password hashes exist in the database schema. |
| NFR-5 | Individual survey response records contain no user identifier, name, email, or SSO identity. | Schema audit and unit tests asserting response table has no foreign key or stored field to a user identity table. |
| NFR-6 | Managers can only access data for their own team; API responses for dashboards must return only data associated with the authenticated manager's team. | Automated authorization tests covering positive and negative cases for each dashboard and configuration endpoint. |
| NFR-7 | Trend dashboard updates within 5 minutes of a pulse closing. | End-to-end test closes a pulse and asserts dashboard reflects new aggregated data within 300 seconds. |
| NFR-8 | System availability during scheduled pulse windows is 99.9% as measured over a 30-day rolling period. | Uptime monitoring with synthetic health checks every 60 seconds; compute availability from success rate. |

## Key Implementation Details

- **Frontend**: React-based web application. The prompt does not prescribe a specific React framework, state library, or component system; the development team selects these.
- **Backend**: Node.js service. The development team selects the web framework and runtime version.
- **Database**: PostgreSQL. The schema must keep response records anonymous by design: the response table must not store user identifiers, session identifiers, or any other attribute that can link a response to an individual. Manager and team configuration may reference authenticated identities for authorization and scheduling purposes.
- **Authentication**: Entra ID / OIDC through company SSO. No local credential storage. Tokens issued by the SSO provider are used for manager and engineer sessions. Survey invitation tokens are separate, single-use, time-limited application tokens.
- **Notifications**: Email or Slack. The team must support at least one channel in V1 and design the notification service so the second channel can be added without changing the survey core logic.
- **Survey scheduling**: The system schedules pulses according to the manager-selected frequency (weekly or bi-weekly) and generates invitation tokens at pulse start. A pulse remains open until the next pulse is scheduled or until a manager explicitly closes it.
- **Trend aggregation**: Aggregated values (e.g., average, count per option) are computed from anonymous response records joined only to a pulse and question identity. Aggregation must occur in the backend; raw response records are never sent to the frontend.
- **Tooling**: GitHub for version control; Jira for issue tracking. The team may add CI/CD, linting, and testing tools as needed.

## Scope Boundaries

### In Scope

- Manager configuration of question set, frequency, and team membership.
- Anonymous, recurring pulse surveys for one or more managers, each with an isolated team.
- Single-use, time-limited tokenized survey links delivered by email or Slack.
- Mobile-accessible survey form with 5–7 questions.
- Manager-only trend dashboard with per-question trend lines and period-over-period comparisons.
- Entra ID / OIDC authentication; anonymous response storage enforced at the schema level.

### Out of Scope

- **ML-based sentiment analysis**: No natural-language processing, scoring, or automatic insight generation beyond raw aggregation.
- **Comparison across teams**: Managers cannot view aggregate or trend data for any team other than their own; there is no cross-team analytics or benchmark reporting.
- **Integration with HR systems**: No data export to or import from HRIS, payroll, or identity systems beyond Entra ID for authentication.
- **Mobile native apps**: Only a mobile-accessible web form is required; no iOS or Android native application development.
- **Real-time notifications or reminders**: Follow-up reminders and real-time status updates are not included; only the initial pulse invitation is required.
- **Custom question types beyond Likert or scale-style questions**: V1 supports a single question type (e.g., 1–5 scale or agree/disagree); open-ended comments and custom formats are not required.

### In-Scope Clarification

A manager may belong to only one team and can see only that team's aggregated data. The system must enforce this at the API and data layers, not only in the UI. If an engineer is accidentally added to two managers' teams, each manager sees only the responses submitted through their own team's pulse, and no manager can determine which specific engineer submitted a response.

## Open Questions

1. Should the question bank be fixed for all teams, or can managers add custom questions? What is the maximum length of a custom question?
2. How should the system handle an engineer who is on vacation or out of office during a pulse window — should it extend the token lifetime or skip that engineer for the period?
3. What is the retention policy for anonymous response records and expired survey tokens?
4. Should managers receive an email or Slack notification when a pulse has closed and the dashboard is updated?
5. Which notification channel must be supported first in V1 — email or Slack — and what happens if a team has no Slack workspace configured?

## Change Log

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 0.1.0 | 2026-07-23 | Product Manager | Initial PRD draft based on TeamPulse product description. |
