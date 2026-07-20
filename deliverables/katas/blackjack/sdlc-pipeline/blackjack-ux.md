# Blackjack with Strategy Coach — UX Specification

---

## Overview

This document defines the user interface and interaction flows for a browser-based blackjack game that teaches and reinforces basic strategy through real-time recommendations and accuracy tracking. The application guides learners toward mathematically optimal play by displaying the correct action before each decision and measuring how often they follow it.

The UX bridges the gap between the PRD's requirements and implementation by specifying:
- How each screen appears and behaves
- What controls are available at each game state
- How feedback is presented (accuracy, recommendations, outcomes)
- How the interface adapts to different viewport sizes
- How edge cases and errors are handled

---

## Target Users & Personas

### Persona: Learner

**Profile:**
- A person practicing blackjack basic strategy in a browser environment
- May be a beginner learning strategy from scratch or an intermediate player refining their play
- Wants immediate feedback on decision quality and measurable progress

**Goals:**
1. Play hands of blackjack with clear rules and feedback
2. See the mathematically optimal recommendation before deciding
3. Compare their decision to the recommendation and track accuracy
4. Measure overall progress across multiple hands in a session

**Constraints:**
- No account or login required
- Session data exists only for the current page session
- No persistent profile or cross-session history

**Typical Session:**
- Plays 5–20 hands per session
- Wants to see recommendations immediately (not hidden until after deciding)
- Checks session accuracy after each hand to gauge improvement
- May reset and start a new session to practice specific scenarios

---

## User Goals

1. **Understand the correct play** — See the optimal action for every decision before acting
2. **Learn through feedback** — Immediately know if their decision matched the recommendation
3. **Track progress** — Measure accuracy per hand and cumulatively across the session
4. **Play intuitively** — Reach any decision with minimal clicks and clear visual hierarchy
5. **Understand hand state** — Know their hand total, the dealer's up-card, and whether their hand is soft or hard

---

## User Flows

### Flow 1: Start a New Session

```
User opens page
  ↓
[Initial Game Screen]
  - Session accuracy: "—" (no data yet)
  - "New Game" button visible
  ↓
User clicks "New Game"
  ↓
[Deal Screen]
  - Player dealt two cards (face-up)
  - Dealer shows one card (up-card, face-up)
  - Dealer's hole card is hidden
  - Player hand total displayed (e.g., "A+6 = soft 17")
  - Strategy recommendation displayed (Hit, Stand, Double, or Split)
  - Decision buttons enabled
  ↓
[Continue to Decision Flow]
```

### Flow 2: Play a Single Hand (Happy Path)

```
[Deal Screen]
  - Player has 10+5 (hard 15)
  - Dealer shows 6
  - Recommendation: "Stand" (displayed prominently)
  ↓
User clicks "Stand"
  - Decision recorded as correct (matched recommendation)
  - Hand total incremented
  ↓
[Dealer Play Screen]
  - Dealer's hole card revealed
  - Dealer draws cards per rule (hit soft 16, stand soft 17)
  - Animation or step-by-step reveal of dealer cards
  ↓
[Hand Resolution Screen]
  - Outcome displayed: "Win", "Lose", "Push", or "Blackjack"
  - Hand accuracy: "100% (1/1)"
  - Session accuracy updated and displayed
  - "Next Hand" button enabled
  ↓
User clicks "Next Hand"
  ↓
[Deal Screen for new hand]
```

### Flow 3: Split Decision

```
[Deal Screen]
  - Player dealt 8+8 (hard 16)
  - Dealer shows 5
  - Recommendation: "Split" (displayed prominently)
  ↓
User clicks "Split"
  - Decision recorded as correct
  - Hand splits into two hands, each receiving one new card
  ↓
[Play First Split Hand]
  - First hand (8+new card) is active
  - Recommendation displayed for this hand
  - Player makes decisions (hit, stand, double) on first hand
  ↓
[First Hand Resolves]
  - First hand stands or busts
  ↓
[Play Second Split Hand]
  - Second hand becomes active
  - Recommendation displayed for this hand
  - Player makes decisions on second hand
  ↓
[Both Hands Complete]
  - Dealer plays
  - Both hands resolved independently
  - Hand accuracy: "(correct decisions / total decisions) × 100%"
  - Session accuracy updated
```

### Flow 4: Insurance Offer

```
[Deal Screen]
  - Dealer's up-card is Ace
  - Before any player decision, insurance prompt appears
  - "Insurance offered. Accept?" with Yes/No buttons
  ↓
User clicks "Yes" or "No"
  - Insurance decision is NOT scored for accuracy
  - If "Yes" and dealer has blackjack, insurance payout displayed
  ↓
[Continue to normal decision flow]
```

