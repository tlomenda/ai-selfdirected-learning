# Blackjack with Strategy Coach — Epics and User Stories

---

## Epics

### Epic 1: Core Game Engine & Hand Management
**Epic ID:** E-1  
**Name:** Core Game Engine & Hand Management  
**Summary:** Implement the foundational game logic for dealing, managing hands, calculating hand values, and enforcing blackjack rules. This epic covers the core mechanics that all other features depend on.  
**Business Value:** Enables the core gameplay experience; all other features build on this foundation.  
**Stories:** US-1.1, US-1.3, US-1.6, TS-1.1, TS-1.2, TS-1.3, TS-1.4

---

### Epic 2: Strategy Recommendation Engine
**Epic ID:** E-2  
**Name:** Strategy Recommendation Engine  
**Summary:** Implement the basic strategy lookup table and the engine that classifies hands and returns optimal recommendations at every decision point.  
**Business Value:** Delivers the core learning mechanism—showing players the mathematically correct action before they decide.  
**Stories:** US-1.2, TS-2.1, TS-2.2, TS-2.3

---

### Epic 3: Decision Accuracy Tracking & Feedback
**Epic ID:** E-3  
**Name:** Decision Accuracy Tracking & Feedback  
**Summary:** Track player decisions against recommendations, calculate per-hand and session accuracy, and display feedback to the learner.  
**Business Value:** Provides measurable progress feedback, enabling learners to gauge improvement and identify weak areas.  
**Stories:** US-1.4, US-1.7, US-3.1, US-3.2, TS-3.1, TS-3.2

---

### Epic 4: Multi-Hand Split Logic
**Epic ID:** E-4  
**Name:** Multi-Hand Split Logic  
**Summary:** Implement the ability to split hands up to three times (four simultaneous hands), manage each hand independently, and track strategy recommendations and accuracy per hand.  
**Business Value:** Supports realistic blackjack scenarios and teaches strategy for complex multi-hand situations.  
**Stories:** US-2.1, US-2.2, TS-4.1, TS-4.2

---

### Epic 5: Insurance & Dealer Blackjack Handling
**Epic ID:** E-5  
**Name:** Insurance & Dealer Blackjack Handling  
**Summary:** Implement insurance offer when dealer shows an Ace, detect blackjack, and resolve hands correctly when blackjack is involved.  
**Business Value:** Ensures the game follows standard casino rules and handles edge cases correctly.  
**Stories:** US-1.5, US-1.6, TS-5.1, TS-5.2

---

### Epic 6: User Interface & Interaction
**Epic ID:** E-6  
**Name:** User Interface & Interaction  
**Summary:** Build the React-based UI that displays the game state, strategy recommendations, decision buttons, and accuracy feedback. Ensure responsive design and intuitive interaction.  
**Business Value:** Delivers a learner-friendly interface that makes strategy learning accessible and engaging.  
**Stories:** US-1.1, US-1.2, US-1.7, US-3.1, US-3.2, TS-6.1, TS-6.2, TS-6.3

---

### Epic 7: Testing & Quality Assurance
**Epic ID:** E-7  
**Name:** Testing & Quality Assurance  
**Summary:** Implement comprehensive unit tests for all game logic, strategy correctness, and accuracy calculations. Verify NFRs and perform integration testing.  
**Business Value:** Ensures correctness, reliability, and compliance with all non-functional requirements.  
**Stories:** TS-7.1, TS-7.2, TS-7.3, TS-7.4, TS-7.5, TS-7.6

---

### Epic 8: Deployment & Infrastructure
**Epic ID:** E-8  
**Name:** Deployment & Infrastructure  
**Summary:** Set up build pipeline, static file hosting, and deployment automation. Ensure the application is accessible and performant.  
**Business Value:** Enables users to access the application reliably and ensures fast load times.  
**Stories:** TS-8.1, TS-8.2, TS-8.3

---

## User Story Details

