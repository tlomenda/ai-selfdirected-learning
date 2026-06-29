Conway's Game of Life is a zero-player cellular automaton devised by mathematician John Horton Conway in 1970. 

A simulation, played on a 2D grid, cells are either alive or dead and evolve over time according to four simple mathematical rules based on neighboring cells

Four Rules:
1. Underpopulation: Any live cell with fewer than two live neighbors dies.
2. Survival: Any live cell with two or three live neighbors lives on.
3. Overpopulation: Any live cell with more than three live neighbors dies.
4. Reproduction: Any dead cell with exactly three live neighbors becomes a live cell.


The application should be responsive, alert users when timers expire, and provide a clean, intuitive user interface. 

The simulation follows Conway's rules exactly: a live cell with 2 or 3 neighbors survives; a dead cell with exactly 3 neighbors becomes live; all others die or stay dead. This is verifiable by loading a known pattern (glider) and confirming it moves in the expected direction over the expected number of generations.

The application should be responsive and performance remains acceptable at a 100×100 grid — the simulation does not visibly stutter or lag at normal speeds.

Features:
- The grid boundary behavior is consistent (either wrapping or dying at edges) and does not change during a session.
- A user can open the application and immediately interact with a live simulation. 
- Clicking or dragging on the grid toggles cells on and off. 
- Pressing Play starts the simulation; the grid updates at the configured speed. 
- Pressing Pause freezes it at the current generation. 
- Pressing Step advances exactly one generation. 
- The generation counter and live cell count update in real time.

Game of Life Implementation:
- resizable grid, 
- play/pause/step controls, and adjustable simulation speed. 
- Include a pattern library containing at least the following patterns: glider, blinker, pulsar, and glider gun. Display a generation counter and live cell count. 
- Allow users to draw cells by clicking or dragging on the grid, and support save and load of patterns.

Technical context:
- Application is browser-based; no server-side component
- Target browsers: Chrome, Firefox, Safari, Edge (latest two major versions); Internet Explorer not supported
- Tech stack: React, HTML5, CSS3
- Efficient neighbor counting at scale (a 100×100 grid with 10,000 cells updated every frame)
- Boundary condition handling — grid wraps or cells die at the edge; must be explicitly defined and consistent
- Pattern storage in a format that supports reliable save and load
- Performant rendering — only changed cells re-render on each tick, not the full grid

Out of scope:
- Native mobile apps
- Server-side components or databases