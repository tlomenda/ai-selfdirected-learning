The initial prompt with questions to capture considerations for understanding the domain and creating a developer-ready Product Requirements Document (PRD).

```
I am starting a new chat about creating a Product Requirements Document  (PRD) for a Pomodoro timer application. 

The key task is ""Write a product requirements document for a Pomodoro timer application with 25-minute work intervals, 5-minute break intervals, session tracking, and a weekly productivity heat map."

I need a clear picture of what a developer ready PRD actually contains. To start, can you guide me by answering these questions below:

1. What sections would a skilled Product Manager always include in a PRD that a developer needs before beginning implementation? Think beyond the feature list: non-functional requirements, success criteria, explicit out-of-scope items, and open questions.

2. What implied technical requirements exist in this product description that are not stated explicitly? The description says "accurate timing" — but setInterval in JavaScript drifts over time. Does a 25-minute timer that ends at 25:03 meet the product requirement? Who decides?

3. What does "weekly productivity heat map" mean specifically enough to implement? Is this client-side only? Does it survive a browser restart? What data gets stored, and where?

4. What does a developer need to know about browser API dependencies that this description implies but does not name? (Hint: audio notifications at break transitions, visual notifications, potential background tab behavior.)

5. What would a developer ask about during sprint planning that the bare product description leaves unanswered?
```

## Understanding the Domain

### 1. What sections a skilled PM always includes

A developer-ready PRD goes well beyond a feature list. The sections that matter most:

**Problem & Goal Statement** — Why does this product exist? What user problem does it solve? This prevents scope creep because every disputed feature gets tested against: *does this serve the goal?*

**User Personas & Use Cases** — Who is the primary user? A developer building for a student with ADHD sessions is making different trade-offs than one building for a deep-work knowledge worker. Personas drive edge-case decisions.

**Functional Requirements** — The explicit feature list, written as testable statements. Not "the timer counts down" but "when the user starts a session, a countdown from 25:00 begins, decrementing each second."

**Non-Functional Requirements (NFRs)** — These are what developers ask about at 11pm:
- *Accuracy*: Timer precision tolerance (±2 seconds? ±0 seconds?)
- *Performance*: CPU/battery usage acceptable ceiling
- *Compatibility*: Which browsers and OS versions are supported?
- *Accessibility*: WCAG 2.1 AA compliance? Keyboard-only navigation?
- *Offline support*: Does the app work without internet?

**Explicit Out-of-Scope** — Arguably the most valuable section. If you don't write it down, developers build it anyway. For this app, likely out of scope: user accounts, cloud sync, team features, mobile apps, calendar integrations.

**Data Model & Storage** — What data is persisted, where, in what format, and for how long?

**Success Criteria / Acceptance Criteria** — How do you know when you're done? Ideally measurable: "A 25-minute session completes within ±3 seconds" or "Heat map renders correctly after browser restart."

**Open Questions** — A living section. Every unanswered question that would block implementation belongs here with an owner and a due date.

**Dependencies & Constraints** — Browser APIs, third-party libraries, platform restrictions.

**Change Log** — Version history of the PRD itself, so developers know if requirements shifted under them.

---

### 2. Implied technical requirements the description doesn't state

This is where the "simple" Pomodoro timer gets interesting fast.

**The `setInterval` drift problem** is real. `setInterval(fn, 1000)` doesn't fire every exactly 1000ms — it fires *at least* 1000ms later. On a loaded browser tab, it can drift 30–100ms per tick, accumulating to several seconds over 25 minutes. More critically, browsers intentionally throttle timers in background tabs (Chrome throttles to ~1Hz, Firefox to ~1Hz, Safari can suspend them entirely).

So the implied technical requirement is actually: **the timer must use wall-clock time, not tick counting.** The correct implementation records `startTime = Date.now()` and computes `elapsed = Date.now() - startTime` on each tick, displaying `duration - elapsed`. The display updates via `setInterval`, but the *source of truth* is the system clock, not the interval count.

**Who decides if 25:03 passes?** This is a genuine product decision, not a technical one:
- **Option A: Strict** — The timer must complete within ±1 second. Requires wall-clock implementation and possibly a Web Worker to survive tab throttling.
- **Option B: Display tolerance** — Visual display can drift, but the transition fires at exactly 25 minutes wall-clock. This is the right answer for most apps.
- **Option C: Behavioral tolerance** — ±5 seconds is acceptable. Simplest implementation, defensible for a productivity tool.

The PRD must pick one. If it doesn't, the developer picks, silently, and the PM finds out during demo.

---

### 3. What "weekly productivity heat map" actually means

This phrase is doing a lot of work for seven words. A developer needs answers to all of these before writing a line of code:

**What does a "cell" represent?** Each day? Each hour of each day (a 7×24 grid)? Each 25-minute slot in a day? The visual grammar of a heat map depends entirely on the unit of measurement.

