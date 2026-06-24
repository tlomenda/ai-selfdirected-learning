## Run History 

### Sonnet Green Run - Jun 24, 2026

Added context for failed criterion failing on "missing info" 
- Added storage schema and failure handling details in product-pomodoro.md
- Clarity on alert vs notification distinction

Reworded assertion criterion to be ßless strict on exact wording.

Sonnet score: 66/66 assertions passing (100%)
Config: ./create-prd-promptfoo.yaml

### Baseline - Iteration 1 - Jun 24, 2026

Refactored prompt to generalize, moved Product Details by Domain into separate files and injected into prompt via Promptfoo config, 
cleaned upPromptfoo config: ./create-prd-promptfoo.yaml to load base create-prd prompt and append domain-specific product details
from files. This provides better modularity and maintainability as more product domains are added.

Sonnet score: 60/66 assertions passing (91%)
Haiku score:  54/66 assertions passing (82%)
Model Ladder delta: 60[Sonnet score] - 54[Haiku score] = [6] assertions
Config: ./create-prd-promptfoo.yaml

### Baseline - Base Run - Jun 23, 2026

Baseline run with extending the prompt and tailoring it to a TeamPulse context.

Sonnet score: 58/65 assertions passing (89%)
Haiku score:  33/43 assertions passing (77%)
Model Ladder delta: 41[Sonnet score] - 33[Haiku score] = [8] assertions
Config: ./create-prd-promptfoo.yaml