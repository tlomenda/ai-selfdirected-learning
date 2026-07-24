## Test Case [1]: Quality Checklist and Review Structure

**Input**: Implementation to review to produce a structured code review report

**Expected Output Criteria**

- Pass/fail per acceptance criterion
- Specific issues with file/line references
- A clear overall verdict of the implementation quality
- The review notes what was done well, not only what's wrong (useful signal for what *not* to change)
- The overall verdict weighs severity/count of issues appropriately (e.g. one critical issue isn't buried among ten trivial nitpicks, and isn't treated the same as ten trivial nitpicks)
- Where the implementation diverges from stack conventions (e.g. raw SQL instead of parameterized queries, missing transaction), it's called out specifically

**Failure Criteria (must NOT occur):**

- Vague or missing verdict (e.g. no clear pass/fail/needs-work conclusion)
- Issues listed without any file, function, or line reference
- Acceptance criteria omitted from the report entirely
- A review that is 100% fault-finding with no acknowledgment of correct implementation
- A "fail" verdict driven by nitpicks with no critical issues, or a "pass" verdict that overlooks one critical issue among minor ones

---

## Test Case [2]: Specificity

**Input**: Implementation to review to produce a structured code review report

**Expected Output Criteria**

- The review must cite specific code, not general observations like "error handling could be improved"
- Every acceptance criterion must be explicitly addressed in the review
- Each identified issue includes a concrete suggested fix or next step, not just a description of the problem
- Issues are distinguishable as blocking vs. non-blocking (e.g. "must fix before merge" vs. "nice to have")


**Failure Criteria (must NOT occur):**

- General observations without specific code references
- An acceptance criterion marked pass/fail with no supporting evidence from the code
- Issues flagged with no indication of how to resolve them
- Critical and cosmetic issues presented with equal weight, forcing the reader to guess priority