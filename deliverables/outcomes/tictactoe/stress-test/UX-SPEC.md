# UX Specification: Tic-Tac-Toe Progressive Web Application

## Overview

This UX Specification defines the user interface, interaction flows, and component behavior for a tic-tac-toe progressive web application with three play modes: Player vs. Player, Easy AI, and Impossible AI. The specification bridges the Product Requirements Document (PRD) and Technical Design Specification, providing a detailed blueprint for designers, developers, testers, and product managers.

The application prioritizes clarity, responsiveness, and learning—especially in Impossible AI mode where minimax score visualization is central to the user experience.

---

## Target Users & Personas

### Persona 1: Casual Player
- **Primary Device**: Desktop or tablet
- **Technical Proficiency**: Low to medium
- **Motivation**: Quick entertainment; play against a friend or easy AI
- **Key Needs**: Intuitive interface, clear turn indicators, fast feedback
- **Accessibility Concerns**: May use touch or keyboard; prefers large touch targets

### Persona 2: Learning-Focused Player
- **Primary Device**: Desktop (primary), tablet (secondary)
- **Technical Proficiency**: Medium to high
- **Motivation**: Understand AI decision-making through minimax visualization
- **Key Needs**: Clear minimax score display, ability to study scores before AI moves, visual distinction between modes
- **Accessibility Concerns**: May use keyboard navigation; benefits from clear labeling of scores

### Persona 3: Competitive Player
- **Primary Device**: Desktop or mobile
- **Technical Proficiency**: Low to high
- **Motivation**: Challenge the AI, achieve draws, compete with friends
- **Key Needs**: Fast gameplay, clear game state, ability to start new games quickly
- **Accessibility Concerns**: May use touch on mobile; needs responsive design

---

## User Goals

1. **Select a play mode** and start a game within 2 clicks
2. **Play a complete game** with clear feedback on whose turn it is and when the game ends
3. **(Impossible AI mode)** View minimax scores and understand why the AI makes its move
4. **Play on any device** (mobile, tablet, desktop) without horizontal scrolling or interaction issues
5. **Access the game offline** (PWA capability) and resume play without losing state
6. **Understand game outcomes** (win, loss, draw) immediately and clearly

---

## User Flows

### Flow 1: Mode Selection & Game Initialization

```
User Opens App
    ↓
[Home/Mode Selection Screen]
    ├─ Player vs. Player (selected)
    ├─ Easy AI
    └─ Impossible AI
    ↓
User Selects Mode
    ↓
[Game Board Screen - Mode-Specific Layout]
    ↓
Game Ready for Play
```

**Persona Variations**:
- **Casual Player**: Expects clear, simple mode descriptions; may hover over mode cards for more info
- **Learning-Focused Player**: Reads mode descriptions carefully; may select Impossible AI to study scores
- **Competitive Player**: Quickly selects preferred mode; may alternate between modes in succession

---

### Flow 2: Player vs. Player Mode

```
[Game Board - Player vs. Player]
    ↓
Player X's Turn
    ├─ User clicks empty cell
    ├─ Board updates immediately
    └─ Turn indicator changes to "Player O's Turn"
    ↓
Player O's Turn
    ├─ User clicks empty cell
    ├─ Board updates immediately
    └─ Turn indicator changes to "Player X's Turn"
    ↓
[Terminal State Reached]
    ├─ Win: "Player X Wins!" or "Player O Wins!"
    ├─ Draw: "It's a Draw!"
    └─ Game board becomes non-interactive
    ↓
[Game Over Screen]
    ├─ Result message
    ├─ "New Game" button (same mode)
    └─ "Change Mode" button (return to mode selection)
```

**Key Interactions**:
- Clicking an empty cell immediately updates the board
- Turn indicator updates after each move
- Game state is validated server-side; invalid moves are rejected with brief feedback
- After terminal state, no further moves are accepted

---

### Flow 3: Easy AI Mode

```
[Game Board - Easy AI]
    ↓
Player's Turn
    ├─ User clicks empty cell
    ├─ Board updates immediately
    ├─ Turn indicator shows "AI is thinking..."
    └─ [Loading state for 0.5-1 second]
    ↓
AI Move Executed
    ├─ Board updates with AI's move
    ├─ Turn indicator returns to "Your Turn"
    └─ If terminal state: show result
    ↓
[Repeat or Terminal State]
    ├─ If game continues: Player's Turn
    └─ If game ends: [Game Over Screen]
```

**Key Interactions**:
- AI move latency: 0.5-1 second (user perceives thinking time)
- Loading indicator shows AI is computing
- AI move is clearly visible (e.g., cell highlights or animation)
- Player can see win/loss/draw immediately

---

### Flow 4: Impossible AI Mode (with Minimax Visualization)

