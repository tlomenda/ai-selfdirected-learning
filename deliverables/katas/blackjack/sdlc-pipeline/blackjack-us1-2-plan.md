# Technical Implementation Plan: US-1.2 — Strategy Recommendation Display

**Story ID:** US-1.2  
**Title:** Strategy Recommendation Display  
**Date:** 2026-07-20  
**Status:** Draft

---

## Overview

This plan describes the implementation of the Strategy Recommendation Display feature for the Blackjack with Strategy Coach application. The feature displays the mathematically optimal action (Hit, Stand, Double Down, or Split) for the player's current hand before each decision, derived from a static lookup table. The recommendation updates dynamically as the hand evolves (e.g., after a hit) and adapts when multiple hands are active (e.g., after a split).

**Key Responsibility:** Provide real-time, accurate strategy guidance to support the learner's decision-making and enable accuracy tracking.

---

## Affected Components

### 1. **Strategy Engine Module** (New)
- **Responsibility:** Classify hands and perform strategy table lookups
- **Files/Location:** `src/modules/strategyEngine.js`
- **Key Functions:**
  - `classifyHand(hand)` — Classify hand as PAIR, SOFT, or HARD
  - `getRecommendation(hand, dealerUpCard)` — Return action from lookup table
  - `isEligibleForAction(hand, action)` — Validate action eligibility (e.g., double only on 2-card hands)

### 2. **Strategy Lookup Table** (New)
- **Responsibility:** Static 2D lookup table encoding basic strategy
- **Files/Location:** `src/data/strategyTable.js`
- **Structure:** Object/Map with keys like `'hard-15'`, `'soft-18'`, `'pair-8'` mapping to dealer up-cards (2–A) and actions (HIT, STAND, DOUBLE, SPLIT)
- **Scope:** ~270 entries covering all hard totals (5–20), soft totals (13–21), and pairs (2-2 through A-A)

### 3. **Game Engine Module** (Existing, Modified)
- **Responsibility:** Orchestrate game flow and query strategy engine at decision points
- **Files/Location:** `src/modules/gameEngine.js`
- **Modifications:**
  - Add `currentRecommendation` state field
  - Call `strategyEngine.getRecommendation()` after each hand state change (deal, hit, split)
  - Update `currentRecommendation` before exposing game state to UI

### 4. **Hand Manager Module** (Existing, Modified)
- **Responsibility:** Manage hand state and calculation
- **Files/Location:** `src/modules/handManager.js`
- **Modifications:**
  - Ensure `hand.total` and `hand.isSoft` are recalculated after every card addition (required for accurate classification)
  - Expose `hand.isPair` boolean for pair detection

### 5. **StrategyPanel React Component** (New)
- **Responsibility:** Render the strategy recommendation UI
- **Files/Location:** `src/components/StrategyPanel.jsx`
- **Props:**
  - `recommendation: string | null` — Current action (HIT, STAND, DOUBLE, SPLIT) or null
  - `isVisible: boolean` — Whether to display the panel
- **Behavior:**
  - Display recommendation prominently (large text, high-contrast background)
  - Show label "Recommended Action" and action text
  - Hide or disable if recommendation is null (edge case: no active hand)

### 6. **GameTable React Component** (Existing, Modified)
- **Responsibility:** Top-level game UI composition
- **Files/Location:** `src/components/GameTable.jsx`
- **Modifications:**
  - Pass `gameState.currentRecommendation` to `StrategyPanel`
  - Ensure `StrategyPanel` is rendered before decision buttons (visual hierarchy)

### 7. **Accuracy Tracker Module** (Existing, Modified)
- **Responsibility:** Record decisions and compare against recommendations
- **Files/Location:** `src/modules/accuracyTracker.js`
- **Modifications:**
  - Accept `recommendation` parameter in `recordDecision(recommendation, playerAction)` function
  - Compare and increment correct/total counters

---

## Data Model Changes

### Hand Object (Enhanced)
```javascript
{
  id: string,                    // Unique hand identifier
  cards: Card[],                 // Array of Card objects
  total: number,                 // Calculated hand total (0–21+)
  isSoft: boolean,               // True if Ace counted as 11 without busting
  isPair: boolean,               // True if exactly two cards of equal rank
  isBlackjack: boolean,          // True if initial deal is Ace + 10-value
  isBust: boolean,               // True if total > 21
  status: string,                // 'active' | 'completed' | 'bust'
  decisions: DecisionRecord[]    // Array of (recommendation, action, isCorrect)
}
```

