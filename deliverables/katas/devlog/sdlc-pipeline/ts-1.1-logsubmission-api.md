### TS-1.1: Implement Log Submission API Endpoint
**Story ID:** TS-1.1  
**Type:** Technical Story  
**Title:** Implement Log Submission API Endpoint  
**Description:**  
Implement the POST /logs API endpoint to accept daily log submissions from web forms and Slack shortcuts, with validation, persistence, and idempotency support.

**Acceptance Criteria:**

```gherkin
Scenario: POST /logs endpoint accepts valid log submission
  Given a developer has a valid OIDC token
  When the developer sends a POST request to /logs with work details
  Then the endpoint returns HTTP 201 Created
  And the response includes the created log ID and timestamp
  And the log is persisted in the database

Scenario: POST /logs endpoint accepts empty submission
  Given a developer has a valid OIDC token
  When the developer sends a POST request to /logs with all fields empty
  Then the endpoint returns HTTP 201 Created
  And an empty log entry is persisted in the database

Scenario: POST /logs endpoint validates authentication
  Given a developer does not have a valid OIDC token
  When the developer sends a POST request to /logs
  Then the endpoint returns HTTP 401 Unauthorized
  And no log entry is created

Scenario: POST /logs endpoint enforces idempotency
  Given a developer submits a log with a unique idempotency key
  When the developer submits the same log with the same idempotency key
  Then the endpoint returns HTTP 201 Created
  And only one log entry is created
  And the response includes the same log ID as the first submission

Scenario: POST /logs endpoint responds within 3 seconds
  Given a developer sends a POST request to /logs
  When the request is processed
  Then the response is returned within 3 seconds
```

**Priority:** P0 - Critical  
**Traceability:**
- Architecture: Section 4.1 (Backend Components - LogController, LogService, LogRepository)
- PRD: Non-Functional Requirements (Performance - Web form submission latency ≤3 seconds)
- UX Specification: Flow 1 and Flow 2 (Log submission flows)

**Dependencies:**
- Blocked By: TS-1.3 (Log Data Model), TS-5.1 (OIDC Authentication Middleware), TS-6.2 (PostgreSQL Database Setup)
- Blocks: US-1.1, US-1.2, TS-1.4
- Related Stories: TS-1.2, TS-1.3, TS-1.4