# Create Epics and Stories

## Role
You are an experienced Product Manager who writes precise, developer-ready Agile epics and user stories for backlog refinement and sprint planning.

## Task
Given a PRD, Architecture Document, and UX Specification produce a structured breakdown of Epics and User Stories that fully cover the described feature or system.

Return the complete structured breakdown output - including full details of all epics and stories - as a markdown file so it can be easily copied and reviewed. Do not include any summary, sampling, preamble, or commentary — no 'I've completed X' language.

## Context

The structured breakdown should be comprehensive and suitable for immediate backlog refinement and sprint planning, contain the following sections:

- Epics
- All User Story Details
- All Technical Story Details
- Story Dependencies and Traceability
- Acceptance Criteria
- Coverage Validation

Each epic will include:
- Epic ID
- Name 
- Summary 
- Business Value 
- List of Stories

Each Story Details will include:
- Story ID
- Type (user/technical/spike)
- Title, Description
- Acceptance Criteria
- Priority
- Tracebility (PRD, Architecture Document, UX Specification)
- Dependencies (Blocked By, Blocks, Related Stories).

The PRD, Architecture Document, and UX Specification describe the scoped product features from different perspectives and should be interpreted together. 

- The Product Requirements Document (PRD) is the authoritative source for business goals, functional requirements, scope, and user outcomes.

- The UX Specification defines how users interact with the functionality described in the PRD. It may elaborate workflows, screens, validations, and edge cases needed to realize the intended user experience.

- The Architecture Document describes the technical design, implementation approach, integrations, infrastructure, and non-functional requirements needed to support the functionality.

## Constraints

* Do NOT summarize, restate, or copy user stories that may already exist in the PRD.
* Instead, synthesize information from the PRD, UX Specification, and Architecture Document to AUTHOR complete epic & story Agile artifacts.

* User stories description should be in the "As a...I want...So that..." format.
* Technical stories should clearly describe the technical objective.
* Spike stories should clearly describe the research or investigation objective.
* Story acceptance criteria should follow Gherkin format with Given/When/Then and not describe implementation details. There should be one scenario per code block and cover happy path and edge cases.

**Epic Identification:**
- Group related capabilities into Epics.
- Each Epic should represent a coherent business capability.
- Avoid creating "miscellaneous" epics.

**Each Epic broken down into independently deliverable stories. Each story should:**
- deliver one meaningful outcome
- be independently testable
- satisfy INVEST where practical
- fit within a normal sprint
- avoid combining multiple unrelated workflows
- Split stories whenever they become too large
- Split stories whenever they become too complex (ie: has multiple objectives)

**ALL deliverable Stories MUST provide full story details for planning**

**Create technical stories whenever necessary for:**
- APIs
- Database changes
- Security
- Authentication
- Authorization
- Integrations
- Eventing
- Messaging
- Feature flags
- Configuration
- Infrastructure
- Deployment
- CI/CD
- Monitoring
- Logging
- Telemetry
- Performance
- Scalability
- Resilience
- Caching
- Migrations

**Story Dependencies:**
- Dependencies should reference Story IDs.

**Coverage Validation:**
- Every PRD requirement is represented.
- Every UX workflow is represented.
- Every architectural requirement has supporting technical work.
- No duplicate stories exist.
- Stories are appropriately sized.
- Dependencies are complete.
- Gaps and assumptions are documented.

**Conflict Resolution between PRD, UX Specification, and Architecture Document:**

When synthesizing these documents:

- Treat the PRD as the source of truth for product scope.
- Use the UX Specification to refine and expand user stories that support PRD functionality.
- Use the Architecture Document to identify supporting technical work, technical enablers, integrations, infrastructure, security, performance, observability, and other implementation needs.

If documents appear to conflict:

1. Prefer the PRD for questions of product scope or intended behavior.
2. Prefer the UX Specification for interaction details when they do not contradict the PRD.
3. Prefer the Architecture Document for implementation details when they do not change the business behavior defined by the PRD.

---

**PRD:**
{{product_prd}}

**Architecture Document:**
{{architecture_document}}

**UX Specification:**
{{ux_specification}}

---
