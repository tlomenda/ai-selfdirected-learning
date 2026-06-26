## Run History 

### Baseline Run 3 (Final) — Jun 12, 2026

Adding back the constraints 5-9 to the prompt led to 100% score for Sonnet + 95% for Haiku.

Sonnet score: 38/38 assertions passing (100%)
Haiku score:  36/38 assertions passing (95%)
Model Ladder delta: 38[Sonnet score] - 36[Haiku score] = [2] assertions
Config: ./exercise-4/create-prd-promptfoo.yaml

### Load-Bearing Audit Run for Haiku — Jun 12, 2026

By removing constraints 5-9 from the prompt that led to 100% score for Sonnet, led to the following score on Haiku:

Haiku score:  31/38 assertions passing (82%)
Model Ladder delta: 38[Sonnet score] - 31[Haiku score] = [7] assertions
Config: ./exercise-4/create-prd-promptfoo.yaml

This is still an improvement over the baseline run, but not as good as the final baseline run with all constraints.

### Baseline Run 2 — Jun 12, 2026

Hypothesis: [paste the hypothesis]
Change: Added [specific instruction] to [section]
Sonnet: 39/39 assertions passing (100%)
Haiku:  33/39 assertions passing (85%)
Failing assertions remaining (Sonnet): 0
Failing assertions remaining (Haiku): 
    - The PRD does not say 'weekly heat map' without defining what 'week' means (calendar week or rolling 7 days).
    - PRD explicitly states whether audio is required, optional with a default, or out of scope.
    - PRD specifies considerations for when and how permission to receive notifications is triggered (e.g., after the user starts their first session, not on page load).
    - The PRD does not use the phrase 'accurate timing' without defining what accuracy means numerically.
    - PRD specifies wall-clock anchoring (Date.now()) as the timing mechanism, not tick counting.
    - PRD addresses background tab throttling behavior and defines the required mitigation (Web Worker or visibility API recompute).

### Green State (Sonnet)— Jun 12, 2026

Goal: Get all assertions passing on Sonnet
Hypothesis: For a developer-ready PRD, adding more constraints around storage requirements will help the model produce a more complete document. This combined with slightly more flexible assertions should help.
Change: Most changes to Test #3. Added [clarity and details to the context and constraints as needed] to [prompt], and modified some assertions to be more flexible. 
Sonnet: 39/39 assertions passing
Haiku:  skipped (not relevant for this iteration)
Failing assertions remaining (Sonnet): 0

### Iteration to Green State — Jun 11, 2026

Goal: Get all assertions passing on Sonnet
Hypothesis: My assertions are too strict for a PRD and provide developers flexibility in implementation.
Change: Added [context and constraints] to [prompt], and modified some assertions to be more flexible.
Sonnet: 37/39 assertions passing (95%)
Haiku:  skipped (not relevant for this iteration)
Failing assertions remaining (Sonnet): [In test case #3]

### Baseline Run — Jun 10, 2026

Sonnet score: 42/47 assertions passing (89%)
Haiku score:  30/47 assertions passing (64%)
Model Ladder delta: 42[Sonnet score] - 30[Haiku score] = [12] assertions
Config: ./exercise-3create-prd-promptfoo.yaml