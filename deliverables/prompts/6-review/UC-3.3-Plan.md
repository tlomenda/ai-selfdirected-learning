# UC-3.3 Technical Implementation Plan
## Engineer Completes and Submits Anonymous Survey

---

## Overview

User Story US-3.3 requires implementing the engineer-facing survey completion and submission workflow. This story focuses on delivering a fast, mobile-responsive survey form that allows engineers to answer 5–7 questions and submit their responses anonymously. The implementation must ensure:

- **Anonymous submission**: No user identifiers are captured or stored with responses
- **Mobile-first UX**: Responsive design for 320px–2560px viewports with 44px+ touch targets
- **Validation & error handling**: Required fields are validated before submission; duplicate submissions are rejected
- **Confirmation feedback**: Engineers receive clear confirmation that their response was submitted anonymously

This story is blocked by US-3.2 (token generation) and TS-3.5/TS-3.7 (backend infrastructure), and blocks US-5.1 (analytics/reporting).

---

## Affected Components

### Frontend (React)
1. **Survey Form Component** (`src/components/SurveyForm.tsx`)
   - Renders survey questions dynamically based on survey metadata
   - Handles form state management (question responses, validation errors)
   - Implements responsive layout for mobile and desktop viewports
   - Displays validation errors for required fields

2. **Confirmation Page Component** (`src/components/ConfirmationPage.tsx`)
   - Displays success message after submission
   - Reassures engineer that response is anonymous
   - Provides option to close or navigate away

3. **Token Validation & Error Handling** (`src/utils/tokenValidator.ts`)
   - Validates survey token before rendering form
   - Handles expired or invalid tokens
   - Provides user-friendly error messages and link to request new token

4. **Form Utilities** (`src/utils/formValidation.ts`)
   - Validates required fields before submission
   - Formats response data for API submission

### Backend (Express.js / Node.js)
1. **Survey Submission Endpoint** (`/api/surveys/:surveyRunId/responses`)
   - POST endpoint to accept anonymous survey responses
   - Validates token and survey run
   - Implements idempotency check to reject duplicate submissions
   - Stores response anonymously (no user identifier)

2. **Token Validation Service** (`src/services/tokenService.ts`)
   - Validates survey token (format, expiration, usage)
   - Checks if token has already been used (duplicate submission prevention)
   - Returns survey metadata if token is valid

3. **Response Storage Service** (`src/services/responseService.ts`)
   - Stores responses anonymously in database
   - Ensures no PII is captured or logged
   - Handles transaction rollback on validation failure

4. **Duplicate Submission Check** (`src/middleware/idempotencyMiddleware.ts`)
   - Tracks token usage to prevent double-submission
   - Returns 409 Conflict if token already used
   - Provides user-friendly error message

### Database (PostgreSQL)
1. **survey_tokens** table
   - Tracks token usage (used_at timestamp, used_count)
   - Enables duplicate submission detection

2. **survey_responses** table
   - Stores responses anonymously (no user_id or email)
   - Columns: id, survey_run_id, question_id, response_value, created_at
   - No identifying information

3. **survey_runs** table
   - Tracks survey run metadata (status, response_count, close_time)
   - Used to validate survey is still open

---

## Data Model Changes

### New/Modified Tables

#### survey_responses (Anonymous Storage)
```
- id: UUID (primary key)
- survey_run_id: UUID (foreign key to survey_runs)
- question_id: UUID (foreign key to questions)
- response_value: TEXT or JSONB (stores Likert score, multiple choice, or short text)
- created_at: TIMESTAMP
- updated_at: TIMESTAMP

Constraints:
- No user_id or email column (anonymous by design)
- Composite unique constraint: (survey_run_id, question_id, created_at) to prevent duplicates
- Foreign key to survey_runs ensures referential integrity
```

