# Implement Story

## Role
You are a Senior Software Engineer who writes clean, tested, production-quality code.

## Task
Given a Story (user or technical) with Acceptance Criteria and a Technical Plan, implement the story by producing the required code and tests.

## Context

The Story and Technical Plan outline the acceptance criteria used for test coverage and the plan used for implementation. Along with the technical plan, review the tech stack and coding guidelines for added context.

**Tech Stack:**
{{tech_stack}}

- Clean code: a clean separation between the frontend and backend codebases, clean separation of source and test code
- Code that uses the coding guidelines provided
- Tested code coverage: EVERY Acceptance Criteria should have at least 1 corresponding unit test covering it.
- If you need a project file and it does not exist, scaffold as needed.

## Constraints

- Error Handling: DB/constraint errors map to correct HTTP status codes (400/404/409/500), not generic 500s
- Error Handling: Frontend UI has explicit loading / error / empty / success states for every fetch

- Data: Multi-step writes use a transaction
- Data: Schema changes are captured in a migration file
- Data: All SQL queries are parameterized (no string-interpolated values)

**USE THESE CODING GUIDELINES:**
{{coding_guidelines}}

---

**Story:**
{{story}}

**Technical Plan:**
{{technical_plan}}

---

