# Blackjack with Strategy Coach — Product Requirements Document

---

## Product Overview

### Problem Statement

Players learning blackjack basic strategy have no reliable, immediate way to verify whether each decision they make is mathematically correct. Real casinos provide no guidance, and most online blackjack games either ignore strategy or bolt on vague hints. As a result, players develop bad habits and cannot measure whether they are actually improving.

### Goals

1. Deliver a browser-based blackjack game that plays by standard casino rules and displays the mathematically optimal action at every player decision point.
2. Track each player decision against the optimal recommendation and report accuracy — per hand and cumulatively across the session.
3. Implement the complete basic strategy lookup table correctly, covering all hard hands, soft hands, and pair splits against all dealer up-cards.
4. Support the full complexity of split hands (up to four simultaneous hands) with per-hand strategy recommendations.

---

## Features

### Personas

This product has a single user type: the **Learner**. There are no administrative accounts, no multi-player roles, and no dealer-side user interaction.

#### Persona: Learner

- **Description**: A person practicing blackjack basic strategy in a browser. They may be a beginner or an intermediate player who wants to measure their strategy accuracy.
- **Goals**: Play hands of blackjack, see the optimal recommendation before deciding, and track how often they follow it correctly.
- **Access scope**: Full access to all game features — dealing, hitting, standing, doubling down, splitting, and session accuracy statistics.
- **Constraints**: No account, login, or persistent profile. Session data exists only for the current page session.

---

### Use Cases & User Stories

#### Use Case 1: Play a Hand of Blackjack

**US-1.1 — Initial Deal**
> As a Learner, I want to be dealt two cards and see the dealer's up-card, so that I can evaluate my starting hand.

Acceptance Criteria:
- Two cards are dealt face-up to the player; the dealer receives one face-up card (up-card) and one face-down card (hole card).
- Each card displays its rank and suit (or rank alone — implementation choice).
- The player's hand total is displayed. If the hand is soft, the display reads, for example, "A+6 = soft 17" or equivalent that communicates the dual value.
- The dealer's hole card is not revealed until the dealer plays.
- Blackjack (an Ace plus a 10-value card on the initial two-card deal) is detected immediately and the hand resolves as blackjack.

**US-1.2 — Strategy Recommendation Display**
> As a Learner, I want to see the optimal action for my current hand before I decide, so that I can compare my instinct to correct basic strategy.

Acceptance Criteria:
- Before each player decision, the application displays one of: **Hit**, **Stand**, **Double Down**, or **Split**.
- The recommendation is derived from a static 2D lookup table keyed on (player hand category, dealer up-card), not from a computed heuristic.
- The recommendation is visible before the player acts — it is not hidden until after the decision.
- After a hit adds a card to the hand, the recommendation updates to reflect the new hand total.
- The recommendation is shown for each active hand when the player is splitting.

**US-1.3 — Player Decision**
> As a Learner, I want to choose Hit, Stand, Double Down, or Split, so that I can play the hand.

Acceptance Criteria:
- **Hit**: A card is dealt to the active hand. If the total exceeds 21, the hand busts and the turn ends.
- **Stand**: No card is dealt. The turn for the active hand ends.
- **Double Down**: Available only on the player's first decision for a given hand (two-card hand). One additional card is dealt and the hand stands automatically.
- **Split**: Available only when the active hand is exactly two cards of equal rank. The hand is divided into two hands; each receives one new card. The player then plays each resulting hand in sequence.
- Each action taken by the player is recorded for accuracy comparison against the recommendation at the time of the decision.

**US-1.4 — Decision Accuracy Recording**
> As a Learner, I want each decision I make to be compared against the strategy recommendation, so that my accuracy is tracked correctly.

Acceptance Criteria:
- A decision is recorded as **correct** if the action the player chose matches the recommendation displayed at the time of that decision.
- A decision is recorded as **incorrect** if the player chose a different action.
- The split action itself is recorded as one decision (correct or incorrect). Subsequent decisions on each resulting hand are recorded independently.
- The insurance decision (see US-1.5) is not included in the decision accuracy count.

**US-1.5 — Insurance**
> As a Learner, I want to be offered insurance when the dealer shows an Ace, so that the game follows standard casino rules.

Acceptance Criteria:
- When the dealer's up-card is an Ace, the player is offered insurance before the player's first decision.
- The player may accept or decline.
- Insurance is not scored as a strategy decision for accuracy purposes (it is not included in the correct/incorrect decision count).
- If insurance is offered, the dealer checks for blackjack before the player acts. If the dealer has blackjack and the player accepted insurance, the hand resolves accordingly.

