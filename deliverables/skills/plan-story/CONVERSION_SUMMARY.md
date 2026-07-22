# Plan Story Prompt Command → Skill Conversion

## Summary

Successfully converted the `@prompts/4-plan-story/plan-story.md` Prompt Command into a Skill located at `@skills/plan-story-skill/SKILL.md`.

## What Was Converted

### Source
- **File**: `@prompts/4-plan-story/plan-story.md`
- **Type**: Prompt Command (template-based prompt with variable placeholders)

### Destination
- **File**: `@skills/plan-story-skill/SKILL.md`
- **Type**: Devin Skill (executable skill with frontmatter metadata)

## Key Transformations

### 1. Frontmatter Added
```yaml
---
name: plan-story
description: Produces clear, actionable technical implementation plans from user stories. Use when you have a story with acceptance criteria and need to plan how to implement it within the constraints of the product, architecture, and technology stack.
triggers: both
---
```

**Rationale**:
- `name`: Matches the prompt command name for consistency
- `description`: Summarizes the skill's purpose and invocation context
- `triggers: both`: Allows both user-initiated (`/plan-story`) and model-initiated invocation based on context

### 2. Role and Task Preserved
- Kept the "Senior Software Engineer" role definition
- Maintained the core task: produce technical implementation plans from stories

### 3. Context Sections Restructured
The original prompt's context sections (PRD, Architecture Document, UX Specification, Tech Stack, Story) were transformed into:
- **"When to Invoke This Skill"**: Clarifies the invocation boundary (when to use this skill vs. other workflows)
- **"Gather Required Context"**: Explains how to obtain and validate required inputs

### 4. Constraints Converted to Actionable Guidance
Original constraints were reorganized into:
- **"Apply Constraints"**: Maintains all original constraints in a more readable format
- **"Structure the Plan"**: Provides the exact sections required in output

### 5. Plan Structure Formalized
The original prompt's list of required sections:
- Overview
- Affected Components
- Data Model Changes
- API Changes
- Implementation Steps
- Testing Strategy
- Risks & Open Questions

These are now part of the "Structure the Plan" section with brief descriptions of what each contains.

### 6. Usage Instructions Added
- **"How to Use This Skill"**: Step-by-step guidance for applying the skill
- **"Example Invocation"**: Concrete example showing input and expected output

## Key Differences from Original Prompt

| Aspect | Original Prompt | Skill Version |
|--------|-----------------|---------------|
| **Invocation** | Manual template substitution | Model-aware with triggers |
| **Input Handling** | Variable placeholders ({{...}}) | Contextual gathering with guidance |
| **Missing Data** | Assumes all inputs provided | Explicitly handles incomplete context |
| **Scope** | Single-use prompt | Reusable skill with clear boundaries |
| **Discovery** | Manual reference | Auto-discoverable via `/plan-story` or model inference |

## Invocation Boundary Analysis

Based on the skill readiness assessment, this skill is designed to activate when:

1. **Story Readiness**: User story has been defined and approved (not in draft/refinement)
2. **Context Availability**: Supporting documents (PRD, architecture, UX, tech stack) are available
3. **Intent Clarity**: User is asking "How should we implement this?" not "What should we build?"
4. **Output Need**: User needs implementation approach, task breakdown, component impact, or risk assessment

## Files Included

- `SKILL.md` - The executable skill definition
- `plan-story-skill-tests.md` - Test cases for validating skill behavior
- `CONVERSION_SUMMARY.md` - This document

## Next Steps

The skill is now ready to be:
1. Tested using the test cases in `plan-story-skill-tests.md`
2. Integrated into the project's skill discovery path (`.devin/skills/plan-story/SKILL.md` or similar)
3. Invoked via `/plan-story` command or automatically by the model when appropriate context is detected