### Strategy Table Structure
```javascript
// Example structure (simplified)
const strategyTable = {
  'hard-5': { '2': 'HIT', '3': 'HIT', ..., 'A': 'HIT' },
  'hard-6': { '2': 'HIT', '3': 'HIT', ..., 'A': 'HIT' },
  // ... more hard totals
  'soft-13': { '2': 'HIT', '3': 'DOUBLE', ..., 'A': 'HIT' },
  // ... more soft totals
  'pair-2': { '2': 'SPLIT', '3': 'SPLIT', ..., 'A': 'HIT' },
  // ... more pairs
}
```

### Game State (Enhanced)
```javascript
{
  phase: string,                 // 'idle' | 'dealing' | 'playerTurn' | 'dealerTurn' | 'resolved'
  playerHands: Hand[],           // Array of active hands
  activeHandIndex: number,       // Index of current hand being played
  dealerHand: Hand,              // Dealer's hand
  currentRecommendation: string | null,  // 'HIT' | 'STAND' | 'DOUBLE' | 'SPLIT' | null
  sessionCorrect: number,        // Cumulative correct decisions
  sessionTotal: number,          // Cumulative total decisions
}
```

---

## API Changes

### Strategy Engine Interface
```javascript
// src/modules/strategyEngine.js

/**
 * Classify a hand into one of three categories for lookup.
 * @param {Hand} hand - Hand object with cards, total, isSoft, isPair
 * @returns {string} - One of: 'pair-{rank}', 'soft-{total}', 'hard-{total}'
 */
function classifyHand(hand) { ... }

/**
 * Retrieve the recommended action for a hand against a dealer up-card.
 * @param {Hand} hand - Hand object
 * @param {string} dealerUpCard - Dealer's visible card ('2'–'9', '10', 'A')
 * @returns {string} - One of: 'HIT', 'STAND', 'DOUBLE', 'SPLIT'
 */
function getRecommendation(hand, dealerUpCard) { ... }

/**
 * Check if an action is valid for the current hand state.
 * @param {Hand} hand - Hand object
 * @param {string} action - Action to validate
 * @returns {boolean} - True if action is eligible
 */
function isEligibleForAction(hand, action) { ... }
```

### Game Engine Modification
```javascript
// In gameEngine.js, after each hand state change:

// After dealing initial hand
const recommendation = strategyEngine.getRecommendation(
  gameState.playerHands[0],
  gameState.dealerHand.visibleCard
);
gameState.currentRecommendation = recommendation;

// After player hits
const newRecommendation = strategyEngine.getRecommendation(
  gameState.playerHands[gameState.activeHandIndex],
  gameState.dealerHand.visibleCard
);
gameState.currentRecommendation = newRecommendation;

// After split
const splitHandRecommendation = strategyEngine.getRecommendation(
  gameState.playerHands[gameState.activeHandIndex],
  gameState.dealerHand.visibleCard
);
gameState.currentRecommendation = splitHandRecommendation;
```

---

## Implementation Steps

### Phase 1: Foundation (Strategy Engine & Lookup Table)

**Step 1.1:** Create the static strategy lookup table
- **File:** `src/data/strategyTable.js`
- **Action:** Encode the ~270-entry basic strategy table as a JavaScript object/constant
- **Source:** Derive from a published standard multi-deck basic strategy chart (dealer stands on soft 17)
- **Verification:** Create a reference table in tests to validate every entry

**Step 1.2:** Implement the Strategy Engine module
- **File:** `src/modules/strategyEngine.js`
- **Functions:**
  - `classifyHand(hand)` — Determine hand category (pair, soft, hard) based on cards and isSoft flag
  - `getRecommendation(hand, dealerUpCard)` — Perform O(1) lookup in strategy table
  - `isEligibleForAction(hand, action)` — Validate action eligibility (e.g., double only on 2-card hands, split only on pairs)
