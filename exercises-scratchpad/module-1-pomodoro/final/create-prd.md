   # Create PRD

   ## Role
   a Product Manager who writes Product Requirements Documents (PRDs) for engineering-led software teams

   ## Task
   Write a developer-ready product requirements document for a Pomodoro timer application with 25-minute work intervals, 5-minute break intervals, session tracking, and a weekly productivity heat map.

   ## Context
   A Pomodoro timer is a time management tool that uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks. 
   Time productivity is tracked through session history and visualized in a weekly heat map where each cell represents a day block.

   Providing a developer-ready PRD requires not only the features but also the non-functional requirements, implementation environment, explicit scope boundaries, 
   and open questions that must be resolved before implementation begins.

   It is assumed that the application will be built as a web application that runs on all modern browsers. 

   The audience for this PRD is a solo developer or small development team who will be building the application.

   ## Constraints

   1. The PRD requires the following sections:
      - Product Overview (Problem Statement & Goals)
      - Features (Personas, Use Cases & User Stories)
      - Non-Functional Requirements with suggested tool or method for verification
      - Key Implementation Details
         * Define timer drift tolerance with a numeric threshold (e.g., ±2 seconds over a 25-minute session)
         * Specify that timing is anchored to wall-clock time (comparing saved timestamps) rather than counting elapsed ticks
         * Address browser throttling of background tabs and specify the required mitigation approach
      - Scope Boundaries
      - Open Questions
      - Change Log

   2. Storage Requirements Section:
      - Specify where data is stored
      - Define whether 'week' in the heat map means a calendar week (e.g., Monday–Sunday) or a rolling 7-day window.
      - Define retention policy (duration or size limit)
      - A concrete storage schema with field names and types, including:
         * Unique identifier
         * Timing fields (start/end timestamps)
         * Completion status (boolean or equivalent)
         * Session type discriminator ('work' vs 'break')
      - Describe what happens when storage fails (incognito mode, quota exceeded, disabled storage)
         * Example: "If localStorage is unavailable, the app will function in memory-only mode with a warning banner."

   3. The PRD should consider browser lifecycle, notification availability, and how the application behaves when minimized or closed
      - Define empty state behavior for first-time users (no data yet)
      - Define error state behavior when storage is unavailable
      - These are distinct scenarios requiring different messaging

   4. The application should be responsive, alert users when timers expire, and provide a clean, intuitive user interface.
      - Provide example notification copy for both work-break and break-work transitions
      - Copy should include title and body text
      - Explicitly state the audio requirement: required, optional with a default on/off state, or explicitly out of scope.
      - Specify the UX trigger for requesting browser notification permission (e.g., after the user starts their first session; never on page load)

   5. Vague language must never appear without a measurable definition (e.g., "responsive," "fast," "accurate," "easy to use")
   6. The PRD should not specify technical solutions beyond what is necessary for key implementation details
   7. It is important to be explicit about the what is in scope and what is out of scope
   8. As part of the PRD, include a list of open questions that must be answered before implementation begins