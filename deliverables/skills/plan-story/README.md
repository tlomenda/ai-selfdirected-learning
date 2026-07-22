# Plan Story Skill

A Devin skill that produces clear, actionable technical implementation plans from user stories with acceptance criteria.

## Quick Start

**Invocation:** `/plan-story`

**When to Use:**
- You have a story with clear acceptance criteria
- The story is approved and ready for development
- You have supporting context (PRD, architecture, UX spec, tech stack)
- You're asking "How should we implement this?" not "What should we build?"

**What You Get:**
A structured markdown technical plan with:
- Overview
- Affected Components
- Data Model Changes
- API Changes
- Implementation Steps
- Testing Strategy
- Risks & Open Questions

---

## Files in This Directory

### Core Skill Files

1. **SKILL.md** (60 lines)
   - The executable skill definition
   - Frontmatter metadata (name, description, triggers)
   - When to invoke the skill
   - How to use the skill
   - Example invocation scenario

### Documentation & Testing

2. **plan-story-skill-tests.md** (245 lines)
   - Comprehensive test case documentation
   - Detailed positive cases with signals and expected outputs
   - Detailed negative cases with rationale and failure modes
   - Quality cases with specific criteria
   - Invocation decision matrix

3. **CONVERSION_SUMMARY.md** (93 lines)
   - Documents the conversion from prompt command to skill
   - Key transformations applied
   - Differences from original prompt
   - Invocation boundary analysis
   - Next steps for integration

4. **README.md** (this file)
   - Quick start guide
   - File directory overview
   - Usage examples

---

## Test Cases at a Glance

### ✅ Positive Cases (Skill SHOULD Invoke)

| Case | Story | Key Signal | Status |
|------|-------|-----------|--------|
| **Case 1** | Feature flag management | "How should we implement this?" + Complete context | Approved |
| **Case 2** | Request rate limiting | "What changes are required?" + Architecture provided | Approved |

### ❌ Negative Cases (Skill SHOULD NOT Invoke)

| Case | Story | Key Signal | Status | Why Not |
|------|-------|-----------|--------|---------|
| **Case 1** | Better search functionality | "What should this include?" + Vague AC | Draft/Refinement | Requirements still being clarified |
| **Case 2** | Export user data in bulk | "Does this make sense?" | In Review | Requirements validation needed first |

### ✓ Quality Cases (Output Validation)

| Case | Focus | Key Criteria |
|------|-------|--------------|
| **Case 1** | Acceptance Criterion Coverage | Every AC addressed, traceability, no scope creep, testing verification |
| **Case 2** | Constraint Adherence | Tech stack compliance, no invented components, appropriate abstraction level, open questions, conciseness |

---

## Invocation Boundaries

### ✅ INVOKE When:
- Story is **approved** and ready for development
- User has **supporting context** (PRD, architecture, UX, tech stack)
- User asks **"How should we implement this?"** (implementation planning intent)
- **Acceptance criteria are specific and measurable**

### ❌ DON'T INVOKE When:
- Story is in **draft, refinement, or review** phase
- **Supporting context is missing** or incomplete
- User asks **"What should we build?"** or **"Does this make sense?"** (requirements, not implementation)
- **Acceptance criteria are vague** or incomplete
- User is asking for **requirements clarification** or **validation**

### ⚠️ MAYBE INVOKE When:
- User asks "estimate this" (related but distinct; may need separate skill)
- User asks "what are the risks?" (part of plan but might want just risk analysis)

---

## Usage Examples

### Example 1: Feature Flag System

**User Input:**
```
I have a story for implementing a feature flag system. Here's the story:

"As a product manager, I want to create and manage feature flags so I can 
control feature rollout without deploying code"

Acceptance Criteria:
- Create a feature flag management UI in the admin dashboard
- Implement backend API endpoints to create, read, update, delete flags
- Add flag evaluation logic to the application runtime
- Support percentage-based rollout (0-100%)
- Persist flags in PostgreSQL database

I have the PRD, architecture document, and UX spec. Tech stack is Node.js, 
React, PostgreSQL. How should we implement this?
```

**Skill Invocation:** ✅ YES (Positive Case 1)

**Output:** Technical plan with 7 sections addressing all 5 acceptance criteria

---

### Example 2: Search Refinement

**User Input:**
```
I'm working on a search story that's still in refinement. The story is 
"As a user, I want better search functionality" but we're still figuring 
out what that means. Can you help me understand what this story should 
include?
```

**Skill Invocation:** ❌ NO (Negative Case 1)

**Model Should:** Ask clarifying questions about search requirements, help refine acceptance criteria, suggest gathering supporting documents first.

---

### Example 3: Requirements Validation

**User Input:**
```
I have a story for exporting user data in bulk. Here it is:

"As an admin, I want to export user data in bulk so I can perform data analysis"

Acceptance Criteria:
- Export all user records to CSV
- Include user ID, email, name, created_at, last_login
- Support filtering by date range
- Generate file within 30 seconds for 100K users

Does this story make sense? Are the acceptance criteria complete? 
Should we add anything?
```

**Skill Invocation:** ❌ NO (Negative Case 2)

**Model Should:** Review story for completeness, identify gaps (data privacy, PII handling), ask clarifying questions, suggest improvements before moving to implementation planning.

---

## Quality Standards

### Acceptance Criterion Coverage
- ✓ Every AC is addressed by at least one plan section
- ✓ Traceability from AC to plan sections is clear
- ✓ No scope creep beyond the ACs
- ✓ Testing strategy verifies each AC

### Constraint Adherence
- ✓ Uses only technologies in provided tech stack
- ✓ No invented components or services
- ✓ Describes changes at module/component level (not code)
- ✓ Lists open questions instead of guessing
- ✓ Concise and structured (no verbatim restating)

---

## Integration Notes

This skill is ready to be integrated into:
- Project-specific paths: `.devin/skills/plan-story/SKILL.md`
- Global paths: `~/.config/devin/skills/plan-story/SKILL.md`

The skill will be discoverable via:
- `/plan-story` command (user-initiated)
- Automatic invocation by the model when appropriate context is detected (model-initiated)

---

## References

- **Original Prompt Command:** `@prompts/4-plan-story/plan-story.md`
- **Skill Readiness Assessment:** `@skills/skill-readiness-assessment.md`
- **Skill Mechanism Notes:** `@skills/skill-mechanism-notes.md`

---

## Next Steps

1. **Review** the test cases in `plan-story-skill-tests.md`
2. **Validate** the skill against the positive and negative cases
3. **Test** the skill with real stories from your project
4. **Integrate** the skill into your project's `.devin/skills/` directory
5. **Monitor** invocation patterns and refine boundaries as needed

