# DevLog: UX Specification

## Overview

DevLog is a lightweight daily digest system that enables individual contributors to recap and share their work at the end of each business day. The system provides multiple entry points (web form and Slack shortcut) for developers to submit brief daily logs, aggregates submissions nightly, and delivers formatted digests to team Slack channels. Managers access a web dashboard to view rolling 30-day team history with filtering and blocker highlighting capabilities.

This UX specification defines the user interface, interaction flows, and component requirements for all three primary user flows: developer log submission, team digest delivery, and manager dashboard viewing.

---

## Target Users & Personas

### Persona 1: Developer (Individual Contributor)
- **Role**: Software engineer, data scientist, or technical contributor
- **Primary Goals**: 
  - Submit daily work recap in ≤2 minutes
  - Control personal privacy settings (opt-out, display name)
  - Access logs from anywhere (desktop, mobile)
- **Constraints**: Limited time availability; prefers minimal friction
- **Technical Proficiency**: Moderate to high

### Persona 2: Manager (Team Lead/Engineering Manager)
- **Role**: Engineering manager or team lead
- **Primary Goals**: 
  - Gain visibility into team progress and blockers
  - Identify trends over time
  - Access historical data for team planning and 1:1s
- **Constraints**: Needs fast access to information; cannot edit developer logs
- **Technical Proficiency**: Moderate

### Persona 3: System Administrator
- **Role**: DevOps or infrastructure team member
- **Status**: Out of scope for V1
- **Note**: Deployment, configuration, and monitoring handled separately

---

## User Goals

### Developer Goals
1. Submit daily work log in under 2 minutes without leaving Slack (if possible)
2. Maintain privacy by controlling visibility of their entries
3. Quickly access and modify personal preferences (display name, opt-out status)
4. Receive confirmation that their submission was successful

### Manager Goals
1. View team's daily work and progress at a glance
2. Identify blockers and recurring issues quickly
3. Track individual contributor productivity over time (30-day rolling window)
4. Filter and search logs by developer or date range
5. Access dashboard in under 2 seconds

### System Goals
1. Aggregate and post team digests reliably on business days only
2. Respect developer privacy preferences in all outputs
3. Maintain data persistence with zero loss after successful submission
4. Support up to 100 concurrent developers without performance degradation

---

## User Flows

### Flow 1: Developer Submits Daily Log via Web Form

```
Developer → Navigates to web form URL
         → Sees pre-filled form with 4 fields
         → Fills in optional fields (all optional)
         → Clicks "Submit"
         → Sees success confirmation (≤3 seconds)
         → Optionally clicks "Manage Preferences" link
         → Flow ends
```

**Key Decision Points:**
- All fields are optional; user can submit empty form
- Form submission is idempotent (no duplicate entries on re-submission)
- Success confirmation visible in-page without page reload

### Flow 2: Developer Submits Daily Log via Slack Shortcut

```
Developer → Opens Slack workspace
         → Clicks "Log Daily Work" shortcut
         → Modal opens with 4-field form
         → Fills in optional fields
         → Clicks "Submit" in modal
         → Sees success confirmation in Slack (≤3 seconds)
         → Modal closes
         → Flow ends
```

**Key Decision Points:**
- Modal form has same 4 fields as web form
- Confirmation message appears in Slack, not in modal
- Shortcut only available to authenticated workspace members

### Flow 3: Developer Configures Preferences

```
Developer → Accesses preferences page (via link after submission or direct URL)
         → Sees current display name (default: Slack display name)
         → Sees toggle for "Include in team digest" (default: on)
         → Modifies display name (optional)
         → Toggles digest inclusion (optional)
         → Changes save immediately (no save button needed)
         → Sees success feedback
         → Flow ends
```

**Key Decision Points:**
- Preferences persist across sessions
- Changes save immediately without explicit save action
- Default display name is Slack display name

### Flow 4: Team Receives Daily Digest (Automated)

```
System → Runs nightly job at configured time (default: 5 PM UTC)
      → Queries all logs submitted that day
      → Filters out opted-out developers
      → Aggregates entries by developer
      → Formats digest with headers, bullets, timestamps
      → Posts to configured Slack channel
      → Logs execution; alerts on failure
      → Flow ends
```

**Key Decision Points:**
- Job runs only on business days (Mon–Fri, excluding holidays)
- Digest is readable in Slack without external links
- Digest includes link to manager dashboard
- Digest includes count of entries and timestamp

### Flow 5: Manager Views Team Dashboard

```
Manager → Navigates to dashboard URL
       → Authenticates via Entra ID/OIDC
       → Sees 30-day rolling history of team logs
       → Logs displayed in reverse chronological order
       → Blocker entries highlighted
       → Manager optionally filters by developer or date range
       → Manager views entry counts per developer
       → Manager cannot edit any logs
       → Flow ends
```

