# TeamPulse — Epics and User Stories Breakdown

## 1. Epics

### EPIC-01: Manager Authentication & Session Management
| Field | Value |
|-------|-------|
| **Epic ID** | EPIC-01 |
| **Name** | Manager Authentication & Session Management |
| **Summary** | Enable engineering managers to authenticate via company SSO (Entra ID/OIDC), establish secure sessions, and log out, providing the identity foundation for all manager-facing functionality. |
| **Business Value** | Satisfies the P0 security requirement that managers use corporate identity; eliminates local credential storage and its associated breach risk; enables team-scoped authorization across the platform. |
| **Stories** | US-1.1, US-1.2, TS-1.3, TS-1.4 |

### EPIC-02: Survey Configuration & Lifecycle Management
| Field | Value |
|-------|-------|
| **Epic ID** | EPIC-02 |
| **Name** | Survey Configuration & Lifecycle Management |
| **Summary** | Allow managers to create, edit, deactivate, and list recurring pulse surveys with 5–7 custom questions, and enable the system to schedule future survey runs automatically. |
| **Business Value** | Delivers the core manager configuration capability; drives the recurring feedback loop that produces trend data; ensures changes apply only to future runs to protect historical data integrity. |
| **Stories** | US-2.1, US-2.2, US-2.3, US-2.4, TS-2.5, TS-2.6, TS-2.7, TS-2.8 |

### EPIC-03: Anonymous Survey Response Collection
| Field | Value |
|-------|-------|
| **Epic ID** | EPIC-03 |
| **Name** | Anonymous Survey Response Collection |
| **Summary** | Provide engineers with a frictionless, mobile-responsive, anonymous survey form accessed via a single-use, time-limited token, and allow them to request a replacement link if the original expires. |
| **Business Value** | Captures candid team-health feedback without attribution; supports the under-3-minute completion target; protects psychological safety by design. |
| **Stories** | US-3.1, US-3.2, US-3.3, US-3.4, TS-3.5, TS-3.6, TS-3.7, TS-3.8 |

### EPIC-04: Survey Notification Delivery
| Field | Value |
|-------|-------|
| **Epic ID** | EPIC-04 |
| **Name** | Survey Notification Delivery |
| **Summary** | Deliver survey invitations to engineers through the channel configured by the manager (email and/or Slack), including a unique, single-use tokenized link valid for seven days, with retry logic for failed deliveries. |
| **Business Value** | Drives survey participation; enables channel choice; supports the recurring schedule by ensuring engineers know when and where to respond. |
| **Stories** | US-4.1, TS-4.2, TS-4.3, TS-4.4 |

### EPIC-05: Team Health Dashboard & Analytics
| Field | Value |
|-------|-------|
| **Epic ID** | EPIC-05 |
| **Name** | Team Health Dashboard & Analytics |
| **Summary** | Present managers with aggregated trend lines, period-over-period comparisons, and date-range filters so they can understand team health without viewing individual responses. |
| **Business Value** | Translates raw anonymous feedback into actionable, manager-ready insights; supports evidence-based decisions about team health initiatives. |
| **Stories** | US-5.1, US-5.2, US-5.3, TS-5.4, TS-5.5, TS-5.6 |

### EPIC-06: Data Isolation, Privacy & Authorization
| Field | Value |
|-------|-------|
| **Epic ID** | EPIC-06 |
| **Name** | Data Isolation, Privacy & Authorization |
| **Summary** | Enforce that each manager sees only their own team's aggregated data, that engineers cannot reach dashboards or other responses, and that all anonymous guarantees hold at storage, API, and UI layers. |
| **Business Value** | Preserves confidentiality and trust; satisfies data-privacy NFRs; prevents cross-team leakage and accidental attribution. |
| **Stories** | US-6.1, US-6.2, TS-6.3, TS-6.4, TS-6.5 |

### EPIC-07: Security, Compliance & Platform Quality
| Field | Value |
|-------|-------|
| **Epic ID** | EPIC-07 |
| **Name** | Security, Compliance & Platform Quality |
| **Summary** | Implement CSRF protection, rate limiting, encryption, audit logging, accessibility (WCAG 2.1 AA), internationalization, and other cross-cutting quality attributes required for production readiness. |
| **Business Value** | Reduces attack surface and legal risk; ensures the product is usable by a diverse workforce; meets corporate compliance and procurement standards. |
| **Stories** | TS-7.1, TS-7.2, TS-7.3, TS-7.4, TS-7.5, TS-7.6 |

### EPIC-08: Infrastructure, Observability & Operations
| Field | Value |
|-------|-------|
| **Epic ID** | EPIC-08 |
| **Name** | Infrastructure, Observability & Operations |
| **Summary** | Provision deployment environments, CI/CD, monitoring, alerting, structured logging, and performance validation so the system can be released, operated, and scaled with confidence. |
| **Business Value** | Enables reliable delivery, rapid incident response, and 99.5% uptime; supports the 100-concurrent-user and 10,000-response/month scalability targets. |
| **Stories** | TS-8.1, TS-8.2, TS-8.3, TS-8.4, TS-8.5, SP-8.6, SP-8.7, SP-8.8 |

## 2. All User Story Details

### US-1.1 — Manager logs in via company SSO
| Field | Value |
|-------|-------|
| **Story ID** | US-1.1 |
| **Type** | user |
| **Title** | Manager logs in via company SSO |
| **Description** | **As a** manager, **I want** to sign in with my company's Entra ID / OIDC account, **so that** I can access TeamPulse without creating or remembering a separate password. |
| **Priority** | P0 |
| **Traceability** | PRD: Persona 1, Use Case 4, NFR-9; Architecture: §2.2, §6.3, §8.1, ADR-2; UX: §3 Persona 1, §4.1, §6.1, §13 Manager Workflows |
| **Dependencies** | **Blocked by:** TS-1.3 (OIDC backend), TS-1.4 (manager data model). **Blocks:** US-2.1, US-2.4, US-5.1, US-6.1. **Related:** US-1.2 |

**Acceptance Criteria**

```gherkin
Scenario: Manager initiates SSO login from the landing page
  Given a manager is on the TeamPulse login page
  When they click "Sign in with Company SSO"
  Then they are redirected to the Entra ID / OIDC authorization endpoint
  And the login button enters a loading state
```

```gherkin
Scenario: Manager completes login and lands on dashboard
  Given a manager has authenticated successfully with Entra ID
  When the OIDC callback is processed
  Then a secure session is established
  And the manager is redirected to the dashboard
  And their name or email appears in the account menu
```

```gherkin
Scenario: Login failure shows a helpful error without leaking information
  Given a manager is on the login page
  When the OIDC provider returns an error or invalid token
  Then the page displays a generic error message
  And no other team's data or internal details are exposed
```

---

### US-1.2 — Manager logs out
| Field | Value |
|-------|-------|
| **Story ID** | US-1.2 |
| **Type** | user |
| **Title** | Manager logs out |
| **Description** | **As a** manager, **I want** to log out of TeamPulse, **so that** my session ends and no one else can access my team's data from my device. |
| **Priority** | P0 |
| **Traceability** | PRD: Persona 1; Architecture: §6.3, ADR-2; UX: §5.1 Manager Navigation, §13 Manager Workflows |
| **Dependencies** | **Blocked by:** US-1.1, TS-1.3. **Blocks:** none. **Related:** none |

**Acceptance Criteria**

```gherkin
Scenario: Manager logs out from the header menu
  Given a manager is authenticated
  When they select "Logout" from the account dropdown
  Then the session token is invalidated
  And they are redirected to the login page
  And navigating back does not restore the authenticated dashboard
```

```gherkin
Scenario: Session expiration redirects to login
  Given a manager has an expired or revoked session
  When they attempt to access the dashboard
  Then they are redirected to the login page
  And a message explains that the session has expired
```

---

### US-2.1 — Manager creates a new pulse survey
| Field | Value |
|-------|-------|
| **Story ID** | US-2.1 |
| **Type** | user |
| **Title** | Manager creates a new pulse survey |
| **Description** | **As a** manager, **I want** to create a new pulse survey with a title, team, frequency, start time, and 5–7 custom questions, **so that** I can collect feedback relevant to my team's current challenges. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 1.1, Feature Summary; Architecture: §3.1, §4.1, §5.1, §6.1; UX: §3 Manager Goals, §4.1, §6.2, §7.1, §13 |
| **Dependencies** | **Blocked by:** US-1.1, TS-2.5, TS-2.6. **Blocks:** US-2.2, US-2.3, US-2.4, US-4.1, US-5.1, TS-2.7. **Related:** TS-4.2, TS-4.3 |

**Acceptance Criteria**

```gherkin
Scenario: Manager successfully creates a survey
  Given a manager is authenticated and on the create-survey page
  When they enter a title, select a team, choose a frequency, set a future start date/time, and add 5–7 questions
  And they submit the form
  Then the survey is persisted
  And a success message is displayed
  And the survey appears on the dashboard with status "Active"
```

```gherkin
Scenario: Manager tries to create a survey with fewer than five questions
  Given a manager is creating a survey
  When they enter only 3 questions
  And they submit the form
  Then the form displays a validation error
  And the survey is not created
```

```gherkin
Scenario: Manager tries to create a survey with a past start date
  Given a manager is creating a survey
  When they set the start date/time in the past
  And they submit the form
  Then the form displays a validation error
  And the survey is not created
```

```gherkin
Scenario: No notifications are sent before the configured start time
  Given a manager created a survey with a future start time
  When the current time is before that start time
  Then no survey invitations are sent
  And no survey run is considered active
```

---

### US-2.2 — Manager edits survey configuration
| Field | Value |
|-------|-------|
| **Story ID** | US-2.2 |
| **Type** | user |
| **Title** | Manager edits survey configuration |
| **Description** | **As a** manager, **I want** to modify an existing survey's title, frequency, questions, or team membership, **so that** I can adjust the survey when my team's needs change. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 1.2; Architecture: §3.1, §4.1, §6.1; UX: §3, §4.3, §7.1, §12.1, §13 |
| **Dependencies** | **Blocked by:** US-2.1, TS-2.6. **Blocks:** none. **Related:** US-2.3 |