### Flow 5: Session Reset

```
[Any game state]
  - User clicks "New Session" button (or equivalent reset control)
  ↓
[Confirmation (optional)]
  - "Reset session data? This cannot be undone."
  - "Yes" / "Cancel" buttons
  ↓
User clicks "Yes"
  ↓
[Initial Game Screen]
  - Session accuracy reset to "—"
  - Session correct/total counters reset to 0/0
  - "New Game" button ready
```

---

## Information Architecture

### Screen Hierarchy

```
Root: Game Container
├── Header
│   ├── Title: "Blackjack with Strategy Coach"
│   └── Session Accuracy Display
│       ├── Label: "Session Accuracy"
│       ├── Percentage: "—" or "XX%"
│       └── Stats: "(X correct / Y total)"
├── Main Game Area
│   ├── Dealer Section
│   │   ├── Dealer Label
│   │   ├── Dealer Cards (visual representation)
│   │   └── Dealer Total (hidden until dealer plays)
│   ├── Player Section
│   │   ├── Player Cards (visual representation)
│   │   ├── Player Total (e.g., "A+6 = soft 17")
│   │   └── Hand Accuracy (post-hand only)
│   ├── Strategy Recommendation Box
│   │   ├── Label: "Recommended Action"
│   │   └── Action: "Hit" | "Stand" | "Double" | "Split"
│   └── Decision Controls
│       ├── Hit Button
│       ├── Stand Button
│       ├── Double Button (conditionally enabled)
│       └── Split Button (conditionally enabled)
├── Messages Area
│   ├── Insurance Prompt (conditional)
│   ├── Hand Outcome (post-hand)
│   └── Status Messages (e.g., "Bust!", "Dealer plays...")
└── Footer Controls
    ├── Next Hand Button (post-hand only)
    ├── New Session Button
    └── Help / Rules Link (optional)
```

---

## Screen Specifications

### Screen 1: Initial Game State

**Purpose:** Display the starting state before any hand is dealt.

**Layout:**
- Header with title and session accuracy display (showing "—" or "0%")
- Large "New Game" button centered in the main area
- Optional: brief instructions or welcome message

**Components:**
- Title: "Blackjack with Strategy Coach"
- Session Accuracy Box:
  - Label: "Session Accuracy"
  - Value: "—" (if no decisions yet) or "XX%"
  - Subtext: "(X correct / Y total decisions)"
- New Game Button:
  - Label: "New Game"
  - Size: Large, tap-friendly (min 44px height)
  - Color: Primary action color (e.g., green)
- Optional Help Text:
  - "Play blackjack and compare your decisions to basic strategy recommendations."

**States:**
- Default: New Game button enabled
- After session data exists: Session accuracy displays percentage and counts

---

### Screen 2: Deal Screen (Initial Deal)

**Purpose:** Show the dealt hand, dealer up-card, and strategy recommendation.

**Layout:**
- Header: Title + Session Accuracy (always visible)
- Dealer area (top): Dealer's up-card and hidden hole card
- Player area (middle): Player's two cards and hand total
- Strategy recommendation box (prominent, below cards)
- Decision buttons (bottom)

**Components:**

#### Dealer Section
- Label: "Dealer"
- Card display: One card face-up, one card face-down (or "?" placeholder)
- Dealer total: Hidden until dealer plays (or shows "?" or "Dealer's turn")

#### Player Section
- Label: "Your Hand"
- Card display: Two cards face-up
- Hand total display:
  - Hard hand: "10 + 5 = 15"
  - Soft hand: "A + 6 = soft 17" (clearly indicates soft status)
  - Blackjack: "Blackjack!" (special display, hand auto-resolves)
- Hand accuracy: Empty (not shown until hand completes)

#### Strategy Recommendation Box
- Label: "Recommended Action"
- Action text: One of "Hit", "Stand", "Double Down", or "Split"
- Visual emphasis: Large, contrasting color, icon or badge
- Always visible before player decides

#### Decision Buttons
- Hit Button: Always enabled
- Stand Button: Always enabled
- Double Down Button: Enabled only on first decision (two-card hand)
- Split Button: Enabled only if hand is a pair (two cards of equal rank) and fewer than four hands exist

**States:**
- Blackjack detected: Hand auto-resolves; buttons disabled; outcome displayed immediately
- Normal hand: All applicable buttons enabled
- After split: Each split hand shows its own recommendation and buttons

---

### Screen 3: Hit / Decision Sequence

**Purpose:** Show the updated hand after a hit and the new recommendation.

**Layout:**
- Same as Deal Screen, but with additional cards in player hand
- Updated hand total
- Updated recommendation (if applicable)
- Buttons update based on new state