### US-1.1: Initial Deal
**Story ID:** US-1.1  
**Type:** User Story  
**Title:** Initial Deal  
**Description:** As a Learner, I want to be dealt two cards and see the dealer's up-card, so that I can evaluate my starting hand.  
**Acceptance Criteria:**
```gherkin
Scenario: Player receives initial two-card hand
  Given the game is in the initial state
  When a new hand is dealt
  Then the player receives two face-up cards
  And the dealer receives one face-up card (up-card) and one face-down card (hole card)
  And the player's hand total is displayed (e.g., "10 + 5 = 15" or "A + 6 = soft 17")
  And the dealer's hole card is not revealed

Scenario: Blackjack is detected on initial deal
  Given the player is dealt an Ace and a 10-value card
  When the hand is evaluated
  Then the hand is immediately resolved as blackjack
  And the hand does not proceed to the decision phase

Scenario: Soft hand is correctly labeled
  Given the player is dealt an Ace and a 6
  When the hand total is displayed
  Then it shows "A + 6 = soft 17" or equivalent
  And the soft status is clearly communicated
```
**Priority:** P0 (Critical)  
**Traceability:**
- PRD: US-1.1, NFR-2, NFR-3
- UX: Screen 2 (Deal Screen)
- Architecture: Hand Representation, Soft Hand Algorithm

**Dependencies:**
- Blocked By: None
- Blocks: US-1.2, US-1.3, US-1.4
- Related: TS-1.1, TS-1.2, TS-1.3

---

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

---

### US-1.3: Player Decision
**Story ID:** US-1.3  
**Type:** User Story  
**Title:** Player Decision  
**Description:** As a Learner, I want to choose Hit, Stand, Double Down, or Split, so that I can play the hand.  
**Acceptance Criteria:**
```gherkin
Scenario: Player hits and receives a card
  Given the player's hand is not bust
  When the player clicks the Hit button
  Then a card is dealt to the active hand
  And the hand total is recalculated
  And if the total exceeds 21, the hand busts and the turn ends
  And if the total is 21 or less, the player may continue deciding

Scenario: Player stands
  Given the player's hand is not bust
  When the player clicks the Stand button
  Then no card is dealt
  And the turn for the active hand ends
  And if there are more hands, the next hand becomes active
  And if there are no more hands, the dealer plays

Scenario: Player doubles down on first decision
  Given the player's hand is exactly two cards
  When the player clicks the Double Down button
  Then one additional card is dealt
  And the hand stands automatically
  And the turn ends

Scenario: Player splits a pair
  Given the player's hand is exactly two cards of equal rank
  And fewer than four hands exist
  When the player clicks the Split button
  Then the hand is divided into two hands
  And each hand receives one new card
  And the first hand becomes active
  And the player plays each hand in sequence

Scenario: Split is not available when conditions are not met
  Given the player's hand is not a pair
  Or four hands already exist
  When the player views the decision buttons
  Then the Split button is disabled
```
**Priority:** P0 (Critical)  
**Traceability:**
- PRD: US-1.3, In-Scope Clarifications
- UX: Decision Buttons, Screen 2, 3, 7
- Architecture: Game Engine, Hand Manager, Split Manager

**Dependencies:**
- Blocked By: US-1.1, US-1.2
- Blocks: US-1.4, US-1.6, US-1.7
- Related: US-2.1, TS-1.1, TS-4.1

---

### US-1.4: Decision Accuracy Recording
**Story ID:** US-1.4  
**Type:** User Story  
**Title:** Decision Accuracy Recording  
**Description:** As a Learner, I want each decision I make to be compared against the strategy recommendation, so that my accuracy is tracked correctly.  
**Acceptance Criteria:**
```gherkin
Scenario: Correct decision is recorded
  Given a strategy recommendation is displayed
  When the player chooses an action that matches the recommendation
  Then the decision is recorded as correct
  And the correct decision counter is incremented

Scenario: Incorrect decision is recorded
  Given a strategy recommendation is displayed
  When the player chooses an action that does not match the recommendation
  Then the decision is recorded as incorrect
  And the correct decision counter is not incremented

Scenario: Split decision is recorded as one decision
  Given the player has a pair
  When the player clicks Split
  Then the split action itself is recorded as one decision (correct or incorrect)
  And subsequent decisions on each resulting hand are recorded independently

Scenario: Insurance decision is not scored
  Given the dealer shows an Ace
  When the player accepts or declines insurance
  Then the insurance decision is not included in the accuracy count
```
**Priority:** P0 (Critical)  
**Traceability:**
- PRD: US-1.4, NFR-5
- UX: Accuracy Display
- Architecture: Accuracy Tracker

