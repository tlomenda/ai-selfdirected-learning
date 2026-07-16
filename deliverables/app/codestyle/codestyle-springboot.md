# Spring Boot / Java Coding Style Guide for AI Coding Agents

**Target stack:** Spring Boot 4.x, Java 25, Maven/Gradle
**Audience:** AI coding agents (Claude Code, Copilot, Cursor, etc.) generating or modifying code

This document defines conventions an AI agent should follow by default unless the repository's existing code clearly establishes a different pattern — in which case, match the existing pattern.

---

## 1. Language & Java 25 Features

- **Use records** for DTOs, request/response bodies, and immutable value objects. Do not write manual getters/equals/hashCode for these.
  ```java
  public record CreateOrderRequest(String customerId, List<OrderLineItem> items) {}
  ```
- **Use `var`** for local variables when the type is obvious from the right-hand side. Do not use `var` when it obscures the type (e.g., returned from a poorly-named method).
- **Use pattern matching for `switch`** and **sealed interfaces** for closed type hierarchies (e.g., domain events, result types) instead of enums-with-behavior or instanceof chains.
  ```java
  sealed interface PaymentResult permits Approved, Declined, Pending {}
  ```
- **Use virtual threads** (`Executors.newVirtualThreadPerTaskExecutor()`) for blocking I/O-bound concurrent work instead of platform thread pools, and prefer Spring Boot's built-in virtual thread support (`spring.threads.virtual.enabled=true`) over manual executor configuration.
- **Avoid `null`** as a return value or field default — prefer `Optional<T>` for return types (never for fields or method parameters) or explicit sentinel/empty objects.
- **Text blocks** (`"""`) for multi-line SQL, JSON, or templates instead of concatenated strings.
- Target `--release 25` explicitly in build config; do not silently downgrade language level.

---

## 2. Project & Package Structure

- Organize by **feature/domain package**, not by technical layer-only package. Prefer:
  ```
  com.company.app.order
      OrderController.java
      OrderService.java
      OrderRepository.java
      Order.java (entity)
      OrderMapper.java
      dto/
          CreateOrderRequest.java
          OrderResponse.java
  ```
  over a single `controller/`, `service/`, `repository/` split across all domains.
- One public top-level class/interface/record per file, filename matches type name.
- Package-private by default for implementation classes; only make classes `public` if they're part of the module's external contract.

---

## 3. Dependency Injection & Bean Wiring

- **Constructor injection only.** Never use `@Autowired` on fields.
- Do not add Lombok's `@RequiredArgsConstructor` as a default — with Java 25 records for DTOs and normal explicit constructors for services, Lombok is often unnecessary. If the project already uses Lombok, follow existing convention; do not introduce it in a Lombok-free codebase without being asked.
  ```java
  @Service
  class OrderService {
      private final OrderRepository orderRepository;
      private final PaymentClient paymentClient;

      OrderService(OrderRepository orderRepository, PaymentClient paymentClient) {
          this.orderRepository = orderRepository;
          this.paymentClient = paymentClient;
      }
  }
  ```
- Avoid `@Autowired` field injection, avoid `@ComponentScan` sprawl — keep the main application class annotated simply with `@SpringBootApplication` and let package structure drive scanning.
- Prefer `@ConfigurationProperties` records over `@Value` for grouped configuration.
  ```java
  @ConfigurationProperties(prefix = "app.payments")
  public record PaymentProperties(String apiKey, Duration timeout) {}
  ```

---

## 4. Controllers (Web Layer)

- Controllers are thin: validate input, delegate to a service, map to a response. No business logic in controllers.
- Use `ResponseEntity<T>` when status code/headers need explicit control; otherwise return the body type directly and let Spring set 200.
- Use `@RestController` + `@RequestMapping` at class level with a versioned base path (`/api/v1/orders`).
- Validate request bodies with Jakarta Bean Validation (`@Valid` + `@NotNull`/`@NotBlank`/etc. on the record components), not manual null checks.
- Never expose JPA entities directly in request/response bodies — always map to DTOs (records).

```java
@RestController
@RequestMapping("/api/v1/orders")
class OrderController {

    private final OrderService orderService;

    OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping
    ResponseEntity<OrderResponse> createOrder(@Valid @RequestBody CreateOrderRequest request) {
        var order = orderService.createOrder(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(order);
    }
}
```

---

## 5. Services (Business Layer)

