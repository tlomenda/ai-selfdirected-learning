### US-3.3 — Engineer completes and submits anonymous survey
| Field | Value |
|-------|-------|
| **Story ID** | US-3.3 |
| **Type** | user |
| **Title** | Engineer completes and submits anonymous survey |
| **Description** | **As an** engineer, **I want** to answer 5–7 questions quickly on any device and submit my response, **so that** I can share feedback without spending much time. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 2.2, NFR-1, NFR-3, NFR-5, NFR-7; Architecture: §3.3, §5.2, §6.2, ADR-1; UX: §3, §4.5, §6.3, §7.2, §8.3, §9, §10, §12.2, §13 |
| **Dependencies** | **Blocked by:** US-3.2, TS-3.5, TS-3.7. **Blocks:** US-5.1. **Related:** US-3.4 |

**Acceptance Criteria**

```gherkin
Scenario: Engineer submits a complete survey
  Given an engineer has opened a valid survey form
  When they answer all required questions
  And they click "Submit"
  Then the response is stored anonymously
  And a confirmation page is displayed
  And the page reassures them the response is anonymous
```

```gherkin
Scenario: Engineer submits incomplete survey
  Given an engineer has opened a valid survey form
  When they leave required questions unanswered
  And they click "Submit"
  Then the form displays validation errors
  And required fields are highlighted
  And no response is stored
```

```gherkin
Scenario: Engineer accidentally double-clicks submit
  Given an engineer has already submitted a response for the current run
  When they attempt to submit again using the same token
  Then the system rejects the duplicate submission
  And a message explains that a response was already recorded
```

```gherkin
Scenario: Survey renders on a narrow mobile viewport
  Given an engineer opens the survey on a 320px-wide device
  When the page loads
  Then the form renders without horizontal scrolling
  And all controls are at least 44px tall
```