**Dependencies:**
- Blocked By: US-1.2, US-1.3
- Blocks: US-1.7, US-3.1
- Related: TS-3.1, TS-3.2

---

### US-1.5: Insurance
**Story ID:** US-1.5  
**Type:** User Story  
**Title:** Insurance  
**Description:** As a Learner, I want to be offered insurance when the dealer shows an Ace, so that the game follows standard casino rules.  
**Acceptance Criteria:**
```gherkin
Scenario: Insurance is offered when dealer shows Ace
  Given the dealer's up-card is an Ace
  When a hand is dealt
  Then the player is offered insurance before any player decision
  And an insurance prompt is displayed with Accept/Decline options

Scenario: Insurance decision is not scored for accuracy
  Given insurance is offered
  When the player accepts or declines
  Then the insurance decision is not included in the accuracy count
  And the game continues to the normal decision flow

Scenario: Insurance payout is applied when dealer has blackjack
  Given the player accepted insurance
  When the dealer's hole card is revealed
  And the dealer has blackjack
  Then the insurance payout is displayed
  And the hand outcome reflects the insurance resolution
```
**Priority:** P1 (High)  
**Traceability:**
- PRD: US-1.5
- UX: Screen 6 (Insurance Prompt)
- Architecture: Dealer Engine, Hand Resolver

**Dependencies:**
- Blocked By: US-1.1
- Blocks: US-1.3
- Related: TS-5.1, TS-5.2

---

### US-1.6: Dealer Play and Hand Resolution
**Story ID:** US-1.6  
**Type:** User Story  
**Title:** Dealer Play and Hand Resolution  
**Description:** As a Learner, I want to see the dealer play their hand after I finish, so that I know the outcome.  
**Acceptance Criteria:**
```gherkin
Scenario: Dealer hole card is revealed
  Given all player hands are complete
  When the dealer's turn begins
  Then the dealer's hole card is revealed

Scenario: Dealer plays by strict rule
  Given the dealer's hand is complete
  When the dealer evaluates their hand
  Then the dealer hits on every total of 16 or less
  And the dealer hits on soft 16
  And the dealer stands on every total of 17 or more
  And the dealer stands on soft 17

Scenario: Hand outcomes are evaluated correctly
  Given the dealer's hand is complete
  When outcomes are evaluated
  Then each outcome is one of: player bust, dealer bust, player total higher, dealer total higher, or push
  And blackjack pays 3:2
  And a player 21 achieved by hitting (not initial deal) is not blackjack
  And split hands are resolved independently

Scenario: Multiple split hands are resolved independently
  Given the player has split into multiple hands
  When the dealer's hand is complete
  Then each player hand is compared to the dealer's hand independently
  And each hand receives its own outcome
```
**Priority:** P0 (Critical)  
**Traceability:**
- PRD: US-1.6, NFR-4
- UX: Screen 4 (Dealer Play), Screen 5 (Hand Resolution)
- Architecture: Dealer Engine, Hand Resolver

**Dependencies:**
- Blocked By: US-1.3
- Blocks: US-1.7
- Related: TS-1.4, TS-5.2

---

