# TS-1.1: Implement Log Submission API Endpoint - Implementation Plan

## Overview

TS-1.1 requires implementing the `POST /logs` REST API endpoint to accept daily log submissions from web forms and Slack shortcuts. The endpoint must:

1. Validate OIDC authentication tokens
2. Accept log submissions with optional fields (worked_on, completed, blockers, planned_tomorrow)
3. Persist logs to PostgreSQL with a unique constraint on `(user_id, log_date)`
4. Support idempotency using idempotency keys
5. Return HTTP 201 Created with the created log ID and timestamp
6. Respond within 3 seconds (performance requirement)

The implementation follows the FastAPI backend architecture described in devlog-arch.md, leveraging the Python-FastAPI-React tech stack with PostgreSQL persistence.

---

## Affected Components

### Backend (Python/FastAPI)

| Component | Type | Action | Purpose |
|-----------|------|--------|---------|
| `app/api/routes/logs.py` | Route Handler | **Create** | Define POST /logs endpoint |
| `app/services/log_service.py` | Service Layer | **Create** | Business logic for log submission, idempotency, validation |
| `app/repositories/log_repository.py` | Data Access | **Create** | Database queries for logs (insert, check duplicates, retrieve) |
| `app/models/schemas.py` | Pydantic Models | **Modify** | Add LogSubmissionRequest and LogResponse schemas |
| `app/models/database.py` | ORM Models | **Verify** | Ensure LOG table model exists (from TS-1.3) |
| `app/middleware/auth.py` | Middleware | **Use** | Leverage existing OIDC token validation (from TS-5.1) |
| `app/main.py` | Application | **Modify** | Register logs route in FastAPI app |

### Database (PostgreSQL)

| Component | Action | Purpose |
|-----------|--------|---------|
| `USER` table | **Verify** | Must exist with user_id, email, slack_user_id columns |
| `LOG` table | **Verify** | Must exist with log_id, user_id, log_date, worked_on, completed, blockers, planned_tomorrow, created_at, updated_at |
| `AUDIT_LOG` table | **Verify** | Must exist for audit trail logging |
| Indexes | **Verify** | Ensure indexes on (user_id, log_date), user_id, log_date, created_at |
| Unique Constraint | **Verify** | Unique constraint on (user_id, log_date) to prevent duplicate entries |

### Frontend (React)

| Component | Action | Purpose |
|-----------|--------|---------|
| `src/components/LogForm.tsx` | **Use** | Call POST /logs endpoint when form is submitted |
| `src/api/logApi.ts` | **Create/Modify** | HTTP client to POST /logs with OIDC token |

### Testing

| Component | Type | Action |
|-----------|------|--------|
| `tests/unit/services/test_log_service.py` | Unit Tests | **Create** |
| `tests/unit/repositories/test_log_repository.py` | Unit Tests | **Create** |
| `tests/integration/test_logs_endpoint.py` | Integration Tests | **Create** |
| `tests/e2e/test_log_submission_flow.py` | E2E Tests | **Create** |

---

## Data Model Changes

### No New Tables Required

The LOG, USER, and AUDIT_LOG tables are defined in TS-1.3 (Log Data Model). This story assumes they exist.

### Idempotency Handling

**Approach**: Use idempotency key in request headers or body
- If `idempotency_key` is provided and a log with that key exists, return the existing log with HTTP 201
- Store idempotency key in a separate `IDEMPOTENCY_KEY` table or as a column in LOG table
- **Recommended**: Add `idempotency_key` (nullable, unique) column to LOG table for simplicity

### Data Constraints (Verification)

```sql
-- Unique constraint to prevent duplicate logs per user per day
ALTER TABLE LOG ADD CONSTRAINT unique_user_log_date UNIQUE (user_id, log_date);

-- Indexes for query performance
CREATE INDEX idx_log_user_id ON LOG(user_id);
CREATE INDEX idx_log_date ON LOG(log_date);
CREATE INDEX idx_log_created_at ON LOG(created_at);
CREATE INDEX idx_log_user_date ON LOG(user_id, log_date);
```