#### survey_tokens (Idempotency Tracking)
```
- id: UUID (primary key)
- token: VARCHAR (unique, indexed)
- survey_run_id: UUID (foreign key)
- engineer_email: VARCHAR (hashed, for link re-request only; not stored with response)
- used_at: TIMESTAMP (NULL until first use)
- used_count: INTEGER (default 0)
- expires_at: TIMESTAMP
- created_at: TIMESTAMP

Constraints:
- Unique index on token
- used_count incremented on each submission attempt
- Reject submission if used_count > 0 (already submitted)
```

#### survey_runs (Metadata & Validation)
```
- id: UUID (primary key)
- survey_id: UUID (foreign key)
- scheduled_at: TIMESTAMP
- closes_at: TIMESTAMP
- status: ENUM ('pending', 'active', 'closed')
- response_count: INTEGER (aggregate count)
- created_at: TIMESTAMP

Constraints:
- Used to validate survey is still open (closes_at > NOW())
```

---

## API Changes

### New Endpoints

#### POST /api/surveys/:surveyRunId/responses
**Purpose**: Submit anonymous survey response

**Request**:
```json
{
  "token": "eyJhbGc...",
  "responses": [
    { "questionId": "q1-uuid", "value": 4 },
    { "questionId": "q2-uuid", "value": "Multiple choice option" },
    { "questionId": "q3-uuid", "value": "Short text response" }
  ]
}
```

**Response (200 OK)**:
```json
{
  "success": true,
  "message": "Your response has been submitted successfully",
  "anonymous": true
}
```

**Error Responses**:
- **400 Bad Request**: Missing required fields, invalid response format
- **401 Unauthorized**: Invalid or expired token
- **409 Conflict**: Duplicate submission (token already used)
- **410 Gone**: Survey run closed or not found

### Modified Endpoints

#### GET /api/surveys/:surveyRunId/form
**Purpose**: Retrieve survey form metadata (questions, types, options)

**Response (200 OK)**:
```json
{
  "surveyRunId": "sr-uuid",
  "surveyTitle": "Team Health Check",
  "questions": [
    {
      "id": "q1-uuid",
      "text": "How would you rate team morale?",
      "type": "likert",
      "required": true,
      "options": [1, 2, 3, 4, 5]
    },
    {
      "id": "q2-uuid",
      "text": "What's your biggest challenge?",
      "type": "short_text",
      "required": false
    }
  ]
}
```

---

## Implementation Steps

### Phase 1: Backend Infrastructure (Prerequisite)
**Blocked by US-3.2, TS-3.5, TS-3.7**

1. **Database Schema**
   - Create/update survey_tokens table with used_at, used_count columns
   - Create survey_responses table (anonymous, no user identifiers)
   - Add indexes on survey_run_id, token, expires_at for query performance

2. **Token Validation Service**
   - Implement tokenService.validateToken(token) → returns survey metadata or error
   - Check token format, expiration, and usage count
   - Return 401 if invalid/expired; 409 if already used

3. **Response Storage Service**
   - Implement responseService.storeResponse(surveyRunId, responses) → stores anonymously
   - Validate all required fields are present
   - Ensure no PII is captured in logs or error messages
   - Return response ID on success

4. **Idempotency Middleware**
   - Implement middleware to check if token has been used
   - Increment used_count on submission attempt
   - Reject with 409 if used_count > 0

### Phase 2: Backend API Endpoints

1. **POST /api/surveys/:surveyRunId/responses**
   - Accept token and responses array
   - Validate token using tokenService
   - Check survey run is still open (closes_at > NOW())
   - Call responseService.storeResponse()
   - Update survey_tokens.used_at and used_count
   - Return 200 with success message or appropriate error

2. **GET /api/surveys/:surveyRunId/form** (if not already implemented)
   - Retrieve survey questions and metadata
   - Return form structure for frontend rendering
   - No authentication required (token-based access)

### Phase 3: Frontend Survey Form Component

