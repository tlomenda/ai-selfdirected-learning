# Create PRD

## Role

You are a Product Manager who writes Product Requirements Documents (PRDs) for engineering-led software teams

## Task

Write a developer-ready product requirements document for a TeamPulse system that allows engineering managers to run anonymous, recurring pulse surveys with their teams. 

## Context

TeamPulse is a lightweight team health check system. 

Engineers answer 5–7 questions on a weekly or bi-weekly schedule. Results are aggregated and displayed in a trend dashboard visible only to the manager. Individual responses remain anonymous — managers see team-level patterns, not individual attributions.

The engineering organization is using a React frontend, a Node.js backend, and a PostgreSQL database. The team uses GitHub for version control and Jira for issue tracking. Authentication is via the company's existing SSO system (Entra ID / OIDC).

Providing a developer-ready PRD requires not only the features but also the non-functional requirements, implementation environment, explicit scope boundaries, and open questions that must be resolved before implementation begins.

A change log section with version and date is required to track iterations and improvements to the PRD.

The audience for this PRD is a solo developer or small development team who will be building the TeamPulse system.

## Constraints

1. The PRD requires the following sections:
      - Product Overview (Problem Statement & Goals)
      - Features (Personas, Use Cases & User Stories)
      - Non-Functional Requirements with suggested tool or method for verification
      - Key Implementation Details
      - Scope Boundaries
      - Open Questions
      - Change Log

2. Out of scope for V1:
      - ML-based sentiment analysis
      - Comparison across teams
      - Integration with HR systems
      - Mobile native apps

3. Key Requirements:
      - Engineers receive a notification (email or Slack) with a link to a brief survey form
      - Survey form is mobile-accessible and completable in under 3 minutes
      - Managers have a dashboard showing trend lines over time for each question, with comparisons to prior periods
      - All responses are stored anonymously — no individual attribution in any view, including admin views
      - Managers can configure: question set, frequency (weekly/bi-weekly), and team membership
      - The system supports multiple managers with separate teams; no cross-team visibility

4. Privacy & Authorization:
      - Only authorized managers can configure the system and view dashboards
      - Engineers can only submit survey responses
      - Managers can only view their own team's aggregated data and cannot see individual responses as they are anonymized for privacy