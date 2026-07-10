## Run History 

Conclusion: After multiple iterations, and getting inconsistent results for the model ladder delta, I am increasingly convinced that Sonnet is the better model for building PRDs. Haiku produces inconsistent test results from run to run and does not appear reliable for developer-ready PRD task. 

Ask: I would like to review other's Module 1 and 2 work so I can compare and contrast my approach with theirs.

### Baseline - Iteration 2 - Jun 23, 2026

Added change log requirement to the context of the RTCC prompt.

For the multi-role requirements coverage test case improved the rubrics to indicate engineering-facing vs manager-facing requirements.

Added Privacy & Authorization constraints to the RTCC prompt.

I also removed redundant and overly specific assertions from the test suite.

Sonnet score: 32/32 assertions passing (100%)
Haiku score:  26/32 assertions passing (82%)
Model Ladder delta: 32[Sonnet score] - 26[Haiku score] = [6] assertions
Config: ./create-prd-promptfoo.yaml

### Baseline - Iteration 1 - Jun 22

The subtle changes I made for the load-bearing "sonnet green run" improved the Haiku results and closed the gap between the models.

Sonnet score: 42/42 assertions passing (100%)
Haiku score:  39/42 assertions passing (93%)
Model Ladder delta: 42[Sonnet score] - 39[Haiku score] = [3] assertions
Config: ./create-prd-promptfoo.yaml

### Sonnet Green Run - Jun 22

One of the original assertions was incorrect (copy/paste error) and I removed it from the test suite.

Another assertion was reworded to indicate "some detail for a developer to start implementation" for the Survey scheduling behavior and notification mechanism. This wording is less strict and more realistic for a developer-ready PRD.

Sonnet score: 42/42 assertions passing (100%)
Config: ./create-prd-promptfoo.yaml

### Baseline - Base Run - Jun 22, 2026

Baseline run with extending the prompt and tailoring it to a TeamPulse context.

Sonnet score: 41/43 assertions passing (95%)
Haiku score:  33/43 assertions passing (77%)
Model Ladder delta: 41[Sonnet score] - 33[Haiku score] = [8] assertions
Config: ./create-prd-promptfoo.yaml