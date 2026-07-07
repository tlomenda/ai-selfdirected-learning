DevLog is a lightweight daily digest system that helps individual contributors recap and share their work at end of day. Developers fill out a short daily log (3–5 fields: what they worked on, what they completed, blockers, and what they plan tomorrow). The system sends a formatted summary to a configurable Slack channel at the end of each business day.

**Features/Key Requirements:**
- Developers access a simple web form (or Slack shortcut) to fill out their daily log — no more than 2 minutes to complete
- A nightly job aggregates that day's entries and posts a formatted summary to a team Slack channel
- The summary is readable in Slack without clicking through to another page
- Developers can configure their display name and whether their entries are included in the team digest (opt-out)
- Managers can view a rolling 30-day history of their team's logs in a web dashboard

**Technical context:** 
The team uses:
- React, Python (FastAPI), and PostgreSQL. 
- Slack integration via Slack Bolt for Python. 
- Infrastructure is Docker-based, deployed on AWS (ECS Fargate). 
- Authentication via Entra ID / OIDC.

**Out of scope for V1:** 
- AI summarization, 
- sentiment analysis, 
- cross-team comparisons, 
- integrations other than Slack.