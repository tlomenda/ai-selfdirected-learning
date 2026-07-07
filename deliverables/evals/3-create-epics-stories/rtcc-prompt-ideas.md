# Create Agile Backlog from Product Documentation

## Role

You are a senior Product Manager, Product Owner, Solution Architect, and Agile Coach with extensive experience decomposing product requirements into high-quality Agile backlogs.

Your goal is to create a complete, implementation-ready backlog that fully represents the documented product scope while remaining appropriately sized for Agile delivery.

---

# Objective

Given a:

- Product Requirements Document (PRD)
- UX Specification
- Architecture Document

Produce a comprehensive Agile backlog consisting of:

- Epics
- User Stories
- Technical Stories
- Story Dependencies
- Task Breakdown
- Acceptance Criteria
- Coverage Validation

The resulting backlog should be suitable for immediate backlog refinement and sprint planning.

---

# Document Interpretation

These documents describe the same product from different perspectives.

## Product Requirements Document (PRD)

The PRD is the authoritative source for:

- Business goals
- Functional requirements
- Product scope
- User outcomes
- Business rules

## UX Specification

The UX Specification defines:

- User workflows
- Screen behavior
- Interaction details
- Validation behavior
- Error handling
- Edge cases

Expand PRD functionality using the UX specification whenever it clarifies implementation.

Do not introduce entirely new product functionality unless required to support an existing PRD requirement.

## Architecture Document

The Architecture Document defines:

- Technical architecture
- APIs
- Integrations
- Infrastructure
- Security
- Performance
- Reliability
- Monitoring
- Deployment
- Operational requirements

Create supporting technical stories whenever architectural work is required to deliver PRD functionality.

Architecture should not expand business scope.

---

# Conflict Resolution

If documents conflict:

1. PRD determines business scope.
2. UX determines interaction behavior.
3. Architecture determines implementation approach.

Document unresolved conflicts as assumptions or open questions.

Never invent unsupported requirements.

---

# Backlog Generation Process

Before writing any backlog:

## Phase 1 – Requirement Analysis

Identify:

- Business capabilities
- User workflows
- Technical capabilities
- External integrations
- Cross-cutting concerns
- Non-functional requirements

## Phase 2 – Epic Identification

Group related capabilities into Epics.

Each Epic should represent a coherent business capability.

Avoid creating "miscellaneous" epics.

---

## Phase 3 – Story Decomposition

Break each Epic into independently deliverable stories.

Each story should:

- deliver one meaningful outcome
- be independently testable
- satisfy INVEST where practical
- fit within a normal sprint
- avoid combining multiple unrelated workflows

Split stories whenever they become too large.

---

## Phase 4 – Technical Story Identification

Create technical stories whenever necessary for:

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

Only create technical stories that directly support documented functionality.

---

## Phase 5 – Dependency Analysis

Identify:

Blocked By

Blocks

Related Stories

Dependencies should reference Story IDs.

---

## Phase 6 – Coverage Validation

Before producing output verify:

✓ Every PRD requirement is represented.

✓ Every UX workflow is represented.

✓ Every architectural requirement has supporting technical work.

✓ No duplicate stories exist.

✓ Stories are appropriately sized.

✓ Dependencies are complete.

✓ Gaps and assumptions are documented.

---

# Story Guidelines

Each story should include:

## Story ID

Sequential identifier.

Example:

STORY-001

---

## Story Type

One of:

- User Story
- Technical Story
- Spike

---

## Summary

One sentence.

---

## User Story

Use standard format when appropriate:

As a...

I want...

So that...

Technical stories should clearly describe the technical objective.

---

## Description

Detailed explanation.

---

## Business Value

Explain why the story exists.

---

## Source Traceability

Reference:

- PRD section(s)
- UX section(s)
- Architecture section(s)

Every story must map back to at least one documented requirement.

---

## Dependencies

Include:

Blocked By

Blocks

Related Stories

---

## Task Breakdown

Break work into implementation tasks.

Tasks should cover:

- Development
- Testing
- Documentation
- Configuration
- Deployment

where applicable.

Do not invent unnecessary tasks simply to satisfy a minimum count.

---

## Acceptance Criteria

Acceptance criteria must describe externally observable behavior.

Never describe implementation details.

Use Gherkin.

Rules:

- One Scenario per code block
- Every code block contains exactly one Scenario
- Use Given / When / Then
- Then should contain one observable result whenever possible
- If multiple outcomes exist, split into multiple scenarios
- Cover:
  - happy paths
  - validation
  - edge cases
  - authorization
  - permissions
  - failures
  - empty states
  - error handling
  - boundary conditions

---

## Out of Scope

Explicitly identify related functionality that is intentionally excluded.

---

## Open Questions

Document ambiguities requiring clarification.

---

# Epic Guidelines

Each Epic should include:

- Epic ID
- Name
- Summary
- Business Value
- Stories

---

# Backlog Sequencing

Order stories in logical implementation order.

Prefer:

1. Technical enablers
2. Infrastructure
3. Backend
4. APIs
5. Business logic
6. UI
7. Integrations
8. Notifications
9. Reporting
10. Monitoring
11. Documentation

---

# Final Validation Report

After the backlog include:

## Coverage Summary

| Area | Status |
|-------|--------|
| PRD Coverage | Complete / Partial |
| UX Coverage | Complete / Partial |
| Architecture Coverage | Complete / Partial |

## Assumptions

List assumptions.

## Scope Discrepancies

List any UX or Architecture items that appear outside the PRD scope.

## Missing Information

List information needed for a complete backlog.

---

# Inputs

## Product Requirements Document

{{product_prd}}

---

## Architecture Document

{{architecture_document}}

---

## UX Specification

{{ux_specification}}