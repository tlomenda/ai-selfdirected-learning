## SDLC Pipeline Run Notes — Blackjack — Jul 20

### Output Quality by Stage
**Create PRD:** [10/10 Decided to create the PRD using Sonnet in order to test my hypothesis of higher quality upstream makes it more feasible to use lower cost models (Haiku) for donwstream artifacts]
**Create Architecture:** [8/8 Used sonnet to create the Arch artifact. The remaining artifacts will use Haiku.]
**Create UX:** [14/14 The UX document had and extensive screen flow and information architecture.]
**Epics & Stories:** [13/14 Overall happy with the detailed breakdown. There was some hiccups on 2 stories describing the same capability]
**Plan Story:** [5/5]
**Implement Story:** [7.5/8 core behavior and edge cases are covered, but boundary scenarios covered in the implementation were not handled in the tests.]
**Review Implementation:** [10/10]

### Generalization: What Held Up vs. What Did Not
[For each command that failed on Blackjack criteria: was the failure a prompt issue or an input quality issue?]

(1) create-epics-stories command only provided details of a single user story not all deliverable stories.

Hypothesis: I added the following constraint to the command to excplicitly state that story details NEEDS to be included for
each story. Constraint (**ALL deliverable Stories MUST provide full story details for planning**).

Result: After re-running the command, all epic + story details were provided in the result.

(2) create-epics-stories. Two stories described the same capability (displaying strategy recommendations). Even though
one was for per-hand strategy after split.

Hypothesis: Some overlap might be unavoidable, however in this case adding more context to separate card play (hands) from displaying strategy implementations might fix this overlap in this case.

(3) implement-story. core behavior and edge cases are covered, but boundary scenarios covered in the implementation were not handled in the tests

Hypothesis: Missing testing constraints indicating that all scenarios within the implementation code needs to have a corresponding test.

### Upstream Dependency Trace
Vague language in the AC can be traced back to the PRD - where past PRD generation using a higher reasoning model produced more specific language and less vagueness in downstream AC. 

Hypotheis: experiment with adding more context to the PRD prompt to ensure that requirements coverage is more specific and measurable.

For Blackjack, even though less vagueness and overall "objective lanaguage" was used in AC, there was still subjective language with terms like prominent and clearly being present. Perhaps, specifically out these terms along with
specific examples to use would improve this.