# TeamPulse UX Specification

## 1. Overview

TeamPulse is a lightweight team health check system that enables engineering managers to collect anonymous, recurring pulse survey feedback from their teams and view aggregated trend data. This UX Specification defines how each user persona (Manager and Engineer) will interact with the system to accomplish their goals.

The specification bridges the PRD requirements and technical implementation, providing designers, developers, and testers with a shared understanding of:
- How users navigate the system
- What information is displayed and when
- How users input data and receive feedback
- How the system handles errors, loading states, and edge cases
- How the interface adapts to different devices and screen sizes

---

## 2. Target Users & Personas

### Persona 1: Engineering Manager
- **Role**: Team lead or engineering manager responsible for 3–15+ engineers
- **Technical Proficiency**: Moderate to high; comfortable with web applications and dashboards
- **Primary Goal**: Understand team health and sentiment trends without compromising individual privacy
- **Devices**: Desktop (primary), tablet (secondary)
- **Access Pattern**: Weekly or bi-weekly; 5–10 minutes per session
- **Key Tasks**:
  - Create and configure surveys
  - Edit survey questions and frequency
  - View trend dashboards
  - Compare metrics between survey periods
  - Filter data by date range

### Persona 2: Engineer
- **Role**: Individual contributor on an engineering team
- **Technical Proficiency**: Moderate to high; comfortable with web forms
- **Primary Goal**: Provide honest feedback on team health without fear of attribution
- **Devices**: Desktop (primary), mobile (secondary); may access from any device
- **Access Pattern**: On-demand; triggered by notification; 2–3 minutes per session
- **Key Tasks**:
  - Receive survey notification
  - Access survey via link
  - Answer survey questions
  - Submit response
  - (Optionally) Request a new survey link if original expired

---

## 3. User Goals

### Manager Goals
1. **Create a survey** in under 5 minutes with custom questions
2. **Configure survey frequency** (weekly or bi-weekly) and team membership
3. **View team health trends** over time without seeing individual responses
4. **Compare metrics** between two survey periods to assess impact of changes
5. **Filter dashboard data** by date range to focus on specific periods
6. **Manage surveys** (edit, deactivate) as requirements change

### Engineer Goals
1. **Receive notification** about a survey via email or Slack
2. **Access survey** via a simple link without logging in
3. **Complete survey** in under 3 minutes on any device
4. **Submit response** with confidence that it is anonymous
5. **Request a new link** if the original link expires

---

## 4. User Flows

### 4.1 Manager Flow: Create a Survey

```
Start
  ↓
[Login Page] → Manager clicks "Login"
  ↓
[OIDC Redirect] → Redirected to Entra ID
  ↓
[Entra ID Login] → Manager authenticates with company credentials
  ↓
[Dashboard] → Redirected to dashboard after successful login
  ↓
[Create Survey Button] → Manager clicks "Create New Survey"
  ↓
[Survey Form - Step 1: Basic Info]
  - Title (text input)
  - Frequency (dropdown: Weekly / Bi-weekly)
  - Team (dropdown: select team)
  - Start Date & Time (date/time picker)
  ↓
[Survey Form - Step 2: Questions]
  - Add Questions (repeat for 5-7 questions)
    - Question text (text input)
    - Question type (dropdown: Likert / Multiple Choice / Short Text)
    - Options (if multiple choice)
  ↓
[Survey Form - Review]
  - Display all entered information
  - Manager reviews and confirms
  ↓
[Confirmation]
  - Success message: "Survey created successfully"
  - Dashboard updated with new survey
  ↓
End
```

### 4.2 Manager Flow: View Dashboard & Trends

```
Start
  ↓
[Dashboard] → Manager logs in and sees dashboard
  ↓
[Survey List] → Manager selects a survey from list
  ↓
[Trend Dashboard]
  - Displays trend lines for each question
  - Shows response count per survey run
  - Displays date range filter (default: last 12 weeks)
  ↓
[Optional: Filter by Date Range]
  - Manager selects start and end dates
  - Dashboard updates with filtered data
  ↓
[Optional: Period-over-Period Comparison]
  - Manager selects two survey runs from dropdown
  - Comparison view displays side-by-side metrics
  - Shows percentage change (↑/↓)
  ↓
End
```

