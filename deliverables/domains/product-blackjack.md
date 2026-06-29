Blackjack is a game following standard casino rules (dealer hits on soft 16, stands on soft 17, blackjack pays 3:2). For every player decision point, display the mathematically optimal play based on basic strategy charts. Track and display player decision accuracy — the percentage of decisions that matched optimal strategy — across the session.

**Game Play:**
A user plays blackjack against a dealer following standard casino rules. At each decision point, the application displays the recommended action (hit, stand, double down, or split) based on the mathematically correct basic strategy for the current hand against the dealer's up-card.

After each hand, the accuracy display shows what percentage of the user's decisions matched optimal strategy. A session accuracy tracker accumulates across hands. After splitting, each hand is played independently with its own strategy recommendation.

**Features/Key Requirements:**

* Key Requirements
  - Complete basic strategy lookup table covering all hard hands, soft hands, and pair splits against all dealer up-cards — this is a 2D lookup table encoding a known correct reference, not a derived algorithm
  - Multi-hand split logic supporting up to four simultaneous hands
  - Correct soft hand vs. hard hand distinction for strategy lookups (an Ace can count as 1 or 11, and this determines which strategy row applies)
  - Running decision accuracy statistics accumulated across multiple hands in a session
  
* Game Play:
    - A dealer following standard casino rules: dealer hits on soft 16, stands on soft 17, blackjack pays 3:2, insurance available when dealer shows an ace. 
    - For every player decision point, display the mathematically optimal play (hit, stand, double down, or split) based on basic strategy charts.
    - After each hand, track and display the player's decision accuracy — the percentage of decisions that matched the optimal strategy — across the session.

* Play Strategy:
    - The basic strategy lookup must be correct 
      - this is a strategy lookup table (a 2D table mapping player hand vs. dealer up-card to optimal action — not a function that calculates the optimal play, but a table you implement correctly); 
      - A complete basic strategy chart is publicly verifiable
      - every recommended action for every hand combination against every dealer up-card must match the standard chart.
    - multi-hand split logic
    - soft vs. hard hand distinction
    - The most common failure modes are: 
      - incorrect soft hand handling (a hand with an Ace that can be 1 or 11 maps to a different strategy row than the same total as a hard hand), 
      - incorrect pair splitting recommendations, 
      - and off-by-one errors in hand value calculation when an Ace changes value. 
    - Dealer rules must be strictly implemented: hits on soft 16, stands on soft 17, no deviation.

**Technical context:** 
- browser-based application using HTML, CSS, and JavaScript

**Out of scope for V1:** 
- Card counting simulation using the Hi-Lo system: display the running count and true count (running count divided by decks remaining) as the game progresses
- Configurable house rules: number of decks, whether dealer hits or stands on soft 17, whether surrender is allowed
- Expected value display showing the EV of each possible decision (hit, stand, double, split) in units of the original bet
- Training mode that replays hands where the player deviated from optimal strategy