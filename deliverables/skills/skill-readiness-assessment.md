## Invocation Boundary Analsysis

### create-epics-stories

**Command 1:** [create-epics-stories]

1. What input or context triggers a human to run this command? (Be specific — what are they looking at, thinking about, or working on when they decide to invoke it?)
- Having a well-documented PRD, Architecture (Solution Design Doc), and optionally a UX Specification for applications with a user interface
- Backlog Creation Triggers
    "How do I break this into manageable pieces?"
    "What epics should this feature set contain?"
    "What stories will developers actually work on?"
    They need to populate Jira, Azure DevOps, Rally, or another planning tool.
    They need acceptance criteria detailed enough for sprint planning.
- Estimation Triggers
    The team needs story-point estimates but no stories exist yet.
    A PI Planning, Quarterly Planning, Sprint 0, or Release Planning event is approaching.
    Product and engineering need to understand implementation scope and dependencies.
- Gap Analysis Triggers
    Verify that all requirements have been covered by planned work.
    Verify requirements, architecture, and UX specifications are aligned.
    Traceability from requirements → epics → stories → acceptance criteria.
- Project Initiation Triggers
    A new initiative, product, or major enhancement is starting.
    A discovery or design phase has ended and delivery planning is beginning.
    An MVP has been defined and must be converted into implementation work.
- Kye Triggers
    "I have the requirements. Now I need the implementation plan."
    "What work needs to be done to build this?"
    "Can someone generate the epics, stories, acceptance criteria, and dependencies for me?"
    "I need a backlog that covers the entire scope before planning starts."

2. Could the model identify that trigger from context alone, without the human explicitly thinking "I should run this command"? Why or why not?
Yes. If the user provides context such as:

- Requirements + architecture + UX documents
- A PRD and asks for "implementation planning"
- A requirements document and asks for "what work is required"
- A feature specification and asks for "sprint planning"
- Questions like:
    "How should we estimate this?"
    "What should go into Jira?"
    "How would you break this down?"
    "What are the epics for this initiative?"
    "Can you create a delivery plan?"

Then the model can reasonably infer: The user is trying to transform solution documentation into a delivery backlog.
In these situations, invoking `create-epics-stories` is likely the most relevant skill.

3. What is the harm if the model invokes this command at the wrong time? (Consider: what downstream actions depend on its output? Who acts on the output before reviewing it?)
The harm is low since it does not lead to immediate downstream execution. It typically is reviewed and refined before making its way into the product mgmt tool. If this skill is invoked and mistakenly generates an epic/story breakdown, a user can simply ignore the output. However, there might be lost time and attention in order to determine why the skill was invoked
incorrectly and how to fix that.

If the skill is invoked incorrectly, it could provide incorrect completeness, lead to incorrect stories and miss critical features. This skill is safer when:
- Requirements are reasonably stable.
- Architecture direction is known.
- UX direction is known.
- The next activity is backlog creation, estimation, or planning

4. What is the harm if the model fails to invoke it when it should? (Is the failure mode "human does the work manually" or "the step gets skipped entirely"?)

The harm is the user does the work manually. This typically means the user knows what activity is being informed and what input is needed, so they can initiate the skill manually to trigger it.

The more serious harm is this activity is skipped completely jumping right to implementation - missing requirements, hidden dependencies, poor estimates, inconsistent AC and traceability.

5. What ambiguous cases exist where you would not be sure whether to invoke this command? What would the model probably do in those cases?

The ambiguity can come into play when my intent is not clear. Do I want more analysis OR a decomposition?

Some examples:

**User Wants Analysis vs. Decomposition**
```
User says:

"Review this PRD and architecture document."

Possible intents:

Architecture review
Gap analysis
Requirements validation
Story decomposition

The model cannot reliably tell which outcome is desired.

What the model would likely do:

Summarize or review the documents.
Identify gaps or inconsistencies.
Avoid automatically generating epics and stories because that is a much larger, more opinionated transformation.
```

**Mixed Signals**
```
User says:

"I need to prepare for PI Planning next week."

This is one of the hardest cases.

Possible interpretations:

Create epics and stories
Estimate work
Build roadmap
Identify dependencies
Create presentation material

All are reasonable.

What the model would likely do:

Ask a clarifying question or provide planning guidance.
Triggering create-epics-stories would be plausible but not certain.
```

---

### plan-story

**Command 2:** [plan-story]

1. What input or context triggers a human to run this command? (Be specific — what are they looking at, thinking about, or working on when they decide to invoke it?)

A user would typically invoke a `plan-story` command when they have already decided what needs to be built (the story is written and approved) but need guidance on how to build it within the constraints of the product, architecture, and technology stack.

A technical plan can be produced when the user has:
- A specific user story or technical story
- Access to supporting documents (PRD, architecture, UX, tech stack)
- Questions about implementation approach
- Need for task breakdown or estimation
- Need to identify impacted components
- Need to understand dependencies or risks

**A Simple Trigger Rule**

Invoke plan-story when a story has been defined and approved, and the next question is no longer "What should we build?" but rather "How should we implement it?"