### 4.3 Manager Flow: Edit Survey

```
Start
  ↓
[Dashboard] → Manager selects a survey
  ↓
[Survey Details] → Manager clicks "Edit"
  ↓
[Survey Form - Edit Mode]
  - Can edit title, frequency, questions
  - Cannot edit past survey runs (read-only)
  ↓
[Changes Confirmation]
  - Manager reviews changes
  - Confirms edit
  ↓
[Confirmation]
  - Success message: "Survey updated successfully"
  - Changes apply to future survey runs only
  ↓
End
```

### 4.4 Manager Flow: Deactivate Survey

```
Start
  ↓
[Dashboard] → Manager selects a survey
  ↓
[Survey Details] → Manager clicks "Deactivate"
  ↓
[Confirmation Modal]
  - "Are you sure you want to deactivate this survey?"
  - "Future notifications will not be sent"
  - "Historical data will remain accessible"
  ↓
[Manager Confirms]
  ↓
[Confirmation]
  - Success message: "Survey deactivated"
  - Survey status changes to "Inactive"
  - Survey removed from active list
  ↓
End
```

### 4.5 Engineer Flow: Receive & Complete Survey

```
Start
  ↓
[Email / Slack Notification]
  - Subject: "Team Health Check: Please share your feedback"
  - Body: Brief message + survey link
  - Link: Single-use, time-limited token
  ↓
[Engineer Clicks Link]
  ↓
[Token Validation]
  - System validates token
  - If valid: proceed to survey form
  - If invalid/expired: show error + option to request new link
  ↓
[Survey Form]
  - Displays survey title
  - Displays 5-7 questions
  - Question types: Likert scale, multiple choice, short text
  - No identifying information visible
  ↓
[Engineer Answers Questions]
  - For Likert: click radio button (1-5 scale)
  - For Multiple Choice: click radio button or checkbox
  - For Short Text: type response (optional)
  ↓
[Submit Button]
  - Engineer clicks "Submit"
  ↓
[Submission Validation]
  - System validates all required fields are answered
  - If validation fails: show error message + highlight missing fields
  - If validation passes: proceed to confirmation
  ↓
[Confirmation]
  - Success message: "Thank you! Your response has been submitted"
  - Message: "Your response is anonymous and will not be attributed to you"
  - Option to close or return to home
  ↓
End
```

### 4.6 Engineer Flow: Request New Survey Link

```
Start
  ↓
[Expired Token Page]
  - Engineer clicks on expired link
  - System displays: "This link has expired"
  - Option: "Request a new link"
  ↓
[Email Input Form]
  - Engineer enters email address
  - Submits request
  ↓
[Rate Limiting Check]
  - System checks if email has exceeded 3 requests per survey run
  - If exceeded: show error "Too many requests. Please try again later."
  - If allowed: proceed
  ↓
[Confirmation]
  - Success message: "A new link has been sent to your email"
  - Message: "The link will expire in 7 days"
  ↓
[Email Delivery]
  - New survey link sent to email
  - Engineer receives email and clicks new link
  ↓
[Survey Form] → (same as 4.5)
  ↓
End
```

---

## 5. Information Architecture

### 5.1 Manager Navigation Structure

```
Dashboard (Home)
├── Surveys (List View)
│   ├── Active Surveys
│   │   ├── Survey Details
│   │   │   ├── Trend Dashboard
│   │   │   ├── Period Comparison
│   │   │   ├── Edit Survey
│   │   │   └── Deactivate Survey
│   │   └── Create New Survey
│   └── Inactive Surveys
├── Account
│   ├── Profile
│   ├── Teams
│   └── Logout
└── Help / Documentation
```

### 5.2 Engineer Navigation Structure

