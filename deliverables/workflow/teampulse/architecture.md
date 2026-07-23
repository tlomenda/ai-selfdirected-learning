# TeamPulse Architecture Document

## 1. High-Level Architecture

TeamPulse is a web application built on the PERN stack: PostgreSQL for persistent storage, Express.js and Node.js for the backend API and job scheduling, and React (bundled with Vite) for the frontend. The system is split into two primary interfaces: a manager dashboard protected by Entra ID / OIDC, and an anonymous, tokenized survey form that does not require login. A lightweight job scheduler inside the Node.js backend triggers pulses and dispatches invitations. Aggregated trend data is computed in the backend and exposed through the dashboard API.

## 2. System Context Map

The Domain-Driven Design (DDD) context map identifies three bounded contexts. The boundaries below keep survey response data anonymous and isolated from team configuration and identity data.

```mermaid
graph LR
    subgraph TeamPulse
        IC[Identity & Access Context]
        TC[Team Configuration Context]
        SC[Survey & Reporting Context]
    end

    IC -- "authenticates managers" --> TC
    TC -- "creates pulses, rosters, invitations" --> SC
    SC -- "returns anonymous aggregates" --> TC

    ExtIDP[Entra ID / OIDC]
    ExtNotify[Email / Slack Gateway]
    Engineer[Engineer]
    Manager[Engineering Manager]

    Manager -- "SSO" --> ExtIDP
    ExtIDP -- "tokens & claims" --> IC
    Manager -- "configure / view dashboard" --> TC
    TC -- "send invitations" --> ExtNotify
    ExtNotify -- "tokenized link" --> Engineer
    Engineer -- "submit response" --> SC
```

### Bounded Contexts

| Context | Responsibility | Data Ownership |
|---------|----------------|----------------|
| Identity & Access | OIDC session validation, manager identity, role claims | SSO `sub`, `email`, `name`, `role` |
| Team Configuration | Manager profile, team roster, question set, pulse schedule, invitation delivery | `teams`, `team_members`, `question_bank`, `pulses`, `invitations` |
| Survey & Reporting | Anonymous response ingestion, aggregation, trend dashboard query | `responses`, aggregated views only |

## 3. System Breakdown (C4 Modeling)

### 3.1 System Context Diagram

```mermaid
C4Context
    title System Context Diagram for TeamPulse

    Person(manager, "Engineering Manager", "Configures surveys and views team trend dashboards.")
    Person(engineer, "Engineer", "Receives tokenized survey link and submits anonymous responses.")

    System(teamPulse, "TeamPulse", "Recurring, anonymous team health check system.")

    System_Ext(entra, "Entra ID / OIDC", "Company single sign-on provider for manager authentication.")
    System_Ext(email, "Email Gateway", "SMTP / transactional email provider.")
    System_Ext(slack, "Slack Gateway", "Slack messaging API for survey invitations.")

    Rel(manager, teamPulse, "Configures surveys and views dashboards", "HTTPS / OIDC")
    Rel(engineer, teamPulse, "Submits anonymous survey", "HTTPS / tokenized link")
    Rel(teamPulse, entra, "Authenticates manager", "OIDC")
    Rel(teamPulse, email, "Sends tokenized survey links", "SMTP / HTTPS API")
    Rel(teamPulse, slack, "Sends tokenized survey links", "HTTPS API")
```

### 3.2 Container Diagram