---

## API Changes

### New Endpoint: POST /logs

**Route**: `POST /logs`

**Authentication**: Required (OIDC token in Authorization header)

**Request Body** (Pydantic model):
```python
class LogSubmissionRequest(BaseModel):
    worked_on: Optional[str] = None
    completed: Optional[str] = None
    blockers: Optional[str] = None
    planned_tomorrow: Optional[str] = None
    idempotency_key: Optional[str] = None  # UUID format
```

**Response (201 Created)**:
```python
class LogResponse(BaseModel):
    log_id: str  # UUID
    user_id: str
    log_date: str  # ISO date format (YYYY-MM-DD)
    worked_on: Optional[str]
    completed: Optional[str]
    blockers: Optional[str]
    planned_tomorrow: Optional[str]
    created_at: str  # ISO timestamp
    updated_at: str  # ISO timestamp
```

**Error Responses**:
- `401 Unauthorized`: Invalid or missing OIDC token
- `400 Bad Request`: Invalid request body (e.g., invalid UUID format for idempotency_key)
- `409 Conflict`: (Optional) If idempotency key validation fails
- `500 Internal Server Error`: Database or server error

**Performance Requirement**: Response must be returned within 3 seconds

---

## Implementation Steps

### Phase 1: Setup & Scaffolding

1. **Create Pydantic schemas** (`app/models/schemas.py`)
   - Add `LogSubmissionRequest` with optional fields
   - Add `LogResponse` with all fields including timestamps
   - Add validation for idempotency_key (UUID format if provided)

2. **Verify ORM model** (`app/models/database.py`)
   - Confirm LOG model exists with all required columns
   - Confirm idempotency_key column exists (or add if needed)
   - Verify relationships to USER table

3. **Create log repository** (`app/repositories/log_repository.py`)
   - Implement `create_log(user_id, log_date, submission_data)` → LogResponse
   - Implement `get_log_by_idempotency_key(idempotency_key)` → Optional[Log]
   - Implement `get_log_by_user_and_date(user_id, log_date)` → Optional[Log]
   - Handle database transactions and error cases

### Phase 2: Service Layer