**Key Decision Points:**
- Dashboard loads in ≤2 seconds
- Only shows logs from developers on manager's team
- Respects developer opt-out preferences
- Blocker highlighting is automatic (case-insensitive)
- No AI summarization or sentiment analysis in V1

---

## Information Architecture

### Web Form Page Structure
```
Header
├── Logo / App Name
├── User Profile (display name, settings link)
└── Logout

Main Content
├── Page Title: "Daily Work Log"
├── Form Container
│   ├── Field 1: "What I worked on today" (textarea)
│   ├── Field 2: "What I completed" (textarea)
│   ├── Field 3: "Blockers" (textarea)
│   ├── Field 4: "What I plan tomorrow" (textarea)
│   ├── Submit Button
│   └── "Manage Preferences" Link
└── Footer (optional: help text, support link)
```

### Preferences Page Structure
```
Header
├── Logo / App Name
├── Back to Form Link
└── Logout

Main Content
├── Page Title: "Preferences"
├── Preferences Container
│   ├── Display Name Setting
│   │   ├── Label: "Display Name"
│   │   ├── Input Field (text)
│   │   └── Help Text: "How your name appears in team digest"
│   ├── Digest Inclusion Toggle
│   │   ├── Label: "Include in team digest"
│   │   ├── Toggle Switch (on/off)
│   │   └── Help Text: "When off, your logs won't appear in team digest"
│   └── Saved Confirmation (appears after change)
└── Footer
```

### Manager Dashboard Structure
```
Header
├── Logo / App Name
├── User Profile (manager name)
├── Date Range Selector (optional)
└── Logout

Sidebar (optional, collapsible on mobile)
├── Team Name
├── Filter by Developer (dropdown/search)
└── Filter by Date Range (date picker)

Main Content
├── Summary Stats
│   ├── Total Entries (30-day)
│   ├── Entries per Developer (count)
│   └── Blockers Count (highlighted)
├── Entries List
│   ├── Entry Card (repeating)
│   │   ├── Developer Name
│   │   ├── Date
│   │   ├── "What I worked on today"
│   │   ├── "What I completed"
│   │   ├── "Blockers" (highlighted if present)
│   │   └── "What I plan tomorrow"
│   └── Pagination / Load More
└── Footer
```

### Slack Digest Format
```
:calendar: **Daily Work Digest** — [Date]
Posted at [Time]

**[Developer Name 1]**
• Worked on: [text]
• Completed: [text]
• Blockers: [text] ⚠️ (if present)
• Tomorrow: [text]

**[Developer Name 2]**
• Worked on: [text]
• Completed: [text]
• Blockers: [text] ⚠️ (if present)
• Tomorrow: [text]

---
**Total entries:** [count]
[Link to manager dashboard]
```

---

## Screen Specifications

### Screen 1: Daily Log Web Form

**Layout**: Single-column, centered container (max-width: 600px)

**Components:**
- **Page Title** (H1): "Daily Work Log"
- **Subtitle** (optional): "Takes about 2 minutes"
- **Form Fields** (4 textareas, stacked vertically):
  1. Label: "What I worked on today"
     - Placeholder: "e.g., Implemented user authentication, reviewed PRs"
     - Min-height: 80px
     - Optional field
  2. Label: "What I completed"
     - Placeholder: "e.g., Merged 3 PRs, deployed to staging"
     - Min-height: 80px
     - Optional field
  3. Label: "Blockers"
     - Placeholder: "e.g., Waiting for API docs, need design review"
     - Min-height: 80px
     - Optional field
  4. Label: "What I plan tomorrow"
     - Placeholder: "e.g., Start database migration, attend sprint planning"
     - Min-height: 80px
     - Optional field

- **Submit Button**
  - Label: "Submit Log"
  - Style: Primary (filled, high contrast)
  - Disabled state: During submission
  - Size: Full width on mobile, auto on desktop

- **Secondary Link**
  - Label: "Manage Preferences"
  - Placement: Below submit button
  - Style: Text link, secondary color

- **Character Counters** (optional, helpful for users)
  - Display current/max characters per field
  - Warn at 80% capacity

**Mobile Considerations:**
- Single column layout
- Full-width form inputs
- Touch-friendly button size (min 44px height)
- No horizontal scrolling
- Viewport: 320px–2560px

---

### Screen 2: Success Confirmation (Web Form)

**Trigger**: After successful form submission

**Components:**
- **Success Icon**: Checkmark or success indicator
- **Success Message**: "Your daily log has been submitted!"
- **Secondary Message**: "Your team will see this in today's digest."
- **Action Buttons**:
  - "Submit Another Log" (resets form)
  - "Manage Preferences" (navigates to preferences page)
  - "Close" (clears confirmation, returns to blank form)