```
[Game Board - Impossible AI]
    ↓
Player's Turn
    ├─ User clicks empty cell
    ├─ Board updates immediately
    ├─ Turn indicator shows "AI is evaluating..."
    └─ [Loading state for 0.5-1 second]
    ↓
Minimax Scores Displayed
    ├─ Each empty cell shows its minimax score (+1, 0, or -1)
    ├─ Scores are color-coded or visually distinct
    ├─ Turn indicator shows "AI will move to highest score"
    └─ Player can study scores (no time limit)
    ↓
AI Move Executed
    ├─ Scores disappear
    ├─ Board updates with AI's move
    ├─ Turn indicator returns to "Your Turn"
    └─ If terminal state: show result
    ↓
[Repeat or Terminal State]
    ├─ If game continues: Player's Turn
    └─ If game ends: [Game Over Screen - Always Draw or Loss]
```

**Key Interactions**:
- Scores appear *before* AI move
- Player has time to study and learn
- Scores disappear after AI moves
- Game always ends in draw or loss (AI never loses)
- Learning-focused players can replay to test different strategies

---

## Information Architecture

### Screen Hierarchy

```
Home / Mode Selection Screen
├─ Header (App Title)
├─ Mode Cards (3 options)
│  ├─ Player vs. Player
│  ├─ Easy AI
│  └─ Impossible AI
└─ Footer (optional: settings, about)

Game Board Screen
├─ Header
│  ├─ Mode Indicator (e.g., "Easy AI")
│  ├─ Turn Indicator (e.g., "Your Turn" or "Player X's Turn")
│  └─ Back/Menu Button
├─ Main Content
│  ├─ Game Board (3×3 grid)
│  └─ Minimax Scores (Impossible AI mode only)
├─ Game Status
│  ├─ Current state (playing, loading, terminal)
│  └─ Result message (if game ended)
└─ Actions
   ├─ New Game Button
   └─ Change Mode Button

Game Over Screen
├─ Result Message (Win/Loss/Draw)
├─ Game Summary (optional: moves played, duration)
├─ New Game Button
└─ Change Mode Button
```

---

## Screen Specifications

### Screen 1: Home / Mode Selection

**Purpose**: Allow user to select which play mode to start

**Layout**:
- Full viewport, centered content
- Header with app title and logo
- Three mode cards displayed in a row (desktop) or column (mobile)
- Each card is a clickable button with clear visual affordance

**Components**:
- **App Title**: "Tic-Tac-Toe" (large, prominent)
- **Mode Card (Player vs. Player)**
  - Title: "Player vs. Player"
  - Description: "Play against a friend on the same device"
  - Icon: Two player silhouettes or game board
  - Visual Style: Neutral color (e.g., blue)
  - Hover State: Slight shadow or color shift
  - Active State: Highlighted border or background

- **Mode Card (Easy AI)**
  - Title: "Easy AI"
  - Description: "Play against a random AI. You can win!"
  - Icon: Single player + robot
  - Visual Style: Green (indicates beatable)
  - Hover State: Slight shadow or color shift
  - Active State: Highlighted border or background

- **Mode Card (Impossible AI)**
  - Title: "Impossible AI"
  - Description: "Play against an unbeatable AI. See how it thinks."
  - Icon: Single player + robot with brain/lightbulb
  - Visual Style: Purple or orange (indicates challenging)
  - Hover State: Slight shadow or color shift
  - Active State: Highlighted border or background

**Responsive Behavior**:
- **Desktop (1024px+)**: Three cards in a row, each ~300px wide
- **Tablet (768px-1023px)**: Two cards in first row, one in second row; or three cards stacked
- **Mobile (320px-767px)**: Three cards stacked vertically, full width with padding

**Accessibility**:
- Each card is a semantic button with `role="button"` or `<button>` element
- Card titles are headings (h2 or h3)
- Descriptions are clear and concise
- Keyboard navigation: Tab to each card, Enter/Space to select
- Screen reader: "Player vs. Player mode, play against a friend on the same device"

---

### Screen 2: Game Board - Player vs. Player Mode

**Purpose**: Display the game board and manage turn-based gameplay

**Layout**:
- Header with mode indicator, turn indicator, and back button
- Centered game board (3×3 grid)
- Action buttons below board

**Components**:

**Header**:
- **Back/Menu Button** (top-left): Small button to return to mode selection
  - Icon: Back arrow or menu icon
  - Label: "Back" or "Menu"
  - Tap target: 44px × 44px minimum

- **Mode Indicator** (top-center): Text or badge showing "Player vs. Player"
  - Font: Medium weight, readable
  - Color: Neutral (gray or dark)

- **Turn Indicator** (top-right or below mode): Large, prominent text
  - Content: "Player X's Turn" or "Player O's Turn"
  - Font: Bold, large (24px+)
  - Color: Changes based on player (e.g., blue for X, red for O)
  - Updates immediately after each move

**Game Board**:
- **Grid Layout**: 3×3 grid of cells
- **Cell Dimensions**: 
  - Desktop: 120px × 120px (or responsive)
  - Tablet: 100px × 100px
  - Mobile: 80px × 80px (minimum 44px × 44px touch target)
- **Cell Content**: Empty, "X", or "O"
  - Font: Bold, large (48px+ for X/O)
  - Color: X = blue, O = red (or configurable)