**Acceptance Criteria**

```gherkin
Scenario: Manager edits a future-facing survey
  Given a manager has an active survey that has not yet started its next run
  When they change the questions and frequency
  And they confirm the changes
  Then the survey configuration is updated
  And a success message is displayed
  And the changes apply to future runs only
```

```gherkin
Scenario: Manager edits a survey while a run is active
  Given a manager has a survey with an active response window
  When they edit the survey
  Then the current run remains unchanged
  And a message explains that changes apply to future runs starting on the next scheduled date
```

```gherkin
Scenario: Manager cannot edit another manager's survey
  Given a manager is authenticated
  When they attempt to edit a survey they do not own
  Then the system returns a 403 Forbidden response
  And an error message is displayed
```

---

### US-2.3 — Manager deactivates a survey
| Field | Value |
|-------|-------|
| **Story ID** | US-2.3 |
| **Type** | user |
| **Title** | Manager deactivates a survey |
| **Description** | **As a** manager, **I want** to stop a recurring survey with a single action, **so that** no further notifications are sent while preserving historical trend data. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 1.3; Architecture: §4.1, §6.1; UX: §4.4, §6.2, §11.3, §13 |
| **Dependencies** | **Blocked by:** US-2.1, TS-2.6. **Blocks:** none. **Related:** US-2.2 |

**Acceptance Criteria**

```gherkin
Scenario: Manager deactivates an active survey
  Given a manager has an active survey on the dashboard
  When they click "Deactivate" and confirm in the modal
  Then the survey status changes to "Inactive"
  And future notifications are stopped
  And historical data remains visible in the dashboard
```

```gherkin
Scenario: Manager cancels deactivation
  Given a manager has clicked "Deactivate" on a survey
  When they dismiss the confirmation modal
  Then the survey remains active
  And no status change occurs
```

---

### US-2.4 — Manager views list of surveys
| Field | Value |
|-------|-------|
| **Story ID** | US-2.4 |
| **Type** | user |
| **Title** | Manager views list of surveys |
| **Description** | **As a** manager, **I want** to see all my active and inactive surveys in one place, **so that** I can quickly choose one to view, edit, or deactivate. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 3 (dashboard entry), Feature Summary; Architecture: §3.3, §6.1; UX: §4.2, §5.1, §6.2, §8.4, §13 |
| **Dependencies** | **Blocked by:** US-1.1, US-2.1, TS-2.6. **Blocks:** US-5.1, US-2.2, US-2.3. **Related:** none |

**Acceptance Criteria**

```gherkin
Scenario: Manager sees active and inactive surveys
  Given a manager is authenticated and has multiple surveys
  When they land on the dashboard
  Then active surveys are displayed in one section
  And inactive surveys are displayed in another section
  And each card shows title, team, frequency, and response count
```

```gherkin
Scenario: Empty state for new manager
  Given a manager has no surveys
  When they land on the dashboard
  Then an empty state message is shown
  And a "Create New Survey" call-to-action is visible
```

### US-3.1 — Engineer receives survey notification
| Field | Value |
|-------|-------|
| **Story ID** | US-3.1 |
| **Type** | user |
| **Title** | Engineer receives survey notification |
| **Description** | **As an** engineer, **I want** to receive an email or Slack notification containing a unique, single-use survey link, **so that** I know when and where to provide feedback. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 2.1, Feature Summary, NFR-8; Architecture: §2.2, §3.1, §7.1, §8.4; UX: §3 Engineer Goals, §4.5, §4.6, §11.3, §13 |
| **Dependencies** | **Blocked by:** TS-2.7, TS-3.6, TS-4.2/TS-4.3. **Blocks:** US-3.2. **Related:** US-4.1 |

**Acceptance Criteria**

```gherkin
Scenario: Engineer receives email notification at scheduled start time
  Given a survey run begins at the configured start time
  When the notification job executes
  Then each engineer on the team receives an email
  And the email contains a unique single-use link
  And the link includes a token valid for 7 days
```

```gherkin
Scenario: Engineer receives Slack notification
  Given a manager selected Slack as the notification method
  When a survey run begins
  Then each engineer receives a Slack direct message
  And the message contains a unique single-use survey link
```

```gherkin
Scenario: Duplicate notifications for the same run contain different tokens
  Given an engineer receives multiple notifications for one survey run
  When they inspect each link
  Then each link contains a distinct token
  And any unused token can be used to access the survey
```

---

### US-3.2 — Engineer accesses survey form via tokenized link
| Field | Value |
|-------|-------|
| **Story ID** | US-3.2 |
| **Type** | user |
| **Title** | Engineer accesses survey form via tokenized link |
| **Description** | **As an** engineer, **I want** to click my survey link and see the correct survey form, **so that** I can provide feedback without logging in. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 2.2, NFR-8; Architecture: §3.2, §6.2, ADR-3; UX: §4.5, §6.3, §12.2 |
| **Dependencies** | **Blocked by:** US-3.1, TS-3.6. **Blocks:** US-3.3. **Related:** US-3.4 |

**Acceptance Criteria**

```gherkin
Scenario: Valid token opens the survey form
  Given an engineer clicks a valid, unused survey link
  When the system validates the token
  Then the survey form is displayed
  And the token is marked as used
  And no identifying information is shown
```

```gherkin
Scenario: Expired token shows request-new-link option
  Given an engineer clicks a link whose token has expired
  When the form loads
  Then an error page explains the link has expired
  And a form to request a new link is available
```

```gherkin
Scenario: Already-used token shows request-new-link option
  Given an engineer clicks a link whose token has already been used
  When the form loads
  Then an error page explains the link has already been used
  And a form to request a new link is available
```

---

### US-3.3 — Engineer completes and submits anonymous survey
| Field | Value |
|-------|-------|
| **Story ID** | US-3.3 |
| **Type** | user |
| **Title** | Engineer completes and submits anonymous survey |
| **Description** | **As an** engineer, **I want** to answer 5–7 questions quickly on any device and submit my response, **so that** I can share feedback without spending much time. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 2.2, NFR-1, NFR-3, NFR-5, NFR-7; Architecture: §3.3, §5.2, §6.2, ADR-1; UX: §3, §4.5, §6.3, §7.2, §8.3, §9, §10, §12.2, §13 |
| **Dependencies** | **Blocked by:** US-3.2, TS-3.5, TS-3.7. **Blocks:** US-5.1. **Related:** US-3.4 |

**Acceptance Criteria**

```gherkin
Scenario: Engineer submits a complete survey
  Given an engineer has opened a valid survey form
  When they answer all required questions
  And they click "Submit"
  Then the response is stored anonymously
  And a confirmation page is displayed
  And the page reassures them the response is anonymous
```

```gherkin
Scenario: Engineer submits incomplete survey
  Given an engineer has opened a valid survey form
  When they leave required questions unanswered
  And they click "Submit"
  Then the form displays validation errors
  And required fields are highlighted
  And no response is stored
```

```gherkin
Scenario: Engineer accidentally double-clicks submit
  Given an engineer has already submitted a response for the current run
  When they attempt to submit again using the same token
  Then the system rejects the duplicate submission
  And a message explains that a response was already recorded
```

```gherkin
Scenario: Survey renders on a narrow mobile viewport
  Given an engineer opens the survey on a 320px-wide device
  When the page loads
  Then the form renders without horizontal scrolling
  And all controls are at least 44px tall
```

---

### US-3.4 — Engineer requests a new survey link
| Field | Value |
|-------|-------|
| **Story ID** | US-3.4 |
| **Type** | user |
| **Title** | Engineer requests a new survey link |
| **Description** | **As an** engineer, **I want** to request a replacement survey link if my original expired, **so that** I can still provide feedback after the initial window closes. |
| **Priority** | P1 |
| **Traceability** | PRD: Use Case 2.3, Feature Summary, NFR-8; Architecture: §6.2, §8.4; UX: §3, §4.6, §6.3, §11.3, §12.2, §13 |
| **Dependencies** | **Blocked by:** TS-3.6, TS-3.8, TS-4.2. **Blocks:** none. **Related:** US-3.1, US-3.2 |

**Acceptance Criteria**

```gherkin
Scenario: Engineer requests a new link within allowed limit
  Given an engineer's token has expired
  And they have made fewer than 3 requests for this survey run
  When they enter their email on the request-new-link form
  Then a new link is generated
  And it is sent within 1 minute
  And the new link is valid for 7 days
```

```gherkin
Scenario: Engineer exceeds new-link request limit
  Given an engineer has already requested 3 new links for the current run
  When they submit another request
  Then the system returns a rate-limit error
  And the message says "Too many requests. Please try again later."
```

```gherkin
Scenario: Engineer requests a link for an email not on the team
  Given an email address that is not assigned to the survey's team
  When a link request is submitted
  Then the system shows a generic confirmation message
  And no new token is generated
```

---

### US-4.1 — Manager configures notification method
| Field | Value |
|-------|-------|
| **Story ID** | US-4.1 |
| **Type** | user |
| **Title** | Manager configures notification method |
| **Description** | **As a** manager, **I want** to choose whether survey invitations are sent by email, Slack, or both, **so that** I can reach my team through their preferred channel. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 2.1, Notification Delivery section; Architecture: §7.1; UX: §4.1, §6.2, §7.1 |
| **Dependencies** | **Blocked by:** US-2.1, TS-4.2, TS-4.3. **Blocks:** US-3.1. **Related:** TS-4.4 |

**Acceptance Criteria**

```gherkin
Scenario: Manager selects email notifications
  Given a manager is creating a survey
  When they choose "Email" as the notification method
  And they complete the survey creation
  Then future survey runs send email invitations
```

```gherkin
Scenario: Manager selects both email and Slack notifications
  Given a manager is creating a survey
  When they choose "Email and Slack"
  And they complete the survey creation
  Then future survey runs send both email and Slack invitations
```

```gherkin
Scenario: Slack requires authorization before selection
  Given a manager chooses Slack for the first time
  When they attempt to save the survey
  Then they are prompted to authorize the Slack workspace
  And the survey cannot be saved until authorization succeeds
```