1. **SurveyForm Component**
   - Fetch survey form metadata on mount using token from URL
   - Render questions dynamically based on type (Likert, multiple choice, short text)
   - Implement responsive layout (mobile-first, 320px–2560px)
   - Ensure all controls are 44px+ for touch accessibility
   - Display validation errors inline for required fields
   - Disable submit button until all required fields are answered

2. **Form State Management**
   - Use React hooks (useState) to manage form state
   - Track responses as object: { questionId: value }
   - Track validation errors: { questionId: errorMessage }
   - Implement onChange handlers for each question type

3. **Form Submission**
   - Validate all required fields on submit click
   - If validation fails: display errors, highlight required fields, do not submit
   - If validation passes: POST to /api/surveys/:surveyRunId/responses
   - Handle loading state (disable submit button, show spinner)
   - On success: navigate to ConfirmationPage
   - On error: display error message (e.g., "Duplicate submission", "Survey closed")

### Phase 4: Frontend Confirmation & Error Handling

1. **ConfirmationPage Component**
   - Display success message: "Thank you! Your response has been submitted"
   - Display reassurance: "Your response is anonymous and will not be attributed to you"
   - Provide option to close or navigate away
   - No identifying information displayed

2. **Token Validation & Error Handling**
   - On page load, validate token before rendering form
   - If token invalid/expired: display error message
   - Provide option to request new link (links to US-2.3 flow)
   - Handle 409 Conflict error: "A response was already recorded for this survey"

3. **Responsive Design**
   - Test form rendering at 320px, 768px, 1024px, 2560px viewports
   - Ensure no horizontal scrolling
   - Verify all controls are 44px+ tall for touch targets
   - Use CSS media queries or responsive framework (e.g., Tailwind, Bootstrap)

### Phase 5: Testing & Verification

1. **Unit Tests**
   - Test form validation logic (required fields, response format)
   - Test token validation service
   - Test response storage (no PII captured)

2. **Integration Tests**
   - Test end-to-end submission flow (token validation → form render → submission)
   - Test duplicate submission rejection (409 Conflict)
   - Test survey closed validation (410 Gone)
   - Test validation error display and re-submission

3. **E2E Tests** (Playwright/Cypress)
   - Test complete user flow: token link → form render → answer questions → submit → confirmation
   - Test mobile viewport (320px) rendering and touch interaction
   - Test validation errors and error recovery
   - Test duplicate submission attempt

4. **Performance & Accessibility**
   - Measure form load time (target: < 2s)
   - Measure submission time (target: < 1s)
   - Verify WCAG 2.1 AA compliance (keyboard navigation, screen reader support)
   - Verify touch targets are 44px+ (WCAG 2.5.5)

---

## Testing Strategy

### Acceptance Criteria Mapping

| Acceptance Criterion | Test Approach | Test Type |
|----------------------|---------------|-----------|
| **AC1: Complete survey submission** | Submit form with all required fields answered; verify response stored and confirmation displayed | E2E |
| **AC2: Incomplete survey validation** | Leave required fields empty; click submit; verify validation errors displayed and no response stored | E2E, Unit |
| **AC3: Duplicate submission rejection** | Submit same token twice; verify second submission rejected with 409 Conflict error | Integration |
| **AC4: Mobile responsive rendering** | Render form at 320px viewport; verify no horizontal scrolling and 44px+ controls | E2E (visual) |

### Test Scenarios

1. **Happy Path: Complete & Submit Survey**
   - Given: Valid token, survey open, form loaded
   - When: Engineer answers all required questions and clicks Submit
   - Then: Response stored anonymously, confirmation page displayed, no errors

2. **Validation Error: Incomplete Form**
   - Given: Valid token, survey open, form loaded
   - When: Engineer leaves required question unanswered and clicks Submit
   - Then: Validation error displayed, required field highlighted, no response stored

3. **Duplicate Submission Prevention**
   - Given: Valid token, first response already submitted
   - When: Engineer attempts to submit again using same token
   - Then: 409 Conflict error returned, user sees message "Response already recorded"