**Timing**: Appears within 3 seconds of submit click

**Dismissal**: Auto-dismisses after 5 seconds or on user action

---

### Screen 3: Slack Modal (Daily Log Submission)

**Trigger**: Developer clicks "Log Daily Work" shortcut in Slack

**Components:**
- **Modal Title**: "Daily Work Log"
- **Form Fields** (4 textareas, same as web form):
  1. "What I worked on today"
  2. "What I completed"
  3. "Blockers"
  4. "What I plan tomorrow"

- **Action Buttons**:
  - "Submit" (primary, full width)
  - "Cancel" (secondary)

**Modal Size**: Standard Slack modal (responsive)

**Confirmation**: After submission, modal closes and confirmation message appears in Slack thread or as ephemeral message

---

### Screen 4: Preferences Page

**Layout**: Single-column, centered container (max-width: 600px)

**Components:**
- **Page Title** (H1): "Preferences"
- **Back Link**: "← Back to Form"

- **Setting 1: Display Name**
  - Label: "Display Name"
  - Input Type: Text field
  - Default Value: User's Slack display name
  - Help Text: "How your name appears in team digest"
  - Max Length: 100 characters
  - Save Behavior: Saves immediately on blur or after 1 second of inactivity

- **Setting 2: Digest Inclusion**
  - Label: "Include in team digest"
  - Input Type: Toggle switch
  - Default Value: On (enabled)
  - Help Text: "When off, your logs won't appear in team digest"
  - Save Behavior: Saves immediately on toggle

- **Feedback Message**
  - Text: "Preferences saved" (appears briefly after change)
  - Style: Success color, subtle animation
  - Duration: 3 seconds

**Mobile Considerations:**
- Full-width inputs
- Large touch targets for toggle (min 44px)
- Vertical stacking

---

### Screen 5: Manager Dashboard

**Layout**: Multi-column with optional sidebar

**Header Section:**
- **Page Title**: "Team Daily Logs"
- **Date Range Display**: "Last 30 days" or custom range
- **Refresh Button**: Manual refresh option

**Filter Section** (collapsible on mobile):
- **Filter by Developer**: Dropdown or searchable list
- **Filter by Date Range**: Date picker (from/to)
- **Apply Filters Button** (mobile only)
- **Clear Filters Link**

**Summary Stats** (optional, above entries):
- **Total Entries**: Count of all entries in period
- **Entries per Developer**: Table or list showing count per person
- **Blockers Identified**: Count of entries containing "blocker" or "blocked"

**Entries List:**
- **Entry Card** (repeating for each log entry):
  - **Developer Name** (bold, primary color)
  - **Date** (secondary text, smaller font)
  - **Worked On**: "What I worked on today" text
  - **Completed**: "What I completed" text
  - **Blockers**: "Blockers" text (highlighted with warning color/icon if present)
  - **Tomorrow**: "What I plan tomorrow" text
  - **Divider**: Between entries

- **Sorting**: Reverse chronological (newest first)
- **Pagination**: Load more button or infinite scroll
- **Empty State**: "No logs found for selected filters" message

**Mobile Considerations:**
- Sidebar collapses to hamburger menu
- Single-column entry cards
- Filters accessible via modal or slide-out panel
- Touch-friendly filter controls

**Performance:**
- Initial load: ≤2 seconds
- Lazy load entries as user scrolls
- Responsive to filter changes within 500ms

---

## Interaction Design

### Form Submission Flow

**User Action**: Click "Submit Log" button

**System Response**:
1. Validate form (all fields optional, so validation minimal)
2. Disable submit button, show loading state
3. Send form data to backend API
4. **Expected time**: ≤3 seconds total

**Success Path**:
- Success confirmation appears (in-page)
- Form clears (or user can choose to submit another)
- User can navigate to preferences or close confirmation

**Error Path**:
- Error message appears below form
- Submit button re-enables
- User can retry

**Idempotency**:
- If user submits identical data twice, system recognizes duplicate and doesn't create second entry
- User still sees success confirmation both times

---

### Preferences Update Flow

**User Action**: Modify display name or toggle digest inclusion

**System Response**:
1. Validate input (display name: max 100 chars, no special chars)
2. Send update to backend API
3. Save immediately (no explicit save button)
4. Show success feedback ("Preferences saved")

**Expected time**: ≤500ms

**Error Path**:
- Error message appears below the field
- User can retry

---

### Dashboard Filter Flow

**User Action**: Select developer from dropdown or adjust date range

**System Response**:
1. Update URL query parameters (for bookmarking)
2. Fetch filtered data from backend
3. Re-render entries list
4. Highlight any blockers in new results

