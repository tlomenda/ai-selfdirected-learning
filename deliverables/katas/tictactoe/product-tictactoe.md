Tic-Tac-Toe game is built as a progressive web application with three play modes: Player vs. Player, Easy AI (random legal move selection), and Impossible AI (minimax algorithm — must never lose). When playing against the Impossible AI, visualize its evaluation of each possible move by displaying the minimax score for each open cell so the player can see why the AI made its choice.

**Game Play:**
A user can play all three modes. In Player vs. Player mode, two players alternate turns on a shared device. In Easy AI mode, the AI plays a random legal move and can be beaten. In Impossible AI mode, the AI cannot be beaten — the best outcome a human player can achieve is a draw.

When playing against the Impossible AI, every open cell displays its minimax score before the AI takes its turn. The user can see the score assigned to each possible move and observe that the AI plays the move with the highest score.

**Play Modes:**
Each mode below has a different interaction model and the UI should reflect these differences, and not treat all three modes as variants of the same interface.

- Player vs. Player
- Easy AI (random legal move selection)
- Impossible AI (minimax algorithm — must never lose)
  - The Impossible AI must never lose — exhaustive play across all possible games confirms no path to a human win exists.
  - The minimax scores displayed must be correct: a cell scored +1 must lead to a forced AI win from that position; a cell scored 0 must lead to a draw with optimal play from both sides; a cell scored -1 must lead to a forced human win and must never be the AI's chosen move.

**Features/Key Requirements:**

- Minimax algorithm with correct terminal state detection (win, loss, draw)
- Alpha-beta pruning for efficiency
- Move evaluation display showing minimax scores on open cells without cluttering the UI
- Correct win, draw, and ongoing game state detection — the game must not continue after a terminal state

**Technical context:** 
- React frontend, Express.js and Node.js backend, PostgreSQL database
- AI logic implemented in backend (integrated with an LLM)

**Out of scope for V1:** 
- Extension to Ultimate Tic-Tac-Toe (nine 3×3 boards forming a meta-game, where each move constrains which board the opponent must play in next)
- 4×4 or 5×5 grid variants requiring 4-in-a-row to win
- Teaching mode showing the optimal response after any suboptimal move with explanation
- Adjustable difficulty with deliberate suboptimal move selection at lower levels