```
Survey Link (from Email/Slack)
├── Token Validation
├── Survey Form
│   ├── Question 1
│   ├── Question 2
│   ├── ... (5-7 questions)
│   └── Submit
├── Confirmation
└── Request New Link (if expired)
```

---

## 6. Screen Specifications

### 6.1 Manager: Login Page

**Purpose**: Authenticate manager via company SSO (Entra ID/OIDC)

**Layout**:
```
┌─────────────────────────────────────────┐
│                                         │
│         TeamPulse Logo                  │
│                                         │
│     Team Health Check System            │
│                                         │
│                                         │
│     ┌─────────────────────────────┐    │
│     │  Sign in with Company SSO   │    │
│     └─────────────────────────────┘    │
│                                         │
│     [Privacy notice]                    │
│                                         │
└─────────────────────────────────────────┘
```

**Components**:
- **Logo**: TeamPulse branding (centered, 80px height)
- **Headline**: "Team Health Check System" (H1, 28px, centered)
- **CTA Button**: "Sign in with Company SSO" (primary button, 48px height, full width)
  - On click: Redirect to Entra ID authorization endpoint
  - Loading state: Button shows spinner, text changes to "Signing in..."
- **Privacy Notice**: Small text (12px) explaining SSO authentication and privacy

**Responsive Behavior**:
- Desktop (1024px+): Centered card layout, 400px width
- Tablet (768px–1023px): Centered card layout, 90% width
- Mobile (320px–767px): Full-width layout, 16px padding

**Accessibility**:
- Button has clear focus state (outline, 2px)
- Text contrast ratio ≥ 4.5:1
- Semantic HTML: `<button>` element

---

### 6.2 Manager: Dashboard (Home)

**Purpose**: Display overview of manager's surveys and quick actions

**Layout**:
```
┌─────────────────────────────────────────────────────────┐
│ TeamPulse    [Account ▼]                          Logout │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Dashboard                                              │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │ ┌─────────────────────────────────────────────┐ │   │
│  │ │ [+ Create New Survey]                       │ │   │
│  │ └─────────────────────────────────────────────┘ │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  Active Surveys                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │ Survey Title 1                    Weekly        │   │
│  │ Team: Engineering                 3 responses   │   │
│  │ [View Dashboard] [Edit] [Deactivate]            │   │
│  ├─────────────────────────────────────────────────┤   │
│  │ Survey Title 2                    Bi-weekly     │   │
│  │ Team: Product                     5 responses   │   │
│  │ [View Dashboard] [Edit] [Deactivate]            │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  Inactive Surveys                                       │
│  ┌─────────────────────────────────────────────────┐   │
│  │ Survey Title 3 (Inactive)                       │   │
│  │ [View Historical Data] [Reactivate]             │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Components**:
- **Header**: TeamPulse logo (left), Account dropdown (right), Logout link (right)
- **Page Title**: "Dashboard" (H1, 32px)
- **Create Survey CTA**: Primary button, full width, 48px height
  - On click: Navigate to survey creation form
- **Survey List**: Card-based layout
  - Each card displays:
    - Survey title (H3, 18px, bold)
    - Team name (14px, gray)
    - Frequency (14px, gray)
    - Response count (14px, gray)
    - Action buttons: "View Dashboard", "Edit", "Deactivate" (secondary buttons, 36px height)
  - Hover state: Card background changes to light gray
  - Active surveys section (default expanded)
  - Inactive surveys section (collapsible)

**Empty State**:
- If no surveys exist: "No surveys yet. Create your first survey to get started."

**Responsive Behavior**:
- Desktop (1024px+): 2-column survey card grid
- Tablet (768px–1023px): 1-column survey card grid
- Mobile (320px–767px): Full-width cards, stacked vertically

---

### 6.3 Engineer: Survey Form

**Purpose**: Enable engineer to answer survey questions anonymously

**Layout**:
```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  TeamPulse                                              │
│                                                         │
│  Team Health Check                                      │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │ Question 1 of 3                                 │   │
│  │                                                 │   │
│  │ How satisfied are you with team collaboration? │   │
│  │                                                 │   │
│  │ ○ Very Dissatisfied                             │   │
│  │ ○ Dissatisfied                                  │   │
│  │ ○ Neutral                                       │   │
│  │ ○ Satisfied                                     │   │
│  │ ○ Very Satisfied                                │   │
│  │                                                 │   │
│  │ [Back] [Next]                                   │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  Progress: ███░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   │
│            1 of 3                                       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Components**:
- **Header**: TeamPulse logo (centered, 60px height)
- **Survey Title**: "Team Health Check" (H1, 28px, centered)
- **Question Card**: White background, 16px padding, rounded corners
  - Question number: "Question 1 of 3" (14px, gray)
  - Question text: (H2, 20px, bold)
  - Question type-specific input:
    - **Likert Scale**: Radio buttons (5 options, vertical layout)
    - **Multiple Choice**: Radio buttons or checkboxes
    - **Short Text**: Text area (optional, max 500 characters)