---

### US-5.1 — Manager views trend dashboard
| Field | Value |
|-------|-------|
| **Story ID** | US-5.1 |
| **Type** | user |
| **Title** | Manager views trend dashboard |
| **Description** | **As a** manager, **I want** to see trend lines for each survey question over time, **so that** I can identify patterns and changes in team health. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 3.1, NFR-2, NFR-7; Architecture: §3.1, §3.2, §6.1; UX: §3, §4.2, §6.2, §7.1, §8.4, §12.1, §13 |
| **Dependencies** | **Blocked by:** US-2.4, US-3.3, TS-5.4, TS-5.5, TS-5.6. **Blocks:** US-5.2, US-5.3. **Related:** US-6.1 |

**Acceptance Criteria**

```gherkin
Scenario: Dashboard displays trend lines with sufficient data
  Given a survey has at least 4 weeks of aggregated response data
  When the manager opens the dashboard
  Then one trend line is shown per question
  And the x-axis shows survey run dates
  And the y-axis shows the aggregated metric
  And hovering a data point shows the exact value and response count
```

```gherkin
Scenario: Dashboard with no responses shows empty state
  Given a survey has no responses yet
  When the manager opens the dashboard
  Then an empty state message is displayed
  And no trend chart is rendered
```

```gherkin
Scenario: Dashboard with very few responses shows warning
  Given a survey has 1 or 2 responses per run
  When the manager opens the dashboard
  Then the trend line is shown
  And a warning explains that trends may not be representative
```

```gherkin
Scenario: No individual data is exposed on dashboard
  Given a manager is viewing the dashboard
  When they inspect the page and network responses
  Then no individual response values or engineer identifiers are visible
  And only aggregated averages and counts are shown
```

---

### US-5.2 — Manager views period-over-period comparison
| Field | Value |
|-------|-------|
| **Story ID** | US-5.2 |
| **Type** | user |
| **Title** | Manager views period-over-period comparison |
| **Description** | **As a** manager, **I want** to compare aggregated metrics between two survey runs side by side, **so that** I can assess whether recent changes have impacted team health. |
| **Priority** | P1 |
| **Traceability** | PRD: Use Case 3.2; Architecture: §4.3, §6.1; UX: §3, §4.2, §7.1, §13 |
| **Dependencies** | **Blocked by:** US-5.1, TS-5.4, TS-5.5. **Blocks:** none. **Related:** US-5.3 |

**Acceptance Criteria**

```gherkin
Scenario: Manager compares two survey runs
  Given a manager is on the dashboard
  When they select two different survey runs from the comparison dropdown
  Then side-by-side aggregated scores and response counts are displayed
  And the percentage change is shown for each question
  And upward changes use an up arrow and downward changes use a down arrow
```

```gherkin
Scenario: Manager selects the same run twice
  Given a manager is on the comparison view
  When they select the same survey run for both periods
  Then the system displays a validation message
  And no comparison is rendered
```

```gherkin
Scenario: Comparison view hides individual data
  Given a manager is viewing the comparison
  Then only aggregated metrics are shown
  And no engineer identifiers or individual responses are visible
```

---

### US-5.3 — Manager filters dashboard by date range
| Field | Value |
|-------|-------|
| **Story ID** | US-5.3 |
| **Type** | user |
| **Title** | Manager filters dashboard by date range |
| **Description** | **As a** manager, **I want** to view trend data for a specific date range, **so that** I can focus on a particular period of interest. |
| **Priority** | P1 |
| **Traceability** | PRD: Use Case 3.3; Architecture: §6.1; UX: §3, §4.2, §6.2, §7.1, §12.1, §13 |
| **Dependencies** | **Blocked by:** US-5.1, TS-5.5. **Blocks:** none. **Related:** US-5.2 |

**Acceptance Criteria**

```gherkin
Scenario: Dashboard loads with default 12-week range
  Given a manager opens the dashboard
  Then the date range picker defaults to the last 12 weeks
  And trend lines show only data within that range
```

```gherkin
Scenario: Manager selects a custom date range
  Given a manager is on the dashboard
  When they select a start and end date
  Then the trend lines update to show only data within the selected range
  And the response counts reflect the filtered runs
```

```gherkin
Scenario: Selected range contains no data
  Given a manager selects a date range with no survey runs
  When the dashboard updates
  Then a message says "No data available for the selected date range"
  And a suggestion to adjust the range is shown
```

---

### US-6.1 — Manager can only view own team's data
| Field | Value |
|-------|-------|
| **Story ID** | US-6.1 |
| **Type** | user |
| **Title** | Manager can only view own team's data |
| **Description** | **As a** manager, **I want** my dashboard and APIs to expose only my own team's surveys and aggregated data, **so that** I cannot access other teams' confidential information. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 4.1, NFR-6, Scope; Architecture: §3.2, §6.1, §8.1, §8.2; UX: §3, §5.1, §13 |
| **Dependencies** | **Blocked by:** US-1.1, TS-6.3, TS-6.5. **Blocks:** US-5.1, US-2.2, US-2.3. **Related:** US-6.2 |

**Acceptance Criteria**

```gherkin
Scenario: Manager sees only their own surveys
  Given two managers each own different teams and surveys
  When each manager logs in
  Then each dashboard lists only the surveys for the teams they manage
```

```gherkin
Scenario: Manager cannot access another team's survey via URL
  Given a manager is authenticated
  When they navigate to a URL for another manager's survey
  Then the API returns 403 Forbidden
  And the UI shows an access-denied message
```

```gherkin
Scenario: Cross-team data is never returned in list responses
  Given a manager requests the survey list
  When the response is returned
  Then it contains only surveys whose team_id matches the manager's teams
  And no other team's names or identifiers are leaked
```

---

### US-6.2 — Engineer cannot access dashboard or other responses
| Field | Value |
|-------|-------|
| **Story ID** | US-6.2 |
| **Type** | user |
| **Title** | Engineer cannot access dashboard or other responses |
| **Description** | **As an** engineer, **I want** my survey link to grant access only to the survey form and not to dashboards or other responses, **so that** I can trust that my feedback is anonymous. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 4.2, NFR-6, NFR-7; Architecture: §3.2, §6.2, §8.1, §8.2; UX: §3, §4.5, §6.3, §12.2, §13 |
| **Dependencies** | **Blocked by:** US-3.2, TS-6.4. **Blocks:** none. **Related:** US-6.1 |

**Acceptance Criteria**

```gherkin
Scenario: Engineer navigates to a dashboard URL
  Given an engineer has a valid survey token
  When they attempt to access a manager dashboard URL
  Then the system returns 403 Forbidden
  And no dashboard data is rendered
```

```gherkin
Scenario: Engineer token cannot list surveys
  Given an engineer authenticates with a survey token
  When they call a manager-only API endpoint
  Then the API returns 403 Forbidden
  And no survey or response data is returned
```

```gherkin
Scenario: Survey form shows no identifying data
  Given an engineer opens the survey form
  Then the form does not display their email, name, or any other engineer's information
```

## 3. All Technical Story Details

### TS-1.3 — Implement OIDC authentication flow and JWT session management
| Field | Value |
|-------|-------|
| **Story ID** | TS-1.3 |
| **Type** | technical |
| **Title** | Implement OIDC authentication flow and JWT session management |
| **Description** | Build the backend OIDC integration with Entra ID, implement `/api/v1/auth/login`, `/api/v1/auth/callback`, and `/api/v1/auth/logout`, and issue short-lived JWT session tokens stored in HTTP-only cookies. |
| **Priority** | P0 |
| **Traceability** | PRD: NFR-9; Architecture: §2.2, §3.2, §6.3, §8.1, ADR-2; UX: §4.1, §6.1 |
| **Dependencies** | **Blocked by:** none. **Blocks:** US-1.1, US-1.2. **Related:** TS-7.1, TS-7.2 |

**Acceptance Criteria**

```gherkin
Scenario: Login endpoint redirects to OIDC provider
  Given the backend is configured with Entra ID credentials
  When a GET request is made to /api/v1/auth/login
  Then the response is a 302 redirect to the OIDC authorization URL
  And the state parameter is a cryptographically random value
```

```gherkin
Scenario: Callback exchanges code for tokens and creates session
  Given a manager has authenticated with Entra ID
  When Entra ID redirects to /api/v1/auth/callback with a valid code
  Then the backend exchanges the code for ID and access tokens
  And creates or updates the manager record
  And issues an HTTP-only JWT session cookie
```

```gherkin
Scenario: Logout invalidates session
  Given a manager has an active session
  When they POST to /api/v1/auth/logout
  Then the session cookie is cleared
  And the token is added to a revocation list if applicable
```

---

### TS-1.4 — Create manager and team ownership data model
| Field | Value |
|-------|-------|
| **Story ID** | TS-1.4 |
| **Type** | technical |
| **Title** | Create manager and team ownership data model |
| **Description** | Implement the database schema and seeding strategy for managers, teams, and team membership, establishing the foundation for authorization and survey ownership. |
| **Priority** | P0 |
| **Traceability** | PRD: Persona 1, Use Case 4; Architecture: §4.1, §5.1, §5.2; UX: §3, §5.1 |
| **Dependencies** | **Blocked by:** none. **Blocks:** US-1.1, TS-6.3, TS-6.5, US-2.1. **Related:** SP-8.8 |

**Acceptance Criteria**

```gherkin
Scenario: Schema supports managers, teams, and engineers
  Given the database migrations are applied
  Then tables exist for managers, teams, engineers, surveys, and survey-team relationships
  And foreign keys enforce referential integrity
```

```gherkin
Scenario: Manager is linked to their teams
  Given a manager record exists
  When they are assigned one or more teams
  Then the manager-team relationship is persisted
  And surveys can reference the team_id
```

---

### TS-2.5 — Implement survey and question database schema
| Field | Value |
|-------|-------|
| **Story ID** | TS-2.5 |
| **Type** | technical |
| **Title** | Implement survey and question database schema |
| **Description** | Create the PostgreSQL schema for surveys, questions, and survey runs with appropriate enums, indexes, and constraints to support recurring schedules and future-run-only edits. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 1, Key Implementation Details; Architecture: §4.1, §5.1, §5.2, §6.1; UX: §4.1, §6.2 |
| **Dependencies** | **Blocked by:** TS-1.4. **Blocks:** TS-2.6, TS-2.7, TS-2.8. **Related:** none |

