# ASP.NET Web API Coding Style Guide for AI Coding Agents

**Target stack:** C# 10+, ASP.NET Web API (.NET 6+), xUnit, Moq, Playwright
**Audience:** AI coding agents (Claude Code, Copilot, Cursor, etc.) generating or modifying code

This document defines conventions an AI agent should follow by default unless the repository's existing code clearly establishes a different pattern — in which case, match the existing pattern.

---

## 1. Language & C# 10+ Features

- **Use records** for DTOs, request/response bodies, and immutable value objects. Do not write manual `Equals`/`GetHashCode`/property boilerplate for these.
  ```csharp
  public record CreateOrderRequest(string CustomerId, IReadOnlyList<OrderLineItem> Items);
  ```
- **Use `record struct`** for small, high-frequency value types (e.g., money amounts, coordinates) where value semantics and avoiding heap allocation both matter.
- **Enable nullable reference types** (`<Nullable>enable</Nullable>` in the `.csproj`) project-wide. Do not sprinkle `#nullable disable` to silence warnings — fix the nullability instead.
- **Use `var`** when the type is obvious from the right-hand side; use the explicit type when it improves clarity (e.g., numeric literals, ambiguous factory calls).
- **Pattern matching**: prefer `switch` expressions and property/type patterns over `if`/`else if` chains and `is`-then-cast.
  ```csharp
  var result = payment switch
  {
      { Status: PaymentStatus.Approved } => Ok(),
      { Status: PaymentStatus.Declined } => Problem(),
      _ => throw new InvalidOperationException("Unhandled payment status")
  };
  ```
- **File-scoped namespaces** (`namespace Company.App.Orders;`) instead of block-scoped namespaces.
- **Global usings** in a single `GlobalUsings.cs` per project for common namespaces (`System`, `System.Linq`, etc.) — don't repeat them file by file.
- **Required members** (`required` keyword) on DTO/entity properties that must be set, instead of relying on constructor-only enforcement when a settable property is still needed (e.g., for model binding).
- Prefer `async`/`await` all the way down — never block on async code with `.Result` or `.Wait()`.

---

## 2. Project & Folder Structure

- Organize by **feature/domain folder**, not by technical layer-only folder. Prefer:
  ```
  /Orders
      OrdersController.cs
      OrderService.cs
      IOrderRepository.cs
      OrderRepository.cs
      Order.cs (entity)
      Dtos/
          CreateOrderRequest.cs
          OrderResponse.cs
  ```
  over a single `Controllers/`, `Services/`, `Repositories/` split across all domains.
- One public top-level type per file, filename matches type name.
- Internal by default for implementation classes; only make types `public` if they're part of the assembly's external contract.
- Minimal APIs (`app.MapGet(...)`) are acceptable for small services; for larger APIs, prefer controller-based routing (`[ApiController]`) for consistency and testability — pick one style per project and don't mix both for the same resource.

---

## 3. Dependency Injection & Service Registration

- **Constructor injection only.** Never use service locator patterns (`IServiceProvider.GetService<T>()`) inside application code — only in composition-root/startup code.
- Register services with the narrowest lifetime that's correct: `Scoped` for anything touching `DbContext` or per-request state, `Singleton` only for stateless/thread-safe services, `Transient` for lightweight stateless helpers.
- Group registrations into extension methods per feature area (`AddOrderServices(this IServiceCollection services)`), called from `Program.cs`, instead of one long flat list of `services.AddScoped<...>()` calls in `Program.cs`.
- Use the `Options` pattern (`IOptions<T>` / `IOptionsSnapshot<T>`) bound from configuration sections, not static config access via `IConfiguration` scattered through services.
  ```csharp
  builder.Services.Configure<PaymentOptions>(builder.Configuration.GetSection("Payments"));
  ```

---

## 4. Controllers (Web Layer)

- Controllers are thin: validate input, delegate to a service, map to a response. No business logic in controllers.
- Return `ActionResult<T>` (or `Results<T1, T2>` for Minimal APIs) so both the success payload and explicit status codes are expressible.
- Use `[ApiController]` at class level to get automatic model validation (400 on invalid `ModelState`) — don't manually re-check `ModelState.IsValid` unless doing something beyond the default.
- Validate request DTOs with data annotations or FluentValidation — not manual null checks scattered through the action method.
- Never expose EF Core entities directly in request/response bodies — always map to DTOs (records).
- Version routes explicitly (`/api/v1/orders`) via route templates or API versioning middleware.

```csharp
[ApiController]
[Route("api/v1/orders")]
public class OrdersController : ControllerBase
{
    private readonly IOrderService _orderService;

    public OrdersController(IOrderService orderService)
    {
        _orderService = orderService;
    }

    [HttpPost]
    public async Task<ActionResult<OrderResponse>> CreateOrder(
        [FromBody] CreateOrderRequest request,
        CancellationToken cancellationToken)
    {
        var order = await _orderService.CreateOrderAsync(request, cancellationToken);
        return CreatedAtAction(nameof(GetOrder), new { id = order.Id }, order);
    }
}
```

---

## 5. Services (Business Layer)

- Services own transaction boundaries: wrap multi-step persistence operations in an explicit `DbContext` transaction, or rely on `SaveChangesAsync` being atomic for single-aggregate changes — don't leave partial writes uncommitted on failure paths.
- Every service method that does I/O accepts and forwards a `CancellationToken`.
- Throw domain-specific exceptions (`OrderNotFoundException`, not bare `Exception`), handled centrally (see §7).
- Interfaces (`IOrderService`) live alongside their implementation in the same feature folder; don't create a separate `Interfaces/` folder that fragments the feature.

