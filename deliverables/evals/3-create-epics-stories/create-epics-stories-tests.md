# Background for Epic & Story Breakdown Quality

Before writing criteria, think through the most common ways story decomposition fails:

- **Stories that are too large:** A story that takes more than one sprint to implement is too large. How do you write a criterion for this without knowing the team's sprint velocity? Think about what signals "too large" without relying on sprint-specific context.

- **Acceptance criteria that are not testable:** "The system should be performant" is not testable. "The survey form submits in under 2 seconds on a 4G connection" is testable. Write a criterion that distinguishes these.

- **Stories that omit dependencies:** If Story B requires work from Story A, that dependency must be explicit. Write a criterion for this.

- **Stories that duplicate work:** Two stories that describe the same implementation work from different angles. How would you write a criterion that a rubric evaluator could apply?

- **Incomplete coverage:** The epics and stories should cover the full scope of the PRD. How do you test coverage without manually checking every feature?

Write at least 4 criteria covering these failure modes. Commit the test file.


## Test Case [1]: Story Breakdown Quality

**Input**: A PRD document that outlines the features and requirements for a product, along with its companion Architecture and UX design documents.

**Expected Output Criteria**

* Each story should deliver one meaningful outcome for the user. If achieving the requirement involves multiple meaningful outcomes, it should be represented as an epic with multiple stories.

* A story is small enough to be designed, implemented, tested, and accepted as a single, independently deliverable increment of value. 

* A story should represent a single, testable slice of user value that can be completed and accepted independently.

**Failure Criteria (must NOT occur):**

* A story that describes multiple user-observed outcomes or requires changes across multiple vertical slices is too large (ie: description contains "and" or "also" or "as well as" connecting independent behaviors)

* A story that contains multiple independently testable capabilities, workflows, or outcomes.

## Test Case [2]: Acceptance Criteria Quality

**Input**: A PRD document that outlines the features and requirements for a product, along with its companion Architecture and UX design documents.

**Expected Output Criteria**

* AC validates user behavior (ie: has an observable input, a measurable outcome/result or threshold)

* AC outcomes/results are testable and measurable (ie: AC can be turned into an automated test assertion or a strict yes/no manual check)

* AC has at least one happy path scenario with Given-When-Then format

* AC has at least one edge case or error scenario with Given-When-Then format

**Failure Criteria (must NOT occur):**

* AC is subjective, vague or unclear

* AC is not testable or measurable

## Test Case [3]: Epic Coverage and Completeness

**Input**: A PRD document that outlines the features and requirements for a product, along with its companion Architecture and UX design documents.

**Expected Output Criteria**

* Each story represents a distinct increment of functionality. Two stories should not require substantially the same implementation work to satisfy their acceptance criteria.

* Each story that depends on another story before it can be implemented, tested, or provide value must explicitly identify that dependency.

* Each functional requirement described in the PRD is represented by one or more epics or user stories.


**Failure Criteria (must NOT occur):**

* A PRD functional requirement is left without backlog coverage (epics and stories).

* Stories describe the same capability or primary deliverable

* Stories have substantially overlapping acceptance criteria

* Stories that would be completed by implementing essentially the same functionality