**Expected time**: ≤500ms

**Empty State**:
- If no results, display "No logs found for selected filters"
- Show option to clear filters

---

### Blocker Highlighting

**Trigger**: Dashboard displays entries

**Logic**:
- Search entry text for "blocker" or "blocked" (case-insensitive)
- If found, apply visual highlighting to that entry's "Blockers" section

**Visual Treatment**:
- Background color: Warning/alert color (e.g., light yellow or light red)
- Icon: Warning icon (⚠️) next to text
- Font weight: Bold or slightly emphasized

---

## Component Specifications

### Input Components

#### Textarea Field
- **Purpose**: Multi-line text input for log entries
- **Attributes**:
  - Min-height: 80px
  - Max-height: 200px (with scroll)
  - Placeholder text (descriptive)
  - Optional field indicator (optional, subtle)
  - Character counter (optional)
- **States**:
  - Default (empty)
  - Focused (border highlight, subtle shadow)
  - Filled (with content)
  - Disabled (during submission)
  - Error (red border, error message below)
- **Accessibility**: Label associated via `<label>` element, ARIA attributes

#### Text Input Field (Display Name)
- **Purpose**: Single-line text input for preferences
- **Attributes**:
  - Max length: 100 characters
  - Placeholder: "e.g., John Smith"
  - Character counter
- **States**:
  - Default
  - Focused
  - Filled
  - Error
- **Accessibility**: Label associated, ARIA attributes

#### Toggle Switch (Digest Inclusion)
- **Purpose**: Binary on/off control for digest visibility
- **Attributes**:
  - Default: On (enabled)
  - Labels: "On" / "Off" or "Included" / "Excluded"
  - Accessible: ARIA role="switch", aria-checked
- **States**:
  - On (filled, primary color)
  - Off (unfilled, secondary color)
  - Disabled (grayed out)
- **Interaction**: Click or tap to toggle; saves immediately

#### Dropdown / Select (Filter by Developer)
- **Purpose**: Select developer to filter dashboard
- **Attributes**:
  - Options: List of team members
  - Searchable: Yes (type to filter)
  - Multi-select: No (single selection)
  - Default: "All developers"
- **States**:
  - Closed
  - Open
  - Selected
  - Disabled
- **Accessibility**: ARIA attributes, keyboard navigation

#### Date Picker (Filter by Date Range)
- **Purpose**: Select date range for dashboard filtering
- **Attributes**:
  - Two inputs: "From" and "To"
  - Default range: Last 30 days
  - Format: YYYY-MM-DD or locale-specific
  - Calendar widget (optional, for easier selection)
- **States**:
  - Default
  - Focused
  - Selected
  - Error (invalid date)
- **Accessibility**: ARIA labels, keyboard navigation

---

### Button Components

#### Primary Button (Submit)
- **Purpose**: Submit form or apply filters
- **Label**: "Submit Log" or "Apply Filters"
- **Style**: Filled, high-contrast color (primary brand color)
- **Size**: 
  - Mobile: Full width, 44px min height
  - Desktop: Auto width, 40px height
- **States**:
  - Default (clickable)
  - Hover (darker shade or shadow)
  - Active (pressed appearance)
  - Disabled (grayed out, no cursor)
  - Loading (spinner or progress indicator)
- **Accessibility**: Sufficient color contrast, keyboard accessible

#### Secondary Button (Cancel)
- **Purpose**: Close modal or cancel action
- **Label**: "Cancel" or "Close"
- **Style**: Outline or text-only
- **Size**: Same as primary button
- **States**: Same as primary button
- **Accessibility**: Keyboard accessible

#### Text Link (Secondary Action)
- **Purpose**: Navigate to preferences or other pages
- **Label**: "Manage Preferences" or "Back to Form"
- **Style**: Text link, secondary color, underline on hover
- **Accessibility**: Sufficient color contrast, underlined or otherwise distinguished from body text

---

### Feedback Components

#### Success Confirmation
- **Purpose**: Confirm successful form submission
- **Content**:
  - Icon: Checkmark or success indicator
  - Message: "Your daily log has been submitted!"
  - Secondary message: "Your team will see this in today's digest."
- **Duration**: Auto-dismiss after 5 seconds or on user action
- **Position**: Top of form or modal
- **Style**: Success color (green), subtle animation (fade-in, fade-out)
- **Accessibility**: ARIA live region for screen readers

#### Error Message
- **Purpose**: Communicate form submission or validation errors
- **Content**:
  - Icon: Error indicator
  - Message: Specific error description
  - Suggestion: How to fix (if applicable)
