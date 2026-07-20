## SDLC Pipeline Run Notes — DevLog — Jul 18

### Output Quality by Stage
**Create PRD:** [10/10 Ran create-prd-promptfoo.yaml against output from create-prd command for Devlog completeness and developer readiness]
**Create Architecture:** [8/8 Ran create-arch-promptfoo.yaml against output from create-arch command for DevLog completeness and developer readiness]
**Create UX:** [13/14 Overall good score including the failed rubric which had a 0.9 score BUT there was not a sepearate "Error Handling" section in the output]
**Epics & Stories:** [13/14 summary]
**Plan Story:** [4/4 summary]
**Implement Story:** [6.5/8 summary - frontend tests leverage mocking. However the pytest tests do not. NOTE: I did not indicate using pytest-mock for mocking in my app tech stack. If I would have provided this context I feel that Python test mocks would have been implemented.]
**Review Implementation:** [10/10 summary - good result from the implementation review of a single story.]

### Generalization: What Held Up vs. What Did Not
[For each command that failed on DevLog criteria: was the failure a prompt issue or an input quality issue?]

(1) PRD + UX Spec - Missing Team Configuration Requirement ??
One requirement that was either implicitly or explicitly missing configuring each DevLog Team of developers and manager(s). This could have been more explicitly stated in the DevLog product description providing more detailed
input to the prompts.

Hypothesis: Use higher reasoning model (Sonnet) for upfront PRD and Architecture outputs. All outputs in this SDLC pipeline were generated with Haiku as the model. In earlier exercises I concluded that the PRD and Architecture outputs should be generated with Sonnet as they are essential to the overall quality of downstream work. Perhaps requirements would not have been missed if a higher reasoning model was used.

(2) Epics & Stories - "mixed bag" of vague/subjective language in AC"
Rubric returned an overall score of 0.3. Many of the criteria were objective and measurable, but because there were some AC with vague language this was called out.

### Upstream Dependency Trace
Vague language in the AC can be traced back to the PRD - where past PRD generation using a higher reasoning model produced more specific language and less vagueness in downstream AC. 

Hypotheis: experiment with adding more context to the PRD prompt to ensure that requirements coverage is more specific and measurable.