### US-1.7: Post-Hand Accuracy Display
**Story ID:** US-1.7  
**Type:** User Story  
**Title:** Post-Hand Accuracy Display  
**Description:** As a Learner, I want to see my decision accuracy for the hand just played, so that I get immediate feedback.  
**Acceptance Criteria:**
```gherkin
Scenario: Per-hand accuracy is displayed after hand resolution
  Given a hand has been resolved
  When the resolution screen is displayed
  Then the per-hand accuracy is shown as a percentage
  And the accuracy is calculated as (correct decisions / total decisions) × 100
  And the accuracy is rounded to the nearest integer
  And the breakdown is displayed (e.g., "67% (2/3)")

Scenario: Single-decision hands show 100% or 0%
  Given a hand had exactly one decision (e.g., player stood immediately)
  When the hand is resolved
  Then the accuracy is either 100% (if correct) or 0% (if incorrect)
```
**Priority:** P1 (High)  
**Traceability:**
- PRD: US-1.7, NFR-5
- UX: Screen 5 (Hand Resolution), Accuracy Display
- Architecture: Accuracy Tracker

**Dependencies:**
- Blocked By: US-1.4, US-1.6
- Blocks: None
- Related: US-3.1, TS-3.2

---

### US-2.1: Multi-Hand Split (Up to Four Hands)
**Story ID:** US-2.1  
**Type:** User Story  
**Title:** Multi-Hand Split (Up to Four Hands)  
**Description:** As a Learner, I want to be able to split up to three times in a session hand, so that the game supports realistic split scenarios.  
**Acceptance Criteria:**
```gherkin
Scenario: Player can split up to three times
  Given the player has a pair
  When the player clicks Split
  Then the hand is divided into two hands
  And each hand receives one new card
  And the player plays the first hand

Scenario: Subsequent splits are allowed if resulting hand is a pair
  Given the player has split once and is playing a resulting hand
  When that hand is a pair
  And fewer than four hands exist
  Then the player may split again

Scenario: Maximum of four hands is enforced
  Given the player has four simultaneous hands
  When the player views the decision buttons
  Then the Split button is disabled
  And no fifth hand can be created

Scenario: Each hand is played in sequence
  Given the player has split into multiple hands
  When the first hand is complete
  Then the next hand becomes active
  And the player plays that hand
  And this continues until all hands are complete

Scenario: Each hand receives its own strategy recommendation
  Given the player is playing a split hand
  When that hand becomes active
  Then the strategy recommendation reflects that hand's composition
  And the recommendation is based on that hand's cards and the dealer's up-card
```
**Priority:** P1 (High)  
**Traceability:**
- PRD: US-2.1, NFR-8
- UX: Screen 7 (Split Hand Play)
- Architecture: Split Manager

**Dependencies:**
- Blocked By: US-1.3
- Blocks: US-2.2
- Related: TS-4.1, TS-4.2

---

### US-2.2: Per-Hand Strategy After Split
**Story ID:** US-2.2  
**Type:** User Story  
**Title:** Per-Hand Strategy After Split  
**Description:** As a Learner, I want each split hand to receive its own strategy recommendation, so that I learn the correct play for each hand independently.  
**Acceptance Criteria:**
```gherkin
Scenario: Each split hand receives independent recommendation
  Given the player has split into multiple hands
  When each hand becomes active
  Then the strategy recommendation is calculated for that specific hand
  And the recommendation reflects that hand's cards and the dealer's up-card
  And the recommendation is independent of other split hands

Scenario: Split Ace hand with 10-value card is not blackjack
  Given the player has split Aces
  When a split Ace hand receives a 10-value card
  Then the hand is counted as 21
  And the hand does not pay 3:2 (not blackjack)
  And the hand pays 1:1
```
**Priority:** P1 (High)  
**Traceability:**
- PRD: US-2.2, In-Scope Clarifications
- UX: Screen 7 (Split Hand Play)
- Architecture: Strategy Engine, Hand Classifier

**Dependencies:**
- Blocked By: US-2.1, TS-2.1
- Blocks: None
- Related: TS-2.3

---