- **Cell States**:
  - Empty: Light gray background, cursor pointer on hover
  - Filled: White background, cursor default
  - Hover (empty): Slight color change or shadow (desktop only)
  - Active (clicked): Immediate update with X or O
- **Cell Accessibility**:
  - Each cell is a button with aria-label (e.g., "Row 1, Column 1, empty")
  - Keyboard navigation: Tab to move between cells, Enter/Space to place mark
  - Screen reader announces cell position and current state

**Game Status**:
- **Status Message** (below board): Displays game state
  - Playing: (hidden or shows turn indicator)
  - Loading: "AI is thinking..." (Easy AI) or "AI is evaluating..." (Impossible AI)
  - Terminal: "Player X Wins!", "Player O Wins!", or "It's a Draw!"
  - Font: Medium, bold
  - Color: Green (win), red (loss), gray (draw)

**Action Buttons** (below status):
- **New Game Button**: Restart in the same mode
  - Label: "New Game"
  - Style: Primary button (prominent color)
  - Tap target: 44px × 44px minimum
  - Action: Clear board, reset turn indicator, start new game

- **Change Mode Button**: Return to mode selection
  - Label: "Change Mode" or "Back to Modes"
  - Style: Secondary button (less prominent)
  - Tap target: 44px × 44px minimum
  - Action: Navigate to mode selection screen

**Responsive Behavior**:
- **Desktop (1024px+)**: Board centered, 120px cells, buttons below
- **Tablet (768px-1023px)**: Board centered, 100px cells, buttons below
- **Mobile (320px-767px)**: Board full width with padding, 80px cells, buttons full width below

**Accessibility**:
- All cells are keyboard navigable
- Turn indicator is announced by screen reader
- Status messages are clear and descriptive
- Color is not the only indicator (X/O symbols are also used)

---

### Screen 3: Game Board - Easy AI Mode

**Purpose**: Display game board and manage AI gameplay

**Layout**: Similar to Player vs. Player, with loading state for AI moves

**Components**:

**Header**: Same as Player vs. Player
- Mode Indicator: "Easy AI"
- Turn Indicator: "Your Turn" or "AI is thinking..."

**Game Board**: Same 3×3 grid as Player vs. Player

**Game Status**:
- **Playing**: "Your Turn"
- **Loading**: "AI is thinking..." (0.5-1 second)
  - Optional: Animated dots or spinner
  - Prevents user interaction during AI computation
- **Terminal**: "You Won!", "You Lost!", or "It's a Draw!"

**Action Buttons**: Same as Player vs. Player

**Responsive Behavior**: Same as Player vs. Player

**Accessibility**: Same as Player vs. Player

---

### Screen 4: Game Board - Impossible AI Mode (with Minimax Visualization)

**Purpose**: Display game board, manage AI gameplay, and visualize minimax scores

**Layout**: Similar to Easy AI, with additional space for minimax score display

**Components**:

**Header**: Same as Easy AI
- Mode Indicator: "Impossible AI"
- Turn Indicator: "Your Turn" or "AI is evaluating..."

**Game Board**: 3×3 grid with minimax scores overlaid or displayed separately

**Minimax Score Display** (Key Component):
- **Timing**: Appears after player move, before AI move
- **Duration**: Visible for 2-5 seconds (or until user acknowledges)
- **Visual Design**:
  - Option A (Overlay): Small numbers in corner of each empty cell
    - Font: 14px, bold, semi-transparent
    - Color: Green (+1), Gray (0), Red (-1)
    - Positioning: Top-right corner of cell to avoid obscuring board
  - Option B (Separate Panel): Scores displayed in a legend or table below board
    - Format: "Cell (Row, Col): Score"
    - Color-coded by score value
  - Option C (Color Coding): Cell background color indicates score
    - Green background = +1 (AI win)
    - Gray background = 0 (draw)
    - Red background = -1 (human win, AI will never choose)
    - Recommendation: Combine with Option A for clarity

- **Recommended Approach**: Option A + Option C
  - Cell background is color-coded
  - Small number in corner for exact score
  - Minimizes clutter while maximizing clarity

**Game Status**:
- **Playing**: "Your Turn"
- **Evaluating**: "AI is evaluating..." (0.5-1 second)
  - Prevents user interaction during minimax computation
- **Scores Visible**: "Study the scores. AI will play the highest score."
  - Turn indicator changes to show scores are visible
  - User can take time to understand
- **AI Moving**: "AI is moving..." (0.5 second)
  - Scores disappear
  - Board updates with AI move
- **Terminal**: "You Won!", "You Lost!", or "It's a Draw!"
  - Note: "You Won!" is impossible; only "You Lost!" or "It's a Draw!"

**Action Buttons**: Same as Easy AI

**Responsive Behavior**:
- **Desktop (1024px+)**: Board centered, scores overlaid, clear visibility
- **Tablet (768px-1023px)**: Board centered, scores overlaid or in separate panel below
- **Mobile (320px-767px)**: 
  - Board full width with padding
  - Scores in separate panel below board (not overlaid to avoid clutter)
  - Panel scrollable if needed