2. Could the model identify that trigger from context alone, without the human explicitly thinking "I should run this command"? Why or why not?
Yes, in many cases the model could identify the trigger from context alone because the surrounding artifacts often reveal that the user has moved from requirements definition into implementation planning. For example, if the user provides a specific story along with references to a PRD, architecture document, UX specification, or technology stack and asks questions such as "how should we implement this?", "what tasks are needed?", or "what systems are impacted?", those are strong signals that a technical plan is needed. 

Ambiguous requests like "review this story" or "help me understand this requirement" may not justify invoking the skill. As a result, the model can often infer the need for plan-story, but confidence depends on whether the user's intent is clearly focused on implementation planning rather than analysis, review, or requirements clarification.

3. What is the harm if the model invokes this command at the wrong time? (Consider: what downstream actions depend on its output? Who acts on the output before reviewing it?)
If the model invokes plan-story at the wrong time, the primary harm is wasted effort and potentially misleading output. A technical plan can create an illusion that implementation details have been validated when requirements, architecture decisions, or UX designs are still incomplete or under discussion. 

Teams may begin estimating, creating tasks, or even implementing work based on assumptions embedded in the generated plan, causing rework later. The output is typically consumed by developers, architects, technical leads, or scrum teams before a detailed human review occurs, so inaccuracies can propagate into sprint plans and execution activities. While the risk is usually not catastrophic because humans generally review technical plans before coding, premature plans can still increase confusion, estimation errors, and development churn.

4. What is the harm if the model fails to invoke it when it should? (Is the failure mode "human does the work manually" or "the step gets skipped entirely"?)
If the model fails to invoke plan-story when it should, the most common outcome is that a human performs the planning work manually rather than the step being skipped entirely. Developers, architects, or technical leads will typically analyze the story, review supporting documents, and create their own implementation approach. 

This is typically done by whiteboarding, brainstorming, and task card creation, which can be time-consuming and may lack the structured documentation that the skill would provide. This can take away from the productivity gains that the command is intended to provide. 

Impacts and dependencies may be overlooked, resulting in extra development iterations to complete the implementation details.

5. What ambiguous cases exist where you would not be sure whether to invoke this command? What would the model probably do in those cases?
Ambiguous cases include requests that are unclear about the user's intent, such as "help me with this story" without specifying whether they need analysis, planning, or implementation guidance. 

The model would likely err on the side of caution and not invoke the skill if the context is insufficient, as the risk of generating an inaccurate plan outweighs the benefit of premature planning. In such cases, the model would probably ask for clarification or suggest a more specific request.


---

## Team Consensus Simulation - plan-story command

Imagine there are two engineers who both use this command independently. They have both been happy with it in their own workflows. They are now asked to agree on a shared version — one skill that both will use, with one shared definition of when it should invoke.

**Scenario 1: Story Refinement vs. Implementation Planning**

Engineer A's expectation:
Invoke plan-story as soon as a story enters backlog refinement so the team can understand scope, dependencies, and implementation complexity before estimating.

Engineer B's expectation:
Do not invoke plan-story until the story is approved, stable, and ready for development because early plans are often invalidated by requirement changes.

Consequence of disagreement:
If the skill invokes during refinement, Engineer B receives premature technical plans that create noise and may contain assumptions that later become obsolete. If it does not invoke, Engineer A loses a tool they rely on for estimation and refinement discussions.

Agreement needed:
The team must define whether the skill is intended for story refinement, development-ready stories, or both, and specify the minimum maturity level of a story before invocation.

---

**Scenario 2: Incomplete Supporting Documentation**

Engineer A's expectation:
Invoke even when some inputs are missing and generate a best-effort plan with assumptions.

Engineer B's expectation:
Do not invoke unless the story, requirements, architecture, UX, and technology context are sufficiently complete.

Consequence of disagreement:
If the skill invokes, Engineer B receives plans based on assumptions that may be incorrect. If it does not invoke, Engineer A loses the ability to accelerate planning in environments where documentation is often incomplete.

Agreement needed:
The team must define the minimum required inputs and whether assumption-based planning is acceptable.

---

**What Must Be Agreed Upon Before Creating a Shared Skill**

The engineers should document:

- Primary purpose of the skill (implementation planning, estimation support, architectural impact analysis, or some combination).
- Required inputs (story only, story + requirements, story + architecture, story + UX, etc.).
- Minimum story readiness level (draft, refinement, ready for development, or in-progress).
- Expected outputs (technical plan, task breakdown, dependency analysis, risk assessment, implementation guidance).
- Whether assumptions are allowed when documentation is incomplete.
- Explicit invocation criteria describing the signals that indicate the user is asking "How should we implement this?" rather than "What should we build?" or "Is this requirement correct?"

Without agreement on these points, different users will have different expectations about when the skill should activate, leading to inconsistent behavior and dissatisfaction with a shared version of the skill.

---

### Some additional thoughts

- Since AI-Assisted SDLC Workflows are becoming more common and encourage a readiness-based approach for upstream outputs (ie: Waterfall-like), it might be beneficial to align the skill's invocation criteria where the story is in a more mature state (ie: ready for development).

- There could be other supporting skills/tasks that could be used for off-shoot steps in the SDLC workflow, such as estimation, architectural impact analysis, or risk assessment.

