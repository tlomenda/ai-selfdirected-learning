## Governed Flow Test Results — Jul 23

**Scenario 1 (go path):**
Input: [product-teampulse.md]
Sentinel values:
```json
{
    "sections_present": [
        "Product Overview",
        "Features",
        "Non-Functional Requirements",
        "Key Implementation Details",
        "Scope Boundaries",
        "Open Questions",
        "Change Log"
    ],
    "word_count": 1300,
    "has_measurable_success_criteria": true,
    "has_explicit_out_of_scope": true,
    "has_problem_statement": true,
    "has_goals": true,
    "has_personas": true,
    "has_user_stories_or_use_cases": true,
    "has_acceptance_criteria": true,
    "has_nfr_with_verification": true
}
```
Hook decision: PASS
Architecture triggered: Yes
Notes: [worked as expected]

The create-architecture.md file was triggered and the missing inputs were asked for. Devin responded with the following:

```
PRD created and sentinel checks passed at /workflow/teampulse/prd.md and /workflow/teampulse/prd-sentinel.json.

To generate the architecture document, I need two file paths:

  1. Product description file path — the source product description to use as input.
  2. Tech stack file path — the source tech stack definition to use as input.

Please provide both paths so I can run prompts/1-create-arch/create-architecture.md and write architecture.md and arch-sentinel.json to /workflow/teampulse/.
```

---

**Scenario 2 (no-go path):**
Input: [I manually edited the prd-sentinel.md file to trigger a failure]
Sentinel values: 
```json
    {
    "sections_present": [
        "Product Overview",
        "Features",
        "Non-Functional Requirements",
        "Key Implementation Details",
        "Scope Boundaries",
        "Open Questions",
        "Change Log"
    ],
    "word_count": 1300,
    "has_measurable_success_criteria": true,
    "has_explicit_out_of_scope": true,
    "has_problem_statement": true,
    "has_goals": true,
    "has_personas": true,
    "has_user_stories_or_use_cases": false,
    "has_acceptance_criteria": true,
    "has_nfr_with_verification": true
}
Hook decision: FAIL
Failure message: [
    NO-GO DECISION: PRD sentinel checks failed. Halt the workflow and prompt the human to review and fix $PRD_FILE before continuing. Do not run create-architecture.md until the PRD passes the sentinel checks.
]
Architecture triggered: No

The following messages where also logged:
[2026-07-23T14:41:13Z] FAIL: PRD does not contain detailed user stories or use cases.
[2026-07-23T14:41:13Z] FAIL: One or more PRD sentinel checks failed.
[2026-07-23T14:41:13Z] HALT: Workflow stopped. Please review and fix /Users/tlomenda/Developer/projects/work/improving-state-of-ai/improving-deep-learning-program/ai-selfdirected-learning/deliverables/workflow/teampulse/prd.md, then re-run the create-prd step.


---

**Scenario 3 (gap scenario):**
Input: [dummy-prd.md]
Sentinel pass/fail: PASS
Promptfoo assertion that fails: [
    Features section includes User Stories or Use Cases with Acceptance Criteria — not just a feature list.
]
Architecture ran: Yes
Notes: [
    It is acceptable to run the complete workflow and run the outputs through the promptfoo assertions to indicate the downstream gaps from an lower quality PRD input
]

---

**Scenario 4 (missing sentinel):**
Hook behavior: Error was logged that the prd-sentinel.md file was not found
Notes: Nothing happens and the architecture document creation is not triggered