**Acceptance Criteria**

```gherkin
Scenario: Schema supports survey configuration
  Given migrations are applied
  Then the surveys table stores title, manager_id, team_id, frequency, status, and timestamps
  And the questions table stores text, type, order, and survey_id
```

```gherkin
Scenario: Schema enforces question count limits
  Given a survey creation transaction
  When it attempts to insert fewer than 5 or more than 7 questions
  Then a database check constraint rejects the transaction
```

---

### TS-2.6 — Implement survey CRUD API endpoints
| Field | Value |
|-------|-------|
| **Story ID** | TS-2.6 |
| **Type** | technical |
| **Title** | Implement survey CRUD API endpoints |
| **Description** | Build REST endpoints for listing, creating, reading, updating, and deactivating surveys, enforcing ownership and validation rules. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 1, API Design Principles; Architecture: §3.2, §6.1; UX: §4.1, §4.3, §4.4 |
| **Dependencies** | **Blocked by:** TS-2.5, TS-1.3, TS-6.3. **Blocks:** US-2.1, US-2.2, US-2.3, US-2.4. **Related:** TS-2.8 |

**Acceptance Criteria**

```gherkin
Scenario: Manager creates a survey via API
  Given an authenticated manager POSTs valid survey data to /api/v1/surveys
  Then a 201 Created response is returned with the new survey id
  And the questions are persisted in the correct order
```

```gherkin
Scenario: Manager cannot update another manager's survey
  Given an authenticated manager PUTs to /api/v1/surveys/{id} they do not own
  Then the API returns 403 Forbidden
  And no changes are persisted
```

```gherkin
Scenario: Deactivate returns updated status
  Given an authenticated manager DELETEs /api/v1/surveys/{id}
  Then the survey status changes to inactive
  And the response returns the updated survey object
```

---

### TS-2.7 — Implement recurring survey scheduling job
| Field | Value |
|-------|-------|
| **Story ID** | TS-2.7 |
| **Type** | technical |
| **Title** | Implement recurring survey scheduling job |
| **Description** | Build an idempotent scheduled job that creates new survey runs at the configured frequency, generates access tokens, and triggers notifications. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 1.1, In-Scope Clarifications; Architecture: §3.1, §7.2, ADR-5; UX: §4.1 |
| **Dependencies** | **Blocked by:** TS-2.5, TS-3.6. **Blocks:** US-3.1, TS-4.4. **Related:** TS-2.8 |

**Acceptance Criteria**

```gherkin
Scenario: Job creates weekly survey run
  Given an active weekly survey exists
  When the scheduler runs after the configured start time
  Then a new survey_run record is created
  And its start_time and end_time are set appropriately
```

```gherkin
Scenario: Job skips inactive surveys
  Given an inactive survey exists
  When the scheduler runs
  Then no new survey_run is created
```

```gherkin
Scenario: Job is idempotent
  Given the scheduler fails mid-run and is retried
  When it executes again
  Then duplicate survey_runs are not created
  And duplicate tokens are not generated for the same engineer
```

---

### TS-2.8 — Implement survey run lifecycle management
| Field | Value |
|-------|-------|
| **Story ID** | TS-2.8 |
| **Type** | technical |
| **Title** | Implement survey run lifecycle management |
| **Description** | Manage survey run states from open to closed, compute response counts, and trigger aggregation when the response window ends. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 3.1 (trend update timing), Open Question 1; Architecture: §4.1, §5.1, §7.2; UX: §4.2 |
| **Dependencies** | **Blocked by:** TS-2.5, TS-3.7. **Blocks:** US-5.1, TS-5.4. **Related:** TS-2.7 |

**Acceptance Criteria**

```gherkin
Scenario: Survey run closes at end time
  Given a survey run has reached its configured end_time
  When the closer job runs
  Then the run status changes to closed
  And response_count is updated
```

```gherkin
Scenario: Closed run triggers aggregation
  Given a survey run has just closed
  When the aggregation job runs
  Then aggregated metrics are calculated for each question
  And the dashboard can fetch fresh data within 1 hour
```

---

### TS-3.5 — Implement anonymous survey response schema
| Field | Value |
|-------|-------|
| **Story ID** | TS-3.5 |
| **Type** | technical |
| **Title** | Implement anonymous survey response schema |
| **Description** | Create the survey_responses table with no user identifier columns, ensuring anonymity is enforced at the database layer. |
| **Priority** | P0 |
| **Traceability** | PRD: NFR-5, Key Implementation Details; Architecture: §4.1, §5.1, §5.2, ADR-1; UX: §4.5, §6.3 |
| **Dependencies** | **Blocked by:** TS-2.5. **Blocks:** TS-3.7, TS-5.4. **Related:** none |

**Acceptance Criteria**

```gherkin
Scenario: Response table has no PII columns
  Given the database migrations are applied
  When the schema is inspected
  Then survey_responses contains only id, survey_run_id, question_id, response_value, and created_at
  And no user_id, email, name, or SSO_id columns exist
```

```gherkin
Scenario: Automated schema validation passes
  Given a deployment pipeline runs schema validation
  When it checks survey_responses columns
  Then the build fails if any new user-identifying column is introduced
```

---

### TS-3.6 — Implement single-use time-limited token generation and validation
| Field | Value |
|-------|-------|
| **Story ID** | TS-3.6 |
| **Type** | technical |
| **Title** | Implement single-use time-limited token generation and validation |
| **Description** | Build secure token generation, hashing, storage, validation, and expiration logic for engineer survey access. |
| **Priority** | P0 |
| **Traceability** | PRD: NFR-8, Key Implementation Details; Architecture: §4.1, §5.1, §6.2, §8.1, ADR-3; UX: §4.5, §4.6 |
| **Dependencies** | **Blocked by:** TS-2.5. **Blocks:** US-3.1, US-3.2, US-3.4, TS-2.7. **Related:** TS-3.8 |

**Acceptance Criteria**

```gherkin
Scenario: Tokens expire after 7 days
  Given a token was generated 6 days, 23 hours ago
  When it is validated
  Then it is accepted
```

```gherkin
Scenario: Tokens older than 7 days are rejected
  Given a token was generated 7 days and 1 minute ago
  When it is validated
  Then it is rejected as expired
```

```gherkin
Scenario: Used tokens are rejected
  Given a token has already been used to submit a response
  When it is validated again
  Then it is rejected as already used
```

```gherkin
Scenario: Plaintext tokens are never stored
  Given a token is generated
  When it is persisted
  Then only a hash of the token is stored
  And the plaintext token exists only in the notification message
```

---

### TS-3.7 — Implement survey response submission API
| Field | Value |
|-------|-------|
| **Story ID** | TS-3.7 |
| **Type** | technical |
| **Title** | Implement survey response submission API |
| **Description** | Build the anonymous response submission endpoint that validates tokens, stores responses without PII, and prevents duplicate submissions per token. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 2.2, NFR-5, NFR-6, API Design Principles; Architecture: §3.2, §6.2, §8.4; UX: §4.5, §6.3, §12.2 |
| **Dependencies** | **Blocked by:** TS-3.5, TS-3.6. **Blocks:** US-3.3, TS-2.8, TS-5.4. **Related:** TS-7.1 |

**Acceptance Criteria**

```gherkin
Scenario: Valid token submits anonymous response
  Given an engineer has a valid unused token
  When they POST complete responses to /api/v1/surveys/respond
  Then the responses are stored without user identifiers
  And the token is marked as used
  And a success response is returned
```

```gherkin
Scenario: Duplicate submission is rejected
  Given an engineer already submitted a response with their token
  When they attempt to submit again
  Then the API returns 409 Conflict
  And no new response is stored
```

```gherkin
Scenario: Missing required responses are rejected
  Given an engineer submits incomplete responses
  When the request is processed
  Then the API returns 400 Bad Request
  And the response includes validation errors per question
```

---

### TS-3.8 — Implement expired token cleanup job
| Field | Value |
|-------|-------|
| **Story ID** | TS-3.8 |
| **Type** | technical |
| **Title** | Implement expired token cleanup job |
| **Description** | Run a daily job that deletes or archives expired tokens older than 30 days to manage database growth and satisfy NFR-8 cleanup requirements. |
| **Priority** | P1 |
| **Traceability** | PRD: NFR-8; Architecture: §7.2, §8.4; UX: §4.6 |
| **Dependencies** | **Blocked by:** TS-3.6. **Blocks:** none. **Related:** TS-4.4 |

**Acceptance Criteria**

```gherkin
Scenario: Expired tokens older than 30 days are removed
  Given tokens exist that expired 31 days ago
  When the cleanup job runs
  Then those tokens are deleted from the database
```

```gherkin
Scenario: Recently expired tokens are retained briefly
  Given tokens expired 5 days ago
  When the cleanup job runs
  Then those tokens remain in the database
```

---

### TS-4.2 — Implement email notification service integration
| Field | Value |
|-------|-------|
| **Story ID** | TS-4.2 |
| **Type** | technical |
| **Title** | Implement email notification service integration |
| **Description** | Integrate with a transactional email provider (e.g., SendGrid or AWS SES) to send survey invitation emails with unique tokenized links. |
| **Priority** | P0 |
| **Traceability** | PRD: Notification Delivery; Architecture: §2.2, §7.1; UX: §4.5, §4.6 |
| **Dependencies** | **Blocked by:** TS-3.6, SP-8.7. **Blocks:** US-3.1, US-4.1. **Related:** TS-4.3, TS-4.4 |

**Acceptance Criteria**

```gherkin
Scenario: Email is sent with correct content
  Given a survey run begins with email notifications enabled
  When the notification job runs
  Then each engineer receives an email containing the survey title
  And a single-use survey link
  And a privacy reassurance statement
```

```gherkin
Scenario: Email delivery status is tracked
  Given an email is sent
  When the provider returns a delivery event
  Then the system records the status for operational monitoring
```