### US-3.1: Cumulative Session Accuracy
**Story ID:** US-3.1  
**Type:** User Story  
**Title:** Cumulative Session Accuracy  
**Description:** As a Learner, I want to see my running accuracy across all hands in the session, so that I can measure my overall progress.  
**Acceptance Criteria:**
```gherkin
Scenario: Session accuracy is displayed and updates after each hand
  Given the session has started
  When a hand is resolved
  Then the session accuracy is displayed
  And the session accuracy is calculated as (total correct decisions / total decisions) × 100
  And the session accuracy is rounded to the nearest integer
  And the session accuracy updates after each hand

Scenario: Session accuracy is visible at all times
  Given the game is in any state
  When the player views the screen
  Then the session accuracy is visible (e.g., in the header)
  And the session accuracy is not hidden during play

Scenario: Session accuracy shows N/A when no decisions have been made
  Given the session has just started
  When no decisions have been made yet
  Then the session accuracy displays "—" or "N/A"
  And the session accuracy does not show "0%"
```
**Priority:** P1 (High)  
**Traceability:**
- PRD: US-3.1, NFR-5
- UX: Session Accuracy Display (Header)
- Architecture: Accuracy Tracker

**Dependencies:**
- Blocked By: US-1.4
- Blocks: None
- Related: TS-3.1, TS-3.2

---

### US-3.2: New Session / Reset
**Story ID:** US-3.2  
**Type:** User Story  
**Title:** New Session / Reset  
**Description:** As a Learner, I want to reset my session stats, so that I can start a fresh practice session.  
**Acceptance Criteria:**
```gherkin
Scenario: Session reset clears all session data
  Given the player is in any game state
  When the player clicks the New Session button
  Then a confirmation prompt is displayed (optional)
  And if confirmed, all session accuracy data is cleared
  And the session correct counter is reset to 0
  And the session total counter is reset to 0
  And the session accuracy display shows "—"

Scenario: New session returns to initial state
  Given the player has confirmed the session reset
  When the reset is complete
  Then the game returns to the initial state
  And the New Game button is ready
  And a new hand is dealt when the player clicks New Game
```
**Priority:** P1 (High)  
**Traceability:**
- PRD: US-3.2
- UX: Flow 5 (Session Reset), Screen 1 (Initial Game State)
- Architecture: Game State Manager

**Dependencies:**
- Blocked By: None
- Blocks: None
- Related: TS-3.2

---

## Technical Story Details

### TS-1.1: Implement Deck Manager
**Story ID:** TS-1.1  
**Type:** Technical Story  
**Title:** Implement Deck Manager  
**Description:** Create a Deck Manager module that creates a standard 52-card deck, shuffles it, and deals cards to hands. The deck must track remaining cards for future card-counting features.  
**Acceptance Criteria:**
```gherkin
Scenario: Deck is created with 52 cards
  Given the Deck Manager is initialized
  When a new deck is created
  Then the deck contains exactly 52 cards
  And each card has a rank (A, 2-10, J, Q, K) and suit (♠, ♥, ♦, ♣)
  And each card has a numeric value (Ace=11 or 1, 2-9=face value, 10/J/Q/K=10)

Scenario: Deck is shuffled
  Given a deck is created
  When the deck is shuffled
  Then the card order is randomized
  And the shuffle is cryptographically random (use Math.random or equivalent)

Scenario: Cards are dealt from the deck
  Given a deck is created
  When a card is dealt
  Then a card is removed from the deck
  And the card is returned to the caller
  And the remaining card count is decremented

Scenario: Deck tracks remaining cards
  Given a deck is created
  When cards are dealt
  Then the deck tracks the number of remaining cards
  And the remaining count is accurate
```
**Priority:** P0 (Critical)  
**Traceability:**
- Architecture: Deck Manager (Component Diagram)
- PRD: Key Implementation Details

**Dependencies:**
- Blocked By: None
- Blocks: TS-1.2, TS-1.3, TS-1.4
- Related: US-1.1

---

