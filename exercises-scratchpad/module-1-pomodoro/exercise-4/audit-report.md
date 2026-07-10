# Load-Bearing Audit

## Load-Bearing Audit Results — create-prd.md — Jun 12, 2026

The load-bearing audit (every instruction earns its place) audit led me to remove constraints 5-9 from the prompt, with the prediction that the score would drop for sonnet. However It did not drop - although the gap between sonnet and haiku increased from the final baseline run with all constraints. The final baseline run with all constraints had a delta of 2 assertions (Sonnet passes / Haiku fails). Where as the load-bearing audit run had a delta of 7 assertion (Sonnet passes / Haiku fails) with the constraints removed.

| Instruction | Predicted Load-Bearing Assertion | Tested | Result |
|-------------|----------------------------------|--------|--------|
| Constraints 5-9 removed from prompt| Test case assertions related to non-functional requirements and specific scoped details will fail without these constraints| Yes | Score did not drop as expected. For Sonnet, the model is inferring these constraints even when they are not present in the prompt.|
| ... | ... | ... | ... |

# Model Ladder Audit 

The model Ladder audit (every gap in models is understood and deliberately addressed), led me to asking my AI agent for guidance on how to proceed in refining and iterating on the prompt and assertions. This, coupled with experimentation and observation, led me to significantly closing the gap from 12 failed assertions to 2 failed assertions.

The downside - due to the comprehensive nature of my tests and assertions - is that it took a lot of time to run through all the iterations and test cases. But taking the time (hours not days) to do so was worth it, as it led to a much more robust and comprehensive prompt.

## Model Ladder Audit #2 — create-prd.md — Jun 12, 2026

Starting delta: [6] assertions Sonnet passes / Haiku fails

| Failing Assertion (Haiku) | Root Cause | Action Taken | Result |
|---------------------------|------------|--------------|--------|
| [assertion] | Sonnet inferring [X] / instruction ambiguous | Added [instruction] | Haiku now passes |
| The PRD does not say 'weekly heat map' without defining what 'week' means (calendar week or rolling 7 days)|||
| PRD explicitly states whether audio is required, optional with a default, or out of scope.|||
| PRD specifies considerations for when and how permission to receive notifications is triggered (e.g., after the user starts their first session, not on page load).|||
| The PRD does not use the phrase 'accurate timing' without defining what accuracy means numerically.|||
| PRD specifies wall-clock anchoring (Date.now()) as the timing mechanism, not tick counting.|||
|PRD addresses background tab throttling behavior and defines the required mitigation (Web Worker or visibility API recompute).|||
| ... | ... | ... | ... |

Final delta: [2] assertions
Decision: Getting a score of 95% is more than acceptable for this exercise. By refining a few key assertions and balancing adding explicit instructions, we've achieved a high level of consistency between models.

That said, to achieve a developer-ready PRD that is comprehensive and ready for implementation, at a glance I would recommend using Sonnet for this task. However, by closing the gaps between models and considering the experience level of the development team, Haiku could also be a viable option.

## Model Ladder Audit #1 — create-prd.md — [date]

Starting delta: [6] assertions Sonnet passes / Haiku fails

| Failing Assertion (Haiku) | Root Cause | Action Taken | Result |
|---------------------------|------------|--------------|--------|
| [assertion] | Sonnet inferring [X] / instruction ambiguous | Added [instruction] | Haiku now passes |
| The PRD does not say 'weekly heat map' without defining what 'week' means (calendar week or rolling 7 days)|||
| PRD explicitly states whether audio is required, optional with a default, or out of scope.|||
| PRD specifies considerations for when and how permission to receive notifications is triggered (e.g., after the user starts their first session, not on page load).|||
| The PRD does not use the phrase 'accurate timing' without defining what accuracy means numerically.|||
| PRD specifies wall-clock anchoring (Date.now()) as the timing mechanism, not tick counting.|||
|PRD addresses background tab throttling behavior and defines the required mitigation (Web Worker or visibility API recompute).|||
| ... | ... | ... | ... |

Final delta: [N] assertions
Decision: [which remaining gaps are accepted vs. planned for future iteration]

### NOTES: Cheat-mode

Based on my audits and testing I was able to get Sonnet to Green State, and get an improved score on Haiku as well (from 64% to 85%).

After some load bearing analysis I did notice a combination of missing or duplicate instructions and some inconsistencies in the test cases that could be improved. 

This is where cheat-mode came in. I took my audit findings and passed in my prompt eval to Claude Sonnet (thinking model) and asked it to review the prompt and suggest improvements. This helped me identify some areas where the prompt could be improved.

After running a final baseline test I was able to get Haiku to pass with a score of xx%.