4. **Create log service** (`app/services/log_service.py`)
   - Implement `submit_log(user_id, submission_data)` → LogResponse
   - **Idempotency logic**:
     - If idempotency_key provided, check if log already exists
     - If exists, return existing log (don't create duplicate)
     - If not exists, create new log with idempotency_key
   - **Duplicate prevention**:
     - Check if log exists for (user_id, today's date)
     - If exists and no idempotency_key, update existing log or return error (TBD by acceptance criteria)
   - **Audit logging**:
     - Call audit repository to log CREATE action with log_id, user_id, submission details
   - Error handling for database constraints, validation failures

5. **Verify auth service** (`app/services/auth_service.py`)
   - Confirm OIDC token validation is implemented (from TS-5.1)
   - Confirm user_id extraction from token claims

### Phase 3: API Endpoint

6. **Create logs route** (`app/api/routes/logs.py`)
   - Define `POST /logs` endpoint handler
   - Extract OIDC token from Authorization header
   - Call auth middleware/service to validate token and extract user_id
   - Parse request body using LogSubmissionRequest schema
   - Call LogService.submit_log(user_id, submission_data)
   - Return LogResponse with HTTP 201 Created
   - Handle exceptions and return appropriate error responses

7. **Register route** (`app/main.py`)
   - Import logs router
   - Include router in FastAPI app: `app.include_router(logs_router, prefix="/api", tags=["logs"])`

### Phase 4: Testing

8. **Unit tests for LogRepository** (`tests/unit/repositories/test_log_repository.py`)
   - Test create_log() with valid data
   - Test get_log_by_idempotency_key() returns existing log
   - Test get_log_by_user_and_date() returns log or None
   - Test database constraint violations (duplicate user_id, log_date)
   - Mock database calls using pytest-mock

9. **Unit tests for LogService** (`tests/unit/services/test_log_service.py`)
   - Test submit_log() with valid submission
   - Test idempotency: same idempotency_key returns same log_id
   - Test empty submission (all fields None)
   - Test audit log creation
   - Test error handling (database errors, validation failures)
   - Mock repository calls

10. **Integration tests for endpoint** (`tests/integration/test_logs_endpoint.py`)
    - Test POST /logs with valid OIDC token → 201 Created
    - Test POST /logs with invalid token → 401 Unauthorized
    - Test POST /logs with missing token → 401 Unauthorized
    - Test POST /logs with empty submission → 201 Created
    - Test POST /logs with idempotency key (duplicate submission) → 201 Created, same log_id
    - Test POST /logs response time ≤ 3 seconds
    - Test response schema matches LogResponse
    - Use test database and real FastAPI test client

11. **E2E tests** (`tests/e2e/test_log_submission_flow.py`)
    - Test complete flow: Developer submits log via web form → backend receives → database persists → response returned
    - Test Slack shortcut integration (if applicable)
    - Use Playwright or similar E2E framework

### Phase 5: Frontend Integration

12. **Create/update log API client** (`src/api/logApi.ts`)
    - Implement `submitLog(submission: LogSubmissionRequest): Promise<LogResponse>`
    - Include OIDC token in Authorization header
    - Handle 401 errors (redirect to login)
    - Handle 400/500 errors (show user-friendly error messages)

13. **Update LogForm component** (`src/components/LogForm.tsx`)
    - Call logApi.submitLog() on form submission
    - Show loading state during submission
    - Show success message with log_id and timestamp
    - Show error message if submission fails
    - Generate idempotency_key (UUID) for each submission attempt

### Phase 6: Verification & Documentation

14. **Performance testing**
    - Load test POST /logs endpoint with concurrent requests
    - Verify response time ≤ 3 seconds under normal load
    - Monitor database query performance (indexes)
    - Profile database connection pooling

15. **Documentation**
    - Add endpoint documentation to API spec (OpenAPI/Swagger)
    - Document request/response schemas
    - Document error codes and handling
    - Add code comments for idempotency logic

---

## Testing Strategy

### Acceptance Criteria Coverage

| Acceptance Criterion | Test Type | Test Case |
|---------------------|-----------|-----------|
| Valid submission → 201 Created | Integration | POST /logs with valid token and data → 201, log_id in response |
| Empty submission → 201 Created | Integration | POST /logs with all fields empty → 201, empty log persisted |
| Invalid token → 401 Unauthorized | Integration | POST /logs without token → 401, no log created |
| Idempotency: same key → same log_id | Integration | POST /logs twice with same idempotency_key → 201, same log_id both times |
| Response time ≤ 3 seconds | Performance | Load test with concurrent requests → all respond within 3s |

### Test Pyramid

```
E2E Tests (5%)
├─ Log submission flow end-to-end
├─ Slack shortcut integration
└─ Dashboard reflects submitted logs

Integration Tests (25%)
├─ POST /logs endpoint with various inputs
├─ Database persistence
├─ OIDC token validation
└─ Idempotency key handling

Unit Tests (70%)
├─ LogService business logic
├─ LogRepository database queries
├─ Pydantic schema validation
└─ Error handling
```

### Test Execution

```bash
# Run all tests
pytest tests/

# Run unit tests only
pytest tests/unit/

# Run integration tests
pytest tests/integration/

# Run with coverage
pytest --cov=app tests/

# Run E2E tests
playwright test tests/e2e/
```

---

## Risks & Open Questions

### Risks

1. **Performance Risk**: Database query for duplicate check (user_id, log_date) could be slow without proper indexing
   - **Mitigation**: Ensure index on (user_id, log_date) exists; monitor query performance

2. **Idempotency Key Storage**: Storing idempotency_key in LOG table may not be ideal if logs are deleted
   - **Mitigation**: Consider separate IDEMPOTENCY_KEY table with TTL; or accept current approach for MVP

3. **Concurrent Submissions**: Race condition if user submits twice simultaneously
   - **Mitigation**: Database unique constraint on (user_id, log_date) prevents duplicates; return 409 or existing log

4. **OIDC Token Validation**: Assumes TS-5.1 (OIDC Middleware) is complete and working
   - **Mitigation**: Verify auth middleware exists and is tested before implementing this story

5. **Database Availability**: If PostgreSQL is down, endpoint will fail
   - **Mitigation**: Implement connection pooling and retry logic; monitor database health

### Open Questions

1. **Duplicate Log Handling**: If user submits log twice on same day WITHOUT idempotency_key, should we:
   - Return 409 Conflict?
   - Update existing log?
   - Return 201 with existing log_id?
   - **Recommendation**: Return 201 with existing log_id (idempotent behavior)

2. **Idempotency Key Format**: Should idempotency_key be:
   - Optional (as currently designed)?
   - Required?
   - Auto-generated by frontend?
   - **Recommendation**: Optional; frontend generates UUID if not provided

3. **Log Date Determination**: Should log_date be:
   - Always today's date (server-determined)?
   - Provided in request body?
   - **Recommendation**: Server-determined (today's date in UTC)

4. **Timezone Handling**: How should we handle timezone-aware log_date?
   - **Recommendation**: Store log_date as UTC date; document in API spec

5. **Slack Shortcut Integration**: How does Slack shortcut submission differ from web form?
   - **Recommendation**: Both call same POST /logs endpoint; Slack shortcut extracts user_id from Slack token

### Dependencies

- **TS-1.3 (Log Data Model)**: Must be complete; LOG table schema must exist
- **TS-5.1 (OIDC Authentication Middleware)**: Must be complete; token validation must work
- **TS-6.2 (PostgreSQL Database Setup)**: Must be complete; database must be accessible

### Assumptions

1. OIDC token validation is implemented and working (TS-5.1)
2. LOG, USER, AUDIT_LOG tables exist with correct schema (TS-1.3)
3. PostgreSQL database is accessible and configured (TS-6.2)
4. FastAPI application structure exists with routes, services, repositories
5. Pydantic is used for request/response validation
6. pytest is used for testing with pytest-mock for mocking
7. Database ORM is SQLAlchemy or similar

---

## Implementation Checklist

- [ ] Create Pydantic schemas (LogSubmissionRequest, LogResponse)
- [ ] Verify LOG ORM model and idempotency_key column
- [ ] Create LogRepository with CRUD operations
- [ ] Create LogService with idempotency logic
- [ ] Create POST /logs endpoint handler
- [ ] Register logs route in FastAPI app
- [ ] Write unit tests for LogRepository
- [ ] Write unit tests for LogService
- [ ] Write integration tests for POST /logs endpoint
- [ ] Write E2E tests for log submission flow
- [ ] Create/update log API client (frontend)
- [ ] Update LogForm component to call API
- [ ] Performance test endpoint (response time ≤ 3s)
- [ ] Add OpenAPI documentation
- [ ] Code review and merge
- [ ] Deploy to staging and test
- [ ] Deploy to production

---

## Success Criteria

✅ All acceptance criteria from TS-1.1 are met:
- POST /logs accepts valid submissions and returns 201 Created
- POST /logs accepts empty submissions and persists them
- POST /logs validates authentication and returns 401 for invalid tokens
- POST /logs enforces idempotency (same key = same log_id)
- POST /logs responds within 3 seconds

✅ Code quality:
- Unit test coverage ≥ 80%
- Integration tests pass
- E2E tests pass
- No linting errors
- Code follows project conventions

✅ Performance:
- Response time ≤ 3 seconds under normal load
- Database queries are optimized with indexes
- No N+1 query problems

✅ Documentation:
- API endpoint documented in OpenAPI spec
- Code comments explain idempotency logic
- README updated with new endpoint