**Accessibility**:
- Minimax scores are announced by screen reader: "Cell Row 1 Column 1: Score +1 (AI win)"
- Color is not the only indicator; numbers are also displayed
- Scores are presented in a logical order (top-left to bottom-right)
- Learning-focused players can navigate scores via keyboard

---

### Screen 5: Game Over Screen

**Purpose**: Display game result and provide options to continue playing

**Layout**:
- Centered modal or full-screen overlay
- Large result message
- Game summary (optional)
- Action buttons

**Components**:

**Result Message**:
- **Content**: "Player X Wins!", "Player O Wins!", "You Won!", "You Lost!", or "It's a Draw!"
- **Font**: Large (32px+), bold
- **Color**: Green (win), red (loss), gray (draw)
- **Icon**: Optional checkmark (win), X (loss), or equal sign (draw)

**Game Summary** (Optional):
- Moves played: "Game lasted 5 moves"
- Duration: "Game duration: 2 minutes 30 seconds"
- Mode: "Played in Easy AI mode"
- Font: Medium, gray

**Action Buttons**:
- **New Game Button**: Restart in the same mode
  - Label: "Play Again"
  - Style: Primary button
  - Action: Clear board, start new game

- **Change Mode Button**: Return to mode selection
  - Label: "Try Another Mode"
  - Style: Secondary button
  - Action: Navigate to mode selection screen

**Responsive Behavior**:
- **Desktop (1024px+)**: Centered modal, 400px wide
- **Tablet (768px-1023px)**: Centered modal, 80% width
- **Mobile (320px-767px)**: Full-screen overlay, full width with padding

**Accessibility**:
- Result message is announced immediately
- Buttons are keyboard navigable
- Modal has focus management (focus moves to first button)

---

## Interaction Design

### Cell Interaction

**Desktop**:
- **Hover**: Cell background lightens or shadow appears
- **Click**: Cell updates immediately with X or O; board updates; turn indicator changes
- **Invalid Move**: Cell is already filled; click is ignored (no visual feedback needed)

**Mobile/Tablet**:
- **Tap**: Cell updates immediately with X or O; board updates; turn indicator changes
- **Touch Target**: 44px × 44px minimum (larger on mobile)
- **Visual Feedback**: Cell background changes color or animates slightly

**Keyboard**:
- **Tab**: Navigate between cells
- **Enter/Space**: Place mark in current cell
- **Arrow Keys** (optional): Navigate between cells in grid pattern

### Button Interaction

**Desktop**:
- **Hover**: Button background changes color or shadow appears
- **Click**: Action executes immediately
- **Focus**: Visible focus ring (keyboard navigation)

**Mobile/Tablet**:
- **Tap**: Action executes immediately
- **Touch Target**: 44px × 44px minimum
- **Visual Feedback**: Button background changes color or animates

**Keyboard**:
- **Tab**: Navigate to button
- **Enter/Space**: Activate button

### Mode Card Interaction

**Desktop**:
- **Hover**: Card shadow increases or background changes
- **Click**: Mode is selected; game board screen appears

**Mobile/Tablet**:
- **Tap**: Mode is selected; game board screen appears
- **Touch Target**: Full card is tappable (at least 44px tall)

**Keyboard**:
- **Tab**: Navigate to card
- **Enter/Space**: Select mode

### Loading State Interaction

**Easy AI & Impossible AI**:
- **During AI Computation**: Board is non-interactive (cells are disabled)
- **Visual Indicator**: "AI is thinking..." or "AI is evaluating..." message
- **Animation** (optional): Animated dots or spinner
- **Duration**: 0.5-1 second (Easy AI), 0.5-1 second (Impossible AI)

### Minimax Score Interaction (Impossible AI)

**Desktop**:
- **Hover over Score**: Optional tooltip showing full explanation (e.g., "This move leads to an AI win")
- **No Time Limit**: Player can study scores as long as desired
- **Click Anywhere**: Optional: Advance to AI move (or auto-advance after 5 seconds)

**Mobile/Tablet**:
- **Tap on Score**: Optional tooltip or legend appears
- **Swipe or Tap to Advance**: Player taps to proceed to AI move (or auto-advance)

**Keyboard**:
- **Arrow Keys**: Navigate between scores
- **Enter**: View details or advance to AI move

---

## Component Specifications

### Component 1: Game Board Cell

**Purpose**: Represent a single cell in the 3×3 grid

**States**:
- **Empty**: No mark, clickable
- **X**: Marked with X, non-clickable
- **O**: Marked with O, non-clickable
- **Hover** (desktop only): Slight visual change
- **Disabled** (during AI move): Non-clickable, grayed out

**Dimensions**:
- Desktop: 120px × 120px
- Tablet: 100px × 100px
- Mobile: 80px × 80px (minimum 44px × 44px touch target)

**Visual Design**:
- Border: 2px solid gray
- Background: White (empty), light gray (hover), white (filled)
- Font: Bold, 48px+ for X/O
- Color: Blue for X, Red for O

**Accessibility**:
- `role="button"` or `<button>` element
- `aria-label`: "Row 1, Column 1, empty" or "Row 1, Column 1, X"
- `aria-disabled="true"` when non-clickable