- **Logic:**
  - Pair detection: Check if hand has exactly 2 cards of equal rank
  - Soft classification: Use hand.isSoft flag (already calculated by Hand Manager)
  - Hard classification: Default if not pair and not soft
  - Lookup: Use `strategyTable[handCategory][dealerUpCard]` to retrieve action
  - Edge case: Hard 17–21 always returns STAND (may be hardcoded or in table)

**Step 1.3:** Enhance Hand Manager to expose required fields
- **File:** `src/modules/handManager.js`
- **Modifications:**
  - Ensure `hand.isSoft` is recalculated after every card addition (already required by PRD)
  - Add `hand.isPair` boolean field, set to true if exactly 2 cards of equal rank
  - Verify `hand.total` is recalculated correctly using the canonical Ace algorithm

### Phase 2: Integration with Game Engine

**Step 2.1:** Modify Game Engine to query strategy engine
- **File:** `src/modules/gameEngine.js`
- **Modifications:**
  - Import `strategyEngine` module
  - Add `currentRecommendation` field to game state
  - After each hand state change (deal, hit, split, advance hand), call `strategyEngine.getRecommendation()` and update `currentRecommendation`
  - Expose `currentRecommendation` in the game state object returned to UI

**Step 2.2:** Integrate with Accuracy Tracker
- **File:** `src/modules/accuracyTracker.js`
- **Modifications:**
  - Modify `recordDecision(recommendation, playerAction)` to accept the recommendation as a parameter
  - Compare `recommendation === playerAction` to determine correctness
  - Increment `handCorrect` and `sessionCorrect` if match

**Step 2.3:** Connect decision buttons to accuracy tracking
- **File:** `src/modules/gameEngine.js` (or decision handler)
- **Logic:**
  - Before executing player action, call `accuracyTracker.recordDecision(currentRecommendation, playerAction)`
  - Then execute the action (hit, stand, double, split)

### Phase 3: UI Implementation

**Step 3.1:** Create StrategyPanel React component
- **File:** `src/components/StrategyPanel.jsx`
- **Props:**
  - `recommendation: string | null` — Current action or null
  - `isVisible: boolean` — Whether to display
- **Rendering:**
  - Display label "Recommended Action"
  - Display action text in large, high-contrast styling
  - Use CSS classes for styling (e.g., `.strategy-panel`, `.strategy-action`)
  - Hide or show based on `isVisible` prop
- **Styling:**
  - High contrast background (e.g., light blue or yellow)
  - Large font (minimum 18px mobile, 24px desktop)
  - Centered or prominent placement below cards

**Step 3.2:** Integrate StrategyPanel into GameTable
- **File:** `src/components/GameTable.jsx`
- **Modifications:**
  - Import `StrategyPanel` component
  - Pass `gameState.currentRecommendation` and `gameState.phase === 'playerTurn'` as props
  - Render `StrategyPanel` before decision buttons (visual hierarchy)
  - Ensure `StrategyPanel` is always visible during player turn

**Step 3.3:** Ensure ActionControls respect recommendation
- **File:** `src/components/ActionControls.jsx`
- **Modifications:**
  - Buttons should be enabled/disabled based on action eligibility (not based on recommendation)
  - Recommendation is informational; player can choose any eligible action
  - No changes to button logic; recommendation is displayed separately

### Phase 4: Testing & Validation

**Step 4.1:** Unit tests for Strategy Engine
- **File:** `src/modules/__tests__/strategyEngine.test.js`
- **Test Cases:**
  - `classifyHand()`: Test pair detection, soft hand detection, hard hand detection
  - `getRecommendation()`: Test all ~270 cells of the strategy table against reference
  - `isEligibleForAction()`: Test double (2-card hands only), split (pairs only), hit/stand (always)
  - Edge cases: Hard 17+, soft 17, Ace transitions

**Step 4.2:** Unit tests for Strategy Lookup Table
- **File:** `src/data/__tests__/strategyTable.test.js`
- **Test Cases:**
  - Verify every entry matches a published reference chart
  - Verify no missing keys
  - Verify all values are valid actions (HIT, STAND, DOUBLE, SPLIT)

**Step 4.3:** Integration tests for Game Engine + Strategy Engine
- **File:** `src/modules/__tests__/gameEngine.integration.test.js`
- **Test Cases:**
  - Deal hand → recommendation displayed
  - Hit → recommendation updates
  - Split → each hand has its own recommendation
  - Accuracy tracking: decision recorded as correct/incorrect

