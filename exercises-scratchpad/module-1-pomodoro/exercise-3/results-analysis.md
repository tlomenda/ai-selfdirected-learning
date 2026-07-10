## Assertions Failing on Haiku Only

|TC | Failed Assertion | Hypothesis |
|-|-|-|
|#1|PRD contains a changelog to understand the history of changes|The assertion fails on Haiku but passes on Sonnet. My hypothesis: Sonnet is inferring [change log is important] from the product description without being told. Haiku is not. If I add [instruction to include a changelog] to the [Constraints] section, I predict Haiku will pass this assertion.|
|#1|The PRD does not specify framework choices, library selections, or build tooling, though it may include browser API requirements and data structure specifications.| The assertion fails on Haiku but passes on Sonnet. My hypothesis: Sonnet is inferring [that the technical solutions should only only include key details and not prescriptive about framework choices, etc] from the product description without being told. Haiku is not. If I add [instruction about not specifying overly detailed technical solutions in a PRD] to the [Constraints] section, I predict Haiku will pass this assertion.|
|||
|#2|PRD specifies wall-clock anchoring|The assertion fails on Haiku but passes on Sonnet. My hypothesis: Sonnet is inferring [about key detail about wall clock time with browser based apps] from the product description without being told. Haiku is not. If I add [instructions to add key solution details for browser-based apps] to the [Context] section, I predict Haiku will pass this assertion.|
|#2|PRD names the Page Visibility API|Same as row above|
|||
|#3|PRD mentioning requirements for empty state and how long to retain data|Haiku needs more guidance on these key requirements for a developer-ready PRD|
|||
|#4|A number of assertions (5) fail on Haiku only|My hypothesis is Sonnet is inferring more details from "a developer-ready PRD" than Haiku. Within the context section I need to add more explicit instructions about what details are required in a developer-ready PRD.|
|||

## Weakest Assertion Across Both Models

Which assertion failed most consistently — across both models and across multiple test cases? Write a specific hypothesis for why it is failing. This is your first iteration target for Exercise 4.

In Test Case 5, "Notify the user when a work session ends and a break begins." the assertions that fail are:

* PRD distinguishes between in-app visual alerts, Web Notifications API alerts, and audio alerts as three separate mechanisms. **This is due to audio alerts being an out-of-scope feature for this test case**. Should be an easy fix.

* PRD defines the complete fallback chain: what the user sees or hears if notification permission is denied, if audio context is suspended due to no prior user gesture, and if the tab is closed. **Nothing in prompt indicates what should happen during a tab close.**

* PRD specifies when and how Notification.requestPermission() is triggered (e.g., after the user starts their first session, not on page load). **This is indicated as an open question in the PRD**. Perhaps this should either be answered or removed from the PRD?