**Interaction**:
- Click/Tap: Place mark if empty
- Keyboard: Tab to navigate, Enter/Space to place mark
- Screen Reader: Announces cell position and state

---

### Component 2: Turn Indicator

**Purpose**: Show whose turn it is

**States**:
- **Player X's Turn**: "Player X's Turn" (blue text)
- **Player O's Turn**: "Player O's Turn" (red text)
- **Your Turn** (AI mode): "Your Turn" (neutral color)
- **AI is thinking...**: "AI is thinking..." (gray text, optional animation)
- **AI is evaluating...**: "AI is evaluating..." (gray text, optional animation)
- **Scores visible**: "Study the scores. AI will play the highest score." (purple text)

**Font**: Bold, 24px+

**Positioning**: Top-right of header or below mode indicator

**Accessibility**:
- Live region: `aria-live="polite"` to announce changes
- Screen reader: "Player X's turn" or "Your turn"

---

### Component 3: Status Message

**Purpose**: Display game status and results

**States**:
- **Playing**: (hidden or shows turn indicator)
- **Loading**: "AI is thinking..." or "AI is evaluating..."
- **Terminal**: "Player X Wins!", "You Won!", "You Lost!", or "It's a Draw!"

**Font**: Bold, 18px+

**Color**: Green (win), red (loss), gray (draw)

**Positioning**: Below game board

**Accessibility**:
- Live region: `aria-live="assertive"` for terminal states
- Screen reader: Announces result immediately

---

### Component 4: Mode Card

**Purpose**: Allow user to select a play mode

**States**:
- **Default**: Card with title, description, icon
- **Hover**: Shadow or color shift
- **Active/Selected**: Highlighted border or background
- **Disabled**: Grayed out (if applicable)

**Dimensions**:
- Desktop: ~300px wide, 200px tall
- Mobile: Full width with padding, 150px tall

**Visual Design**:
- Border: 1px solid gray
- Background: White or light color
- Icon: 48px × 48px
- Title: Bold, 18px+
- Description: Regular, 14px, gray

**Accessibility**:
- `role="button"` or `<button>` element
- `aria-label`: "Player vs. Player mode, play against a friend on the same device"
- Keyboard navigable: Tab to card, Enter/Space to select

---

### Component 5: Minimax Score Badge

**Purpose**: Display minimax score for a cell

**States**:
- **+1** (AI win): Green background, white text
- **0** (draw): Gray background, white text
- **-1** (human win): Red background, white text

**Dimensions**:
- 24px × 24px (small badge in corner of cell)
- Or: Full cell background color

**Font**: Bold, 12px-14px

**Positioning**: Top-right corner of cell (Option A) or full cell background (Option C)

**Accessibility**:
- Announced by screen reader: "Score +1, AI win"
- Color is not the only indicator; number is also displayed

---

### Component 6: Action Button

**Purpose**: Trigger actions (New Game, Change Mode, etc.)

**States**:
- **Default**: Neutral color, clickable
- **Hover**: Color shift or shadow (desktop only)
- **Active/Pressed**: Darker color
- **Disabled**: Grayed out, non-clickable
- **Focus**: Visible focus ring (keyboard navigation)

**Dimensions**:
- Desktop: 120px × 44px
- Mobile: Full width with padding, 44px tall (minimum)

**Visual Design**:
- Border: None or 1px solid
- Background: Primary color (blue) or secondary color (gray)
- Font: Bold, 16px
- Text: White or dark (high contrast)

**Accessibility**:
- `<button>` element
- `aria-label`: "New Game" or "Change Mode"
- Keyboard navigable: Tab to button, Enter/Space to activate
- Focus ring: Visible and high contrast

---

## States & Feedback

### Loading States

**Easy AI Move Loading**:
- **Duration**: 0.5-1 second
- **Visual**: "AI is thinking..." message + optional spinner
- **Board State**: Non-interactive (cells disabled)
- **User Feedback**: Clear indication that AI is computing

**Impossible AI Evaluation Loading**:
- **Duration**: 0.5-1 second
- **Visual**: "AI is evaluating..." message + optional spinner
- **Board State**: Non-interactive (cells disabled)
- **User Feedback**: Clear indication that AI is computing minimax scores

**Minimax Score Display**:
- **Duration**: 2-5 seconds or until user acknowledges
- **Visual**: Scores overlaid on board or in separate panel
- **Board State**: Non-interactive (cells disabled)
- **User Feedback**: "Study the scores. AI will play the highest score."

### Error States

**Invalid Move** (should not occur in normal flow):
- **Trigger**: User clicks already-filled cell
- **Feedback**: Move is ignored; no visual feedback needed (cell is already filled)
- **Recovery**: User can click another empty cell

**Network Error** (if applicable):
- **Trigger**: Server fails to respond to move submission
- **Feedback**: "Connection error. Please try again." message
- **Recovery**: User can retry move or return to mode selection

### Terminal States

**Win** (Player vs. Player or Easy AI):
- **Visual**: Large, green "Player X Wins!" or "You Won!" message
- **Board State**: Non-interactive
- **Options**: New Game, Change Mode

