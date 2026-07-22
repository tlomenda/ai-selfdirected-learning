## PRD Sentinel File Schema

### Purpose
This sentinel file is a **structural and basic completeness gate** that runs immediately after the create-prd.md prompt completes. It catches obvious failures (missing sections, insufficient content, malformed markdown) before the output is passed to promptfoo for detailed rubric evaluation. The hook uses this schema to:
- Verify all 7 required sections are present and in the correct order
- Confirm minimum content thresholds to avoid trivial outputs
- Detect markdown parsing errors or structural corruption
- Halt the workflow if critical sections are missing or empty

This is a **fast, deterministic check** that prevents obviously broken PRDs from reaching the evaluation layer.

### Schema
```json
{
  "sections_present": ["Product Overview", "Features", "Non-Functional Requirements", "Key Implementation Details", "Scope Boundaries", "Open Questions", "Change Log"],
  "word_count": 700,
  "has_measurable_success_criteria": true,
  "has_explicit_out_of_scope": true,
  "has_product_overview": true,
  "has_problem_statement": true,
  "has_goals": true,
  "has_personas": true,
  "has_user_stories_or_use_cases": true,
  "has_acceptance_criteria": true,
  "has_nfr_with_verification": true
}
```

### Required Properties
| Property | Type | Required Value | On Failure |
|----------|------|---------------|------------|
| sections_present | array | must include all 7 sections in order: Product Overview, Features, Non-Functional Requirements, Key Implementation Details, Scope Boundaries, Open Questions, Change Log | **halt workflow** |
| word_count | number | ≥ 700 words | **warn** (allow continuation, but flag for review) |
| has_measurable_success_criteria | boolean | true | **halt workflow** |
| has_explicit_out_of_scope | boolean | true | **halt workflow** |
| has_product_overview | boolean | true | **halt workflow** |
| has_problem_statement | boolean | true (within Product Overview) | **halt workflow** |
| has_goals | boolean | true (within Product Overview) | **halt workflow** |
| has_personas | boolean | true (within Features) | **halt workflow** |
| has_user_stories_or_use_cases | boolean | true (within Features) | **halt workflow** |
| has_acceptance_criteria | boolean | true (within Features) | **halt workflow** |
| has_nfr_with_verification | boolean | true (within Non-Functional Requirements) | **halt workflow** |

### What This Does NOT Validate
This sentinel file **cannot and should not** validate:

1. **Quality of content** — Whether the problem statement is compelling, goals are well-reasoned, or personas are realistic. Promptfoo handles this with LLM-rubric assertions.

2. **Correctness of technical details** — Whether the Non-Functional Requirements are actually achievable, whether the storage schema is sound, or whether the implementation details are feasible. This requires domain expertise and is evaluated by promptfoo.

3. **Accuracy of feature descriptions** — Whether user stories match the product description, whether acceptance criteria are appropriate, or whether features are complete. Promptfoo validates this.

4. **Quality of scope boundaries** — Whether the out-of-scope items are reasonable, whether they represent genuine ambiguities, or whether the in-scope clarifications are helpful. Promptfoo checks this.

5. **Thoughtfulness of open questions** — Whether questions are non-trivial, whether they represent real decisions that need judgment, or whether they are framed constructively. Promptfoo validates this.

6. **Consistency across sections** — Whether personas are referenced consistently in user stories, whether NFRs align with features, or whether implementation details support the stated requirements. Promptfoo checks cross-section coherence.

7. **Absence of framework/library prescriptions** — Whether the PRD inappropriately mandates specific tech choices. Promptfoo validates this constraint.

8. **Privacy and anonymity operationalization** — Whether privacy claims are concrete and verifiable vs. vague assurances. Promptfoo validates this.

**Promptfoo's role:** Promptfoo uses LLM-rubric assertions to evaluate all semantic, technical, and coherence aspects. It reads the full PRD and judges whether the content meets the quality bar defined in the create-prd.md constraints.