**Components:**
- Player Section:
  - Cards: Now shows 3+ cards (previous cards + new card)
  - Hand total: Recalculated (e.g., "10 + 5 + 7 = 22 — Bust!")
  - If bust: "Bust!" message displayed; decision buttons disabled; next hand prompt shown
- Strategy Recommendation:
  - Updates to reflect new hand total
  - If hand is bust or 17+, recommendation may be "Stand" or hidden (see design choice below)
- Decision Buttons:
  - Hit: Still enabled (unless bust)
  - Stand: Still enabled (unless bust)
  - Double: Disabled (only on first decision)
  - Split: Disabled (hand no longer a pair)

**Design Choice:** For hard totals ≥ 17, the recommendation is always "Stand". The UX may either:
1. Display "Stand" explicitly (reinforces learning)
2. Suppress the recommendation box (reduces visual clutter)

Recommendation: Display "Stand" explicitly to reinforce that no further action is needed.

---

### Screen 4: Dealer Play

**Purpose:** Show the dealer revealing their hole card and drawing cards per rule.

**Layout:**
- Dealer section (top): Hole card revealed; dealer draws cards step-by-step or all at once
- Player section (middle): Player's final hand(s) displayed
- Message area: "Dealer plays..." or step-by-step dealer actions
- No decision buttons (player turn is over)

**Components:**
- Dealer Section:
  - Hole card: Revealed (flipped or animated)
  - Dealer cards: All cards displayed
  - Dealer total: Displayed and updated as cards are drawn
  - Dealer status: "Dealer hits...", "Dealer stands...", "Dealer busts!"
- Player Section:
  - Cards: Final hand(s) displayed (unchanged)
  - Hand total: Final total displayed
- Message Area:
  - Step-by-step dealer actions (optional animation or text)
  - "Dealer has 17. Dealer stands."
  - "Dealer has 16. Dealer hits."
  - "Dealer busts!" (if applicable)

**States:**
- Dealer drawing: Cards added one at a time (or all at once; implementation choice)
- Dealer stands: Dealer total ≥ 17 and not soft 16
- Dealer busts: Dealer total > 21

---

### Screen 5: Hand Resolution

**Purpose:** Show the outcome of the hand and per-hand accuracy.

**Layout:**
- Dealer section (top): Final dealer hand and total
- Player section (middle): Final player hand(s) and total(s)
- Outcome display: Win/Lose/Push/Blackjack
- Hand accuracy: Per-hand accuracy percentage
- Session accuracy: Updated session accuracy
- Next Hand button

**Components:**

