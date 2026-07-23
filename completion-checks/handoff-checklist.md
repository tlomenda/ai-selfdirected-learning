## Handoff Checklist Review

Every artifact you submit must be usable by a developer who was not in this program — someone who just joined a client team and found your files in the repository. Apply this checklist to each committed file:

**For each command file:**
- [x] Has a comment header: what it does, when to use it, what the expected input format is, where the test file lives
- [x] Promptfoo configuration is committed in the same directory as the command file
- [x] Every instruction is load-bearing (audit documented)
- [x] The test file exists and is referenced in the header

**For each Promptfoo configuration:**
- [x] Committed alongside the command it tests, not in a separate directory
- [x] Includes a comment describing the product domain and the constraints being tested

**For the skill file:**
- [x] Invocation description is specific enough that a new team member would understand when it should and should not trigger
- [x] Invocation test cases (positive and negative) are committed alongside it

**For the sentinel file schema:**
- [x] The schema is documented in the hook script or in a separate schema file
- [x] The relationship between the schema and the Promptfoo assertions is documented (which properties does the sentinel cover, and which are left to Promptfoo?)

**For the hook script:**
- [x] Comments explain what events trigger the hook and what decision it makes
- [x] Failure messages are clear enough for a developer to know what to fix without reading the code