### US-1.2: Strategy Recommendation Display
**Story ID:** US-1.2  
**Type:** User Story  
**Title:** Strategy Recommendation Display  
**Description:** As a Learner, I want to see the optimal action for my current hand before I decide, so that I can compare my instinct to correct basic strategy.  

**Acceptance Criteria:**
```gherkin
Scenario: Recommendation is displayed before player decides
  Given a hand is dealt or a decision has been made
  When the player is ready to act
  Then the application displays one of: Hit, Stand, Double Down, or Split
  And the recommendation is visible and prominent
  And the recommendation is derived from the static strategy lookup table

Scenario: Recommendation updates after a hit
  Given the player has hit and received a new card
  When the new hand total is calculated
  Then the recommendation updates to reflect the new hand
  And the updated recommendation is displayed before the next decision

Scenario: Recommendation is shown for each split hand
  Given the player has split into multiple hands
  When each hand becomes active
  Then the recommendation for that specific hand is displayed
  And the recommendation reflects only that hand's composition
```
**Priority:** P0 (Critical)  
**Traceability:**
- PRD: US-1.2, NFR-1
- UX: Strategy Recommendation Box (Screen 2, 3, 7)
- Architecture: Strategy Engine, Hand Classifier, Strategy Lookup

**Dependencies:**
- Blocked By: US-1.1, TS-2.1, TS-2.2
- Blocks: US-1.3, US-1.4
- Related: TS-2.3