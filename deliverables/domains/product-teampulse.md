TeamPulse is a lightweight team health check system for engineering organizations.

Engineers answer 5–7 questions on a weekly or bi-weekly schedule. Results are aggregated and displayed in a trend dashboard visible only to the manager. Individual responses remain anonymous — managers see team-level patterns, not individual attributions.

Features:
- Engineering managers run anonymous, recurring pulse surveys with their teams
- Engineers answer 5–7 questions on a weekly or bi-weekly schedule
- Results are aggregated and displayed in a trend dashboard visible only to the manager
- Individual responses remain anonymous — managers see team-level patterns, not individual attributions
- Engineers receive a notification (email or Slack) with a single-use, time-limited tokenized link to a brief survey form
- Survey form is mobile-accessible and completable in under 3 minutes
- Managers have a dashboard showing trend lines over time per question, with period-over-period comparisons
- All responses are stored anonymously — no individual attribution in any view, including admin views
- Managers can configure: question set, frequency (weekly/bi-weekly), and team membership
- The system supports multiple managers with separate teams; no cross-team visibility

Feature Details - Privacy & Authorization:
- Only authorized managers can configure the system and view dashboards
- Engineers can only submit survey responses
- Managers can only view their own team's aggregated data; individual responses are never surfaced
- Multiple managers are supported; each manager's data is isolated; no cross-team visibility
- All survey responses must be stored anonymously: no user identifier, name, email, or SSO identity
  is linked to any individual response record
- Database schema must not store any user identifier alongside individual survey responses

Out of scope for V1:
- ML-based sentiment analysis
- Comparison across teams
- Integration with HR systems
- Mobile native apps

Technical context:
- Tech stack: React frontend, Node.js backend, PostgreSQL database.
- Authentication: Entra ID / OIDC (company SSO — no local credential storage).
- Tooling: GitHub for version control; Jira for issue tracking.