**Loss** (Easy AI or Impossible AI):
- **Visual**: Large, red "You Lost!" message
- **Board State**: Non-interactive
- **Options**: New Game, Change Mode

**Draw**:
- **Visual**: Large, gray "It's a Draw!" message
- **Board State**: Non-interactive
- **Options**: New Game, Change Mode

### Feedback Mechanisms

**Immediate Visual Feedback**:
- Cell updates immediately when clicked
- Turn indicator changes immediately
- Board state is always clear

**Status Messages**:
- Turn indicator shows whose turn it is
- Loading messages show AI is computing
- Result messages show game outcome

**Animation** (optional, not required):
- Subtle cell fill animation (0.2 seconds)
- Subtle button hover effects
- Animated spinner during loading (not required)

---

## Accessibility

### Keyboard Navigation

**Mode Selection Screen**:
- Tab: Navigate between mode cards
- Enter/Space: Select mode
- Shift+Tab: Navigate backwards

**Game Board Screen**:
- Tab: Navigate between cells and buttons
- Arrow Keys (optional): Navigate within grid (up/down/left/right)
- Enter/Space: Place mark in current cell or activate button
- Shift+Tab: Navigate backwards

**Game Over Screen**:
- Tab: Navigate between buttons
- Enter/Space: Activate button
- Shift+Tab: Navigate backwards

### Screen Reader Support

**Mode Selection Screen**:
- App title: "Tic-Tac-Toe"
- Mode cards: "Player vs. Player mode, play against a friend on the same device"
- Descriptions: Clear, concise text

**Game Board Screen**:
- Mode indicator: "Easy AI mode"
- Turn indicator: "Your turn" or "Player X's turn" (live region, `aria-live="polite"`)
- Game board: "Game board, 3 by 3 grid"
- Cells: "Row 1, Column 1, empty" or "Row 1, Column 1, X"
- Status message: "AI is thinking..." or "You won!" (live region, `aria-live="assertive"`)
- Minimax scores: "Cell Row 1, Column 1: Score +1, AI win" (if applicable)

**Game Over Screen**:
- Result message: "You won!" or "It's a draw!" (live region, `aria-live="assertive"`)
- Buttons: "Play Again" or "Try Another Mode"

### Color Contrast