- **Position**: Below affected field or at top of form
- **Style**: Error color (red), persistent until resolved
- **Accessibility**: ARIA live region, associated with input field

#### Loading State
- **Purpose**: Indicate form submission in progress
- **Visual**: Spinner or progress bar
- **Position**: On submit button or above form
- **Duration**: Until response received
- **Accessibility**: ARIA busy state, screen reader announcement

#### Empty State (Dashboard)
- **Purpose**: Communicate when no logs match filters
- **Content**:
  - Icon: Empty state illustration
  - Message: "No logs found for selected filters"
  - Action: "Clear filters" link
- **Position**: Center of content area
- **Style**: Secondary color, subtle
- **Accessibility**: Descriptive text, not just icon

---

### Card Components

#### Entry Card (Dashboard)
- **Purpose**: Display a single daily log entry
- **Content**:
  - Developer name (bold, primary color)
  - Date (secondary text, smaller)
  - Four fields: Worked on, Completed, Blockers, Tomorrow
  - Each field labeled and separated
- **Layout**: Vertical stack
- **Styling**:
  - Border or shadow for separation
  - Padding: 16px
  - Margin-bottom: 12px
  - Background: White or subtle gray
- **Blocker Highlighting**: If "Blockers" field contains text, highlight with warning color and icon
- **Interaction**: Click to expand (optional, for mobile)
- **Accessibility**: Semantic HTML, proper heading hierarchy

---

## States & Feedback

### Form States

| State | Appearance | Behavior |
|-------|-----------|----------|
| **Empty** | Blank form, submit button enabled | User can type or submit empty |
| **Focused** | Input field highlighted, cursor visible | User typing |
| **Filled** | Input field with content | User can submit |
| **Submitting** | Submit button disabled, spinner visible | System processing |
| **Success** | Confirmation message appears | User can submit another or navigate |
| **Error** | Error message below form, submit button re-enabled | User can retry or correct |

### Dashboard States

| State | Appearance | Behavior |
|-------|-----------|----------|
| **Loading** | Skeleton loaders or spinner | System fetching data |
| **Loaded** | Entry cards displayed | User can filter or scroll |
| **Filtered** | Entries updated per filter | User can adjust filters |
| **Empty** | Empty state message | User can clear filters |
| **Error** | Error message, retry button | User can retry |

### Preference States

| State | Appearance | Behavior |
|-------|-----------|----------|
| **Loaded** | Current preferences displayed | User can modify |
| **Saving** | Field disabled, spinner | System processing |
| **Saved** | Success message appears | User can continue |
| **Error** | Error message, field re-enabled | User can retry |

---

## Accessibility

### WCAG 2.1 Compliance (Target: AA)

#### Color Contrast
- All text must have contrast ratio ≥4.5:1 (normal text) or ≥3:1 (large text)
- Error messages, success messages, and warnings must be distinguishable by color + icon/text, not color alone

#### Keyboard Navigation
- All interactive elements (buttons, links, form fields) must be keyboard accessible
- Tab order follows logical flow (top-to-bottom, left-to-right)
- Focus indicator visible on all focusable elements
- Escape key closes modals

#### Screen Reader Support
- All form fields have associated labels (`<label>` elements)
- Buttons have descriptive labels
- Error messages associated with fields via `aria-describedby`
- Success/error confirmations use `aria-live="polite"` for announcement
- Headings use proper hierarchy (H1, H2, H3)
- Images have alt text (if any)

#### Form Accessibility
- Required fields marked with asterisk (*) and `aria-required="true"`
- Error messages appear near fields and in live region
- Form submission confirmation announced to screen readers

#### Dashboard Accessibility
- Table structure for entry lists (or semantic list markup)
- Column headers clearly labeled
- Filter controls have labels and ARIA attributes
- Blocker highlighting uses color + icon, not color alone

#### Mobile Accessibility
- Touch targets minimum 44x44 pixels
- Sufficient spacing between interactive elements
- Readable text size (minimum 16px)
- Zoom support (no fixed viewport width)

---

## Responsive Behavior

### Breakpoints

| Breakpoint | Width | Device | Layout |
|-----------|-------|--------|--------|
| **Mobile** | 320px–599px | Phone | Single column, full-width inputs, stacked buttons |
| **Tablet** | 600px–1023px | Tablet | Single or two-column, adjusted spacing |
| **Desktop** | 1024px+ | Desktop | Multi-column, sidebar (optional), wider containers |

### Form Responsiveness
- **Mobile (320px–599px)**:
  - Single column layout
  - Full-width form inputs and buttons
  - Stacked fields vertically
  - Textarea height: 80px (no scrolling)
  - Button height: 44px (touch-friendly)
  - No horizontal scrolling

