# APython & FastAPI Coding Guidelines for AI Coding Agents

This document defines the coding style, conventions, and architectural patterns
this agent must follow when writing or modifying Python/FastAPI code in this
repository.

---

## 1. General Principles

- Prefer clarity over cleverness. Optimize for the next reader, not for
  fewest keystrokes.
- Follow PEP 8, enforced via `ruff` (linting) and `black` (formatting).
- Every function and public class must have type hints. No untyped `def`.
- Fail fast and loud. Don't swallow exceptions silently.
- Keep functions small and single-purpose (~40 lines as a soft ceiling).
- No dead code, commented-out blocks, or `print()` debugging left in commits.

## 2. Tooling

| Purpose        | Tool                     |
|----------------|--------------------------|
| Formatting     | `black`                  |
| Linting        | `ruff`                   |
| Type checking  | `mypy --strict`          |
| Testing        | `pytest` + `pytest-asyncio` |
| Dependency mgmt| `uv` or `poetry`         |
| Pre-commit     | `pre-commit` running black, ruff, mypy on every commit |

Run before every commit:
```bash
ruff check . --fix
black .
mypy .
pytest
```

## 3. Project Structure

```
app/
├── main.py                # FastAPI app instantiation only
├── api/
│   ├── v1/
│   │   ├── routers/
│   │   │   ├── users.py
│   │   │   └── items.py
│   │   └── dependencies.py
├── core/
│   ├── config.py          # Settings via pydantic-settings
│   ├── security.py
│   └── logging.py
├── models/                # SQLAlchemy / ORM models
├── schemas/                # Pydantic request/response models
├── services/                # Business logic, framework-agnostic
├── repositories/                # Data access layer
├── exceptions.py
tests/
├── unit/
└── integration/
```

**Rule:** routers call services; services call repositories. Routers never
touch the database directly, and services never import FastAPI types
(`Request`, `Depends`, etc.) — keep business logic framework-agnostic and
independently testable.

## 4. Naming Conventions

- `snake_case` for functions, variables, modules.
- `PascalCase` for classes, Pydantic models, SQLAlchemy models.
- `UPPER_SNAKE_CASE` for constants.
- Pydantic request models: `XCreate`, `XUpdate`; response models: `XRead` or `XOut`.
- Router files named after the resource, plural: `users.py`, not `user_router.py`.
- Private/internal helpers prefixed with `_`.

## 5. Type Hints & Data Validation

- Use built-in generics (`list[str]`, `dict[str, int]`), not `typing.List`.
- Use `X | None` instead of `Optional[X]` (Python 3.10+).
- All request/response bodies are Pydantic `BaseModel` subclasses — never
  raw `dict` in a route signature.
- Use `Field(...)` for constraints and descriptions rather than validating
  manually in route bodies.

```python
class UserCreate(BaseModel):
    email: EmailStr
    age: int = Field(ge=0, le=120)
    display_name: str | None = None
```

## 6. FastAPI Route Conventions

- One `APIRouter` per resource, included in `main.py` with an explicit
  `prefix` and `tags`.
- Always declare `response_model` explicitly; never rely on inferred return
  type for the OpenAPI schema.
- Use `status` constants (`status.HTTP_201_CREATED`), not raw integers.
- Path operations should be thin: parse input → call service → return.
  No business logic inline in the route function.

```python
@router.post(
    "/users",
    response_model=UserRead,
    status_code=status.HTTP_201_CREATED,
)
async def create_user(
    payload: UserCreate,
    service: UserService = Depends(get_user_service),
) -> UserRead:
    return await service.create_user(payload)
```

## 7. Dependency Injection

- All shared resources (DB sessions, settings, current user) are provided
  via `Depends`, defined once in `dependencies.py`, and imported — never
  re-declared per router.
- Prefer `Annotated` dependency syntax:

```python
DbSession = Annotated[AsyncSession, Depends(get_db_session)]

async def get_user(user_id: int, db: DbSession) -> UserRead:
    ...
```

## 8. Async Rules

- All I/O (DB calls, HTTP calls, file access) must be `async`/`await`.
  Never call blocking I/O inside an `async def` route.
- Use an async DB driver (e.g., `asyncpg`, `SQLAlchemy` async engine).
- If a truly blocking call is unavoidable, offload it explicitly with
  `run_in_threadpool` or `asyncio.to_thread`.

## 9. Error Handling

- Define domain exceptions in `exceptions.py` (e.g., `UserNotFoundError`),
  raised from services.
- Translate domain exceptions to HTTP responses via registered
  `@app.exception_handler(...)` handlers in `main.py` — routes should not
  contain `try/except HTTPException` boilerplate.
- Never raise bare `Exception`. Never return error info by returning
  `None` from a service silently.

```python
class UserNotFoundError(Exception):
    def __init__(self, user_id: int):
        self.user_id = user_id

@app.exception_handler(UserNotFoundError)
async def user_not_found_handler(request: Request, exc: UserNotFoundError) -> JSONResponse:
    return JSONResponse(
        status_code=status.HTTP_404_NOT_FOUND,
        content={"detail": f"User {exc.user_id} not found"},
    )
```

## 10. Configuration

- All config via `pydantic-settings.BaseSettings`, loaded once as a cached
  singleton (`@lru_cache`).
- No hardcoded secrets, URLs, or magic values in code. Everything
  environment-driven with sane `.env.example` documentation.

## 11. Logging

- Use the standard `logging` module configured centrally in
  `core/logging.py`. No `print()` statements anywhere in `app/`.
- Log at module level: `logger = logging.getLogger(__name__)`.
- Never log secrets, tokens, or full request bodies containing PII.

## 12. Testing

- Unit tests mock repositories/external calls and test services in
  isolation — no FastAPI `TestClient` needed.
- Integration tests use `httpx.AsyncClient` against the app with a test
  database (or `ASGITransport`), covering full request/response cycles.
- Test naming: `test_<unit>_<scenario>_<expected_result>`.
- Every new endpoint requires at least: one happy-path test, one
  validation-error test, one not-found/permission test where applicable.

## 13. Docstrings & Comments

- Public functions/classes get a short docstring (Google style) stating
  purpose, args, returns, and raised exceptions — skip it only for
  self-evident one-liners.
- Comments explain *why*, not *what* — the code should already say what.

```python
async def create_user(self, payload: UserCreate) -> UserRead:
    """Create a new user and send a welcome email.

    Args:
        payload: Validated user creation data.

    Returns:
        The newly created user.

    Raises:
        UserAlreadyExistsError: If the email is already registered.
    """
```

## 14. Security Defaults

- Never trust client input; validate everything through Pydantic.
- Use `passlib`/`argon2` for password hashing — never roll your own.
- All auth via dependency-injected `get_current_user`, never re-parsed
  per route.
- Rate limiting and CORS configured centrally in `main.py`, not per route.

## 15. Commit Hygiene

- Small, focused commits. One logical change per commit.
- Commit messages: imperative mood, e.g. `Add user deletion endpoint`,
  not `Added` or `Adding`.