- **Minimum Ratio**: 4.5:1 for normal text, 3:1 for large text (WCAG AA)
- **Player X**: Blue (#0066CC or similar)
- **Player O**: Red (#CC0000 or similar)
- **Minimax +1**: Green (#00AA00 or similar) with white text
- **Minimax 0**: Gray (#666666 or similar) with white text
- **Minimax -1**: Red (#CC0000 or similar) with white text
- **Text on Buttons**: White or dark (high contrast with button background)

### Touch Targets

- **Minimum Size**: 44px × 44px (iOS/Android standard)
- **Spacing**: 8px minimum between touch targets
- **Cells**: 80px × 80px on mobile (exceeds minimum)
- **Buttons**: 44px tall, full width on mobile (exceeds minimum)

### Accessible Copy

- **Avoid Vague Language**: Use specific, clear descriptions
- **Example**: "Easy AI" instead of "Simple mode"
- **Example**: "Study the scores. AI will play the highest score." instead of "See the AI's thinking"

---

## Responsive Behavior

### Breakpoints

- **Mobile**: 320px - 767px
- **Tablet**: 768px - 1023px
- **Desktop**: 1024px+

### Mode Selection Screen

**Mobile (320px-767px)**:
- Mode cards stack vertically
- Full width with 16px padding on each side
- Card height: 150px
- Font sizes: Title 18px, Description 14px

**Tablet (768px-1023px)**:
- Mode cards in 2-1 layout (two cards in first row, one in second)
- Or: Three cards stacked vertically
- Card width: ~300px
- Card height: 180px

**Desktop (1024px+)**:
- Mode cards in a row, 3 columns
- Card width: ~300px
- Card height: 200px
- Centered with max-width container

### Game Board Screen

**Mobile (320px-767px)**:
- Board: Full width with 16px padding
- Cell size: 80px × 80px (fits in ~300px width)
- Buttons: Full width with 16px padding
- Button height: 44px
- Minimax scores: Displayed in separate panel below board (not overlaid)

**Tablet (768px-1023px)**:
- Board: Centered, 100px cells
- Buttons: Centered, 200px wide
- Minimax scores: Overlaid on board or in separate panel (designer choice)

**Desktop (1024px+)**:
- Board: Centered, 120px cells
- Buttons: Centered, 200px wide
- Minimax scores: Overlaid on board with clear visibility

### Font Scaling

- **Headings**: Scale with viewport (e.g., 32px on desktop, 24px on mobile)
- **Body Text**: 16px on desktop, 14px on mobile
- **Cell Content (X/O)**: 48px on desktop, 36px on mobile
- **Minimax Scores**: 14px on desktop, 12px on mobile

### Image & Icon Scaling

- **Mode Card Icons**: 48px on desktop, 36px on mobile
- **Status Icons**: 24px on desktop, 18px on mobile

---

## Content & Copy

### Tone & Voice

- **Friendly & Encouraging**: "You can win!" (Easy AI), "See how it thinks" (Impossible AI)
- **Clear & Direct**: "Your Turn", "AI is thinking...", "You Won!"
- **No Jargon**: Avoid technical terms like "minimax" in UI copy (use "AI's thinking" or "move scores")

### Key Copy

**Mode Selection**:
- "Player vs. Player": "Play against a friend on the same device"
- "Easy AI": "Play against a random AI. You can win!"
- "Impossible AI": "Play against an unbeatable AI. See how it thinks."

**Game Board**:
- Turn Indicator: "Your Turn" or "Player X's Turn"
- Loading: "AI is thinking..." or "AI is evaluating..."
- Scores: "Study the scores. AI will play the highest score."
- Results: "You Won!", "You Lost!", "It's a Draw!"

**Buttons**:
- "New Game": Start a new game in the same mode
- "Change Mode": Return to mode selection
- "Play Again": Same as "New Game" (on game over screen)
- "Try Another Mode": Same as "Change Mode" (on game over screen)

---

## Edge Cases

### Edge Case 1: User Closes App During Game

**Scenario**: User closes the browser or app while a game is in progress

**Behavior**:
- Game state is saved to localStorage (PWA feature)
- On app reopen, user can resume the game or start a new game
- Option: Display "Resume Game?" dialog on app load

**UX**:
- "Resume Game?" button (primary)
- "New Game" button (secondary)

### Edge Case 2: User Plays Offline

**Scenario**: User plays Easy AI mode without internet connection

**Behavior**:
- Easy AI logic runs client-side (no server needed)
- Game state is stored locally
- No issues expected

**UX**:
- No visual indication needed (game works normally)

### Edge Case 3: User Plays Impossible AI Offline

**Scenario**: User tries to play Impossible AI without internet connection

**Behavior**:
- Option A: Impossible AI is unavailable offline; show message "Impossible AI requires internet connection"
- Option B: Impossible AI logic runs client-side (slower, but possible)

**UX** (Option A):
- Mode selection screen shows Impossible AI as disabled/grayed out
- Tooltip: "Requires internet connection"

**UX** (Option B):
- Game works normally, but may be slower on first move

### Edge Case 4: User Clicks Cell During AI Move

**Scenario**: User clicks a cell while AI is computing

**Behavior**:
- Board is disabled during AI move
- Click is ignored
- No error message needed

**UX**:
- Cells appear disabled (grayed out or cursor changes to "not-allowed")
- "AI is thinking..." message is visible

### Edge Case 5: User Rapidly Clicks Multiple Cells

**Scenario**: User clicks multiple cells in quick succession

**Behavior**:
- Only the first click is registered
- Subsequent clicks are ignored
- Board updates with first move only

**UX**:
- Board updates immediately after first click
- Turn indicator changes
- Subsequent clicks have no effect

### Edge Case 6: User Navigates Away & Returns

**Scenario**: User navigates to another tab/app and returns

**Behavior**:
- Game state is preserved (PWA feature)
- Game resumes from where it left off
- No visual indication needed

**UX**:
- Game board is exactly as it was before
- User can continue playing

### Edge Case 7: Very Small Screens (< 320px)

**Scenario**: User plays on a very small device (e.g., smartwatch)

**Behavior**:
- Not officially supported, but graceful degradation
- Board may require horizontal scrolling
- Game is still playable

**UX**:
- Cells are still 80px × 80px (minimum)
- Board may be slightly smaller or require scrolling
- No error message

### Edge Case 8: Very Large Screens (> 2560px)

**Scenario**: User plays on an ultra-wide monitor

**Behavior**:
- Board scales up proportionally
- No horizontal scrolling
- Plenty of whitespace

**UX**:
- Board is centered with max-width constraint (optional)
- Cells scale up (e.g., 150px × 150px)
- No issues expected

---

## Design Assets

### Required Assets

1. **App Logo/Icon**: 192px × 192px (PWA icon), 512px × 512px (splash screen)
2. **Mode Card Icons**: 48px × 48px (desktop), 36px × 36px (mobile)
   - Player vs. Player: Two silhouettes or game board
   - Easy AI: Player + robot
   - Impossible AI: Player + robot with brain/lightbulb
3. **Status Icons**: 24px × 24px
   - Checkmark (win)
   - X (loss)
   - Equal sign (draw)
4. **Loading Spinner**: Animated, 24px × 24px
5. **Back/Menu Icon**: 24px × 24px

### Color Palette

- **Primary**: Blue (#0066CC)
- **Secondary**: Purple (#6600CC)
- **Success**: Green (#00AA00)
- **Error**: Red (#CC0000)
- **Neutral**: Gray (#666666)
- **Background**: White (#FFFFFF)
- **Border**: Light Gray (#CCCCCC)

### Typography

- **Headings**: Bold, sans-serif (e.g., Roboto, Inter, Helvetica Neue)
- **Body**: Regular, sans-serif
- **Monospace** (optional): For displaying scores or technical info

---

## Acceptance Criteria

### Mode Selection Screen
- [ ] Three mode cards are displayed and clickable
- [ ] Each card has a clear title, description, and icon
- [ ] Clicking a card navigates to the game board screen
- [ ] Cards are responsive (stack on mobile, row on desktop)
- [ ] Keyboard navigation works (Tab, Enter/Space)
- [ ] Screen reader announces card titles and descriptions

### Game Board - Player vs. Player
- [ ] 3×3 grid is displayed and clickable
- [ ] Turn indicator shows whose turn it is
- [ ] Clicking a cell updates the board immediately
- [ ] Turn indicator changes after each move
- [ ] Win condition is detected and displayed
- [ ] Draw condition is detected and displayed
- [ ] Game board becomes non-interactive after terminal state
- [ ] "New Game" button resets the board
- [ ] "Change Mode" button returns to mode selection
- [ ] Responsive design works on mobile, tablet, desktop
- [ ] Keyboard navigation works (Tab, Enter/Space)
- [ ] Screen reader announces cell positions and game state

### Game Board - Easy AI
- [ ] Player can click cells and make moves
- [ ] AI responds with a move within 1 second
- [ ] "AI is thinking..." message is displayed during AI move
- [ ] Board is non-interactive during AI move
- [ ] AI move is clearly visible on the board
- [ ] Win/loss/draw conditions are detected and displayed
- [ ] Game board becomes non-interactive after terminal state
- [ ] "New Game" and "Change Mode" buttons work correctly
- [ ] Responsive design works on mobile, tablet, desktop

### Game Board - Impossible AI
- [ ] Player can click cells and make moves
- [ ] AI evaluates moves and displays minimax scores within 1 second
- [ ] "AI is evaluating..." message is displayed
- [ ] Minimax scores are displayed for each empty cell
- [ ] Scores are color-coded (+1 green, 0 gray, -1 red)
- [ ] Scores are mathematically correct (verified by exhaustive testing)
- [ ] AI selects the move with the highest minimax score
- [ ] AI move is clearly visible on the board
- [ ] Scores disappear after AI moves
- [ ] Game always ends in draw or loss (AI never loses)
- [ ] Game board becomes non-interactive after terminal state
- [ ] "New Game" and "Change Mode" buttons work correctly
- [ ] Responsive design works on mobile, tablet, desktop
- [ ] Minimax scores are announced by screen reader

### Responsive Design
- [ ] No horizontal scrolling at 320px width
- [ ] No horizontal scrolling at 2560px width
- [ ] Touch targets are at least 44px × 44px on mobile
- [ ] Board cells are clickable and responsive on all devices
- [ ] Buttons are full width on mobile, centered on desktop
- [ ] Font sizes scale appropriately with viewport

### Accessibility
- [ ] All interactive elements are keyboard navigable
- [ ] All interactive elements have visible focus rings
- [ ] Screen reader announces all text content
- [ ] Color contrast meets WCAG AA standards (4.5:1 for normal text)
- [ ] Color is not the only indicator (X/O symbols, numbers, text)
- [ ] Touch targets meet minimum size requirements (44px × 44px)

### PWA Features
- [ ] App is installable on home screen
- [ ] App works offline (Easy AI at minimum)
- [ ] Lighthouse PWA audit score is ≥90

---

## Design Decisions & Rationale

### Why Three Distinct Modes?
Each mode has a different interaction model and visual design to reflect its purpose:
- **Player vs. Player**: Straightforward, turn-based, no AI complexity
- **Easy AI**: Simple AI, fast feedback, beatable
- **Impossible AI**: Complex AI, educational, unbeatable

### Why Minimax Scores Before AI Move?
Displaying scores before the AI move allows players to:
- Understand the AI's decision-making process
- Learn optimal strategy by studying the scores
- Verify the AI's move is correct
- Engage with the game at a deeper level

### Why Color-Coded Scores?
Color coding (+1 green, 0 gray, -1 red) provides:
- Quick visual recognition of move quality
- Accessibility for color-blind users (numbers also displayed)
- Intuitive understanding (green = good for AI, red = bad for AI)

### Why Full-Width Buttons on Mobile?
Full-width buttons on mobile:
- Maximize touch target size
- Reduce accidental mis-taps
- Improve usability on small screens
- Follow mobile UX best practices

### Why Separate Panel for Scores on Mobile?
On small screens, overlaying scores on the board:
- Obscures the board
- Reduces clarity
- Makes the game harder to play
- A separate panel below the board is clearer and more accessible

---

## Future Considerations (Out of Scope for V1)

- **Dark Mode**: Toggle between light and dark themes
- **Sound & Music**: Audio feedback for moves and game outcomes
- **Animations**: Smooth cell fill animations, move transitions
- **Game History**: Track wins/losses/draws over time
- **Difficulty Levels**: Multiple AI difficulty levels (Easy, Medium, Hard)
- **Multiplayer Online**: Real-time multiplayer over the internet
- **Teaching Mode**: Explain optimal moves after suboptimal plays
- **Themes & Customization**: Custom board colors, player symbols, etc.