**Step 4.4:** Component tests for StrategyPanel
- **File:** `src/components/__tests__/StrategyPanel.test.jsx`
- **Test Cases:**
  - Recommendation text displayed correctly
  - Panel hidden when `isVisible` is false
  - Panel updates when `recommendation` prop changes

**Step 4.5:** End-to-end tests
- **File:** `e2e/strategy-recommendation.spec.js` (Playwright)
- **Test Cases:**
  - Deal hand → recommendation visible before decision
  - Player hits → recommendation updates
  - Player splits → each hand shows correct recommendation
  - Accuracy tracking: decision compared to recommendation

---

## Testing Strategy

### Unit Testing
- **Framework:** Vitest + React Testing Library
- **Coverage Target:** 100% of Strategy Engine and Lookup Table logic
- **Key Tests:**
  - Hand classification (pair, soft, hard)
  - Strategy table lookups (all ~270 cells)
  - Action eligibility validation
  - Accuracy recording (decision vs. recommendation)

### Integration Testing
- **Scope:** Strategy Engine + Game Engine + Accuracy Tracker
- **Key Tests:**
  - Recommendation displayed after deal
  - Recommendation updates after hit
  - Recommendation updates after split
  - Accuracy correctly recorded (correct/incorrect)

### End-to-End Testing
- **Framework:** Playwright
- **Scope:** Full game flow with strategy recommendations
- **Key Tests:**
  - Deal → recommendation visible
  - Hit → recommendation updates
  - Split → each hand has recommendation
  - Session accuracy updates correctly
- **Browsers:** Chrome, Firefox, Safari (latest stable)

### Manual Testing
- **Scope:** UX and visual presentation
- **Key Tests:**
  - Recommendation box is prominent and readable
  - Recommendation updates smoothly after actions
  - Recommendation is visible before player decides (not hidden)
  - Responsive design: recommendation readable on mobile (320px) and desktop (1920px)

---

## Risks & Open Questions

### Risks

1. **Strategy Table Accuracy**
   - **Risk:** Encoding the ~270-cell table incorrectly could lead to wrong recommendations
   - **Mitigation:** Create a reference table from a published chart; exhaustively test every cell against reference; use a code review process

2. **Hand Classification Edge Cases**
   - **Risk:** Soft/hard classification may fail for edge cases (multiple Aces, Ace transitions)
   - **Mitigation:** Implement canonical Ace algorithm; test with 40+ named test cases covering all edge cases

3. **Performance of Strategy Lookup**
   - **Risk:** O(1) lookup may degrade if table structure is inefficient
   - **Mitigation:** Use JavaScript object/Map for O(1) access; benchmark lookup time; keep table in memory

4. **Recommendation Timing**
   - **Risk:** Recommendation may be displayed after player acts (not before)
   - **Mitigation:** Ensure `currentRecommendation` is set before UI renders; test that recommendation is visible before decision buttons are enabled

### Open Questions

1. **Strategy Table Variant**
   - **Question:** Which basic strategy variant should be encoded? (single-deck vs. multi-deck, dealer hits/stands on soft 17?)
   - **Answer:** Use standard multi-deck variant (dealer stands on soft 17), as specified in PRD. Document this decision in code comments.

2. **Recommendation Display for Hard 17+**
   - **Question:** Should the recommendation box display "Stand" for hard 17–20, or should it be suppressed?
   - **Answer:** Display "Stand" explicitly to reinforce learning (per UX spec recommendation). Recommendation box is always visible during player turn.

3. **Recommendation for Bust Hands**
   - **Question:** If player busts (total > 21), should a recommendation still be displayed?
   - **Answer:** No. If hand is bust, disable decision buttons and hide recommendation. Recommendation only shown for active, non-bust hands.

4. **Insurance Decision Recommendation**
   - **Question:** Should the strategy engine provide a recommendation for insurance (accept/decline)?
   - **Answer:** No. Insurance is not scored for accuracy (per PRD). Recommendation is only for Hit/Stand/Double/Split actions.