**US-1.6 — Dealer Play and Hand Resolution**
> As a Learner, I want to see the dealer play their hand after I finish, so that I know the outcome.

Acceptance Criteria:
- After all player hands are complete, the dealer's hole card is revealed.
- Dealer draws cards according to the rule: **hit on soft 16, stand on soft 17**. No deviation is permitted.
- The dealer continues to draw until their total is 17 or higher (with soft 17 counted as a stand).
- Hand outcomes are evaluated: player bust, dealer bust, player total higher, dealer total higher, or push (equal totals).
- Blackjack pays 3:2. A player 21 achieved by hitting is not blackjack.
- Outcomes for all active hands (including split hands) are resolved independently.

**US-1.7 — Post-Hand Accuracy Display**
> As a Learner, I want to see my decision accuracy for the hand just played, so that I get immediate feedback.

Acceptance Criteria:
- After hand resolution, a per-hand accuracy is displayed: (decisions matching recommendation ÷ total decisions for this hand) × 100, rounded to the nearest integer.
- Example: 2 correct out of 3 decisions = 67%.
- If the hand had exactly one decision (e.g., player stood immediately), accuracy is 100% or 0%.

---

#### Use Case 2: Split Hands

**US-2.1 — Multi-Hand Split (Up to Four Hands)**
> As a Learner, I want to be able to split up to three times in a session hand, so that the game supports realistic split scenarios.

Acceptance Criteria:
- A split is permitted when the active hand is exactly two cards of matching rank.
- After a split, the player may split again if the resulting hand is also a pair, up to a maximum of four total simultaneous hands (three splits from the original pair).
- Each hand is played to completion in order (left to right, or equivalent) before the next hand is started.
- Each hand receives its own strategy recommendation based on its current composition and the dealer's up-card.
- Accuracy decisions for each hand are tracked independently.

**US-2.2 — Per-Hand Strategy After Split**
> As a Learner, I want each split hand to receive its own strategy recommendation, so that I learn the correct play for each hand independently.

Acceptance Criteria:
- When playing a hand resulting from a split, the strategy recommendation reflects the current cards of that specific hand against the dealer's up-card.
- A split Ace hand that receives a 10-value card does not count as blackjack (it counts as 21 and pays 1:1, not 3:2).

---

#### Use Case 3: Session Accuracy Tracking

**US-3.1 — Cumulative Session Accuracy**
> As a Learner, I want to see my running accuracy across all hands in the session, so that I can measure my overall progress.

Acceptance Criteria:
- A session accuracy percentage is displayed and updates after each hand.
- Session accuracy = (total correct decisions across all hands in the session ÷ total decisions in the session) × 100, rounded to the nearest integer.
- Session accuracy is visible at all times during play (not only post-hand).

**US-3.2 — New Session / Reset**
> As a Learner, I want to reset my session stats, so that I can start a fresh practice session.

Acceptance Criteria:
- A control is available to start a new session. Activating it clears all session accuracy data (total correct, total decisions, cumulative percentage).
- A new hand is dealt at the start of the new session.
- No session data is retained after reset.

---

## Non-Functional Requirements