```mermaid
C4Container
    title Container Diagram for TeamPulse

    Person(manager, "Engineering Manager", "Configures surveys and views dashboards.")
    Person(engineer, "Engineer", "Receives link and submits responses.")

    Container_Boundary(browser, "Browser / Mobile Browser") {
        Container(spa, "React SPA", "React + Vite", "Manager dashboard and anonymous survey form.")
    }

    Container_Boundary(backend, "Node.js Backend") {
        Container(api, "API Server", "Express.js + TypeScript", "REST/JSON endpoints for dashboard, configuration, and anonymous survey submission.")
        Container(worker, "Pulse Worker", "Express.js + node-cron / node-schedule", "Schedules pulses and generates invitations.")
        Container(notifier, "Notification Service", "Express.js + TypeScript", "Sends email or Slack messages using adapter pattern.")
    }

    ContainerDb(db, "PostgreSQL", "PostgreSQL", "Stores managers, teams, pulses, invitations, and anonymous responses.")

    System_Ext(entra, "Entra ID / OIDC", "SSO")
    System_Ext(emailGw, "Email Gateway", "SMTP / Email API")
    System_Ext(slackGw, "Slack API", "Slack messaging")

    Rel(manager, spa, "Uses", "HTTPS")
    Rel(engineer, spa, "Opens tokenized link", "HTTPS")
    Rel(spa, api, "Reads/writes JSON", "HTTPS / REST")
    Rel(api, db, "Reads/writes data", "TCP / SQL")
    Rel(api, entra, "Validates OIDC tokens", "HTTPS")
    Rel(worker, db, "Creates pulses & tokens", "TCP / SQL")
    Rel(worker, notifier, "Dispatches invitations", "in-process or internal HTTP")
    Rel(notifier, emailGw, "Sends email", "SMTP / HTTPS")
    Rel(notifier, slackGw, "Sends Slack message", "HTTPS")
```

### 3.3 Component Diagram — API Server

```mermaid
C4Component
    title Component Diagram for TeamPulse API Server

    Container_Boundary(api, "API Server") {
        Component(auth, "Auth Middleware", "Express middleware", "Validates Entra ID OIDC tokens and enforces role-based access.")
        Component(teamConfig, "Team Configuration Controller", "Express + TypeScript", "CRUD for teams, rosters, question sets, and pulse schedules.")
        Component(survey, "Survey Controller", "Express + TypeScript", "Validates survey tokens and records anonymous responses.")
        Component(dashboard, "Dashboard Controller", "Express + TypeScript", "Returns aggregated trend and period-over-period data.")
        Component(aggregator, "Aggregation Service", "TypeScript", "Computes team-level aggregates from response records.")
        Component(scheduler, "Scheduler Service", "TypeScript", "Creates pulse windows and generates one-time tokens.")
        Component(notif, "Notification Adapter", "TypeScript", "Dispatches email or Slack invitations behind a common interface.")
        Component(repo, "Repository Layer", "TypeScript", "Encapsulates PostgreSQL queries using parameterized statements.")
    }

    ContainerDb(db, "PostgreSQL", "PostgreSQL", "Stores all application data.")

    Rel(auth, teamConfig, "protects", "request context")
    Rel(auth, dashboard, "protects", "request context")
    Rel(teamConfig, repo, "uses", "function calls")
    Rel(survey, repo, "uses", "function calls")
    Rel(dashboard, aggregator, "uses", "function calls")
    Rel(aggregator, repo, "uses", "function calls")
    Rel(scheduler, repo, "uses", "function calls")
    Rel(scheduler, notif, "dispatches", "function calls")
    Rel(repo, db, "queries", "TCP / SQL")
```

## 4. Conceptual Database Design

### 4.1 Entity-Relationship Diagram

```mermaid
erDiagram
    MANAGERS ||--|| TEAMS : manages
    TEAMS ||--o{ TEAM_MEMBERS : contains
    TEAMS ||--o{ PULSES : schedules
    TEAMS ||--o{ TEAM_QUESTION_SETS : configures
    QUESTION_BANK ||--o{ TEAM_QUESTION_SETS : belongs_to
    PULSES ||--o{ INVITATIONS : generates
    PULSES ||--o{ RESPONSES : collects
    QUESTION_BANK ||--o{ RESPONSES : answered_as

    MANAGERS {
        uuid id PK
        text sso_subject UK
        text email UK
        text role
        timestamp created_at
    }

    TEAMS {
        uuid id PK
        uuid manager_id FK
        text name
        text frequency
        timestamp next_pulse_at
        boolean active
    }

    TEAM_MEMBERS {
        uuid id PK
        uuid team_id FK
        text email
        text preferred_channel
        timestamp created_at
    }

    QUESTION_BANK {
        uuid id PK
        text text
        int scale_min
        int scale_max
        boolean active
    }

    TEAM_QUESTION_SETS {
        uuid team_id FK
        uuid question_id FK
        int display_order
    }

    PULSES {
        uuid id PK
        uuid team_id FK
        timestamp scheduled_at
        timestamp closed_at
        text status
    }

    INVITATIONS {
        uuid id PK
        uuid pulse_id FK
        uuid team_member_id FK
        text token_hash UK
        text channel
        timestamp sent_at
        timestamp used_at
        timestamp expires_at
    }

    RESPONSES {
        uuid id PK
        uuid pulse_id FK
        uuid question_id FK
        int value
        timestamp submitted_at
    }
```

