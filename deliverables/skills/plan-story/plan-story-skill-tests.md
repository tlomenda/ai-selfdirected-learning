## Plan Story Skill Test Cases

A skill test file has three types of cases. This document provides 2 positive, 2 negative, and 2 quality cases:

---

## Skill Invocation Test Results

```
POSITIVE TC 1: Approved Story with Complete Supporting Context

Expected: Skill invoked successfully, returned markdown technical plan document
Actual: 

Model triggered the skill based on the initial input "How should we implement this story?"

The agent asked for the user story and other supporting documents, which were then provided. The result was a markdown technical plan document.
```

```
POSITIVE TC 2: Technical Story with Architecture Context

Expected: Skill invoked successfully, returned markdown technical plan document
Actual:

I started with `I need to understand what changes are required to implement @katas/devlog/sdlc-pipeline/ts1.1-logsubmission-api.md using architecture document 
  @katas/devlog/sdlc-pipeline/devlog-arch.md and @app/techstack/Python-Postgres-stack.md`

The model did not trigger the skill right away, it developed its own technical approach first THEN
asked me if I wanted to use the plan-story skill or proceed with its own approach. 
```

```
NEGATIVE TC 1: Story in Early Refinement (Ambiguous Requirements)

Expected: Skill NOT INVOKED
Actual: 

Skill was not invoked and I entered into a conversation about clarifying the story requirements and gathering more context.
```

```
NEGATIVE TC 2: Requirements Validation Request (Not Implementation Planning)

Expected: Skill NOT INVOKED
Actual: 

Skill was not invoked and I entered into a conversation to gather more context and resulted in potential gaps and implementation considerations.
```

---

## Positive Invocation Cases

### Positive Case 1: Approved Story with Complete Supporting Context

**Input/Context:**
```
User provides:
- A fully written user story with AC (happy path and edge cases)
- PRD: Requirements
- Architecture document: System and application architecture
- UX specification: Wireframes and user flows (not this may be optional for some stories that are focused on backend or infrastructure)
- Tech stack: Programming languages, frameworks, databases, APIs
- User's question: "How should we implement this story? What components need to change?"
```

**Signals for Correct Invocation:**
- Story is written with clear acceptance criteria (not a draft or vague requirement)
- User explicitly asks "How should we implement this?" (implementation planning intent)
- Supporting documents are referenced or provided (PRD, architecture, UX, tech stack)
- User is focused on technical approach, not requirements validation
- Story appears ready for development (no indication of pending design or requirement changes)

**Expected Output:**
A markdown technical plan document containing:
- **Overview**
- **Affected Components**
- **Data Model Changes**
- **API Changes**
- **Implementation Steps**
- **Testing Strategy**
- **Risks & Open Questions**

---

### Positive Case 2: Technical Story with Architecture Context

**Input/Context:**
```
User provides:
- A technical story with acceptance criteria.
- Architecture document
- Tech stack
- User's statement: "I need to understand what changes are required to implement <...>"
```

**Signals for Correct Invocation:**
- Story is a technical story (not a user-facing feature) but still has clear acceptance criteria
- User is asking for implementation guidance ("what changes are required")
- Architecture context is available showing system components
- Tech stack is specified
- Story is focused on a specific technical capability, not exploratory or investigative work

**Expected Output:**
A markdown technical plan document containing:
- **Overview**
- **Affected Components**
- **Data Model Changes**
- **API Changes**
- **Implementation Steps**
- **Testing Strategy**
- **Risks & Open Questions**

---

## Negative Invocation Cases

### Negative Case 1: Story in Early Refinement (Ambiguous Requirements)

**Input/Context:**
```
User provides:
- A draft story and vague acceptance criteria
- User's question: "Can you help me understand what this story should include?"
- No PRD, architecture, or UX specification provided yet
- User's intent: Requirements clarification and scope definition
```

**Why Skill Should NOT Invoke:**
- Story is in refinement phase, not approved/ready for development
- Acceptance criteria are incomplete and ambiguous (no specific metrics, unclear scope)
- User is asking for requirements clarification ("what should this include?"), not implementation planning
- Supporting context (PRD, architecture, UX) is not yet available
- Invoking plan-story here would create a plan based on assumptions, which could become obsolete as requirements are refined

**What Model Should Do Instead:**
- Ask clarifying questions about search requirements
- Help refine acceptance criteria (What does "faster" mean? How will relevance be measured?)
- Suggest gathering PRD, architecture, and UX context before planning
- Offer to help with requirements analysis or story refinement

**Failure Mode if Skill Invokes Incorrectly:**
- Generated plan would be based on assumptions about unclear requirements
- Team might begin estimating or designing based on the plan before requirements are finalized
- When requirements change during refinement, the plan becomes outdated and creates confusion
- Developers might implement based on assumptions in the plan rather than waiting for approved requirements
- Wasted effort and rework when actual requirements differ from assumptions

---

### Negative Case 2: Requirements Validation Request (Not Implementation Planning)