#### Outcome Display
- Label: "Hand Result"
- Outcome text: One of:
  - "You win!" (player total > dealer total or dealer bust)
  - "You lose." (dealer total > player total or player bust)
  - "Push." (equal totals)
  - "Blackjack! 3:2 payout." (player blackjack)
  - "Dealer blackjack. You lose." (dealer blackjack, player doesn't have blackjack)
- Color coding: Green for win, red for loss, neutral for push

#### Hand Accuracy Display
- Label: "Hand Accuracy"
- Percentage: "XX%" (rounded to nearest integer)
- Breakdown: "(X correct / Y total decisions)"
- Example: "67% (2/3)"

#### Session Accuracy Display (Updated)
- Label: "Session Accuracy"
- Percentage: "XX%" (updated from previous hands)
- Breakdown: "(X correct / Y total decisions)"
- Always visible in header

#### Split Hand Outcomes
- If multiple hands: Each hand shows its own outcome and accuracy
- Example:
  ```
  Hand 1: 18 vs Dealer 17 — Win (100%, 1/1)
  Hand 2: 16 vs Dealer 17 — Lose (100%, 1/1)
  Overall Hand Accuracy: 100% (2/2)
  ```

#### Next Hand Button
- Label: "Next Hand"
- Size: Large, tap-friendly
- Color: Primary action color
- Enabled: Always (ready to deal next hand)

---

### Screen 6: Insurance Prompt

**Purpose:** Offer insurance when dealer shows an Ace.

**Layout:**
- Appears as a modal or overlay on the Deal Screen
- Centered, with clear question and two buttons

**Components:**
- Prompt text: "Dealer shows an Ace. Insurance offered. Accept?"
- Yes Button: Accept insurance
- No Button: Decline insurance
- Subtext (optional): "Insurance pays 2:1 if dealer has blackjack."

**States:**
- Prompt shown: Before any player decision
- After decision: Prompt closes; game continues to normal decision flow
- If dealer has blackjack and insurance accepted: Outcome shows insurance payout

---

### Screen 7: Split Hand Play

**Purpose:** Show the active split hand and its recommendation.

**Layout:**
- Dealer section (top): Unchanged
- Player section (middle): Shows all split hands, with active hand highlighted
- Strategy recommendation: For the active hand only
- Decision buttons: For the active hand only
- Status message: "Playing hand 1 of 2" or equivalent

**Components:**

#### Player Section (Multiple Hands)
- Hand 1 (inactive): Displayed but visually de-emphasized (e.g., grayed out or smaller)
  - Cards, total, and status (e.g., "Completed: 18")
- Hand 2 (active): Displayed prominently
  - Cards, total, highlighted
  - Strategy recommendation for this hand
  - Decision buttons enabled for this hand
- Hand 3, 4 (if applicable): Same as Hand 1

#### Status Message
- "Playing hand 1 of 2" or "Playing hand 2 of 3"
- Helps user track progress through split hands

#### Decision Buttons
- Hit, Stand, Double, Split: Enabled/disabled based on active hand state
- Only apply to the active hand

---

## Interaction Design

### Decision Buttons

**Hit Button**
- Label: "Hit"
- Enabled: Always (unless hand is bust or player has stood)
- Action: Deal one card to active hand; recalculate total and recommendation
- Feedback: New card appears; hand total updates; recommendation updates
- Keyboard shortcut (optional): "H"

**Stand Button**
- Label: "Stand"
- Enabled: Always (unless hand is bust)
- Action: End turn for active hand; move to next hand or dealer play
- Feedback: Hand is marked as complete; next hand or dealer play begins
- Keyboard shortcut (optional): "S"

**Double Down Button**
- Label: "Double Down" or "Double"
- Enabled: Only on first decision for a given hand (exactly two cards)
- Action: Deal one card and stand automatically
- Feedback: One card dealt; hand total updates; hand automatically stands; next hand or dealer play begins
- Keyboard shortcut (optional): "D"

**Split Button**
- Label: "Split"
- Enabled: Only if hand is exactly two cards of equal rank AND fewer than four hands exist
- Action: Divide hand into two hands; each receives one new card; player plays first hand
- Feedback: Hand splits; two new hands displayed; first hand becomes active; recommendation updates for first hand
- Keyboard shortcut (optional): "P"

### New Game Button

- Label: "New Game"
- Enabled: Only on initial screen or after hand resolution
- Action: Deal a new hand; reset hand counters; keep session counters
- Feedback: New hand displayed; strategy recommendation shown; decision buttons enabled

### New Session Button

- Label: "New Session" or "Reset Session"
- Enabled: Always (visible in footer)
- Action: Clear all session data; return to initial screen
- Feedback: Session accuracy reset to "—"; counters reset to 0/0; initial screen displayed
- Confirmation (optional): "Reset session data? This cannot be undone." with Yes/Cancel buttons

### Insurance Prompt

- Yes Button:
  - Action: Accept insurance; continue to normal decision flow
  - Feedback: Prompt closes; game continues
- No Button:
  - Action: Decline insurance; continue to normal decision flow
  - Feedback: Prompt closes; game continues

---

## Component Specifications

### Card Display

**Visual Representation:**
- Each card displays rank and suit (or rank only; implementation choice)
- Rank: A, 2–9, 10, J, Q, K
- Suit: ♠, ♥, ♦, ♣ (or text: Spades, Hearts, Diamonds, Clubs)
- Size: Responsive; minimum 60px width on mobile, 80px on desktop
- Face-down card: Placeholder image or "?" symbol

**States:**
- Face-up: Rank and suit visible
- Face-down: Hidden (dealer's hole card before reveal)
- Highlighted: Active hand in split scenario (e.g., border or shadow)

### Hand Total Display

**Format:**
- Hard hand: "10 + 5 = 15"
- Soft hand: "A + 6 = soft 17" (clearly indicates soft status)
- Multiple cards: "10 + 5 + 7 = 22 — Bust!"
- Blackjack: "Blackjack!" (special display)

**Clarity:**
- Always show the Ace as "A" and indicate soft status explicitly
- Use "soft" keyword to distinguish from hard totals
- Show bust status immediately

### Strategy Recommendation Box

**Visual Design:**
- Prominent, high-contrast background (e.g., light blue or yellow)
- Large, readable text (minimum 18px on mobile, 24px on desktop)
- Icon or badge to indicate recommendation type (optional)
- Always visible before player decides

**Content:**
- Label: "Recommended Action"
- Action: "Hit", "Stand", "Double Down", or "Split"
- No additional explanation (keep it simple for quick reference)

### Accuracy Display

**Per-Hand Accuracy:**
- Format: "XX% (X/Y)"
- Example: "67% (2/3)"
- Displayed after hand resolution
- Rounded to nearest integer

**Session Accuracy:**
- Format: "XX% (X/Y)" or "—" if no decisions yet
- Example: "75% (15/20)"
- Always visible in header
- Updates after each hand

### Status Messages

**Message Types:**
- "Bust!" — Player hand exceeds 21
- "Dealer busts!" — Dealer hand exceeds 21
- "Dealer hits..." — Dealer draws a card
- "Dealer stands." — Dealer stops drawing
- "You win!" — Player total > dealer total
- "You lose." — Dealer total > player total
- "Push." — Equal totals
- "Blackjack! 3:2 payout." — Player blackjack

**Placement:**
- Below the cards or in a dedicated message area
- Color-coded: Green for positive outcomes, red for negative, neutral for push

---

## States & Feedback

### Game States

```
Initial State
  ↓
[New Game Clicked]
  ↓
Deal State (showing initial two cards)
  ↓
[Player Decision: Hit/Stand/Double/Split]
  ↓
Decision State (updated hand, new recommendation)
  ↓
[Repeat until hand complete]
  ↓
Dealer Play State (dealer draws per rule)
  ↓
Hand Resolution State (outcome and accuracy displayed)
  ↓
[Next Hand Clicked]
  ↓
Deal State (new hand)
  ↓
[Repeat or New Session]
```

### Button States

| Button | Initial | Deal | Hit/Stand | Bust | Dealer Play | Resolution |
|--------|---------|------|-----------|------|-------------|------------|
| Hit | Disabled | Enabled | Enabled | Disabled | Disabled | Disabled |
| Stand | Disabled | Enabled | Enabled | Disabled | Disabled | Disabled |
| Double | Disabled | Enabled (if 2 cards) | Disabled | Disabled | Disabled | Disabled |
| Split | Disabled | Enabled (if pair, <4 hands) | Disabled | Disabled | Disabled | Disabled |
| Next Hand | Disabled | Disabled | Disabled | Enabled | Disabled | Enabled |
| New Game | Enabled | Disabled | Disabled | Disabled | Disabled | Disabled |
| New Session | Enabled | Enabled | Enabled | Enabled | Enabled | Enabled |

### Feedback Mechanisms

**Visual Feedback:**
- Button hover state: Color change or shadow effect
- Button active state: Pressed appearance
- Card appearance: Smooth transition when new card is dealt
- Hand total update: Immediate recalculation and display
- Recommendation update: Immediate change when hand total changes

**Textual Feedback:**
- Status messages: "Bust!", "Dealer plays...", "You win!"
- Accuracy display: Immediate display after hand resolution
- Session accuracy: Updated in header after each hand

**Temporal Feedback:**
- Dealer play: Step-by-step reveal of dealer cards (optional animation)
- Hand resolution: Brief pause before "Next Hand" button is enabled (allows user to read outcome)

---

## Accessibility

### Keyboard Navigation

- Tab order: Logical flow through buttons (Hit → Stand → Double → Split → Next Hand → New Session)
- Enter/Space: Activate focused button
- Keyboard shortcuts (optional): H (Hit), S (Stand), D (Double), P (Split)
- Skip links: Not required for this simple interface

### Screen Reader Support

- All buttons have descriptive labels: "Hit", "Stand", "Double Down", "Split"
- Card display: Announce rank and suit (e.g., "Ace of Spades")
- Hand total: Announce total and soft/hard status (e.g., "Soft 17")
- Recommendation: Announce action (e.g., "Recommended action: Hit")
- Outcome: Announce result (e.g., "You win!")
- Accuracy: Announce percentage and breakdown (e.g., "Hand accuracy: 67%, 2 out of 3 decisions")

### Color Contrast

- All text: Minimum WCAG AA contrast ratio (4.5:1 for normal text, 3:1 for large text)
- Buttons: Distinct color from background; not reliant on color alone to convey meaning
- Outcome messages: Use text labels in addition to color (e.g., "Win" in green, "Lose" in red)

### Motor Accessibility

- Buttons: Minimum 44px × 44px touch target (mobile)
- Buttons: Minimum 40px × 40px on desktop
- No hover-only interactions (all interactions available via click/tap)
- No double-click or long-press requirements

### Cognitive Accessibility

- Clear, simple language: "Hit", "Stand", "Double Down", "Split"
- Consistent terminology: Always use "soft" for soft hands, "bust" for exceeding 21
- Visual hierarchy: Recommendation box is prominent; less important info is de-emphasized
- Minimal cognitive load: One decision at a time; no simultaneous choices

---

## Responsive Behavior

### Viewport Breakpoints

#### Mobile (320px – 480px)

**Layout:**
- Single-column layout
- Dealer cards: Displayed in a row, scaled down
- Player cards: Displayed in a row, scaled down
- Hand total: Below cards, large text
- Recommendation box: Full width, prominent
- Buttons: Full width, stacked vertically

**Components:**
- Card size: 60px × 90px (scaled proportionally)
- Button height: 44px (minimum touch target)
- Font size: 16px (body), 20px (hand total), 24px (recommendation)
- Session accuracy: Displayed in header, smaller font (12px)

**Example Layout:**
```
[Header: Title + Session Accuracy]
[Dealer: Cards in row]
[Player: Cards in row]
[Hand Total: "A + 6 = soft 17"]
[Recommendation: "Hit" (full width)]
[Buttons: Hit | Stand | Double | Split (stacked)]
```

#### Tablet (481px – 768px)

**Layout:**
- Two-column layout (optional): Dealer on left, player on right
- Or single-column with more spacing
- Cards: Medium size (70px × 105px)
- Buttons: Displayed in a 2×2 grid or row

**Components:**
- Card size: 70px × 105px
- Button height: 44px
- Font size: 16px (body), 22px (hand total), 26px (recommendation)

#### Desktop (769px – 1920px)

**Layout:**
- Centered content area (max-width: 800px)
- Dealer section: Top
- Player section: Middle
- Recommendation box: Prominent, below cards
- Buttons: Row layout, evenly spaced

**Components:**
- Card size: 80px × 120px
- Button height: 44px
- Font size: 16px (body), 24px (hand total), 28px (recommendation)
- Session accuracy: Header, right-aligned

### Responsive Adjustments

**Dealer Cards:**
- Mobile: Overlapping cards (offset) to fit in narrow space
- Tablet/Desktop: Spaced out horizontally

**Player Cards:**
- Mobile: Overlapping cards (offset) to fit in narrow space
- Tablet/Desktop: Spaced out horizontally

**Split Hands:**
- Mobile: Stacked vertically; active hand highlighted
- Tablet/Desktop: Side-by-side or stacked with clear visual separation

**Buttons:**
- Mobile: Full width, stacked vertically, 44px height
- Tablet: 2×2 grid or row, 44px height
- Desktop: Row layout, 44px height, evenly spaced

**Recommendation Box:**
- Mobile: Full width, large text (24px)
- Tablet: Full width, large text (26px)
- Desktop: Centered, large text (28px)

### No Horizontal Scrolling

- All content fits within viewport width without horizontal scrolling
- Cards may overlap on mobile, but no scrolling required
- Buttons are responsive and stack vertically on small screens

---

## Content & Copy

### Button Labels

- **Hit**: "Hit" (standard blackjack terminology)
- **Stand**: "Stand" (standard blackjack terminology)
- **Double Down**: "Double Down" or "Double" (both acceptable; "Double" is shorter)
- **Split**: "Split" (standard blackjack terminology)
- **Next Hand**: "Next Hand" or "Deal Next Hand"
- **New Game**: "New Game" or "Deal"
- **New Session**: "New Session" or "Reset Session"

### Status Messages

- **Bust**: "Bust!" (player exceeded 21)
- **Dealer Bust**: "Dealer busts!" (dealer exceeded 21)
- **Win**: "You win!" or "Win" (player total > dealer total or dealer bust)
- **Lose**: "You lose." or "Lose" (dealer total > player total or player bust)
- **Push**: "Push." or "Push" (equal totals)
- **Blackjack**: "Blackjack! 3:2 payout." (player blackjack on initial deal)
- **Dealer Blackjack**: "Dealer blackjack. You lose." (dealer blackjack, player doesn't have blackjack)

### Accuracy Display

- **Per-Hand**: "Hand Accuracy: 67% (2/3)"
- **Session**: "Session Accuracy: 75% (15/20)"
- **No Data**: "Session Accuracy: —" (before any decisions)

### Recommendation Display

- **Label**: "Recommended Action"
- **Actions**: "Hit", "Stand", "Double Down", "Split"

### Hand Total Display

- **Hard Hand**: "10 + 5 = 15"
- **Soft Hand**: "A + 6 = soft 17"
- **Bust**: "10 + 5 + 7 = 22 — Bust!"
- **Blackjack**: "Blackjack!"

### Prompts & Confirmations

- **Insurance**: "Dealer shows an Ace. Insurance offered. Accept?" with Yes/No buttons
- **New Session**: "Reset session data? This cannot be undone." with Yes/Cancel buttons

---

## Edge Cases

### Blackjack on Initial Deal

**Scenario:** Player is dealt an Ace and a 10-value card on the initial deal.

**Behavior:**
- Hand is immediately identified as blackjack
- Display: "Blackjack!" (special display, not "A + 10 = 21")
- Buttons: Disabled (no decision needed)
- Outcome: Automatic win with 3:2 payout
- Message: "Blackjack! 3:2 payout."
- Dealer does not play (blackjack is immediate win)

### Dealer Blackjack

**Scenario:** Dealer's hole card is revealed and dealer has blackjack (Ace + 10-value card).

**Behavior:**
- If player also has blackjack: Push (equal totals)
- If player does not have blackjack: Player loses
- Message: "Dealer blackjack. You lose." or "Push."
- Outcome displayed; next hand prompt shown

### Split Ace Receiving 10-Value Card

**Scenario:** Player splits Aces; one Ace receives a 10-value card (total 21).

**Behavior:**
- Hand total: 21 (not blackjack; pays 1:1, not 3:2)
- Display: "A + 10 = 21" (not "Blackjack!")
- Hand stands automatically (no further decisions)
- Outcome: Compared to dealer's final total

### Bust on First Hit

**Scenario:** Player hits and exceeds 21 on the first hit.

**Behavior:**
- Hand is marked as bust
- Display: "Bust!" (e.g., "10 + 5 + 7 = 22 — Bust!")
- Buttons: Disabled (no further decisions)
- If multiple hands: Move to next hand
- If last hand: Dealer plays (even though player busted)

### Bust on Split Hand

**Scenario:** Player busts on the first split hand.

**Behavior:**
- First hand is marked as bust
- Display: "Bust!"
- Buttons: Disabled for first hand
- Next hand becomes active
- Player plays second hand normally
- After all hands complete: Dealer plays

### Four Hands After Splits

**Scenario:** Player has split three times, creating four hands.

**Behavior:**
- Split button: Disabled (cannot create fifth hand)
- Message (optional): "Maximum of 4 hands reached."
- Player plays all four hands in sequence
- After all hands complete: Dealer plays

### Insurance Accepted, Dealer Has Blackjack

**Scenario:** Player accepts insurance; dealer's hole card is revealed as a 10-value card (dealer has blackjack).

**Behavior:**
- Insurance payout: 2:1 (player wins insurance bet)
- Main hand outcome: Player loses (unless player also has blackjack for a push)
- Display: "Insurance wins! 2:1 payout." and "Dealer blackjack. You lose." (or "Push.")
- Net outcome: Insurance win offsets main hand loss (or contributes to push)

### Insurance Declined, Dealer Has Blackjack

**Scenario:** Player declines insurance; dealer's hole card is revealed as a 10-value card (dealer has blackjack).

**Behavior:**
- Insurance: Not applicable
- Main hand outcome: Player loses (unless player also has blackjack for a push)
- Display: "Dealer blackjack. You lose." (or "Push.")

### No Decisions Made Yet (Session Start)

**Scenario:** Page is loaded; no hands have been played.

**Behavior:**
- Session accuracy display: "—" (not "0%")
- Reason: Division by zero avoided; "—" indicates no data
- After first hand: Session accuracy displays percentage

### Double Down on Split Hand

**Scenario:** Player splits; one resulting hand is two cards; player doubles down.

**Behavior:**
- Double down is allowed on split hands (per in-scope clarification)
- One additional card is dealt
- Hand stands automatically
- Recommendation is updated for this hand before the double decision

### Soft 17 Dealer Rule

**Scenario:** Dealer has soft 17 (e.g., A + 6).

**Behavior:**
- Dealer must hit (per rule: "hit on soft 16, stand on soft 17")
- Soft 17 is treated as 17 for the purpose of the rule, but the dealer still hits because it's soft
- Display: "Dealer has soft 17. Dealer hits."
- Dealer continues drawing until hard 17 or higher

### Hard 17 Dealer Rule

**Scenario:** Dealer has hard 17 (e.g., 10 + 7).

**Behavior:**
- Dealer stands (per rule: "stand on soft 17" and hard 17+)
- Display: "Dealer has 17. Dealer stands."

### Multiple Aces in Hand

**Scenario:** Player hits and receives multiple Aces (e.g., A + A + 9).

**Behavior:**
- Hand value: 11 + 1 + 9 = 21 (one Ace counts as 11, others as 1)
- Hand status: Hard 21 (no Ace counting as 11 after the first)
- Display: "A + A + 9 = 21"
- Recommendation: "Stand"

### Soft Hand Transitioning to Hard

**Scenario:** Player has soft 16 (A + 5); hits and receives a 6.

**Behavior:**
- Initial: A + 5 = soft 16
- After hit: A + 5 + 6 = 12 (Ace must count as 1 to avoid bust)
- Hand status: Hard 12 (Ace now counts as 1)
- Display: "A + 5 + 6 = 12"
- Recommendation: Updates to reflect hard 12 (likely "Hit")

### Empty Session Accuracy

**Scenario:** User clicks "New Session" and then views the initial screen.

**Behavior:**
- Session accuracy: "—" (no data)
- Counters: 0 correct, 0 total
- Display: "Session Accuracy: —"

---

## Design Assets

### Color Palette

- **Primary Action**: Green (#4CAF50 or similar) — for "New Game", "Next Hand", "Hit", "Stand"
- **Secondary Action**: Blue (#2196F3 or similar) — for "Double Down", "Split"
- **Recommendation Box**: Light yellow or light blue (#FFF9C4 or #E3F2FD) — high contrast, attention-grabbing
- **Win Outcome**: Green (#4CAF50)
- **Lose Outcome**: Red (#F44336)
- **Push Outcome**: Gray (#9E9E9E)
- **Bust**: Red (#F44336)
- **Text**: Dark gray (#333333) on light background

### Typography

- **Font Family**: Sans-serif (e.g., Arial, Helvetica, Roboto)
- **Body Text**: 16px, line-height 1.5
- **Hand Total**: 22–28px (responsive), bold
- **Recommendation**: 24–28px (responsive), bold
- **Button Labels**: 16px, bold
- **Session Accuracy**: 14–16px

### Icons (Optional)

- **Hit**: Arrow pointing down or card icon
- **Stand**: Hand gesture or stop icon
- **Double Down**: Two cards or double arrow
- **Split**: Two arrows pointing apart or split icon
- **Blackjack**: Star or special badge
- **Win**: Checkmark or trophy
- **Lose**: X or frown
- **Push**: Equal sign or neutral face

---

## Acceptance Criteria

### Functional Acceptance Criteria

1. **Deal Screen**: Initial deal displays two player cards, one dealer up-card, player hand total, and strategy recommendation.
2. **Hit Action**: Clicking "Hit" deals one card; hand total updates; recommendation updates.
3. **Stand Action**: Clicking "Stand" ends the player's turn; dealer plays.
4. **Double Down**: Available only on first decision (two-card hand); deals one card and stands automatically.
5. **Split**: Available only when hand is a pair and fewer than four hands exist; creates two hands; each receives one new card.
6. **Dealer Play**: Dealer hits on soft 16 and stands on soft 17; no deviation.
7. **Accuracy Tracking**: Per-hand accuracy displays correctly; session accuracy updates after each hand.
8. **Insurance**: Offered when dealer shows Ace; not scored for accuracy.
9. **Blackjack Detection**: Ace + 10-value card on initial deal is detected; hand auto-resolves with 3:2 payout.
10. **Hand Resolution**: Outcome (Win/Lose/Push) is determined correctly; displayed clearly.
11. **New Game**: "New Game" button deals a new hand; session accuracy persists.
12. **New Session**: "New Session" button resets session data; returns to initial screen.
13. **Responsive Layout**: No horizontal scrolling; all controls usable at 320px–1920px viewport widths.
14. **Keyboard Navigation**: Tab order is logical; Enter/Space activates buttons.
15. **Screen Reader Support**: All text is announced; buttons have descriptive labels; outcomes are announced.

### Non-Functional Acceptance Criteria

1. **Strategy Correctness**: All strategy recommendations match the published basic strategy table (100% accuracy).
2. **Soft Hand Classification**: All soft hands are correctly identified; all hard hands are correctly identified.
3. **Hand Value Calculation**: All hand totals are calculated correctly; no off-by-one errors.
4. **Dealer Rule Compliance**: Dealer hits on soft 16; stands on soft 17; no deviation.
5. **Accuracy Calculation**: Per-hand and session accuracy are calculated correctly; rounded to nearest integer.
6. **Viewport Compatibility**: Application renders without horizontal scrolling at 320px, 375px, 768px, 1024px, 1280px, 1920px.
7. **Input Responsiveness**: Button clicks produce visible feedback within 300ms.
8. **Split Hand Limit**: Fifth hand cannot be created; split button is disabled when four hands exist.
9. **Browser Support**: Application functions on Chrome, Firefox, and Safari (latest stable releases).

---

## Summary

This UX Specification provides a detailed blueprint for implementing the Blackjack with Strategy Coach application. It defines:

- **How users interact** with the game through clear, responsive screens and intuitive controls
- **What feedback they receive** at each step (recommendations, outcomes, accuracy)
- **How the interface adapts** to different devices and screen sizes
- **How edge cases are handled** (blackjack, bust, split, insurance, etc.)
- **Accessibility considerations** for keyboard, screen reader, and motor accessibility

The specification bridges the PRD's requirements and technical implementation, ensuring that designers, developers, testers, and product managers have a shared understanding of the intended user experience.