---

### TS-4.3 — Implement Slack notification service integration
| Field | Value |
|-------|-------|
| **Story ID** | TS-4.3 |
| **Type** | technical |
| **Title** | Implement Slack notification service integration |
| **Description** | Integrate with the Slack API to send direct messages containing unique survey links, including OAuth authorization and fallback handling. |
| **Priority** | P0 |
| **Traceability** | PRD: Notification Delivery; Architecture: §2.2, §7.1; UX: §4.5, §4.6 |
| **Dependencies** | **Blocked by:** TS-3.6, SP-8.7. **Blocks:** US-3.1, US-4.1. **Related:** TS-4.2, TS-4.4 |

**Acceptance Criteria**

```gherkin
Scenario: Slack DM is sent with survey link
  Given a survey run begins with Slack notifications enabled
  When the notification job runs
  Then each engineer receives a Slack direct message with a single-use survey link
```

```gherkin
Scenario: Slack OAuth authorization is required before first use
  Given a manager selects Slack for the first time
  When they save the survey
  Then they are redirected through Slack OAuth
  And the OAuth token is stored encrypted
```

---

### TS-4.4 — Implement notification retry logic and failure handling
| Field | Value |
|-------|-------|
| **Story ID** | TS-4.4 |
| **Type** | technical |
| **Title** | Implement notification retry logic and failure handling |
| **Description** | Build retry scheduling with exponential backoff and fallback rules so that transient email or Slack failures do not silently drop invitations. |
| **Priority** | P1 |
| **Traceability** | PRD: Open Question 2; Architecture: §7.1, §7.2, §9.2; UX: §4.5, §4.6 |
| **Dependencies** | **Blocked by:** TS-4.2, TS-4.3, TS-2.7. **Blocks:** none. **Related:** SP-8.7 |

**Acceptance Criteria**

```gherkin
Scenario: Failed notifications are retried
  Given an email notification fails on first attempt
  When the retry job runs
  Then the notification is resent up to the configured retry limit
  And retries follow an exponential backoff schedule
```

```gherkin
Scenario: Slack failures fall back to email when both channels configured
  Given Slack delivery fails and email is also configured
  When the fallback rule triggers
  Then an email notification is sent for the same engineer
```

```gherkin
Scenario: Permanent failures are logged for manual review
  Given a notification exhausts all retries
  When the final attempt fails
  Then the failure is logged with the engineer's delivery address and survey run id
  And an alert is raised
```

### TS-5.4 — Implement aggregation service for trend data
| Field | Value |
|-------|-------|
| **Story ID** | TS-5.4 |
| **Type** | technical |
| **Title** | Implement aggregation service for trend data |
| **Description** | Build efficient SQL aggregation queries that compute per-question averages, counts, and distributions per survey run without joining to user tables. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 3.1, NFR-6, NFR-12; Architecture: §3.2, §4.3, §5.1, §6.1, ADR-4; UX: §4.2, §6.2 |
| **Dependencies** | **Blocked by:** TS-3.5, TS-2.8. **Blocks:** US-5.1, US-5.2, TS-5.5, TS-5.6. **Related:** NFR-12 load tests |

**Acceptance Criteria**

```gherkin
Scenario: Aggregates are computed per question and run
  Given responses exist for a survey run
  When the aggregation service runs
  Then it returns average response value and response count per question
  And no individual response values are included
```

```gherkin
Scenario: Aggregation performs within target time for 10,000 responses
  Given the database contains 10,000 responses
  When the dashboard aggregation query runs
  Then it completes in under 1 second
```

```gherkin
Scenario: Aggregation does not join to user tables
  Given the aggregation query is reviewed
  Then no JOIN to engineers, managers, or user identity tables is present
```

---

### TS-5.5 — Implement dashboard API endpoints
| Field | Value |
|-------|-------|
| **Story ID** | TS-5.5 |
| **Type** | technical |
| **Title** | Implement dashboard API endpoints |
| **Description** | Build `/api/v1/surveys/:id/trends`, `/api/v1/surveys/:id/comparison`, and `/api/v1/surveys/:id/runs` endpoints that return only aggregated, authorized data. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 3, NFR-2, NFR-6; Architecture: §6.1; UX: §4.2, §6.2 |
| **Dependencies** | **Blocked by:** TS-5.4, TS-6.3. **Blocks:** US-5.1, US-5.2, US-5.3. **Related:** TS-5.6 |

**Acceptance Criteria**

```gherkin
Scenario: Trends endpoint returns aggregated data only
  Given an authenticated manager requests trends for their survey
  When the response is returned
  Then it contains per-question trend data with averages and counts
  And no individual responses or engineer identifiers are present
```

```gherkin
Scenario: Comparison endpoint requires two run ids
  Given a manager requests comparison with valid run ids
  When the response is returned
  Then it includes aggregated metrics for both runs and percentage change
```

```gherkin
Scenario: Unauthorized manager receives 403
  Given a manager requests trends for another manager's survey
  When the request is processed
  Then the API returns 403 Forbidden
```

---

### TS-5.6 — Implement interactive trend charts
| Field | Value |
|-------|-------|
| **Story ID** | TS-5.6 |
| **Type** | technical |
| **Title** | Implement interactive trend charts |
| **Description** | Build the dashboard chart component using a React-friendly charting library with hover tooltips, responsive legends, and data-table alternatives for accessibility. |
| **Priority** | P1 |
| **Traceability** | PRD: NFR-7; Architecture: §3.3, §11.1; UX: §6.2, §7.1, §9.1, §10.2, §13 |
| **Dependencies** | **Blocked by:** TS-5.5. **Blocks:** US-5.1, US-5.2. **Related:** TS-7.5 |

**Acceptance Criteria**

```gherkin
Scenario: Chart renders one line per question
  Given trend data is loaded
  When the dashboard renders
  Then one line series is shown for each question
  And the chart is responsive across breakpoints
```

```gherkin
Scenario: Hover tooltip shows value and count
  Given a trend chart is displayed
  When the manager hovers over a data point
  Then a tooltip shows the survey run date, aggregated value, and response count
```

```gherkin
Scenario: Chart has an accessible alternative
  Given a trend chart is rendered
  Then a screen-reader-accessible data table or aria-label describes the chart data
```

---

### TS-6.3 — Implement authorization middleware for manager endpoints
| Field | Value |
|-------|-------|
| **Story ID** | TS-6.3 |
| **Type** | technical |
| **Title** | Implement authorization middleware for manager endpoints |
| **Description** | Build middleware that verifies the authenticated manager owns the team or survey referenced in each request and returns 403 for unauthorized access. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 4.1, NFR-6, NFR-9; Architecture: §3.2, §6.1, §8.1; UX: §5.1, §13 |
| **Dependencies** | **Blocked by:** TS-1.3, TS-1.4. **Blocks:** TS-2.6, TS-5.5, US-6.1. **Related:** TS-6.5 |

**Acceptance Criteria**

```gherkin
Scenario: Authorized manager passes middleware
  Given a manager owns the survey referenced in the request
  When the request reaches the endpoint
  Then it is allowed to proceed
```

```gherkin
Scenario: Unauthorized manager is blocked
  Given a manager does not own the survey referenced in the request
  When the request reaches the endpoint
  Then the middleware returns 403 Forbidden
  And the body contains no data about the requested resource
```

```gherkin
Scenario: Unauthenticated requests are blocked
  Given a request has no valid session
  When it reaches a manager endpoint
  Then the middleware returns 401 Unauthorized
```

---

### TS-6.4 — Implement authorization middleware for engineer endpoints
| Field | Value |
|-------|-------|
| **Story ID** | TS-6.4 |
| **Type** | technical |
| **Title** | Implement authorization middleware for engineer endpoints |
| **Description** | Build middleware that validates single-use survey tokens and prevents token reuse for manager-only or response-listing endpoints. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 4.2, NFR-6, NFR-8; Architecture: §3.2, §6.2, §8.1; UX: §4.5, §12.2 |
| **Dependencies** | **Blocked by:** TS-3.6. **Blocks:** US-6.2. **Related:** TS-6.3 |

**Acceptance Criteria**

```gherkin
Scenario: Valid token accesses survey form endpoint
  Given a request contains a valid unused survey token
  When it reaches an engineer endpoint
  Then the middleware allows it to proceed
```

```gherkin
Scenario: Engineer token cannot access manager endpoints
  Given a request uses a survey token on a manager-only endpoint
  When it reaches the endpoint
  Then the middleware returns 403 Forbidden
```

---

### TS-6.5 — Implement team-scoped data access controls
| Field | Value |
|-------|-------|
| **Story ID** | TS-6.5 |
| **Type** | technical |
| **Title** | Implement team-scoped data access controls |
| **Description** | Ensure all queries for surveys, runs, responses, and dashboards include team ownership filters so data isolation is enforced at the data layer, not just the API layer. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 4.1, NFR-6; Architecture: §4.1, §5.2, §6.1, §8.2; UX: §5.1, §13 |
| **Dependencies** | **Blocked by:** TS-1.4, TS-6.3. **Blocks:** none. **Related:** TS-5.5 |

**Acceptance Criteria**

```gherkin
Scenario: List queries filter by manager teams
  Given a manager requests their survey list
  When the repository query executes
  Then the WHERE clause restricts results to surveys where team_id is in the manager's teams
```

```gherkin
Scenario: Direct ID lookups still enforce ownership
  Given a manager requests a specific survey by id
  When the repository query executes
  Then it returns the survey only if its team_id is in the manager's teams
```

---

### TS-7.1 — Implement CSRF protection
| Field | Value |
|-------|-------|
| **Story ID** | TS-7.1 |
| **Type** | technical |
| **Title** | Implement CSRF protection |
| **Description** | Enable CSRF token validation on all state-changing endpoints (POST, PUT, DELETE) for manager and engineer sessions. |
| **Priority** | P0 |
| **Traceability** | PRD: NFR-10; Architecture: §8.1; UX: §6.1, §6.2, §6.3 |
| **Dependencies** | **Blocked by:** TS-1.3, TS-3.6. **Blocks:** none. **Related:** TS-7.2 |