**What is the color scale encoding?** Number of completed Pomodoros? Total focused minutes? Completion rate (completed vs started)? Is the scale fixed (0–8 sessions = white to red) or dynamic (relative to the user's own max)?

**What constitutes a "week"?** Calendar week (Mon–Sun or Sun–Sat)? Rolling 7 days? Does it show the current week, the previous week, or a scrollable history?

**Storage and persistence** is the biggest hidden question:
- *Client-side only (localStorage)*: Zero infrastructure, data dies when the user clears browser storage or switches devices. Simplest implementation.
- *Client-side (IndexedDB)*: Better for larger data sets, still browser-local.
- *Server-side*: Requires auth, a backend, a database — this is a completely different project scope.

For a v1 PRD, "localStorage with graceful degradation" is the right answer, but it must be *stated* — otherwise a developer might reasonably build a backend API.

**Data schema** must be defined. A minimal schema might be:
```
sessions: [{ id, startTime, endTime, completed: bool, type: 'work'|'break' }]
```
Heat map generation reads this array. If the schema isn't defined in the PRD, two developers will invent two incompatible schemas.

**Retention policy**: Does data accumulate indefinitely? Is there a 90-day cap? localStorage has a ~5MB limit; unbounded session storage will eventually hit it.

---

### 4. Browser API dependencies the description implies but doesn't name

The product description is essentially a list of browser API contracts. Here's what it's actually asking for:

**`setTimeout`/`setInterval` + `Date.now()`** — Core timer. Must use wall-clock anchoring (see above).

**Web Workers** — If the timer must survive background tab throttling, the timer logic must move to a Web Worker, which is not subject to the same throttle policies. This is a meaningful architectural decision that affects how the entire app is structured.

**Web Notifications API** (`Notification`)  — For break transition alerts. Requires explicit user permission via `Notification.requestPermission()`. Users can deny it. The app must have a graceful fallback (in-page visual alert). Permission must be requested at an appropriate moment — asking on first load gets denied; asking just before the first session completes gets granted.

**Web Audio API** (`AudioContext`) — For the break chime. Has an important constraint: browsers require a user gesture (click, keypress) before an `AudioContext` can be created or resumed. An app that tries to play a sound 25 minutes after the last interaction will silently fail in many browsers. The PM needs to decide: is audio required, optional, or out of scope?

**Page Visibility API** (`document.visibilityState`, `visibilitychange` event) — To detect when the user switches tabs. The app should at minimum use this to recompute elapsed time when the tab becomes visible again, correcting for any drift that occurred while throttled.

**`localStorage` / `IndexedDB`** — For session persistence (see above).

**`document.title` mutation** — A common UX pattern is updating the browser tab title with the current countdown ("22:14 — Focus Session") so the user can glance without switching tabs. Simple to implement, high utility, not mentioned in the description.

**Service Worker** (optional, higher complexity) — Required if the app needs to fire notifications while the browser is closed. This is almost certainly v2, but the PRD should explicitly say so, or a developer might try to build it in v1.

---

### 5. What a developer would ask during sprint planning

These are the questions that arrive as Slack messages during the first week if the PRD doesn't answer them:

**Timer behavior**
- If the user pauses mid-session, does that session still count toward the heat map?
- If the user closes the browser mid-session, does the timer resume or reset when they return?
- Is there a "skip" button for breaks? For work sessions? Do skipped sessions count?
- Can the user customize the 25/5 minute durations, or are they fixed?

**Session tracking**
- After 4 Pomodoros, is there an automatic long break (the traditional Pomodoro technique has a 15–20 minute break after 4 sessions)? Or is that out of scope?
- Does the app track incomplete sessions separately from completed ones?
- What happens to the session if the OS goes to sleep?

**Heat map**
- Does the heat map appear on a separate "stats" view, or is it on the main timer screen?
- Is there a "today's count" visible on the main screen, or only in the heat map?
- What does the heat map show on day one, before any data exists?

**Notifications**
- What exactly does the notification say at the end of a work session? At the end of a break?
- Is there sound? Is it configurable? Can it be muted?
- What is the fallback experience when Notification permission is denied?

**Persistence**
- What happens when `localStorage` is full or unavailable (private/incognito mode)?
- Is there any data export? (Users will ask for CSV export in week two.)

---

## The meta-lesson

Every one of these questions represents a decision that *someone will make*. If the PRD makes it, the product is intentional. If the PRD doesn't, the developer makes it at implementation time, the PM discovers it at demo, and you either ship the developer's guess or pay the cost of a rework. A PRD's job is to front-load those decisions to the people with the right context — before a single line of code is written.

When you're ready to write the actual PRD, I can draft the full document with all these sections filled in, with the open questions explicitly flagged where the description is still ambiguous.

## Other general considerations