4. **Mobile Rendering**
   - Given: Survey form on 320px-wide device
   - When: Page loads
   - Then: Form renders without horizontal scrolling, all controls 44px+

5. **Expired Token Handling**
   - Given: Expired or invalid token
   - When: Engineer clicks survey link
   - Then: Error message displayed, option to request new link provided

### Test Data & Fixtures

- **Valid survey run**: 5–7 questions, mix of Likert/multiple choice/short text, open status
- **Closed survey run**: status='closed', closes_at < NOW()
- **Valid token**: format correct, not expired, not used
- **Expired token**: expires_at < NOW()
- **Used token**: used_count > 0

---

## Risks & Open Questions

### Risks

1. **Risk: Double-submission race condition**
   - **Description**: Two simultaneous requests with same token could both pass validation
   - **Mitigation**: Implement database-level constraint (used_count check + atomic increment) or distributed lock
   - **Severity**: High

2. **Risk: PII leakage in logs or error messages**
   - **Description**: Engineer email or identifying info could be logged accidentally
   - **Mitigation**: Implement strict logging policy; sanitize error messages; audit logs for PII
   - **Severity**: High

3. **Risk: Form submission timeout on slow networks**
   - **Description**: Mobile users on slow networks may experience timeout or duplicate submission
   - **Mitigation**: Implement client-side timeout handling; disable submit button during submission; show loading state
   - **Severity**: Medium

4. **Risk: Mobile viewport rendering issues**
   - **Description**: Form may not render correctly on all devices (e.g., older browsers, unusual aspect ratios)
   - **Mitigation**: Test on real devices; use responsive CSS framework; implement progressive enhancement
   - **Severity**: Medium

### Open Questions

1. **Response Format for Short Text Questions**
   - Should short text responses be truncated to a max length? (e.g., 500 chars)
   - Should responses be sanitized to prevent XSS or injection attacks?
   - **Recommendation**: Implement max length (500 chars) and HTML entity encoding

2. **Survey Closed Behavior**
   - Should the form be pre-emptively hidden if survey is closed, or should submission fail with error?
   - **Recommendation**: Check survey status on form load; if closed, display message instead of form

3. **Likert Scale Labeling**
   - Should Likert scale options be labeled (e.g., "1=Strongly Disagree, 5=Strongly Agree")?
   - **Recommendation**: Yes, provide clear labels for accessibility and UX

4. **Confirmation Page Persistence**
   - Should confirmation page persist if user navigates back, or should it redirect?
   - **Recommendation**: Confirmation page should be a one-time view; navigating back should redirect to home

5. **Multiple Choice Question Type**
   - Should multiple choice questions allow single selection or multiple selections?
   - **Recommendation**: Clarify in PRD; assume single selection (radio buttons) unless specified otherwise

6. **Error Recovery**
   - If submission fails (e.g., network error), should form state be preserved for retry?
   - **Recommendation**: Yes, preserve form state and show retry button with error message

---

## Implementation Notes

### Frontend Best Practices
- Use controlled components for form inputs
- Implement debouncing for onChange handlers to avoid excessive re-renders
- Use CSS-in-JS or utility classes (Tailwind) for responsive design
- Implement error boundary to catch unexpected errors

### Backend Best Practices
- Use parameterized queries to prevent SQL injection
- Implement rate limiting on submission endpoint (e.g., 10 requests/minute per token)
- Log submission events (without PII) for monitoring and debugging
- Implement circuit breaker for external service calls (if applicable)

### Database Best Practices
- Add indexes on frequently queried columns (survey_run_id, token, expires_at)
- Implement partitioning on survey_responses table if large scale (millions of responses)
- Use transactions for atomic submission (validate + store + update token)

### Security Considerations
- Validate token format and expiration on both client and server
- Implement CSRF protection for form submission
- Use HTTPS for all communication
- Implement rate limiting to prevent brute force attacks
- Sanitize all user inputs (short text responses)
- Ensure no PII is logged or exposed in error messages

