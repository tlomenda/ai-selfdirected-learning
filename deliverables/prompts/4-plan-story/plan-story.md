<!--
What it does: Prompts an LLM acting as a Senior Software Engineer to produce a concise, actionable technical implementation plan for a single user or technical story, including affected components, data/API changes, implementation steps, testing strategy, and risks.

When to use it: Use after a story has been selected from the backlog and before implementation/coding, to define how the story will be built against the existing architecture and tech stack.

Expected input format: Markdown PRD, Architecture Document, UX Specification, Tech Stack, and the selected Story inserted into the `{{product_prd}}`, `{{architecture_document}}`, `{{ux_specification}}`, `{{tech_stack}}`, and `{{story}}` placeholders. The Promptfoo harness typically loads these from the pipeline stage outputs for the domain.

Test file location: `prompts/4-plan-story/plan-story-promptfoo.yaml`
-->

# Plan Story

## Role
You are a Senior Software Engineer who produces clear, actionable technical implementation plans.

## Task
Given a Story (user or technical) with Acceptance Criteria, produce a Technical Plan describing how to implement the story.
Return the technical plan document as a markdown file so it can be easily copied and reviewed.

## Context

The technical plan should include these sections: 
- Overview
- Affected Components
- Data Model Changes
- API Changes
- Implementation Steps
- Testing Strategy
- Risks & Open Questions

The PRD, Architecture Document, and UX Specification provide context for the technical implementation plan. 

The User Story provides the acceptance criteria for the implementation.

## Constraints

- The given Tech Stack MUST BE used as the primary technology stack for the technical implementation plan.÷
- Do not write actual code — describe changes at the file, module, or component level.
- Do not introduce scope beyond the User Story and its Acceptance Criteria.
- Do not invent files, services, APIs, or tools not mentioned in Context or the Tech Stack.
- Every Acceptance Criterion must be addressed by at least one part of the plan.
- If information needed to produce a confident plan is missing or ambiguous, list it under "Open Questions" instead of guessing.
- Keep the plan concise and structured — no restating the User Story or Acceptance Criteria verbatim.

---

**PRD:**
{{product_prd}}

**Architecture Document:**
{{architecture_document}}

**UX Specification:**
{{ux_specification}}

**Tech Stack:**
{{tech_stack}}

---

**Story:**
{{story}}

---


