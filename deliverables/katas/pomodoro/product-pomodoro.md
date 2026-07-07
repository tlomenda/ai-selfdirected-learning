A Pomodoro timer is a time management tool that uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks. The Pomodoro timer should be responsive, fast, accurate, and easy to use across all modern browsers.

The application should be responsive, alert users when timers expire, and provide a clean, intuitive user interface. 

Features:
- 25-minute work sessions and 5-minute short breaks; 15-minute long break after every 4 work sessions
- User-configurable session duration, break duration, and sessions-before-long-break count
- Audio chime and browser push notification at each work-to-break and break-to-work transition
- Session tracking per day, persisted across browser restarts
- Weekly productivity heat map showing completed work sessions per day (one cell per calendar day, Monday through Sunday)
- Timer must remain accurate when the browser tab is in background or minimized
- Timer accuracy: drift must not exceed ±2 seconds over a 25-minute session
- Timer state must survive the user switching tabs for up to 30 minutes and still fire the correct alert

Feature Details - Session tracking:
- Define whether 'week' in the heat map means a calendar week (e.g., Monday–Sunday) or a rolling 7-day window.
- Every completed session (work and break) is tracked in persistent client-side storage
- Data retention: store the past 90 days of session history; older data may be pruned
- First-time user sees an empty heat map with a clear empty-state message
- A concrete storage schema with field names and types, including:
    * Unique identifier
    * Timing fields (start/end timestamps)
    * Completion status (boolean or equivalent)
    * Session type discriminator ('work' vs 'break')
- Storage failure scenarios must be handled: incognito mode (no persistent storage),
  localStorage quota exceeded, storage explicitly disabled by the user

Feature Details - Notification Alerts:
- Notifications should include an audio chime when the timer transitions
- Browser push notifications are shown when the tab is not in focus
- The application requests browser notification permission as needed
- Provide example notification copy for both work-break and break-work transitions
- Copy should include title and body text

Technical context:
- Application is browser-based; no server-side component
- Target browsers: Chrome, Firefox, Safari, Edge (latest two major versions); Internet Explorer not supported
- No user accounts or authentication
- All data stored in browser localStorage
- Avoid using the term "browser push notifications". Refer to these as in-app browser notifications (commonly known as web push notifications) sent directly via the web browser

Out of scope for V1:
- Cloud sync or cross-device session history
- User accounts or authentication
- Team or social features
- Native mobile apps
- Server-side components or databases