**Input/Context:**
```
User provides:
- A written story and acceptance criteria
- User's question: "Does this story make sense? Are the acceptance criteria complete? Should we add anything?"
- User's intent: Requirements validation and gap analysis
- Story is marked as "In Review" (not yet approved)
```

**Why Skill Should NOT Invoke:**
- User is asking for requirements validation ("Does this make sense?"), not implementation planning
- Story is "In Review" status, not approved/ready for development
- User is seeking feedback on completeness of requirements, not how to implement them
- The question "Should we add anything?" indicates requirements are still being finalized
- Invoking plan-story here would skip the requirements validation step and move prematurely to implementation

**What Model Should Do Instead:**
- Review the story and acceptance criteria for completeness
- Identify potential gaps (e.g., data privacy considerations, performance implications)
- Ask clarifying questions about requirements (e.g., Should PII be masked? What about deleted users?)
- Suggest requirements improvements before moving to implementation planning
- Recommend approval/refinement before invoking plan-story

**Failure Mode if Skill Invokes Incorrectly:**
- Technical plan would be created for incomplete or unvalidated requirements
- Plan might address requirements that are later changed during validation
- Team might discover missing requirements after planning is complete, requiring plan rework
- Developers might start implementation based on incomplete requirements
- Creates false sense of readiness when story still needs validation

---

## Quality Cases

### Quality Case 1: Completeness of Acceptance Criterion Coverage

**Given:** The skill invoked correctly for user story from Positive Case 1

**Quality Criteria:**
1. **Every Acceptance Criterion is Addressed**: The plan must explicitly map each AC to at least one section

2. **Traceability**: A reader should be able to trace from each AC to the plan sections that address it without ambiguity

3. **No Scope Creep**: The plan should not introduce features beyond the acceptance criteria

4. **Validation**: For each AC, the Testing Strategy section should describe how to verify it's met

---

### Quality Case 2: Constraint Adherence and Realistic Scope

**Given:** The skill invoked correctly for technical story from Positive Case 2

**Quality Criteria:**

1. **Tech Stack Compliance**: All proposed changes must use only technologies in the provided tech stack

2. **No Invented Components**: The plan should not introduce files, services, or APIs not mentioned in context or tech stack

3. **Module/Component Level Description**: Plan describes changes at the right level of abstraction

4. **Open Questions for Ambiguities**: Missing information should be listed, not guessede)

5. **Conciseness**: Plan is structured and concise, not verbose

---

### INVOCATION DECISION MATRIX

```
================================================================================

Scenario                                    | Status      | Docs              | Intent                  | Invoke? | Rationale
────────────────────────────────────────────┼─────────────┼───────────────────┼─────────────────────────┼─────────┼──────────
Approved story, complete context,           | Approved    | PRD, Arch, UX,    | Implementation          | ✅ YES  | Positive
"how to implement?"                         |             | Tech Stack        | planning                |         | Case 1
────────────────────────────────────────────┼─────────────┼───────────────────┼─────────────────────────┼─────────┼──────────
Technical story, architecture provided,     | Approved    | Architecture,     | Implementation          | ✅ YES  | Positive
"what changes?"                             |             | Tech Stack        | planning                |         | Case 2
────────────────────────────────────────────┼─────────────┼───────────────────┼─────────────────────────┼─────────┼──────────
Draft story, vague AC,                      | Draft/      | Partial/None      | Requirements            | ❌ NO   | Negative
"what should this include?"                 | Refinement  |                   | clarification           |         | Case 1
────────────────────────────────────────────┼─────────────┼───────────────────┼─────────────────────────┼─────────┼──────────
Story in review,                            | In Review   | Complete          | Requirements            | ❌ NO   | Negative
"does this make sense?"                     |             |                   | validation              |         | Case 2
────────────────────────────────────────────┼─────────────┼───────────────────┼─────────────────────────┼─────────┼──────────
Story with AC,                              | Approved    | Partial           | Requirements            | ❌ NO   | Ambiguous
"help me understand the requirement"        |             |                   | analysis                |         | - ask
────────────────────────────────────────────┼─────────────┼───────────────────┼─────────────────────────┼─────────┼──────────
Story approved,                             | Approved    | Complete          | Estimation              | ⚠️ MAYBE| Related
"estimate this for me"                      |             |                   | support                 |         | but distinct
────────────────────────────────────────────┼─────────────┼───────────────────┼─────────────────────────┼─────────┼──────────
Story approved,                             | Approved    | Complete          | Risk analysis           | ⚠️ MAYBE| Part of plan
"what are the risks?"                       |             |                   |                         |         | but clarify
────────────────────────────────────────────┼─────────────┼───────────────────┼─────────────────────────┼─────────┼──────────
Story with AC, user provides all context,   | Approved    | Complete          | Explicit request        | ✅ YES  | Clear
"create a plan"                             |             |                   | for plan                |         | signal

================================================================================
```