| ID | Requirement | Measurable Definition | Verification Method |
|----|-------------|----------------------|---------------------|
| NFR-1 | **Strategy correctness** | 100% of entries in the basic strategy lookup table match a publicly verifiable basic strategy reference chart (standard multi-deck, dealer stands on soft 17 variant). Zero mismatches permitted. | Automated unit tests: exhaustively compare every cell of the implemented lookup table against a hardcoded reference table derived from a published standard chart. Minimum: one test per cell (~270 cells). |
| NFR-2 | **Soft-hand classification accuracy** | Every hand containing an Ace that can count as 11 without exceeding 21 must be classified as soft. Every hand where the Ace must count as 1 must be classified as hard. 0 misclassifications. | Unit tests: at minimum 40 test cases covering: single Ace, Ace after a hit, multiple Aces, Ace transitioning from soft to hard after a bust-preventing recalculation. |
| NFR-3 | **Hand value calculation** | For any card combination, the computed hand total must equal the correct blackjack value (highest non-busting total with Ace counted as 11 where possible). 0 incorrect calculations. | Unit tests with at minimum 60 named test cases: hard totals 4–21, soft totals 12–21, combinations that transition from soft to hard, edge cases with multiple Aces. |
| NFR-4 | **Dealer rule compliance** | Dealer must hit on every soft 16 and stand on every soft 17. No other dealer behavior is permitted. | Unit tests simulating all dealer hand states from 12 through 21 (soft and hard), verifying hit vs. stand decision. At minimum 30 dealer-state test cases. |
| NFR-5 | **Accuracy calculation precision** | Displayed accuracy values (per-hand and session) must equal floor((correct ÷ total) × 100) rounded to the nearest integer. No rounding errors. | Unit tests for the accuracy calculation function covering: 0/0 edge case, 1/1, 1/2, 2/3, 7/9, 0/5, 5/5. |
| NFR-6 | **Viewport compatibility** | The application renders without horizontal scrolling and all controls remain usable at viewport widths from 320px to 1920px. | Manual or automated responsive testing at breakpoints: 320px, 375px, 768px, 1024px, 1280px, 1920px using browser DevTools device simulation. |
| NFR-7 | **Input responsiveness** | Any player action (button click) must produce visible UI feedback within 300ms on a standard modern browser on a 2020 or newer device. | Chrome DevTools Performance panel: record a play session and verify no interaction takes longer than 300ms from click to first visual update. |
| NFR-8 | **Split hand limit enforcement** | The application must not permit a fifth hand after four simultaneous hands exist. The split control must be disabled or hidden when four hands are active. | Manual test: deal matching pairs consecutively to reach four hands; verify split is unavailable and no fifth hand can be created. |
| NFR-9 | **Browser support** | The application must function correctly (all game mechanics and UI) on the latest stable release of Chrome, Firefox, and Safari at time of initial release. | Manual smoke test of core game flow (deal, hit, stand, split, accuracy display) on each of the three browsers. |

---

## Key Implementation Details

### Technology
- Browser-based application: HTML, CSS, and JavaScript only.
- No server-side component, framework, or build pipeline is required by the product description. The development team chooses any tooling.
- No external API calls. All game logic runs client-side.
- No persistent storage is required. Session accuracy may use in-memory JavaScript state. If the page is refreshed, session data may be lost (acceptable for V1).

### Basic Strategy Lookup Table Structure
- The table is a 2D structure with approximately 270 entries.
- **Row keys (player hand):**
  - Hard totals: 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 (hard)
  - Soft totals: soft 13 (A+2) through soft 21 (A+10/A+A treated as soft if possible)
  - Pairs: 2-2, 3-3, 4-4, 5-5, 6-6, 7-7, 8-8, 9-9, 10-10, A-A
- **Column keys (dealer up-card):** 2, 3, 4, 5, 6, 7, 8, 9, 10, A
- **Values:** One of: `HIT`, `STAND`, `DOUBLE`, `SPLIT`
- The table encodes a **known correct reference**, not a computed result. It must be derived manually from a published basic strategy chart and verified by test.
- The table variant implemented must match the out-of-scope boundary: standard rules, dealer stands on soft 17. The number of decks assumed should be documented as an implementation decision (see Open Questions).

### Hand Representation
Each hand in the system must track:
1. **Cards**: ordered list of card values
2. **Soft/hard status**: recalculated after each card addition
3. **Total**: highest non-busting total, recalculated after each card addition
4. **Is-pair**: whether the hand is exactly two cards of equal rank (for split eligibility)
5. **Decision log**: list of (recommendation, player-action, correct: boolean) entries

### Soft Hand Algorithm (Critical)
```
function calculateHandValue(cards):
  total = sum of card values (Ace = 11 initially)
  aces = count of Aces in hand
  while total > 21 and aces > 0:
    total -= 10   // re-count one Ace as 1 instead of 11
    aces -= 1
  isSoft = (aces > 0)  // at least one Ace still counted as 11
  return { total, isSoft }
```
This recalculation must run after every card addition. Any implementation that checks softness separately from this loop is a common source of bugs.

### Dealer Logic (Must Be Exact)
```
while dealerHand.total < 17
    OR (dealerHand.total == 16 AND dealerHand.isSoft):
  deal card to dealer
```
Equivalently: dealer hits on totals ≤ 16, hits on soft 16, stands on hard 17+, stands on soft 17+.

### Split Hand Management
- Maintain a list of active hands. Initially one hand; after a split, replace the active hand with two new hand objects.
- The player plays each hand in the list sequentially, left to right.
- Track which hand is active.
- Maximum list size: 4.
- After all player hands are complete, dealer plays once.