- **Tablet (600px–1023px)**:
  - Single column, wider container (max-width: 600px)
  - Slightly larger font sizes
  - Same button and input sizes

- **Desktop (1024px+)**:
  - Centered container (max-width: 600px)
  - Larger font sizes (optional)
  - Same responsive behavior

### Dashboard Responsiveness
- **Mobile (320px–599px)**:
  - Sidebar collapses to hamburger menu
  - Filters in modal or slide-out panel
  - Entry cards full width
  - Single-column layout
  - Summary stats stacked vertically
  - No horizontal scrolling

- **Tablet (600px–1023px)**:
  - Sidebar visible but narrower
  - Entry cards full width or two-column
  - Filters visible above entries

- **Desktop (1024px+)**:
  - Sidebar visible (200px–250px width)
  - Entry cards in main content area
  - Filters in sidebar
  - Multi-column layout for stats (optional)

### Image & Media Responsiveness
- All images scale proportionally
- No fixed widths; use max-width: 100%
- SVG icons scale with text size

---

## Content & Copy

### Tone & Voice
- **Friendly, conversational**: Avoid jargon; use simple language
- **Encouraging**: Emphasize the value of logging work
- **Clear and concise**: Short sentences, active voice
- **Respectful of time**: Acknowledge that users are busy

### Key Messages

#### Form Page
- **Headline**: "Daily Work Log"
- **Subheading** (optional): "Takes about 2 minutes"
- **Field Labels**:
  - "What I worked on today"
  - "What I completed"
  - "Blockers"
  - "What I plan tomorrow"
- **Placeholders**:
  - "e.g., Implemented user authentication, reviewed PRs"
  - "e.g., Merged 3 PRs, deployed to staging"
  - "e.g., Waiting for API docs, need design review"
  - "e.g., Start database migration, attend sprint planning"
- **Button Label**: "Submit Log"
- **Secondary Link**: "Manage Preferences"

#### Success Confirmation
- **Primary Message**: "Your daily log has been submitted!"
- **Secondary Message**: "Your team will see this in today's digest."
- **Action Buttons**: "Submit Another Log", "Manage Preferences", "Close"

#### Preferences Page
- **Headline**: "Preferences"
- **Setting 1 Label**: "Display Name"
- **Setting 1 Help Text**: "How your name appears in team digest"
- **Setting 2 Label**: "Include in team digest"
- **Setting 2 Help Text**: "When off, your logs won't appear in team digest"
- **Feedback**: "Preferences saved"

#### Dashboard Page
- **Headline**: "Team Daily Logs"
- **Date Range**: "Last 30 days"
- **Filter Labels**: "Filter by Developer", "Filter by Date Range"
- **Empty State**: "No logs found for selected filters"
- **Action**: "Clear filters"

#### Slack Digest
- **Header**: ":calendar: **Daily Work Digest** — [Date]"
- **Posted At**: "Posted at [Time]"
- **Developer Section**: "**[Developer Name]**"
- **Field Bullets**:
  - "Worked on:"
  - "Completed:"
  - "Blockers:" (with ⚠️ icon if present)
  - "Tomorrow:"
- **Footer**: "**Total entries:** [count]"
- **Link**: "[View full history in dashboard](#)"

#### Error Messages
- **Generic Error**: "Something went wrong. Please try again."
- **Network Error**: "Unable to connect. Please check your connection and try again."
- **Validation Error**: "Please check your input and try again."
- **Submission Error**: "Your log could not be submitted. Please try again."

#### Loading States
- **Form Submission**: "Submitting your log..."
- **Dashboard Loading**: "Loading team logs..."
- **Filter Updating**: "Updating results..."

---

## Edge Cases

### Form Submission Edge Cases

1. **Empty Form Submission**
   - User submits form with all fields blank
   - **Behavior**: Accept submission (all fields optional)
   - **Feedback**: Show success confirmation
   - **Backend**: Create entry with null/empty values

2. **Duplicate Submission**
   - User submits identical form twice within short time
   - **Behavior**: Recognize as duplicate, don't create second entry
   - **Feedback**: Show success confirmation both times (user doesn't know it's duplicate)
   - **Backend**: Use idempotency key or timestamp-based deduplication

3. **Very Long Text**
   - User pastes large block of text (>5000 characters)
   - **Behavior**: Accept submission (no hard limit specified)
   - **Feedback**: Show success confirmation
   - **Display**: Truncate in Slack digest if needed (show "..." and link to dashboard)

4. **Special Characters**
   - User includes emoji, markdown, or special characters
   - **Behavior**: Accept and preserve in database
   - **Display**: Render safely in Slack (escape markdown if needed)
   - **Dashboard**: Display as-is