**Acceptance Criteria**

```gherkin
Scenario: State-changing request with valid CSRF token succeeds
  Given a request includes a valid CSRF token in the header
  When it is a POST, PUT, or DELETE request
  Then the endpoint processes the request
```

```gherkin
Scenario: State-changing request without CSRF token is rejected
  Given a request omits the CSRF token
  When it is a POST, PUT, or DELETE request
  Then the API returns 403 Forbidden
```

```gherkin
Scenario: GET requests are not blocked by CSRF
  Given a GET request has no CSRF token
  When it reaches the server
  Then it is allowed to proceed
```

---

### TS-7.2 — Implement rate limiting
| Field | Value |
|-------|-------|
| **Story ID** | TS-7.2 |
| **Type** | technical |
| **Title** | Implement rate limiting |
| **Description** | Apply per-endpoint rate limits for login attempts, token requests, survey submissions, and general API usage to mitigate abuse and DDoS risk. |
| **Priority** | P0 |
| **Traceability** | PRD: Use Case 2.3, NFR-8, NFR-11; Architecture: §8.4; UX: §4.6, §11.3 |
| **Dependencies** | **Blocked by:** none. **Blocks:** US-3.4. **Related:** TS-7.1 |

**Acceptance Criteria**

```gherkin
Scenario: Token request limit is enforced
  Given an engineer has requested 3 new links for a survey run
  When they request a 4th link
  Then the API returns 429 Too Many Requests
```

```gherkin
Scenario: Login attempts are rate-limited by IP
  Given more than 5 login attempts occur from the same IP in 15 minutes
  When the 6th attempt is made
  Then the API returns 429 Too Many Requests
```

```gherkin
Scenario: API rate limit is enforced per user
  Given an authenticated user exceeds 100 requests per minute
  When the next request arrives
  Then the API returns 429 Too Many Requests
```

---

### TS-7.3 — Implement encryption in transit and at rest
| Field | Value |
|-------|-------|
| **Story ID** | TS-7.3 |
| **Type** | technical |
| **Title** | Implement encryption in transit and at rest |
| **Description** | Enforce HTTPS/TLS for all client-server communication, enable database encryption at rest, and store OAuth tokens and secrets in a secrets manager. |
| **Priority** | P0 |
| **Traceability** | PRD: NFR-5, NFR-9; Architecture: §8.3, §10.1; UX: §6.1 |
| **Dependencies** | **Blocked by:** none. **Blocks:** none. **Related:** TS-8.2 |

**Acceptance Criteria**

```gherkin
Scenario: All public endpoints use HTTPS
  Given a request is made over HTTP
  When it reaches the load balancer
  Then it is redirected to HTTPS
```

```gherkin
Scenario: Database encryption at rest is enabled
  Given the database is provisioned
  Then encryption at rest is configured
  And sensitive configuration is stored in a secrets manager
```

---

### TS-7.4 — Implement audit logging
| Field | Value |
|-------|-------|
| **Story ID** | TS-7.4 |
| **Type** | technical |
| **Title** | Implement audit logging |
| **Description** | Log manager logins, survey changes, token usage, and access to dashboard data for security review and compliance, ensuring logs do not contain individual response values. |
| **Priority** | P1 |
| **Traceability** | PRD: NFR-5, NFR-6, NFR-9; Architecture: §5.2, §8.1, §8.2, §8.5; UX: §4.1 |
| **Dependencies** | **Blocked by:** TS-1.3, TS-3.6. **Blocks:** none. **Related:** TS-8.3 |

**Acceptance Criteria**

```gherkin
Scenario: Login events are audited
  Given a manager logs in or out
  When the action completes
  Then an audit log entry is created with timestamp, user id, and action type
```

```gherkin
Scenario: Audit logs exclude response values
  Given a manager views dashboard data
  When the access is logged
  Then the log entry does not contain individual response values or averages
```

```gherkin
Scenario: Token usage is audited without linking to responses
  Given an engineer uses a survey token
  When the token is validated or marked used
  Then an audit log entry records the event without response content
```

---

### TS-7.5 — Implement accessibility compliance (WCAG 2.1 AA)
| Field | Value |
|-------|-------|
| **Story ID** | TS-7.5 |
| **Type** | technical |
| **Title** | Implement accessibility compliance (WCAG 2.1 AA) |
| **Description** | Ensure the survey form, dashboard, and login page meet WCAG 2.1 Level AA through semantic HTML, focus management, ARIA attributes, color contrast, keyboard navigation, and screen-reader alternatives. |
| **Priority** | P0 |
| **Traceability** | PRD: NFR-13; Architecture: §11.1; UX: §6.1, §6.2, §6.3, §9, §10, §13 |
| **Dependencies** | **Blocked by:** none. **Blocks:** US-3.3, US-5.1. **Related:** TS-5.6 |

**Acceptance Criteria**

```gherkin
Scenario: Automated axe-core scan passes
  Given the survey form and dashboard pages are rendered
  When an axe-core scan runs
  Then no WCAG 2.1 Level AA violations are reported
```

```gherkin
Scenario: Keyboard navigation works end-to-end
  Given a user is on the survey form
  When they navigate using only Tab, Shift+Tab, Enter, and Space
  Then all questions and buttons are reachable and operable
  And focus indicators are clearly visible
```

```gherkin
Scenario: Charts have accessible alternatives
  Given a trend chart is displayed
  Then a visually hidden data table or aria-label describes the chart
```

---

### TS-7.6 — Implement internationalization (i18n)
| Field | Value |
|-------|-------|
| **Story ID** | TS-7.6 |
| **Type** | technical |
| **Title** | Implement internationalization (i18n) |
| **Description** | Integrate an i18n library and translate all UI text for English plus at least one additional language, with language selection or browser-locale detection. |
| **Priority** | P0 |
| **Traceability** | PRD: NFR-14; Architecture: §11.1; UX: §11.2, §13 |
| **Dependencies** | **Blocked by:** none. **Blocks:** US-3.3, US-5.1. **Related:** none |

**Acceptance Criteria**

```gherkin
Scenario: UI text is translated into a second language
  Given the user selects a supported non-English locale
  When any page loads
  Then all static labels, buttons, and messages appear in the selected language
```

```gherkin
Scenario: Survey question text is not auto-translated
  Given a manager created questions in English
  When a non-English engineer opens the survey
  Then the questions remain in the language the manager authored
  And only the UI chrome is translated
```

---

### TS-8.1 — Set up CI/CD pipeline
| Field | Value |
|-------|-------|
| **Story ID** | TS-8.1 |
| **Type** | technical |
| **Title** | Set up CI/CD pipeline |
| **Description** | Configure GitHub Actions (or equivalent) to build, test, lint, run Lighthouse CI, accessibility scans, schema validation, and deploy to staging and production. |
| **Priority** | P0 |
| **Traceability** | PRD: NFR-1, NFR-2, NFR-3, NFR-10, Appendix Verification Checklist; Architecture: §9.4, §10.2, §11.2; UX: §13 |
| **Dependencies** | **Blocked by:** none. **Blocks:** TS-8.2, TS-8.5. **Related:** TS-8.3, TS-8.4 |

**Acceptance Criteria**

```gherkin
Scenario: Pull request triggers automated checks
  Given a developer opens a pull request
  When the CI pipeline runs
  Then unit tests, integration tests, linting, and schema validation execute
  And the build fails if any check fails
```

```gherkin
Scenario: Main branch deploys to staging
  Given code is merged to the main branch
  When the deployment pipeline runs
  Then the application is deployed to the staging environment
  And Lighthouse CI, accessibility scans, and schema validation run against staging
```

---

### TS-8.2 — Set up infrastructure and deployment
| Field | Value |
|-------|-------|
| **Story ID** | TS-8.2 |
| **Type** | technical |
| **Title** | Set up infrastructure and deployment |
| **Description** | Provision cloud infrastructure (load balancer, API instances, PostgreSQL primary/replica, optional Redis, background job workers) using infrastructure-as-code. |
| **Priority** | P0 |
| **Traceability** | PRD: NFR-4, NFR-11, NFR-12; Architecture: §9.1, §9.2, §10.1, §10.2, §11.3; UX: §10 |
| **Dependencies** | **Blocked by:** TS-8.1. **Blocks:** TS-8.3, TS-8.5. **Related:** TS-7.3 |

**Acceptance Criteria**

```gherkin
Scenario: Production topology matches architecture
  Given the infrastructure is provisioned
  Then it includes a load balancer, at least two API instances, PostgreSQL, and optional Redis
  And the topology supports horizontal scaling
```

```gherkin
Scenario: Database replication is configured
  Given the data tier is provisioned
  Then a primary PostgreSQL instance and a read replica exist
  And automated backups are enabled
```

---

### TS-8.3 — Implement monitoring and alerting
| Field | Value |
|-------|-------|
| **Story ID** | TS-8.3 |
| **Type** | technical |
| **Title** | Implement monitoring and alerting |
| **Description** | Integrate APM/uptime monitoring, configure alerts for downtime > 5 minutes, job failures, and error-rate thresholds, and publish monthly uptime reports. |
| **Priority** | P0 |
| **Traceability** | PRD: NFR-4, Appendix Verification Checklist; Architecture: §9.4, §10.2, §11.2; UX: §8.3 |
| **Dependencies** | **Blocked by:** TS-8.2. **Blocks:** none. **Related:** TS-8.4 |

**Acceptance Criteria**

```gherkin
Scenario: Downtime alert fires within 5 minutes
  Given the production API becomes unreachable
  When the condition persists for more than 5 minutes
  Then an alert is sent to the on-call channel
```

```gherkin
Scenario: Background job failures trigger alerts
  Given the notification scheduler fails
  When the failure is detected
  Then an alert is raised with the job name and error details
```

---

### TS-8.4 — Implement structured logging
| Field | Value |
|-------|-------|
| **Story ID** | TS-8.4 |
| **Type** | technical |
| **Title** | Implement structured logging |
| **Description** | Add JSON structured logging across the API and jobs, with correlation IDs, log levels, and safe redaction of tokens and PII. |
| **Priority** | P1 |
| **Traceability** | PRD: NFR-5, NFR-9; Architecture: §9.4, §11.2; UX: §8.3 |
| **Dependencies** | **Blocked by:** none. **Blocks:** TS-8.3. **Related:** TS-7.4 |