5. **Split Ace Handling**
   - **Question:** After splitting Aces, each Ace receives exactly one card and stands automatically. Should a recommendation be shown before the automatic stand?
   - **Answer:** No. After split Ace receives a card, the hand automatically stands. No player decision is made, so no recommendation is needed. Recommendation is shown only for hands where the player has a choice.

6. **Recommendation Lookup Efficiency**
   - **Question:** Should the strategy table be pre-computed or loaded from an external source?
   - **Answer:** Encode as a static JavaScript constant in `src/data/strategyTable.js`. No external loading required; all lookups are O(1) in-memory.

---

## Acceptance Criteria Traceability

| Acceptance Criterion | Implementation Component | Verification Method |
|----------------------|--------------------------|---------------------|
| Recommendation displayed before player decides | StrategyPanel component + Game Engine state | E2E test: deal hand, verify recommendation visible before button click |
| Recommendation is one of: Hit, Stand, Double Down, Split | Strategy Engine + Lookup Table | Unit test: verify all table entries are valid actions |
| Recommendation derived from static lookup table | Strategy Engine + Lookup Table constant | Unit test: verify lookup uses strategyTable constant, not computed heuristic |
| Recommendation visible and prominent | StrategyPanel CSS styling | Manual test: verify high-contrast, large font, readable on mobile/desktop |
| Recommendation updates after hit | Game Engine + Strategy Engine | E2E test: hit, verify recommendation updates before next decision |
| Recommendation shown for each split hand | Game Engine + Strategy Engine | E2E test: split, verify each hand shows its own recommendation |

---

## Deliverables

1. **Strategy Lookup Table** (`src/data/strategyTable.js`)
   - ~270-entry static table
   - Verified against published reference

2. **Strategy Engine Module** (`src/modules/strategyEngine.js`)
   - `classifyHand()`, `getRecommendation()`, `isEligibleForAction()`
   - 100% unit test coverage

3. **StrategyPanel React Component** (`src/components/StrategyPanel.jsx`)
   - Renders recommendation prominently
   - Responsive design (mobile to desktop)

4. **Game Engine Modifications** (`src/modules/gameEngine.js`)
   - `currentRecommendation` state field
   - Queries strategy engine at decision points

5. **Accuracy Tracker Modifications** (`src/modules/accuracyTracker.js`)
   - Records decision vs. recommendation
   - Increments correct/total counters

6. **Test Suite**
   - Unit tests: Strategy Engine, Lookup Table, Accuracy Tracker
   - Integration tests: Game Engine + Strategy Engine
   - E2E tests: Full game flow with recommendations
   - Component tests: StrategyPanel rendering

7. **Documentation**
   - Code comments explaining strategy table variant
   - Hand classification algorithm documentation
   - API documentation for Strategy Engine

---

## Success Criteria

- [ ] All ~270 strategy table entries verified against published reference
- [ ] Recommendation displayed before player decides (E2E test passes)
- [ ] Recommendation updates after hit (E2E test passes)
- [ ] Recommendation shown for each split hand (E2E test passes)
- [ ] Accuracy tracking compares decision to recommendation (unit test passes)
- [ ] StrategyPanel renders correctly on mobile (320px) and desktop (1920px)
- [ ] All unit tests pass with 100% coverage of Strategy Engine
- [ ] All E2E tests pass on Chrome, Firefox, Safari
- [ ] No performance degradation: strategy lookup completes in <1ms

---

## Dependencies

- **Blocked By:** US-1.1 (Initial Deal), TS-2.1 (Hand Manager), TS-2.2 (Soft Hand Classification)
- **Blocks:** US-1.3 (Player Decision), US-1.4 (Decision Accuracy Recording)
- **Related:** US-2.1 (Multi-Hand Split), US-3.1 (Session Accuracy)

---

## Effort Estimate

- **Strategy Engine & Lookup Table:** 8–12 hours
- **Game Engine Integration:** 4–6 hours
- **UI Component (StrategyPanel):** 4–6 hours
- **Testing (unit, integration, E2E):** 12–16 hours
- **Documentation & Code Review:** 4–6 hours
- **Total:** 32–46 hours

---

## Change Log

| Date | Version | Author | Change |
|------|---------|--------|--------|
| 2026-07-20 | 1.0 | AI | Initial plan created |

