# TeamPulse — Product Requirements Document

**Version:** 1.0  
**Date:** 2026-06-23  
**Status:** Draft  
**Audience:** Solo developer or small development team

---

## Table of Contents

1. [Product Overview](#1-product-overview)
2. [Features](#2-features)
3. [Non-Functional Requirements](#3-non-functional-requirements)
4. [Key Implementation Details](#4-key-implementation-details)
5. [Scope Boundaries](#5-scope-boundaries)
6. [Open Questions](#6-open-questions)
7. [Change Log](#7-change-log)

---

## 1. Product Overview

### Problem Statement

Engineering managers currently lack a lightweight, systematic way to gauge team health over time. Ad-hoc conversations and annual surveys miss the week-to-week signals that indicate burnout, blockers, or morale shifts. Without recurring, anonymous data, managers are left making decisions based on incomplete or biased information.

### Solution

TeamPulse is a lightweight team health-check system. It delivers short, anonymous pulse surveys to engineers on a weekly or bi-weekly schedule. Aggregated results are displayed in a trend dashboard visible only to the managing manager. Individual responses are never surfaced — not in any role, including admin views.

### Goals

| Goal | Success Indicator |
|------|-------------------|
| Enable regular, anonymous feedback collection | Surveys sent and completed on configured schedule |
| Give managers trend visibility into team health | Dashboard shows time-series data per question |
| Protect engineer privacy absolutely | Zero individual attribution in any system view |
| Minimize friction for engineers | Survey completable in under 3 minutes |
| Support independent teams with no cross-team visibility | Each manager sees only their own team's data |

---

## 2. Features

### 2.1 Personas

| Persona | Description | Primary Interactions |
|---------|-------------|----------------------|
| **Engineering Manager** | Owns one or more teams; wants to understand team health trends over time | Configure team, configure survey, view dashboard |
| **Engineer** | Team member who responds to pulse surveys | Receive notification, complete survey |

> Note: A system administrator role for platform-level management (user provisioning, global settings) is out of scope for V1 and should be resolved as an open question (see Section 6).

---

### 2.2 Use Cases & User Stories

#### UC-01: Manager Configures a Team

**Actor:** Engineering Manager  
**Goal:** Define which engineers are on their team so surveys can be targeted correctly.

| ID | User Story | Acceptance Criteria |
|----|-----------|---------------------|
| US-01.1 | As a manager, I want to create a team with a name so I can organize my direct reports. | Team is created and visible in my dashboard. |
| US-01.2 | As a manager, I want to add engineers to my team by email address (matching their SSO identity) so they receive future surveys. | Added engineers receive the next scheduled survey. |
| US-01.3 | As a manager, I want to remove an engineer from my team so they stop receiving surveys when they leave or transfer. | Removed engineer receives no future surveys; historical aggregated data is preserved. |

---

#### UC-02: Manager Configures a Survey

**Actor:** Engineering Manager  
**Goal:** Define the questions and cadence for recurring pulse surveys.

| ID | User Story | Acceptance Criteria |
|----|-----------|---------------------|
| US-02.1 | As a manager, I want to choose from a default question bank (5–7 questions) or customize the question set so the survey is relevant to my team. | Selected questions appear on the survey form sent to engineers. |
| US-02.2 | As a manager, I want to set the survey frequency to weekly or bi-weekly so surveys are sent automatically on a schedule. | Surveys are triggered on the configured cadence without manual intervention. |
| US-02.3 | As a manager, I want to pause or resume a survey schedule so I can stop sending surveys during holidays or team events. | No surveys are sent while paused; schedule resumes when reactivated. |

---

#### UC-03: Engineer Receives and Completes a Survey

**Actor:** Engineer  
**Goal:** Respond to a pulse survey anonymously and efficiently.

| ID | User Story | Acceptance Criteria |
|----|-----------|---------------------|
| US-03.1 | As an engineer, I want to receive a notification (email or Slack) with a survey link when a new survey is available so I know to respond. | Notification is delivered within 15 minutes of the scheduled send time. |
| US-03.2 | As an engineer, I want to complete the survey on any device (mobile or desktop) so I'm not forced to use a specific platform. | Survey form is fully usable on screens ≥ 320px wide. |
| US-03.3 | As an engineer, I want my responses to be anonymous so I can answer honestly without fear of identification. | No response is stored with any user identifier; only the team and survey period are recorded. |
| US-03.4 | As an engineer, I want to complete the survey in under 3 minutes so it doesn't interrupt my workflow. | Default question set is completable in ≤ 3 minutes based on usability testing or a cognitive walkthrough. |
| US-03.5 | As an engineer, I want the survey link to expire after submission or after the survey window closes so I can only submit once per period. | Duplicate submissions are rejected; expired links display an appropriate message. |

---

#### UC-04: Manager Views the Trend Dashboard

**Actor:** Engineering Manager  
**Goal:** Understand team health patterns over time from aggregated, anonymous survey data.

| ID | User Story | Acceptance Criteria |
|----|-----------|---------------------|
| US-04.1 | As a manager, I want to see a trend line for each survey question over time so I can identify improving or declining areas. | Dashboard displays a time-series chart per question with data points per completed survey period. |
| US-04.2 | As a manager, I want to compare the current period's scores to prior periods so I can quickly identify meaningful changes. | Dashboard highlights delta (e.g., ±% or arrow indicator) vs. the prior period and a configurable rolling average. |
| US-04.3 | As a manager, I want the dashboard to only show aggregated data so I cannot identify individual responses. | No individual response data or personally identifiable information is exposed in any dashboard view. |
| US-04.4 | As a manager, I want to see the response rate for each survey period so I know how representative the data is. | Response rate (% of team who submitted) is displayed per period; individual identities are not revealed. |
| US-04.5 | As a manager, I want my dashboard to show only my team's data so I cannot see other teams' results. | Data is strictly scoped to the authenticated manager's teams; no cross-team data is accessible. |

---

#### UC-05: Authentication & Authorization

**Actor:** Engineering Manager, Engineer  
**Goal:** Access the system securely using existing company credentials.

| ID | User Story | Acceptance Criteria |
|----|-----------|---------------------|
| US-05.1 | As a user, I want to log in using my company SSO (Entra ID) so I don't need a separate password. | Authentication is delegated entirely to the company OIDC provider; no local password storage. |
| US-05.2 | As a manager, I want my dashboard to be inaccessible to engineers so sensitive aggregated data is protected. | Engineers accessing the manager dashboard URL receive a 403 Forbidden response. |
| US-05.3 | As an engineer, I want to submit a survey response without being required to log in (token-based link) so the friction is minimal and anonymity is preserved. | Survey link contains a single-use, time-limited token; no SSO login is required to submit. |

---

## 3. Non-Functional Requirements

| ID | Category | Requirement | Verification Method |
|----|----------|-------------|---------------------|
| NFR-01 | Performance | Survey form initial load ≤ 2 seconds on a 4G mobile connection | Lighthouse performance audit (target score ≥ 90); measure Time to Interactive (TTI) |
| NFR-02 | Performance | Manager dashboard initial load ≤ 3 seconds under normal load | k6 or Artillery load test simulating concurrent dashboard requests |
| NFR-03 | Availability | System uptime ≥ 99.5% (excluding planned maintenance) | Uptime monitoring via UptimeRobot or Datadog synthetic checks |
| NFR-04 | Security | All data in transit encrypted using TLS 1.2+ | SSL Labs scan; reject HTTP and TLS < 1.2 at the load balancer |
| NFR-05 | Security | All data at rest encrypted (PostgreSQL tablespace encryption or disk-level) | Infrastructure review; confirm encryption at provisioning |
| NFR-06 | Security | Authentication via Entra ID OIDC; no local credential storage | Code review: no password hashing libraries; verify OIDC token validation |
| NFR-07 | Privacy | No personally identifiable information (PII) stored with survey responses | Database schema review; automated test asserting no user ID column on the responses table |
| NFR-08 | Privacy | Aggregated dashboard data suppressed when response count is below minimum threshold (k-anonymity) | Unit tests verifying suppression logic; manual QA with test data sets below threshold |
| NFR-09 | Accessibility | Survey form meets WCAG 2.1 AA standards | axe-core automated scan; manual keyboard navigation test |
| NFR-10 | Scalability | System supports at least 50 concurrent managers and 500 engineers without performance degradation | k6 load test with simulated concurrent users at target volumes |
| NFR-11 | Reliability | Scheduled survey notifications delivered within 15 minutes of configured send time | Integration test: verify notification dispatch time in staging with a short-cadence schedule |
| NFR-12 | Maintainability | Backend API endpoints covered by automated tests (≥ 80% coverage) | Jest/Supertest coverage report in CI pipeline |

---

## 4. Key Implementation Details

### 4.1 Technology Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React (existing org standard) |
| Backend | Node.js (existing org standard) |
| Database | PostgreSQL (existing org standard) |
| Authentication | Entra ID via OIDC (`openid-client` or equivalent Node.js OIDC library) |
| Version Control | GitHub |
| Issue Tracking | Jira |

---

### 4.2 Authentication & Authorization

- **SSO Login (Manager):** Implement OIDC authorization code flow against Entra ID. On successful authentication, the backend issues a short-lived JWT session token stored in an HttpOnly cookie.
- **Role Determination:** Roles (manager vs. engineer) are derived from Entra ID group membership or a local role table seeded during user provisioning. This must be confirmed as an open question (see Section 6).
- **Anonymous Survey Submission (Engineer):** Survey links contain a signed, single-use token (HMAC or JWT with `jti` claim). The token encodes the survey ID and team ID but no user identity. The backend validates and invalidates the token on submission. No authentication session is created.

---

### 4.3 Data Model (Conceptual)

```
Manager
  - id (UUID)
  - entra_oid (string, SSO identifier)
  - email (string)

Team
  - id (UUID)
  - name (string)
  - manager_id (FK → Manager)

TeamMember
  - id (UUID)
  - team_id (FK → Team)
  - entra_oid (string, engineer SSO identifier)
  - email (string)

SurveyConfig
  - id (UUID)
  - team_id (FK → Team)
  - frequency (enum: weekly | biweekly)
  - is_active (boolean)
  - questions (JSONB array of question definitions)

SurveyPeriod
  - id (UUID)
  - survey_config_id (FK → SurveyConfig)
  - period_start (date)
  - period_end (date)
  - status (enum: open | closed)

SurveyToken
  - id (UUID)
  - survey_period_id (FK → SurveyPeriod)
  - token_hash (string, hashed one-time token)
  - used_at (timestamp, nullable)
  - expires_at (timestamp)

Response
  - id (UUID)
  - survey_period_id (FK → SurveyPeriod)
  - submitted_at (timestamp)
  - answers (JSONB)  -- keyed by question ID, no user identifier
```

> **Privacy note:** The `Response` table must contain no direct or indirect reference to the responding engineer. The `SurveyToken` table links a token to a period, but is considered used/expired immediately after submission and must not be joinable back to a specific engineer in any production query.

---

### 4.4 Notification System

- **Supported channels (V1):** Email and/or Slack — channel selection to be confirmed as an open question (see Section 6).
- **Email:** Use a transactional email provider (e.g., SendGrid, AWS SES). Email contains team member's name (from SSO data), survey link with embedded single-use token, and an expiry date.
- **Slack:** If a Slack workspace integration is available, use Slack's Incoming Webhooks or Bot API to send a DM. Token is embedded in the survey URL.
- **Scheduling:** A background job (cron or a job queue such as BullMQ) runs on the configured cadence to generate tokens, create `SurveyPeriod` records, and dispatch notifications.

---

### 4.5 Dashboard Aggregation & Privacy Enforcement

- All dashboard queries aggregate at the `survey_period_id` level.
- If the total number of submitted responses for a period is below the **minimum response threshold** (exact value is an open question — suggested default: **5**), the period's data is suppressed and the manager sees a "Not enough responses to display results" message. This prevents de-anonymization in small teams.
- Trend data is computed as the mean score per question per period.
- Comparison to the prior period is displayed as an absolute delta and directional indicator.

---

### 4.6 Survey Form

- The form is a standalone React page rendered from the single-use token URL.
- No login wall; the token is sufficient authorization.
- Questions use a consistent response format (e.g., Likert 1–5 scale with optional free-text comment field).
- Form is optimized for mobile: large tap targets, minimal scrolling, single submission button.
- On submission, the token is invalidated and the engineer sees a confirmation screen. Returning to the URL shows an "already submitted" message.

---

## 5. Scope Boundaries

### In Scope — V1

- Anonymous recurring pulse surveys (weekly or bi-weekly cadence)
- Manager-configurable question sets (selection from a default question bank)
- Manager-configurable team membership
- Single-use tokenized survey links delivered via email and/or Slack
- Mobile-accessible survey form completable in under 3 minutes
- Manager trend dashboard with per-question time-series charts and period-over-period comparison
- Response-rate visibility per period (no individual attribution)
- Multi-manager support with strict data isolation (no cross-team visibility)
- SSO authentication via Entra ID / OIDC
- k-anonymity suppression when response count is below threshold

### Out of Scope — V1

| Item | Rationale |
|------|-----------|
| ML-based sentiment analysis | Adds significant complexity; not required for baseline health tracking |
| Cross-team comparison / benchmarking | Requires organizational data model and additional privacy controls |
| Integration with HR systems (Workday, etc.) | Out of scope per product decision; adds compliance complexity |
| Native mobile apps (iOS / Android) | Mobile-accessible web form meets the requirement; native apps are a future investment |
| Manager-to-engineer direct messaging or feedback loops within the tool | Out of scope for V1; anonymity must be preserved |
| Free-text response analysis or word clouds | Deferred pending privacy review of qualitative data storage |
| Self-service engineer registration | Engineers are added by managers; self-registration is not in scope |

---

## 6. Open Questions

The following questions must be resolved before or during the initial implementation sprint. Each blocking question is marked **[BLOCKING]**.

| ID | Question | Why It Matters | Owner |
|----|----------|----------------|-------|
| OQ-01 | **[BLOCKING]** What is the minimum response threshold below which dashboard data is suppressed (k-anonymity floor)? | Directly affects privacy enforcement logic and UX copy for suppressed periods. Recommend defaulting to 5. | Product / Legal |
| OQ-02 | **[BLOCKING]** How are engineers provisioned into the system — manually by managers via email, or synced automatically from Entra ID groups? | Determines complexity of the team-membership feature and whether a group-sync integration is needed. | Engineering / IT |
| OQ-03 | **[BLOCKING]** What is the default question bank (the 5–7 questions)? Who owns creating and approving them? | Required before the survey form or database schema can be finalized. | Product / HR |
| OQ-04 | **[BLOCKING]** Will notifications be delivered via email, Slack, or both? If Slack, is a workspace-level Slack app already approved? | Determines which notification infrastructure needs to be built or integrated. | Product / IT |
| OQ-05 | How should the system handle an engineer who is on multiple teams managed by different managers? | Affects token generation and response scoping; needs a clear data model decision. | Engineering |
| OQ-06 | What happens to survey data when an engineer is removed from a team? Is historical aggregated data preserved or purged? | Privacy and data retention policy must be defined. | Product / Legal |
| OQ-07 | How is the manager role assigned — via an Entra ID group, a claim in the OIDC token, or a manually maintained role table? | Required to implement role-based access control correctly. | Engineering / IT |
| OQ-08 | Is there a system administrator role needed for V1 (e.g., to provision the first manager, manage global settings)? If so, how is this role bootstrapped? | Affects initial deployment and onboarding flow. | Product / Engineering |
| OQ-09 | What is the survey window duration (e.g., how many days after the notification is sent can an engineer still submit)? | Determines token expiry time and `SurveyPeriod.period_end` logic. | Product |
| OQ-10 | Should the system send a reminder notification to engineers who have not submitted before the survey window closes? If so, how many reminders and at what interval? | Affects scheduling and notification complexity; also has UX implications for engineer experience. | Product |
| OQ-11 | What are the data retention requirements — how long should survey responses and aggregated data be stored? | Required for compliance and database sizing. | Legal / Product |

---

## 7. Change Log

| Version | Date | Author | Summary of Changes |
|---------|------|--------|-------------------|
| 1.0 | 2026-06-23 | AI (PM Role) | Initial draft — all sections complete. Pending resolution of open questions before implementation begins. |