### 4.2 Anonymity Rule

The `RESPONSES` table has no foreign key or column that identifies an individual. It does not reference `invitations`, `team_members`, `managers`, or any SSO claim. This guarantees that a response record cannot be attributed to a person through the schema alone.

### 4.3 Data Flow Diagram — Survey Submission

```mermaid
flowchart LR
    A[Engineer opens tokenized link] --> B[React SPA validates token with backend]
    B --> C{Token valid & unused?}
    C -->|No| D[Show error / expired link]
    C -->|Yes| E[Survey Controller marks invitation used]
    E --> F[Engineer submits answers]
    F --> G[Survey Controller writes only pulse_id, question_id, value, submitted_at to RESPONSES]
    G --> H[Return success confirmation]
```

### 4.4 Data Flow Diagram — Pulse Scheduling

```mermaid
flowchart LR
    A[Pulse Worker wakes at scheduled time] --> B[Create PULSE row for each active team]
    B --> C[Generate one-time INVITATION token per team member]
    C --> D[Notification Adapter sends via email or Slack]
    D --> E[Worker updates next_pulse_at based on frequency]
```

## 5. Integrations

### 5.1 API Interface Overview

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/auth/oidc/callback` | `GET` / `POST` | OIDC only | Handles Entra ID callback and establishes manager session. |
| `/api/teams` | `GET/POST/PUT/DELETE` | Manager | Manage team configuration and roster. |
| `/api/teams/:id/questions` | `GET/PUT` | Manager | Select 5–7 questions and ordering. |
| `/api/teams/:id/dashboard` | `GET` | Manager | Returns aggregated trend and period-over-period data for the manager's team. |
| `/api/pulses/:id/close` | `POST` | Manager or system | Closes a pulse and triggers aggregation refresh. |
| `/api/survey/:token` | `GET` | Token | Returns survey questions for the token's pulse. |
| `/api/survey/:token` | `POST` | Token | Submits anonymous responses. |
| `/health` | `GET` | None | Synthetic health check for uptime monitoring. |

All endpoints require HTTPS in production. Manager endpoints must present a valid Entra ID OIDC `id_token` or access token in the `Authorization` header. Anonymous survey endpoints accept only the single-use application token in the URL path.

### 5.2 External Integration Patterns

| External System | Pattern | Notes |
|-----------------|---------|-------|
| Entra ID / OIDC | OpenID Connect `authorization_code` flow or token validation | The backend validates tokens and extracts `sub` and `email` claims. No local password storage. |
| Email Gateway | SMTP or HTTPS API adapter | The `Notification Service` uses a common interface with an `EmailAdapter` implementation. |
| Slack Gateway | HTTPS REST API adapter | A `SlackAdapter` implementation can be swapped in without changing pulse or survey logic. |

**Adapter Pattern**: Both notification channels implement a single `Notifier` interface (e.g., `send(invitation: Invitation): Promise<void>`). Adding a new channel requires a new adapter, not changes to the scheduler or survey core.

## 6. Security Considerations

| Threat | Mitigation |
|--------|------------|
| Unauthorized dashboard access | All manager routes require valid Entra ID OIDC tokens. Backend re-evaluates `sub` / `email` against the `managers` table for every request. |
| Cross-team data leakage | Dashboard queries are filtered by `manager_id` or `team_id` derived from the authenticated manager. No endpoint accepts a `team_id` parameter from the client. |
| Individual response attribution | `RESPONSES` table has no user identifier columns and no FK to `invitations` or `team_members`. Aggregates are computed in SQL, not in the client. |
| Token replay | Invitation tokens are one-time; the backend checks `used_at IS NULL` before accepting a submission. Token hashes are stored, not plain tokens. |
| Token brute force / enumeration | Tokens are cryptographically random strings (≥128 bits). They expire after 7 days or at the next pulse, whichever is earlier. |
| Injection attacks | All database access uses parameterized queries / prepared statements. |
| Transit security | TLS 1.2+ for all browser, API, and integration traffic. |
| Session security | Manager sessions use short-lived OIDC tokens; refresh is delegated to Entra ID. |

## 7. Quality Attributes

| Quality Attribute | How It Is Addressed |
|-------------------|---------------------|
| **Performance** | The survey form is a lightweight React SPA. API responses are paginated; dashboard aggregates are pre-computed on pulse close. |
| **Reliability** | Stateless API servers behind a reverse proxy can be restarted without losing in-flight survey submissions. PostgreSQL is the single source of truth. |
| **Availability** | Health endpoint and synthetic monitoring support 99.9% uptime during pulse windows. The pulse worker can run as a separate process for resilience. |
| **Scalability** | Backend is stateless; additional Node.js instances can be added. Database read load for dashboards can be reduced with materialized aggregate tables if needed. |
| **Maintainability** | Clear bounded contexts, repository pattern, and adapter-based notification service isolate changes and enable unit testing with Jest (backend) and Vitest (frontend). |
| **Extensibility** | New notification channels or question types are added by implementing new adapters or question schemas without changing response storage. |
| **Security** | OIDC for authentication, team-level authorization, anonymous response schema, and one-time tokens. |

## 8. Deployment View

```mermaid
flowchart LR
    User[Browser / Mobile] --> LB[Reverse Proxy / TLS Termination]
    LB --> Static[React SPA static files]
    LB --> API[Node.js API + Worker processes]
    API --> DB[(PostgreSQL)]
    API --> OIDC[Entra ID]
    API --> Email[Email Gateway]
    API --> Slack[Slack API]