---

## 6. Persistence (EF Core)

- Entities are plain classes with a parameterless constructor for EF Core materialization; use private setters or `init` where mutation should be controlled through explicit methods rather than property assignment.
- Configure entities with `IEntityTypeConfiguration<T>` classes (Fluent API) in a `Configurations/` folder — avoid scattering configuration via data annotations across entity classes for anything non-trivial.
- Repositories (if used) are thin wrappers exposing intention-revealing methods (`GetByCustomerIdAsync`), not generic `IRepository<T>` CRUD wrappers that just proxy `DbSet<T>` — prefer using `DbContext`/`DbSet` directly in services if the project doesn't already have a repository abstraction, rather than adding one.
- Use `.AsNoTracking()` for read-only queries.
- Avoid N+1 queries — use `.Include()`/`.ThenInclude()` or projection (`.Select(...)`) explicitly rather than lazy loading.

---

## 7. Error Handling

- Centralize exception-to-HTTP mapping in exception-handling middleware (`IExceptionHandler` in .NET 8+, or custom middleware) rather than try/catch blocks duplicated across controllers.
- Return `ProblemDetails` (RFC 7807) for error responses — ASP.NET Core has built-in support via `ProblemDetailsFactory`.
- Never let stack traces leak to API responses outside the `Development` environment.

```csharp
public class OrderNotFoundExceptionHandler : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext, Exception exception, CancellationToken cancellationToken)
    {
        if (exception is not OrderNotFoundException notFound)
        {
            return false;
        }

        httpContext.Response.StatusCode = StatusCodes.Status404NotFound;
        await httpContext.Response.WriteAsJsonAsync(
            new ProblemDetails { Title = "Order not found", Detail = notFound.Message },
            cancellationToken);
        return true;
    }
}
```

---

## 8. Testing

- **Unit tests**: xUnit + Moq. Test one class in isolation; mock all collaborators via constructor injection. Use `[Theory]` + `[InlineData]`/`[MemberData]` for parameterized cases instead of copy-pasted `[Fact]` methods.
- **Integration tests**: `WebApplicationFactory<Program>` (`Microsoft.AspNetCore.Mvc.Testing`) for in-process API testing, combined with Testcontainers for a real database instead of an in-memory provider, when testing persistence behavior.
- **E2E tests**: Playwright (.NET bindings) against a running instance, kept in a separate test project (e.g., `Orders.E2ETests`) so they don't run on every unit test invocation (`dotnet test` filters, or a separate CI stage).
- Naming: `MethodName_Condition_ExpectedResult` or `Should_ExpectedResult_When_Condition` — pick one convention per repo and stay consistent; don't mix within the same test class.
- Use FluentAssertions (`result.Should().Be(...)`) over raw `Assert.*` if already a dependency; otherwise stick to xUnit's built-in `Assert` consistently.
- No `Thread.Sleep()` in tests — use Playwright's own auto-waiting for E2E, and proper async signaling for integration tests.
- Mock only what you own or what crosses a process boundary (external HTTP clients, repositories) — don't mock simple value objects or DTOs.

---

## 9. Configuration & Environments

- `appsettings.json` for defaults, `appsettings.{Environment}.json` for overrides (`Development`, `Staging`, `Production`), selected via `ASPNETCORE_ENVIRONMENT`.
- Secrets never committed — use User Secrets locally (`dotnet user-secrets`), environment variables or a secrets manager (Azure Key Vault, AWS Secrets Manager) in deployed environments.
- Bind configuration sections to strongly-typed `Options` records, not raw `IConfiguration["Section:Key"]` string-indexer access scattered through the codebase.

---

## 10. Logging

- Use `ILogger<T>` (Microsoft.Extensions.Logging) — never `Console.WriteLine`.
- Use structured/semantic logging with message templates, not string interpolation:
  ```csharp
  _logger.LogInformation("Order {OrderId} created for customer {CustomerId}", order.Id, order.CustomerId);
  ```
  not `_logger.LogInformation($"Order {order.Id} created...")`.
- Correlate logs with the built-in `TraceIdentifier`/OpenTelemetry trace context rather than manually generating and threading a custom request ID.
- Log at the right level: `Error` for actionable failures, `Warning` for recoverable/unexpected states, `Information` for lifecycle/business events, `Debug`/`Trace` for diagnostic detail — not everything at `Information`.

---

## 11. Formatting & Style Baseline

- 4-space indentation, no tabs.
- Line length target ~120 chars.
- Braces always used, even for single-line `if`/`for` bodies.
- Favor early returns / guard clauses over deep nesting.
- Follow a repo `.editorconfig` if present (this is the standard place C# projects define formatting rules) — defer to it over these defaults.
- Enable and respect `TreatWarningsAsErrors` / analyzer rules (`Microsoft.CodeAnalysis.NetAnalyzers`) already configured in the project rather than suppressing warnings inline.

---

## 12. What AI Agents Should Do Before Generating Code

1. Check for an existing `.editorconfig`, `.globalconfig`, or analyzer ruleset, and match it over this guide where they conflict.
2. Check the target framework (`<TargetFramework>` in the `.csproj`) before assuming APIs from a specific .NET/C# version are available.
3. Check whether the project uses Controllers or Minimal APIs before adding new endpoints, and follow the existing style rather than introducing the other.
4. Prefer extending existing patterns (DTO mapping approach, exception hierarchy, response envelope, DI registration style) over introducing a new pattern for the same concern.
5. Do not introduce new dependencies (FluentValidation, AutoMapper, a new HTTP client, etc.) without flagging it — check what's already referenced in the `.csproj` first.