### TS-1.2: Implement Hand Manager
**Story ID:** TS-1.2  
**Type:** Technical Story  
**Title:** Implement Hand Manager  
**Description:** Create a Hand Manager module that creates Hand objects, calculates hand totals, and determines soft/hard status using the canonical Ace-recalculation algorithm.  
**Acceptance Criteria:**
```gherkin
Scenario: Hand object is created with cards
  Given the Hand Manager is initialized
  When a hand is created with a list of cards
  Then a Hand object is created
  And the Hand object stores the cards in order
  And the Hand object has properties: cards, total, isSoft, isBlackjack, isBust, status

Scenario: Hand total is calculated correctly for hard hands
  Given a hand with cards [10, 5]
  When the hand total is calculated
  Then the total is 15
  And isSoft is false

Scenario: Hand total is calculated correctly for soft hands
  Given a hand with cards [Ace, 6]
  When the hand total is calculated
  Then the total is 17
  And isSoft is true

Scenario: Soft hand transitions to hard after a hit
  Given a hand with cards [Ace, 6] (soft 17)
  When a card [10] is added
  Then the total is 17
  And isSoft is false (hard 17)

Scenario: Multiple Aces are handled correctly
  Given a hand with cards [Ace, Ace, 9]
  When the hand total is calculated
  Then the total is 21
  And isSoft is true (one Ace counted as 11)

Scenario: Bust is detected
  Given a hand with cards [10, 5, 7]
  When the hand total is calculated
  Then the total is 22
  And isBust is true

Scenario: Blackjack is detected on initial deal
  Given a hand with cards [Ace, 10]
  When the hand is evaluated
  Then isBlackjack is true
  And the total is 21
```
**Priority:** P0 (Critical)  
**Traceability:**
- Architecture: Hand Manager (Component Diagram), Soft Hand Algorithm
- PRD: Hand Representation, Soft Hand Algorithm, NFR-2, NFR-3

**Dependencies:**
- Blocked By: TS-1.1
- Blocks: TS-2.1, TS-4.1
- Related: US-1.1, US-1.2

---

### TS-1.3: Implement Split Manager
**Story ID:** TS-1.3  
**Type:** Technical Story  
**Title:** Implement Split Manager  
**Description:** Create a Split Manager module that manages the ordered list of active hands (max 4), advances the active hand pointer, and enforces split eligibility and limits.  
**Acceptance Criteria:**
```gherkin
Scenario: Split Manager maintains list of active hands
  Given the Split Manager is initialized
  When a game starts
  Then the active hands list contains one hand
  And the active hand index is 0

Scenario: Split creates two hands
  Given the player has a pair
  When a split is performed
  Then the active hands list contains two hands
  And each hand has one of the original pair cards
  And each hand receives one new card
  And the active hand index is 0 (first hand)

Scenario: Multiple splits are allowed up to four hands
  Given the player has split once
  When the first hand is complete
  And the second hand is a pair
  Then the player may split again
  And the active hands list contains three hands
  And this continues up to four hands

Scenario: Fifth hand is not allowed
  Given the player has four active hands
  When the player attempts to split
  Then the split is not allowed
  And the Split button is disabled

Scenario: Active hand pointer advances
  Given the player has multiple hands
  When a hand is complete
  Then the active hand index is incremented
  And the next hand becomes active
  And the strategy recommendation updates for the new active hand

Scenario: All hands are played before dealer turn
  Given the player has multiple hands
  When all hands are complete
  Then the dealer's turn begins
  And all player hands are evaluated against the dealer's hand
```
**Priority:** P0 (Critical)  
**Traceability:**
- Architecture: Split Manager (Component Diagram)
- PRD: Split Hand Management, NFR-8

**Dependencies:**
- Blocked By: TS-1.1, TS-1.2
- Blocks: TS-4.1, TS-4.2
- Related: US-2.1, US-2.2

---