```

The React frontend is built with Vite into static assets served by a reverse proxy or static host. The Node.js backend runs one or more stateless processes: one or more API server processes and at least one pulse worker process. PostgreSQL runs as a managed or self-hosted service. The deployment topology does not depend on a specific cloud provider; any environment that can run Node.js, serve static files, and connect to PostgreSQL is acceptable.

## 9. Architecture Decisions and Trade-offs

| Decision | Rationale | Trade-off |
|----------|-----------|-----------|
| **PERN stack** | Matches the mandated tech stack and the team's skill set. | Vendor-agnostic but requires self-managed build and deployment tooling. |
| **Separate anonymous `RESPONSES` table** | Enforces anonymity at the database level and prevents accidental attribution in views or exports. | Debugging response issues is harder because there is no link back to invitations. |
| **One-time tokenized links, no engineer login** | Simplifies UX and avoids storing engineer credentials or sessions. | Lost invitations cannot be recovered without re-issuing a token. |
| **Pulse worker inside Node.js** | Reduces operational complexity for V1. | At scale, a dedicated job queue may be needed. |
| **Adapter pattern for notifications** | Allows email in V1 and Slack to be added without changing core logic. | Slightly more abstraction than a direct SMTP call. |
| **Aggregates computed on demand / at pulse close** | Keeps dashboard reads simple and consistent. | Large teams may require a periodic aggregate refresh strategy. |

## 10. Open Architecture Questions

1. Should the manager authenticate through a server-side session or a pure SPA implicit / PKCE OIDC flow?
2. How should invitation tokens be delivered if both email and Slack are configured for the same engineer?
3. Should expired invitation tokens be retained for audit, or deleted after the pulse closes?
4. Where should the pulse worker run — as a background process in the API container, as a separate container, or via an external cron service?
5. What is the disaster-recovery target for PostgreSQL (point-in-time recovery window, backup frequency)?