**Acceptance Criteria**

```gherkin
Scenario: API requests emit structured logs
  Given an API request is processed
  Then a JSON log entry is emitted containing method, path, status, duration, and correlation id
  And no plaintext survey tokens are logged
```

```gherkin
Scenario: Logs support log-level filtering
  Given logs are collected
  Then they can be filtered by level (error, warn, info, debug)
  And they include timestamps in UTC
```

---

### TS-8.5 — Conduct performance and load testing
| Field | Value |
|-------|-------|
| **Story ID** | TS-8.5 |
| **Type** | technical |
| **Title** | Conduct performance and load testing |
| **Description** | Validate NFR-1 (form load ≤ 2s on 4G), NFR-2 (dashboard ≤ 3s broadband), NFR-11 (100 concurrent submissions, p95 ≤ 2s), and NFR-12 (10,000 responses/month, query ≤ 1s). |
| **Priority** | P0 |
| **Traceability** | PRD: NFR-1, NFR-2, NFR-11, NFR-12, Appendix Verification Checklist; Architecture: §9.1, §9.3; UX: §10 |
| **Dependencies** | **Blocked by:** TS-8.1, TS-8.2. **Blocks:** none. **Related:** TS-5.4 |

**Acceptance Criteria**

```gherkin
Scenario: Survey form loads within 2 seconds on 4G
  Given Lighthouse CI runs against the survey form under 4G throttling
  When the test completes
  Then Time to Interactive is less than or equal to 2 seconds
```

```gherkin
Scenario: Dashboard query completes within 1 second for 10,000 responses
  Given the database contains 10,000 responses
  When the trend aggregation query runs
  Then it completes in under 1 second
```

```gherkin
Scenario: 100 concurrent submissions meet response-time target
  Given k6 simulates 100 concurrent survey submissions
  When the test completes
  Then the p95 response time is less than or equal to 2 seconds
```

### SP-8.6 — Spike: Define data retention policy
| Field | Value |
|-------|-------|
| **Story ID** | SP-8.6 |
| **Type** | spike |
| **Title** | Spike: Define data retention policy |
| **Description** | Research legal, compliance, and storage-cost trade-offs and document how long survey responses, tokens, audit logs, and manager configurations should be retained or archived. |
| **Priority** | P1 |
| **Traceability** | PRD: Open Question 7, NFR-5; Architecture: §13.2 Scalability Considerations; UX: §11.2 |
| **Dependencies** | **Blocked by:** none. **Blocks:** TS-3.8, TS-8.2. **Related:** TS-7.4 |

**Acceptance Criteria**

```gherkin
Scenario: Retention policy is documented
  Given the spike is complete
  When the team reviews the decision record
  Then it specifies retention periods for responses, tokens, audit logs, and configurations
  And it defines deletion versus archival procedures
```

```gherkin
Scenario: Policy aligns with regulations
  Given the documented retention policy
  Then it addresses GDPR and CCPA requirements
  And it is approved by legal/compliance stakeholders
```

---

### SP-8.7 — Spike: Define notification retry strategy
| Field | Value |
|-------|-------|
| **Story ID** | SP-8.7 |
| **Type** | spike |
| **Title** | Spike: Define notification retry strategy |
| **Description** | Determine retry counts, intervals, backoff strategy, fallback channels, and failure alerting for email and Slack notifications. |
| **Priority** | P1 |
| **Traceability** | PRD: Open Question 2; Architecture: §7.1, §7.2; UX: §4.5, §4.6 |
| **Dependencies** | **Blocked by:** none. **Blocks:** TS-4.2, TS-4.3, TS-4.4. **Related:** TS-8.3 |

**Acceptance Criteria**

```gherkin
Scenario: Retry strategy is documented
  Given the spike is complete
  Then a runbook specifies retry counts, intervals, and backoff formula for email and Slack
  And fallback rules are defined when both channels are configured
```

```gherkin
Scenario: Retry strategy is accepted by operations
  Given the documented strategy
  Then the operations team signs off on alert thresholds and escalation paths
```

---

### SP-8.8 — Spike: Define team membership management approach
| Field | Value |
|-------|-------|
| **Story ID** | SP-8.8 |
| **Type** | spike |
| **Title** | Spike: Define team membership management approach |
| **Description** | Decide how engineers are added to or removed from a manager's team: manual email/SSO entry, Azure AD/Okta sync, or hybrid approach, and document onboarding/offboarding impact. |
| **Priority** | P1 |
| **Traceability** | PRD: Open Question 3, Persona 1; Architecture: §5.1, §5.2; UX: §3 Manager Goals, §5.1 |
| **Dependencies** | **Blocked by:** none. **Blocks:** TS-1.4, US-2.1. **Related:** SP-8.9 |

**Acceptance Criteria**

```gherkin
Scenario: Membership approach is documented
  Given the spike is complete
  Then an ADR or runbook documents whether team membership is manual, synced, or hybrid
  And it covers engineer onboarding and offboarding workflows
```

```gherkin
Scenario: Manager offboarding path is defined
  Given the membership approach is documented
  Then it specifies what happens to surveys and historical data when a manager leaves
```

---

## 4. Story Dependencies and Traceability

### Dependency Graph by Epic

| Epic | Leading Technical Enablers | Consumer Stories |
|------|---------------------------|------------------|
| EPIC-01 | TS-1.3, TS-1.4 | US-1.1, US-1.2 |
| EPIC-02 | TS-2.5, TS-2.6, TS-2.7, TS-2.8 | US-2.1, US-2.2, US-2.3, US-2.4 |
| EPIC-03 | TS-3.5, TS-3.6, TS-3.7, TS-3.8 | US-3.1, US-3.2, US-3.3, US-3.4 |
| EPIC-04 | TS-4.2, TS-4.3, TS-4.4 | US-4.1, US-3.1 |
| EPIC-05 | TS-5.4, TS-5.5, TS-5.6 | US-5.1, US-5.2, US-5.3 |
| EPIC-06 | TS-6.3, TS-6.4, TS-6.5 | US-6.1, US-6.2 |
| EPIC-07 | TS-7.1, TS-7.2, TS-7.3, TS-7.4, TS-7.5, TS-7.6 | Cross-cutting |
| EPIC-08 | TS-8.1, TS-8.2, TS-8.3, TS-8.4, TS-8.5, SP-8.6, SP-8.7, SP-8.8 | Cross-cutting |

### Critical Path

```
TS-1.3/TS-1.4 (identity) → TS-6.3/TS-6.5 (authz)
                                ↓
TS-2.5/TS-2.6 (survey CRUD) → US-2.1 (create survey)
                                ↓
TS-3.6 (tokens) + TS-2.7 (scheduler) + TS-4.2/TS-4.3 (notifications)
                                ↓
US-3.1 (notify) → US-3.2 (open form) → US-3.3 (submit)
                                ↓
TS-2.8 (run close) → TS-5.4 (aggregate) → TS-5.5/TS-5.6 (dashboard)
                                ↓
US-5.1 (trends) → US-5.2 (comparison) / US-5.3 (filter)
```

### Traceability Matrix

| PRD Reference | Covered By |
|---------------|------------|
| Use Case 1.1 (Create survey) | US-2.1, TS-2.5, TS-2.6, TS-2.7 |
| Use Case 1.2 (Edit survey) | US-2.2, TS-2.6 |
| Use Case 1.3 (Deactivate survey) | US-2.3, TS-2.6 |
| Use Case 2.1 (Receive notification) | US-3.1, US-4.1, TS-4.2, TS-4.3, TS-2.7 |
| Use Case 2.2 (Complete survey) | US-3.2, US-3.3, TS-3.5, TS-3.6, TS-3.7 |
| Use Case 2.3 (New link request) | US-3.4, TS-3.6, TS-3.8, TS-4.2 |
| Use Case 3.1 (Trend dashboard) | US-5.1, TS-5.4, TS-5.5, TS-5.6 |
| Use Case 3.2 (Period comparison) | US-5.2, TS-5.4, TS-5.5 |
| Use Case 3.3 (Date range filter) | US-5.3, TS-5.5 |
| Use Case 4.1 (Own-team only) | US-6.1, TS-6.3, TS-6.5 |
| Use Case 4.2 (Engineer isolation) | US-6.2, TS-6.4 |
| NFR-1 / NFR-2 (Performance) | TS-8.5, TS-5.4, TS-3.7 |
| NFR-3 (Responsiveness) | US-3.3, US-5.1, TS-7.5, TS-8.5 |
| NFR-4 (Uptime) | TS-8.2, TS-8.3, TS-8.5 |
| NFR-5 / NFR-6 / NFR-7 (Privacy) | TS-3.5, TS-3.6, TS-5.4, TS-6.5, TS-7.4 |
| NFR-8 (Token expiration) | TS-3.6, TS-3.8 |
| NFR-9 (OIDC) | TS-1.3, US-1.1 |
| NFR-10 (CSRF) | TS-7.1 |
| NFR-11 / NFR-12 (Scalability) | TS-8.2, TS-8.5, TS-5.4 |
| NFR-13 (Accessibility) | TS-7.5 |
| NFR-14 (Localization) | TS-7.6 |

---

## 5. Acceptance Criteria Summary

The following table provides a high-level summary of the key acceptance criteria by story. Detailed Gherkin scenarios are included in each story's detail section above.