### TS-1.4: Implement Dealer Engine
**Story ID:** TS-1.4  
**Type:** Technical Story  
**Title:** Implement Dealer Engine  
**Description:** Create a Dealer Engine module that implements the exact dealer draw logic: hit on totals ≤ 16, hit on soft 16, stand on hard/soft 17+.  
**Acceptance Criteria:**
```gherkin
Scenario: Dealer hits on hard 16
  Given the dealer's hand is hard 16
  When the dealer evaluates their hand
  Then the dealer draws a card

Scenario: Dealer hits on soft 16
  Given the dealer's hand is soft 16 (e.g., Ace + 5)
  When the dealer evaluates their hand
  Then the dealer draws a card

Scenario: Dealer stands on hard 17
  Given the dealer's hand is hard 17
  When the dealer evaluates their hand
  Then the dealer does not draw

Scenario: Dealer stands on soft 17
  Given the dealer's hand is soft 17 (e.g., Ace + 6)
  When the dealer evaluates their hand
  Then the dealer does not draw

Scenario: Dealer stands on 18 or higher
  Given the dealer's hand is 18 or higher
  When the dealer evaluates their hand
  Then the dealer does not draw

Scenario: Dealer busts if total exceeds 21
  Given the dealer's hand total exceeds 21
  When the dealer evaluates their hand
  Then the dealer's hand is marked as bust
  And the dealer does not draw
```
**Priority:** P0 (Critical)  
**Traceability:**
- Architecture: Dealer Engine (Component Diagram)
- PRD: Dealer Logic, NFR-4

**Dependencies:**
- Blocked By: TS-1.2
- Blocks: TS-5.2
- Related: US-1.6

---

## Story Dependencies and Traceability

### Dependency Graph
- **E-1 (Core Game Engine)** → Foundation for all other epics
- **E-2 (Strategy Engine)** → Depends on E-1; enables E-3, E-4
- **E-3 (Accuracy Tracking)** → Depends on E-1, E-2
- **E-4 (Multi-Hand Split)** → Depends on E-1, E-2, E-3
- **E-5 (Insurance & Blackjack)** → Depends on E-1, E-2
- **E-6 (UI)** → Depends on E-1, E-2, E-3, E-4, E-5
- **E-7 (Testing)** → Parallel to all; validates E-1 through E-6
- **E-8 (Deployment)** → Final; depends on E-1 through E-7

### Critical Path
1. TS-1.1 (Deck Manager)
2. TS-1.2 (Hand Manager)
3. TS-2.1 (Strategy Table)
4. TS-2.2 (Hand Classifier)
5. TS-2.3 (Strategy Lookup)
6. TS-3.1 (Accuracy Tracker)
7. TS-1.3 (Split Manager)
8. TS-1.4 (Dealer Engine)
9. TS-6.1 (React Components)
10. TS-6.2 (Game State Management)
11. TS-7.1 through TS-7.6 (Testing)

---

## Acceptance Criteria Coverage

### PRD Requirements Coverage
- ✅ US-1.1 covers PRD US-1.1 (Initial Deal)
- ✅ US-1.2 covers PRD US-1.2 (Strategy Recommendation)
- ✅ US-1.3 covers PRD US-1.3 (Player Decision)
- ✅ US-1.4 covers PRD US-1.4 (Decision Accuracy)
- ✅ US-1.5 covers PRD US-1.5 (Insurance)
- ✅ US-1.6 covers PRD US-1.6 (Dealer Play)
- ✅ US-1.7 covers PRD US-1.7 (Post-Hand Accuracy)
- ✅ US-2.1 covers PRD US-2.1 (Multi-Hand Split)
- ✅ US-2.2 covers PRD US-2.2 (Per-Hand Strategy)
- ✅ US-3.1 covers PRD US-3.1 (Session Accuracy)
- ✅ US-3.2 covers PRD US-3.2 (Session Reset)

### NFR Coverage
- ✅ NFR-1 (Strategy Correctness) → TS-2.1, TS-7.2
- ✅ NFR-2 (Soft-Hand Classification) → TS-1.2, TS-7.1
- ✅ NFR-3 (Hand Value Calculation) → TS-1.2, TS-7.1
- ✅ NFR-4 (Dealer Rule Compliance) → TS-1.4, TS-7.3
- ✅ NFR-5 (Accuracy Calculation) → TS-3.1, TS-7.4
- ✅ NFR-6 (Viewport Compatibility) → TS-6.3
- ✅ NFR-7 (Input Responsiveness) → TS-6.1
- ✅ NFR-8 (Split Hand Limit) → TS-1.3, TS-4.1
- ✅ NFR-9 (Browser Support) → TS-8.1