5. **Network Timeout**
   - Form submission takes >3 seconds or fails
   - **Behavior**: Show error message, allow retry
   - **Feedback**: "Unable to submit. Please try again."
   - **State**: Submit button re-enabled, form data preserved

6. **Session Expiration**
   - User's authentication token expires during form filling
   - **Behavior**: Redirect to login on submission
   - **Feedback**: "Your session has expired. Please log in again."
   - **Data**: Preserve form data in localStorage if possible

### Dashboard Edge Cases

1. **No Logs for Period**
   - Manager views dashboard but no logs exist for selected filters
   - **Behavior**: Show empty state
   - **Feedback**: "No logs found for selected filters"
   - **Action**: Offer to clear filters

2. **Developer Opted Out**
   - Manager filters by developer who has opted out
   - **Behavior**: Show empty state or "No logs available"
   - **Feedback**: No indication that developer exists but opted out (privacy)

3. **Very Long Entry Text**
   - Entry contains very long text (>1000 characters)
   - **Behavior**: Display full text in dashboard, truncate in Slack digest
   - **Display**: Add scroll or expand/collapse (optional)

4. **Blocker Detection Edge Cases**
   - Entry contains "blocker" in URL or code snippet
   - **Behavior**: Still highlight (false positive acceptable)
   - **Rationale**: Better to over-highlight than miss real blockers

5. **Timezone Differences**
   - Manager in different timezone views dashboard
   - **Behavior**: Display dates in manager's local timezone
   - **Feedback**: Show timezone indicator (optional)

6. **Large Team (100+ developers)**
   - Dashboard loads logs for very large team
   - **Behavior**: Implement pagination or infinite scroll
   - **Performance**: Lazy load entries as user scrolls
   - **Feedback**: Show loading indicator while fetching

### Preferences Edge Cases

1. **Display Name Conflicts**
   - Two developers set same display name
   - **Behavior**: Allow (no uniqueness constraint)
   - **Display**: Both appear with same name in digest (acceptable)

2. **Display Name with Special Characters**
   - User sets display name with emoji or special chars
   - **Behavior**: Accept and preserve
   - **Display**: Render safely in Slack and dashboard

3. **Opt-Out Then Back In**
   - Developer opts out, then opts back in
   - **Behavior**: Future logs included, past logs remain hidden
   - **Feedback**: No indication of past opt-out

---

## Design Assets

