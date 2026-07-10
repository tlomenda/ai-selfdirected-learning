## Test Case Template

**Template for each test case:**

```
## Test Case [N]: [Short name]

**Input:** [The specific product description or variant]

**Expected Output Criteria:**
- [Criterion 1]
- [Criterion 2]
- [Criterion 3]
- (add more as needed)

**Failure Criteria (must NOT occur):**
- [Failure criterion 1]
- [Failure criterion 2]
```

---

## Test Case 1: Required Sections Completeness

**Input**: The full TeamPulse product description as provided in the prompt.

**Expected Output Criteria:**

* Contains all 7 required sections: Product Overview, Features, Non-Functional Requirements, Key Implementation Details, Scope Boundaries, Open Questions, and Change Log
* Product Overview includes both a Problem Statement and stated Goals
* Features section includes at least 2 distinct personas (e.g., Engineering Manager, Engineer)
* Non-Functional Requirements includes at least one suggested tool or verification method per NFR
* Change Log contains at least one initial version entry with a date and description
* Open Questions contains at least 3 unresolved questions relevant to implementation

**Failure Criteria (must NOT occur):**

* One or more of the 7 required sections is missing entirely
* Non-Functional Requirements are listed without any verification methods
* Open Questions section is empty or contains only placeholder text

---

## Test Case 2: Anonymity and Privacy Requirements

**Input**: The full TeamPulse product description as provided in the prompt.

**Expected Output Criteria**:

* Anonymity is captured as an explicit, concrete requirement — not just mentioned in passing
* The constraint that no individual attribution exists in any view (including admin views) is reflected in the PRD
* At least one User Story captures an engineer's expectation or reliance on anonymity
* Dashboard requirements specify team-level aggregation only, with no drill-down to individual responses
* Data storage requirements reference anonymous response storage with no PII linkage

**Failure Criteria (must NOT occur):**

* Any view or role is described in a way that could allow tracing a response to an individual
* Anonymity is referenced only in the Context/Overview without being expressed as a verifiable requirement
* Admin or manager access is described without an explicit anonymity constraint

---

## Test Case 3: Developer Readiness and Technical Specificity

**Input**: The full TeamPulse product description as provided in the prompt.

**Expected Output Criteria:**

* Key Implementation Details references the stated tech stack (React, Node.js, PostgreSQL)
* SSO integration via Entra ID / OIDC is referenced as a concrete implementation constraint
* At least one security-related NFR is present (e.g., authentication, authorization, data isolation between teams)
* Survey scheduling behavior (weekly/bi-weekly) is described in enough detail to implement
* Notification mechanism (email or Slack) includes enough detail for a developer to begin implementation
* The PRD enables a solo developer to scope work without inventing undocumented requirements

**Failure Criteria (must NOT occur):**

* The PRD is entirely generic and omits the specified tech stack or integration context
* Authentication/SSO requirements are absent or described only in vague business terms
* Requirements are written at a strategy level only, with no developer-actionable specifics

---

## Test Case 4: Scope Boundaries and Open Questions Quality

**Input**: The full TeamPulse product description as provided in the prompt.

**Expected Output Criteria:**

* Scope Boundaries explicitly names all 4 V1 out-of-scope items: ML-based sentiment analysis, cross-team comparison, HR system integration, and mobile native apps
* Scope Boundaries includes at least one in-scope clarification alongside out-of-scope items
* Open Questions includes at least one question about notification delivery (email vs. Slack)
* Open Questions includes at least one question about survey content or configuration ownership
* Open Questions are framed as decisions that must be resolved before or during implementation, not rhetorical observations

**Failure Criteria (must NOT occur):**

* One or more of the 4 specified V1 out-of-scope items is absent from Scope Boundaries
* Open Questions are trivially answerable from the provided context (i.e., the prompt already answers them)
* Scope Boundaries section is present as a heading but contains no actual content

---

## Test Case 5: Multi-Role Requirements Coverage

**Input**: The full TeamPulse product description as provided in the prompt.

**Expected Output Criteria**:

* Features section defines at least 2 distinct personas — one for Engineer and one for Engineering Manager — with separate access scopes
* Engineer-facing requirements are limited to survey submission (receiving notifications, accessing and completing the survey form)
* Manager-facing requirements cover all three configuration responsibilities: question set, survey frequency, and team membership
* Manager-facing requirements include dashboard access with trend lines and period-over-period comparisons
* At least one User Story or Use Case exists for each role independently
* Authorization requirements reflect that engineers cannot access the manager dashboard or configuration

**Failure Criteria (must NOT occur):**

* The PRD describes the system with a single generalized user type or "user" persona without role distinction
* Engineer capabilities include any access to survey results, dashboards, or configuration
* Manager capabilities are described without covering both the configuration and results-viewing responsibilities