### UX Specification Coverage
- ✅ Screen 1 (Initial Game State) → US-3.2
- ✅ Screen 2 (Deal Screen) → US-1.1, US-1.2
- ✅ Screen 3 (Hit/Decision Sequence) → US-1.3
- ✅ Screen 4 (Dealer Play) → US-1.6
- ✅ Screen 5 (Hand Resolution) → US-1.7
- ✅ Screen 6 (Insurance Prompt) → US-1.5
- ✅ Screen 7 (Split Hand Play) → US-2.1, US-2.2

---

## Story Sizing & Complexity

### Critical Path Stories (P0)
- **TS-1.1 to TS-1.4:** Core game engine (4 stories, ~40 story points)
- **TS-2.1 to TS-2.3:** Strategy engine (3 stories, ~30 story points)
- **TS-3.1 to TS-3.2:** Accuracy tracking (2 stories, ~15 story points)
- **US-1.1 to US-1.7:** Core user stories (7 stories, ~35 story points)

### High-Value Stories (P1)
- **TS-4.1 to TS-4.2:** Split hand management (2 stories, ~20 story points)
- **TS-5.1 to TS-5.2:** Insurance logic (2 stories, ~15 story points)
- **TS-6.1 to TS-6.3:** UI implementation (3 stories, ~40 story points)
- **US-2.1 to US-2.2:** Split user stories (2 stories, ~15 story points)
- **US-3.1 to US-3.2:** Session management (2 stories, ~10 story points)

### Testing & Infrastructure (P1)
- **TS-7.1 to TS-7.6:** Testing (6 stories, ~50 story points)
- **TS-8.1 to TS-8.3:** Deployment (3 stories, ~15 story points)

**Total Estimated Effort:** ~280 story points

---

## Gaps and Assumptions

### Documented Assumptions
1. **Deck Variant:** Multi-deck (6-deck shoe) basic strategy is implemented; documented in code comments
2. **Double Down After Split:** Unrestricted on any two-card hand (per PRD in-scope clarification)
3. **Re-split Aces:** Not permitted (standard casino rule; documented in code)
4. **Session Persistence:** Session data exists only in-memory; page refresh clears all data (acceptable per PRD)
5. **Build Tooling:** Vite + React 18 + Vitest for testing (implementation choice)

### Known Gaps (Out of Scope for V1)
- Card counting (Hi-Lo) not implemented
- Configurable house rules not available
- Expected value display not shown
- Training mode / hand replay not available
- Bet sizing / bankroll not tracked
- User accounts or persistent profiles not available
- Multiplayer not supported
- Animations and sound not included

### Open Questions Requiring Clarification
1. **Deck Size:** Confirm multi-deck (6-deck) vs. single-deck variant for strategy table
2. **Session Reset UI:** Explicit button vs. page refresh
3. **Hard 17+ Recommendation Display:** Show "Stand" explicitly or suppress for clarity
4. **Accuracy Display at Start:** Show "—", "N/A", "0%", or hide entirely
5. **Bust Confirmation:** Brief confirmation step or immediate next hand
6. **Keyboard Shortcuts:** Implement optional H/S/D/P shortcuts for faster play

---

## Verification Checklist

- ✅ All PRD requirements are represented in user stories
- ✅ All UX workflows are represented in user stories
- ✅ All architectural requirements have supporting technical work
- ✅ No duplicate stories exist
- ✅ Stories are appropriately sized (fit within a sprint)
- ✅ Dependencies are complete and traceable
- ✅ Acceptance criteria follow Gherkin format
- ✅ Each story delivers one meaningful outcome
- ✅ Each story is independently testable
- ✅ Critical path is clearly identified
- ✅ Testing strategy is comprehensive
- ✅ Deployment strategy is defined