- Services own transaction boundaries: `@Transactional` goes on service methods, not repositories or controllers.
- Keep `@Transactional` methods focused — avoid calling external HTTP/network clients inside a transactional method (keep the transaction short-lived).
- Throw domain-specific exceptions (`OrderNotFoundException`, not generic `RuntimeException`), handled centrally (see §7).

---

## 6. Persistence (Spring Data JPA)

- Entities use Java classes (not records — JPA entities are mutable and require a no-arg constructor), package-private setters where possible, and `@Id` with a defined generation strategy (prefer `GenerationType.UUID` or a sequence over `IDENTITY` for portability).
- Repositories extend `JpaRepository<Entity, IdType>`; add derived query methods or `@Query` with JPQL — avoid native SQL unless necessary for performance, and comment why when used.
- Never return entities from a `@RestController` — map to DTOs via a dedicated mapper class or MapStruct (if already in the project).
- Use `@EntityGraph` or explicit fetch joins to avoid N+1 queries; do not rely on default lazy-loading inside loops.

---

## 7. Error Handling

- Centralize exception-to-HTTP mapping in a single `@RestControllerAdvice` class using `@ExceptionHandler`.
- Return a consistent error response shape (a record, e.g. `ErrorResponse(String code, String message, Instant timestamp)`), following [RFC 7807 Problem Details](https://datatracker.ietf.org/doc/html/rfc7807) via Spring's built-in `ProblemDetail` where practical.
- Never let stack traces leak to API responses in production profiles.

```java
@RestControllerAdvice
class GlobalExceptionHandler {

    @ExceptionHandler(OrderNotFoundException.class)
    ProblemDetail handleNotFound(OrderNotFoundException ex) {
        return ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, ex.getMessage());
    }
}
```

---

## 8. Testing

- **Unit tests**: JUnit 5 + Mockito. Test one class in isolation; mock all collaborators via constructor injection.
- **Slice tests**: `@WebMvcTest` for controllers, `@DataJpaTest` for repositories — don't boot the full context for isolated layer tests.
- **Integration tests**: `@SpringBootTest` + Testcontainers for real database/broker behavior instead of H2 or mocks, when testing persistence or integration boundaries.
- **E2E tests**: Playwright (Java bindings) against a running instance, kept in a separate module/source set (e.g., `src/e2e/java` or a dedicated `e2e-tests` module) so they don't run on every unit test invocation.
- Naming: `MethodName_condition_expectedResult` or `should_expectedResult_when_condition` — pick one convention per repo and stay consistent; don't mix within the same test class.
- Use AssertJ (`assertThat(...)`) over raw JUnit assertions for readability.
- No `Thread.sleep()` in tests — use Awaitility for async assertions, and Playwright's own auto-waiting for E2E.

---

## 9. Configuration & Profiles

- `application.yml` over `.properties` for readability with nested structure.
- Split by profile: `application.yml` (defaults) + `application-dev.yml` / `application-prod.yml`, activated via `spring.profiles.active`.
- Secrets never committed — reference environment variables or a secrets manager, never hardcode API keys/passwords even in "example" configs.

---

## 10. Logging

- Use SLF4J (`org.slf4j.Logger`) — never `System.out.println` or `e.printStackTrace()`.
- Structure logs for correlation: include a request/trace ID (Spring Boot's built-in Micrometer Tracing integration) rather than manually threading IDs through log statements.
- Log at the right level: `ERROR` for actionable failures, `WARN` for recoverable/unexpected states, `INFO` for lifecycle/business events, `DEBUG` for diagnostic detail — not everything at `INFO`.

---

## 11. Formatting & Style Baseline

- 4-space indentation, no tabs.
- Line length target ~120 chars.
- Braces always used, even for single-line `if`/`for` bodies.
- Favor early returns / guard clauses over deep nesting.
- If the repo has a `.editorconfig`, checkstyle, or Spotless config, defer to it over these defaults — this guide is the fallback, not an override.

---

## 12. What AI Agents Should Do Before Generating Code

1. Check for an existing style — an `.editorconfig`, `checkstyle.xml`, `spotless` Gradle/Maven config, or simply the patterns in neighboring files — and match it over this guide where they conflict.
2. Check the Spring Boot version in `pom.xml`/`build.gradle` before assuming Spring Boot 4 APIs (e.g., `@MockitoBean` vs. the older `@MockBean`) are available.
3. Prefer extending existing patterns (mapper style, exception hierarchy, response envelope) over introducing a new pattern for the same concern.
4. Do not introduce new dependencies (Lombok, MapStruct, a new HTTP client, etc.) without flagging it — check what's already on the classpath first.