| Story ID | Key Themes | Critical Scenarios |
|----------|-----------|--------------------|
| US-1.1 | OIDC redirect, callback success, error handling | Redirect to Entra ID; session established; generic errors |
| US-1.2 | Logout, session expiry | Token invalidated; redirect to login |
| US-2.1 | Validation, persistence, no early send | 5–7 questions; future start date; confirmation message |
| US-2.2 | Future-run edits, ownership | Current run unchanged; 403 for non-owners |
| US-2.3 | Deactivation, confirmation modal | Status inactive; historical data preserved |
| US-2.4 | Survey list, empty state | Active/inactive sections; create CTA |
| US-3.1 | Email/Slack delivery, unique tokens | Valid 7-day link; distinct tokens per notification |
| US-3.2 | Token validation states | Valid opens; expired/used show new-link form |
| US-3.3 | Anonymous submission, validation, mobile | Complete/incomplete; duplicate prevention; 320px viewport |
| US-3.4 | Rate-limited new-link requests | 3-request limit; under-1-minute delivery |
| US-4.1 | Channel selection, Slack OAuth | Email/Slack/both; authorization gate |
| US-5.1 | Trend lines, hover, privacy | One line per question; no individual data |
| US-5.2 | Side-by-side comparison, change percent | Two distinct runs; percentage change arrows |
| US-5.3 | Default 12 weeks, custom range | Date picker updates trend data |
| US-6.1 | Own-team isolation, URL access control | Only own surveys; 403 for others |
| US-6.2 | Engineer cannot access manager data | Dashboard 403; form shows no identifying info |
| TS-1.3 | OIDC endpoints, JWT cookie | Redirect; callback; logout |
| TS-1.4 | Manager/team schema | Tables and relationships |
| TS-2.5 | Survey/question schema | Enums, indexes, question-count constraint |
| TS-2.6 | CRUD endpoints | Create; ownership; deactivate |
| TS-2.7 | Scheduler idempotency | Weekly/bi-weekly runs; no duplicates |
| TS-2.8 | Run lifecycle | Close; response count; aggregation trigger |
| TS-3.5 | Anonymous response schema | No PII columns; schema validation |
| TS-3.6 | Token lifecycle | 7-day expiration; used-token rejection; hashing |
| TS-3.7 | Response submission API | Anonymous storage; duplicate rejection; validation |
| TS-3.8 | Token cleanup | Delete tokens > 30 days expired |
| TS-4.2 | Email integration | Send unique links; delivery status |
| TS-4.3 | Slack integration | DM delivery; OAuth authorization |
| TS-4.4 | Retry/fallback | Exponential backoff; email fallback; failure alert |
| TS-5.4 | Aggregation query | Per-question/run averages; no user joins; ≤ 1s |
| TS-5.5 | Dashboard endpoints | Aggregated-only data; 403 for unauthorized |
| TS-5.6 | Chart component | Responsive; hover tooltips; accessible alternative |
| TS-6.3 | Manager authz middleware | Ownership check; 403; 401 |
| TS-6.4 | Engineer authz middleware | Valid token; block manager endpoints |
| TS-6.5 | Team-scoped queries | WHERE filters by manager's teams |
| TS-7.1 | CSRF middleware | Valid token passes; missing token blocked; GET exempt |
| TS-7.2 | Rate limiting | Token requests; login; general API |
| TS-7.3 | Encryption | HTTPS redirect; encryption at rest |
| TS-7.4 | Audit logging | Login/token events; no response values |
| TS-7.5 | Accessibility | axe-core pass; keyboard navigation; chart alternatives |
| TS-7.6 | i18n | Second-language support; question text not translated |
| TS-8.1 | CI/CD | PR checks; staging deployment |
| TS-8.2 | Infrastructure | Load balancer; API instances; PostgreSQL; backups |
| TS-8.3 | Monitoring | Uptime alerts; job-failure alerts |
| TS-8.4 | Logging | JSON logs; no token/PII leakage |
| TS-8.5 | Performance testing | Form ≤ 2s 4G; dashboard query ≤ 1s; 100 concurrent ≤ 2s p95 |
| SP-8.6 | Retention policy | Documented; approved |
| SP-8.7 | Retry strategy | Documented; ops sign-off |
| SP-8.8 | Team membership | ADR; offboarding path |

---

## 6. Coverage Validation

### PRD Requirement Coverage

| PRD Requirement | Status | Supporting Stories |
|-----------------|--------|--------------------|
| Manager creates/edits/deactivates surveys | Covered | US-2.1, US-2.2, US-2.3, TS-2.5, TS-2.6 |
| Engineer receives notification (email/Slack) | Covered | US-3.1, US-4.1, TS-4.2, TS-4.3, TS-2.7 |
| Engineer completes anonymous survey form | Covered | US-3.2, US-3.3, TS-3.5, TS-3.6, TS-3.7 |
| Manager views trend dashboard | Covered | US-5.1, TS-5.4, TS-5.5, TS-5.6 |
| Manager views period-over-period comparison | Covered | US-5.2, TS-5.4, TS-5.5 |
| Manager filters dashboard by date range | Covered | US-5.3, TS-5.5 |
| Data isolation & authorization | Covered | US-6.1, US-6.2, TS-6.3, TS-6.4, TS-6.5 |
| Engineer requests new survey link | Covered | US-3.4, TS-3.6, TS-3.8, TS-4.2 |
| ML-based sentiment analysis | Out of Scope | Noted below |
| Cross-team comparison | Out of Scope | Noted below |
| HR system integration | Out of Scope | Noted below |
| Mobile native apps | Out of Scope | Noted below |

### UX Workflow Coverage

| UX Workflow | Status | Supporting Stories |
|-------------|--------|--------------------|
| Manager login via SSO | Covered | US-1.1, TS-1.3, UX §4.1, §6.1 |
| Manager creates survey (3-step) | Covered | US-2.1, TS-2.6, UX §4.1 |
| Manager views dashboard & trends | Covered | US-2.4, US-5.1, TS-5.5, TS-5.6, UX §4.2, §6.2 |
| Manager edits/deactivates survey | Covered | US-2.2, US-2.3, UX §4.3, §4.4 |
| Engineer receives & completes survey | Covered | US-3.1, US-3.2, US-3.3, UX §4.5, §6.3 |
| Engineer requests new link | Covered | US-3.4, UX §4.6 |
| Loading, success, error, empty states | Covered | TS-7.5, embedded in all user stories, UX §8 |
| Responsive behavior (320px–2560px) | Covered | US-3.3, US-5.1, TS-5.6, TS-7.5, UX §10 |
| Accessibility (WCAG 2.1 AA) | Covered | TS-7.5, UX §9 |

### Architecture Requirement Coverage

| Architectural Requirement | Status | Supporting Stories |
|---------------------------|--------|--------------------|
| Three-tier PERN stack | Covered | TS-8.2, TS-8.1 |
| Anonymous response storage | Covered | TS-3.5, ADR-1 |
| OIDC manager authentication | Covered | TS-1.3, US-1.1, ADR-2 |
| Single-use time-limited engineer tokens | Covered | TS-3.6, ADR-3 |
| Aggregation at query time | Covered | TS-5.4, ADR-4 |
| Scheduled jobs for lifecycle | Covered | TS-2.7, TS-2.8, TS-3.8, TS-4.4, ADR-5 |
| API-first design | Covered | TS-2.6, TS-3.7, TS-5.5 |
| Stateless backend | Covered | TS-1.3, ADR-2 |
| Email/Slack integrations | Covered | TS-4.2, TS-4.3 |
| CSRF, rate limiting, encryption | Covered | TS-7.1, TS-7.2, TS-7.3 |
| Observability | Covered | TS-8.3, TS-8.4 |
| Scalability targets | Covered | TS-8.2, TS-8.5, TS-5.4 |

### Duplicate Check

- No two stories deliver the same outcome. US-2.2 (edit) and US-2.3 (deactivate) are distinct. TS-3.6 (token lifecycle) and TS-3.8 (cleanup) are distinct. TS-5.4 (aggregation service) and TS-5.5 (endpoints) are distinct. TS-4.2 (email) and TS-4.3 (Slack) are distinct.

### Story Sizing Assessment

- All user stories describe a single workflow or screen-level outcome and fit within a normal sprint.
- Technical stories are bounded to one subsystem (schema, endpoint, job, integration) and are independently testable.
- Spike stories are time-boxed research activities that produce documented decisions.

### Dependency Completeness

- Every user story that touches data has a preceding data-model or API technical story.
- Authorization middleware (TS-6.3/TS-6.4) is scheduled before dependent user stories.
- Notification delivery (EPIC-04) depends on token generation (TS-3.6) and scheduler (TS-2.7).
- Dashboard (EPIC-05) depends on response collection (EPIC-03) and run lifecycle (TS-2.8).

### Out-of-Scope Confirmation

The following PRD out-of-scope items are explicitly not represented as stories:

- ML-based sentiment analysis
- Cross-team comparison
- HR system integration
- Mobile native apps
- Survey branching logic
- Custom question types beyond Likert/multiple choice/short text
- Real-time dashboard updates
- Export to CSV/PDF
- Survey templates
- Multi-language survey questions (manager-authored)

### Gaps and Assumptions Documented

1. **Response window duration**: Assumed to be 7 days, matching token validity. Final confirmation needed from product (PRD Open Question 1). Covered by TS-2.8.
2. **Notification retry logic**: Retry counts and intervals are pending the SP-8.7 spike before TS-4.4 implementation.
3. **Team membership management**: SP-8.8 will decide manual vs. directory sync before TS-1.4 finalization.
4. **Minimum response threshold**: PRD Open Question 4 is not implemented in V1; dashboard shows all data with a low-response warning.
5. **Likert scale range**: Assumed 1–5 for V1; not configurable unless a future spike decides otherwise (PRD Open Question 6).
6. **Data retention period**: Pending SP-8.6 before TS-3.8 and TS-8.2 finalize archival/deletion.
7. **Manager offboarding**: Pending SP-8.8; no automated transfer/deletion story is in V1 scope until the approach is decided.
8. **Slack OAuth scopes**: Assumed limited to sending direct messages; exact scopes to be confirmed during TS-4.3.

### Validation Sign-Off Checklist

- [x] Every PRD in-scope requirement is represented by at least one story.
- [x] Every UX workflow is represented by at least one story.
- [x] Every architectural requirement has supporting technical work.
- [x] No duplicate stories exist.
- [x] Stories are appropriately sized and independently deliverable.
- [x] Dependencies are documented and form a coherent critical path.
- [x] Gaps and assumptions are explicitly documented.
- [x] Out-of-scope items are explicitly excluded.