### Color Palette
- **Primary**: Brand color (e.g., blue #0066CC)
- **Secondary**: Complementary color (e.g., gray #666666)
- **Success**: Green (#28A745)
- **Error**: Red (#DC3545)
- **Warning**: Yellow/Orange (#FFC107)
- **Background**: White (#FFFFFF) or light gray (#F5F5F5)
- **Text**: Dark gray (#333333) or black (#000000)

### Typography
- **Font Family**: System font stack (e.g., -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto)
- **Heading (H1)**: 28px, bold, line-height 1.2
- **Heading (H2)**: 20px, bold, line-height 1.3
- **Body Text**: 16px, regular, line-height 1.5
- **Small Text**: 14px, regular, line-height 1.4
- **Label**: 14px, bold, line-height 1.4

### Spacing
- **Padding**: 8px, 12px, 16px, 20px, 24px (multiples of 4)
- **Margin**: Same as padding
- **Gap between form fields**: 16px
- **Gap between entries**: 12px

### Icons
- **Checkmark** (success): ✓ or SVG icon
- **Error**: ✕ or SVG icon
- **Warning**: ⚠️ or SVG icon
- **Spinner** (loading): Animated SVG or CSS spinner
- **Hamburger Menu** (mobile): Three horizontal lines

### Shadows & Borders
- **Border Radius**: 4px (subtle) or 8px (cards)
- **Box Shadow**: Subtle shadow for cards (e.g., 0 2px 4px rgba(0,0,0,0.1))
- **Focus Outline**: 2px solid primary color

---

## Acceptance Criteria

### Form Submission (User Story 1.1)
- [ ] Form accessible via web URL with Entra ID/OIDC authentication
- [ ] Form contains exactly 4 fields: "What I worked on today," "What I completed," "Blockers," "What I plan tomorrow"
- [ ] All fields are optional; empty form can be submitted
- [ ] Form submission completes in ≤3 seconds (p95 latency)
- [ ] Success confirmation message appears after submission
- [ ] Form is mobile-responsive, no horizontal scrolling (320px–2560px)
- [ ] Form submission is idempotent; duplicate submissions don't create duplicate entries
- [ ] Form clears after successful submission or user can submit another
- [ ] "Manage Preferences" link accessible from form

### Slack Shortcut Submission (User Story 1.2)
- [ ] "Log Daily Work" shortcut available in Slack workspace
- [ ] Shortcut opens modal with same 4 fields as web form
- [ ] Form submission from modal completes in ≤3 seconds
- [ ] Success confirmation appears in Slack (not in modal)
- [ ] Shortcut only available to authenticated workspace members
- [ ] Modal closes after successful submission

### Preferences Configuration (User Story 1.3)
- [ ] Preferences page accessible via link after form submission or direct URL
- [ ] Developer can set custom display name (default: Slack display name)
- [ ] Developer can toggle "Include in team digest" (default: on)
- [ ] Preferences save immediately upon change (no explicit save button)
- [ ] Preferences persist across sessions
- [ ] Success feedback appears after change

### Team Digest (User Story 2.1)
- [ ] Nightly job runs at configurable time (default: 5 PM UTC)
- [ ] Job runs only on business days (Mon–Fri, excluding holidays)
- [ ] Job aggregates all logs submitted that day from non-opted-out developers
- [ ] Summary posted to configurable Slack channel
- [ ] Summary readable in Slack without external links
- [ ] Summary includes date, developer names, entries, and count
- [ ] Summary respects developer opt-out preferences
- [ ] Job execution logged; failures trigger alerts
- [ ] Summary includes link to manager dashboard

### Digest Format (User Story 2.2)
- [ ] Digest uses consistent formatting (headers, bullets, line breaks)
- [ ] Each developer's entry clearly labeled with name
- [ ] Entries grouped by developer, not by field type
- [ ] Digest includes timestamp (date and time)
- [ ] Digest includes link to manager dashboard

### Manager Dashboard (User Story 3.1)
- [ ] Dashboard accessible via authenticated login (Entra ID/OIDC)
- [ ] Dashboard displays logs for past 30 days (rolling window)
- [ ] Dashboard shows only logs from manager's team
- [ ] Dashboard respects developer opt-out preferences
- [ ] Entries displayed in reverse chronological order (newest first)
- [ ] Dashboard is responsive, no horizontal scrolling (320px–2560px)
- [ ] Dashboard loads in ≤2 seconds (FCP/LCP measured)
- [ ] Manager can filter by developer name
- [ ] Manager can filter by date range
- [ ] Manager cannot edit logs created by developers

### Blocker Identification (User Story 3.2)
- [ ] Dashboard highlights entries containing "blocker" or "blocked" (case-insensitive)
- [ ] Dashboard provides count of entries per developer (30-day period)
- [ ] No AI-powered summarization or sentiment analysis in V1

---

## Implementation Notes for Developers

### Frontend (React)
- Use controlled components for form fields
- Implement form validation on blur and submit
- Use React hooks (useState, useEffect) for state management
- Implement loading states with spinners or skeleton loaders
- Use responsive CSS (media queries or CSS Grid/Flexbox)
- Implement keyboard navigation and focus management
- Use semantic HTML for accessibility

### Backend (FastAPI)
- Implement idempotency for form submissions (use idempotency key or timestamp)
- Validate all inputs (max length, required fields, etc.)
- Implement rate limiting to prevent abuse
- Log all form submissions and API calls
- Implement error handling with meaningful error messages
- Use database transactions for data consistency

### Slack Integration (Slack Bolt)
- Register "Log Daily Work" shortcut in workspace
- Implement modal form in Slack
- Handle form submission from modal
- Format and post digest to configured channel
- Implement scheduled job for nightly digest (use APScheduler or similar)
- Log job execution and failures

### Database (PostgreSQL)
- Create tables for logs, developers, preferences
- Implement indexes on frequently queried columns (developer_id, date)
- Implement soft deletes or audit trail for data integrity
- Implement backup and recovery procedures

### Testing
- Unit tests for form validation
- Integration tests for API endpoints
- E2E tests for form submission flow
- Load tests for form submission (100 concurrent users, p95 ≤3s)
- Performance tests for dashboard (load time ≤2s)
- Accessibility tests (WCAG 2.1 AA compliance)

---

## Glossary

- **Idempotent**: An operation that produces the same result regardless of how many times it's executed
- **Opt-out**: Developer can choose not to appear in team digest
- **Rolling 30-day window**: The past 30 days from today, updating daily
- **Business days**: Monday–Friday, excluding configured holidays
- **Blocker**: An issue or dependency preventing progress (identified by keywords "blocker" or "blocked")
- **Digest**: Aggregated summary of team's daily logs posted to Slack
- **Dashboard**: Web interface for managers to view team logs
- **Preferences**: User settings (display name, digest inclusion)

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Name] | Initial UX specification based on PRD |

---

**Document Status**: Ready for Design & Development

**Next Steps**:
1. Review with product and design teams
2. Create wireframes and mockups
3. Conduct usability testing with target personas
4. Finalize visual design and component library
5. Hand off to development team