- **Navigation Buttons**:
  - "Back": Secondary button, 36px height (disabled on first question)
  - "Next": Primary button, 36px height (on all but last question)
  - "Submit": Primary button, 36px height (on last question only)
- **Progress Bar**: Visual indicator of progress through survey

**Confirmation Page** (after submission):
```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  TeamPulse                                              │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │                                                 │   │
│  │  ✓ Thank you!                                   │   │
│  │                                                 │   │
│  │  Your response has been submitted successfully. │   │
│  │                                                 │   │
│  │  Your response is anonymous and will not be    │   │
│  │  attributed to you. Only team-level trends     │   │
│  │  will be visible to your manager.              │   │
│  │                                                 │   │
│  │  [Close]                                        │   │
│  │                                                 │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Responsive Behavior**:
- Desktop (1024px+): Centered card layout, 500px width
- Tablet (768px–1023px): Centered card layout, 90% width
- Mobile (320px–767px): Full-width layout, 16px padding
- **Tap-Friendly Controls**: Radio buttons and buttons are 44px minimum height on mobile

**Accessibility**:
- Form labels associated with inputs via `<label>` tags
- Required fields marked with asterisk (*) and `aria-required="true"`
- Error messages linked to inputs via `aria-describedby`
- Radio button groups have `<fieldset>` and `<legend>`
- Focus states: 2px outline on all interactive elements

---

## 7. Interaction Design

### 7.1 Manager Interactions

#### Survey Creation
- **Multi-step form**: Breaks survey creation into 3 manageable steps
- **Progress indicator**: Shows current step and total steps
- **Data persistence**: Form data is preserved when navigating back
- **Confirmation step**: Allows manager to review all information before submitting
- **Success feedback**: Clear confirmation message with next steps

#### Dashboard Navigation
- **Card-based layout**: Easy scanning of surveys
- **Hover states**: Cards highlight on hover to indicate interactivity
- **Quick actions**: Action buttons on each card for common tasks
- **Filtering**: Date range picker enables focused analysis

#### Trend Visualization
- **Interactive charts**: Hover to see exact values
- **Multiple views**: Toggle between trends and comparison
- **Responsive legends**: Adapt to screen size

### 7.2 Engineer Interactions

#### Survey Completion
- **Single-question-per-screen**: Reduces cognitive load
- **Progress indicator**: Shows progress through survey
- **Back/Next navigation**: Allows reviewing previous answers
- **Validation feedback**: Clear error messages for required fields
- **Confirmation**: Reassures engineer that response is anonymous

#### Token Management
- **Simple email input**: Minimal friction for requesting new link
- **Rate limiting feedback**: Clear message if too many requests
- **Confirmation message**: Confirms link was sent

---

## 8. States & Feedback

### 8.1 Loading States

**Page Loading**:
- Spinner animation (rotating circle, 32px)
- Text: "Loading..." (14px, gray)
- Displayed in center of page

**Button Loading**:
- Spinner animation inside button (16px)
- Text changes to "Loading..." or "Submitting..."
- Button is disabled during loading

### 8.2 Success States

**Form Submission**:
- Success message banner (green background, white text)
- Icon: Checkmark (green, 24px)
- Text: "Survey created successfully" (14px)
- Auto-dismiss after 5 seconds or manual close

**Page Confirmation**:
- Confirmation page with checkmark icon
- Headline: "Thank you!" or "Success!"
- Message: Confirmation text
- CTA: "Continue" or "Close" button

### 8.3 Error States

**Form Validation Error**:
- Error message below field (red text, 12px)
- Field has red border (2px)
- Icon: Exclamation mark (red, 16px)
- Message: "This field is required" or specific validation message

**Form Submission Error**:
- Error banner at top of form (red background, white text)
- Icon: Exclamation mark (red, 24px)
- Text: "Failed to create survey. Please try again." (14px)
- Retry button: "Try Again" (secondary button)

**Page Error**:
- Error page with warning icon (orange, 48px)
- Headline: "Error" or "Something went wrong" (H1, 28px)
- Message: Explanation of error (16px)
- CTA: "Retry" or "Go Back" button

### 8.4 Empty States

**No Surveys**:
- Illustration or icon (optional)
- Headline: "No surveys yet" (H2, 20px)
- Message: "Create your first survey to get started" (14px)
- CTA: "Create New Survey" button

**No Responses**:
- Illustration or icon (optional)
- Headline: "No responses yet" (H2, 20px)
- Message: "Survey responses will appear here once engineers submit their feedback" (14px)
- Additional info: "Survey starts on: June 30, 2026 at 9:00 AM" (12px, gray)

---

## 9. Accessibility

### 9.1 WCAG 2.1 Level AA Compliance

**Color Contrast**:
- Text on background: ≥ 4.5:1 for normal text, ≥ 3:1 for large text
- UI components: ≥ 3:1 for borders and outlines

**Keyboard Navigation**:
- All interactive elements are keyboard accessible
- Tab order follows logical flow (left to right, top to bottom)
- Focus states are visible (2px outline)
- No keyboard traps
- Escape key closes modals and dropdowns

**Screen Reader Support**:
- Semantic HTML: `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<footer>`
- Form labels: `<label>` associated with inputs via `for` attribute
- Required fields: `aria-required="true"`
- Error messages: `aria-describedby` links to error text
- Form groups: `<fieldset>` and `<legend>` for radio/checkbox groups
- Images: `alt` text for all images
- Icons: `aria-label` for icon-only buttons
- Charts: Data table alternative or `aria-label` describing chart

**Focus Management**:
- Focus moves to new content after page load
- Focus returns to trigger element after closing modal
- Focus trap in modals (Tab cycles through modal content only)

### 9.2 Mobile Accessibility

**Touch Targets**:
- Minimum 44px × 44px for touch targets
- Adequate spacing between touch targets (8px minimum)
- Buttons and links are easily tappable

**Text Size**:
- Minimum 12px font size for body text
- Larger font sizes for headings (20px+)
- Zoom support: Page is usable at 200% zoom

**Orientation**:
- App works in both portrait and landscape orientations
- Content is not locked to a single orientation

---

## 10. Responsive Behavior

### 10.1 Breakpoints

| Device | Width | Layout |
|--------|-------|--------|
| Mobile | 320px–767px | Single column, full-width cards |
| Tablet | 768px–1023px | Single or two-column, 90% width |
| Desktop | 1024px+ | Multi-column, constrained width (max 1200px) |

### 10.2 Responsive Design Patterns

**Navigation**:
- Desktop: Horizontal navigation bar
- Mobile: Hamburger menu (collapsible)

**Cards**:
- Desktop: 2-column grid
- Tablet: 1-column grid
- Mobile: Full-width, stacked vertically

**Charts**:
- Desktop: Full-width chart with legend below
- Tablet: Full-width chart, simplified legend
- Mobile: Full-width chart, legend on side or below

**Forms**:
- Desktop: Single-column form, 600px width
- Tablet: Single-column form, 90% width
- Mobile: Full-width form, 16px padding

**Buttons**:
- Desktop: 36px height, 12px padding
- Mobile: 44px height (minimum), 12px padding (for touch targets)

### 10.3 Mobile-Specific Considerations

**Input Methods**:
- Use appropriate input types: `type="email"`, `type="date"`, `type="tel"`
- Trigger native mobile keyboards
- Avoid custom date/time pickers if native input is available

**Touch Interactions**:
- Tap-friendly buttons and links (44px minimum)
- Avoid hover-only interactions
- Provide visual feedback on tap (active state)

**Performance**:
- Optimize images for mobile (use responsive images, WebP format)
- Minimize JavaScript bundle size
- Lazy load non-critical content

---

## 11. Content & Copy

### 11.1 Tone & Voice

- **Professional but approachable**: Use clear, simple language
- **Reassuring**: Emphasize privacy and anonymity
- **Action-oriented**: Use active voice and clear CTAs
- **Concise**: Minimize text; use bullet points and short sentences

### 11.2 Key Messages

**Privacy & Anonymity**:
- "Your response is anonymous and will not be attributed to you"
- "Only team-level trends will be visible to your manager"
- "No individual responses are ever displayed"

**Ease of Use**:
- "Complete this survey in under 3 minutes"
- "Your feedback helps us understand team health"
- "No login required; just click the link"

**Clarity**:
- "Survey responses will appear here once engineers submit their feedback"
- "Survey starts on: June 30, 2026 at 9:00 AM"
- "Changes apply to future survey runs only"

### 11.3 Microcopy Examples

| Context | Copy |
|---------|------|
| Required field | "This field is required" |
| Validation error | "Please enter a valid email address" |
| Success message | "Survey created successfully" |
| Expired token | "This link has expired. Survey links are valid for 7 days." |
| Rate limit | "Too many requests. Please try again later." |
| Empty state | "No surveys yet. Create your first survey to get started." |
| Loading | "Loading dashboard..." |
| Confirmation | "Are you sure you want to deactivate this survey?" |

---

## 12. Edge Cases

### 12.1 Manager Edge Cases

**Survey with No Responses**:
- Dashboard displays empty state message
- Trend chart is not shown
- Message: "No responses yet. Survey responses will appear here once engineers submit their feedback."

**Survey with Very Few Responses** (e.g., 1–2):
- Trend chart is shown, but with limited data points
- Warning message: "Limited responses. Trends may not be representative."
- Average value is still calculated and displayed

**Manager Edits Survey While Survey Run is Active**:
- Changes apply to future survey runs only
- Current survey run is not affected
- Message: "Changes will apply to future survey runs starting [date]"

**Manager Filters Dashboard with Date Range Containing No Data**:
- Message: "No data available for the selected date range"
- Suggestion: "Try adjusting your date range or view all data"

**Manager Logs Out While Editing Survey**:
- Session expires
- Redirect to login page
- Message: "Your session has expired. Please log in again."
- Form data is not preserved (security consideration)

### 12.2 Engineer Edge Cases

**Engineer Receives Multiple Notifications for Same Survey**:
- Each notification contains a unique token
- Engineer can use any token to access the survey
- Only one response is recorded per engineer per survey run

**Engineer Submits Survey Twice** (e.g., accidental double-click):
- System prevents duplicate submissions
- Message: "You have already submitted a response for this survey"

**Engineer Requests New Link Multiple Times**:
- Rate limiting: Max 3 requests per email per survey run
- After 3 requests: "Too many requests. Please try again later."
- Message: "A new link has been sent to your email"

**Engineer Attempts to Access Survey After Submission**:
- Token is invalidated after first use
- Message: "This link has already been used"
- Option: "Request a new link" (if survey is still active)

**Engineer Accesses Survey on Multiple Devices**:
- Each device receives a unique token
- Engineer can submit response from any device
- Only one response is recorded (first submission wins)

**Engineer Submits Incomplete Survey**:
- Validation error: "Please answer all required questions"
- Highlighted fields: Red border and error message
- Engineer must complete all questions before submitting

---

## 13. Acceptance Criteria

### Manager Workflows

- [ ] Manager can log in via company SSO (Entra ID/OIDC)
- [ ] Manager can create a survey with custom questions in under 5 minutes
- [ ] Manager can select survey frequency (weekly or bi-weekly)
- [ ] Manager can view dashboard with list of active and inactive surveys
- [ ] Manager can view trend dashboard for a survey
- [ ] Manager can filter dashboard by date range
- [ ] Manager can compare metrics between two survey periods
- [ ] Manager can edit survey configuration (affects future runs only)
- [ ] Manager can deactivate a survey
- [ ] Manager cannot see individual response data or engineer identities
- [ ] Manager can log out

### Engineer Workflows

- [ ] Engineer receives survey notification via email or Slack
- [ ] Engineer can access survey form via single-use, time-limited token
- [ ] Engineer can answer 5–7 survey questions
- [ ] Engineer can submit response in under 3 minutes
- [ ] Engineer receives confirmation that response was submitted
- [ ] Engineer is reassured that response is anonymous
- [ ] Engineer can request a new survey link if original expired
- [ ] Engineer cannot access dashboard or see other responses
- [ ] Survey form is mobile-responsive and renders without horizontal scrolling at 320px–2560px

### UI & Interaction

- [ ] All form fields have clear labels and validation messages
- [ ] All buttons have clear focus states and hover states
- [ ] All interactive elements are keyboard accessible
- [ ] Loading states are clearly indicated
- [ ] Error states are clearly indicated with actionable messages
- [ ] Empty states are clearly indicated with helpful guidance
- [ ] Success states are clearly indicated with confirmation messages
- [ ] Mobile layout is optimized for touch (44px minimum touch targets)
- [ ] All text meets WCAG 2.1 Level AA color contrast requirements
- [ ] All pages are usable at 200% zoom
- [ ] All pages work in both portrait and landscape orientations

---

## 14. Design System Components

The following components should be designed and documented in a design system (e.g., Figma, Storybook):

- **Buttons**: Primary, Secondary, Danger, Disabled, Loading states
- **Form Inputs**: Text, Email, Date, Dropdown, Radio, Checkbox, Textarea
- **Cards**: Survey card, data card, empty state card
- **Modals**: Confirmation, error, success modals
- **Charts**: Line chart, bar chart, legend
- **Progress Indicators**: Progress bar, spinner, skeleton loader
- **Navigation**: Header, sidebar, breadcrumbs
- **Typography**: Headings (H1–H6), body text, labels, captions
- **Colors**: Primary blue (#0066CC), secondary gray (#F5F5F5), success green (#28A745), error red (#DC3545), warning orange (#FFC107)
- **Spacing**: 4px, 8px, 12px, 16px, 24px, 32px, 48px
- **Icons**: Checkmark, exclamation, warning, close, menu, etc.

---

## 15. Design Handoff Notes

### For Designers

1. Create high-fidelity mockups for all screens listed in Section 6
2. Define component library with all states (default, hover, focus, disabled, loading, error)
3. Create interactive prototypes for key user flows (survey creation, survey completion, dashboard navigation)
4. Conduct accessibility audit (color contrast, keyboard navigation, screen reader testing)
5. Create responsive design specifications for mobile, tablet, and desktop breakpoints

### For Developers

1. Implement all components from design system
2. Ensure all interactive elements are keyboard accessible
3. Implement form validation with clear error messages
4. Implement loading and error states for all async operations
5. Implement responsive design using CSS media queries
6. Test on multiple devices and browsers
7. Conduct accessibility testing (axe-core, WAVE, manual testing)

### For QA

1. Test all user flows on desktop, tablet, and mobile devices
2. Test all form validation scenarios (required fields, invalid input, etc.)
3. Test all error states (network errors, validation errors, etc.)
4. Test all loading states (page load, button click, etc.)
5. Test keyboard navigation (Tab, Enter, Escape)
6. Test screen reader compatibility (NVDA, JAWS, VoiceOver)
7. Test at 200% zoom
8. Test in both portrait and landscape orientations (mobile)