### Accuracy Tracking
- Maintain two counters at session scope: `sessionCorrect` and `sessionTotal`.
- Maintain two counters at hand scope: `handCorrect` and `handTotal`.
- At each player decision point: increment `handTotal` and `sessionTotal`. If the player's action matches the recommendation, increment `handCorrect` and `sessionCorrect`.
- After each hand, display `handCorrect / handTotal` as a percentage.
- At all times, display `sessionCorrect / sessionTotal` as a percentage.
- Edge case: if `sessionTotal == 0`, display "—" or "N/A" rather than dividing by zero.

---

## Scope Boundaries

### In Scope
- Single-player game (one player, one dealer)
- Complete basic strategy lookup table for all hard hands, soft hands, and pairs
- Soft vs. hard hand distinction for strategy lookups and hand value calculation
- Multi-hand split logic, up to four simultaneous hands
- Decision accuracy tracking per hand and cumulatively per session
- Insurance option when dealer shows an Ace (not scored for accuracy)
- Blackjack detection and 3:2 payout labeling
- Dealer plays by strict rule: hit soft 16, stand soft 17
- Browser-based UI with no backend

### Out of Scope for V1

The following items are explicitly excluded. A developer should not implement them or stub them out in anticipation:

1. **Card counting (Hi-Lo)**: Running count, true count display, or deck depletion tracking are not in V1.
2. **Configurable house rules**: Number of decks, surrender, whether dealer hits or stands on soft 17, re-split Aces — none are configurable. The game uses a single fixed rule set.
3. **Expected value display**: EV calculations for hit/stand/double/split options are not shown.
4. **Training mode / hand replay**: Hands where the player deviated from strategy are not replayed or flagged beyond the existing accuracy display.
5. **Bet sizing / bankroll**: No money, chips, or bankroll tracking. The game does not simulate financial stakes.
6. **User accounts or persistent profiles**: No login, no saved history, no cross-session statistics.
7. **Multiplayer**: One player only.
8. **Animations and sound**: Card dealing animations, flip effects, and audio are not required.

### In-Scope Clarifications (to reduce developer ambiguity)

- **Strategy recommendations are always visible before the decision**: The recommendation is not a post-decision reveal or a "check answer" feature. It is displayed before the player acts on every decision.
- **Double down is allowed on split hands**: After splitting, the player may double down on each resulting two-card hand.
- **Split Aces receive one card only**: After splitting Aces, each Ace receives exactly one additional card and the hand stands automatically. The player does not have the option to hit on a split Ace hand. A 10-value card on a split Ace counts as 21, not blackjack.

---

## Open Questions

The following questions require a judgment call during implementation. They are not answerable from the product description alone.

1. **Deck size and composition**: The basic strategy table differs slightly between single-deck and multi-deck games. Which variant does this game implement? This decision must be made before the table is encoded and documented in a code comment.

2. **Double-down restriction on split hands**: Some casinos restrict double down after splitting to totals of 9, 10, or 11 only. Is double down after split unrestricted (any two-card hand), or restricted by total? (The in-scope clarification above says it is allowed; this question asks whether any restriction applies.)

3. **Re-split Aces**: After splitting Aces and receiving a new Ace as the second card, can the player split again? Some casinos prohibit this. The product description does not specify.

4. **Insurance payout display**: When insurance is accepted and the dealer has blackjack, how is the net outcome communicated to the player? (The game has no betting, so this is a display-only concern — what message or outcome label is shown?)

5. **Session reset trigger**: Is a "new session" an explicit UI button, or does refreshing the page serve as the session reset? If an explicit button is required, where should it be placed to avoid accidental activation mid-hand?

6. **Strategy recommendation for totals ≥ 17 (hard)**: For hard 17–20, the recommendation is always Stand. Should the recommendation still be displayed visually for these hands, or is the display suppressed when the correct action is unambiguous? Both are valid UX choices with different learning implications.

7. **Accuracy display when no decisions have been made**: At the start of a session before any hand is played, the session accuracy display has no data. Should it show "—", "N/A", "0%", or be hidden entirely?

8. **Bust handling for split hands**: If the player busts on the first split hand, does the session move immediately to the second split hand, or is there a brief confirmation step? This affects the UX flow but not the game rules.

---

## Change Log

| Version | Date | Author | Notes |
|---------|------|--------|-------|
| 1.0 | 2026-07-20 | Product (AI-generated, Claude Sonnet 4.5) | Initial PRD. Covers full game play, strategy lookup, accuracy tracking, split logic, and scope boundaries for V1. |
