# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`  
**Created**: [DATE]  
**Status**: Draft  
**Input**: User description: "$ARGUMENTS"

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - [Brief Title] (Priority: P1)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently - e.g., "Can be fully tested by [specific action] and delivers [specific value]"]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 3 - [Brief Title] (Priority: P3)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more user stories as needed, each with an assigned priority]

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

- What happens when [boundary condition]?
- How does system handle [error scenario]?

## ICP & Target Segments *(mandatory for Sales/GTM features)*

<!--
  SALES-AI-KIT: Define sharp ICP (role, context, constraints, buyer type) per constitution.
  This ensures all features are optimized for real-world GTM execution.
-->

### Primary ICP (Ideal Customer Profile)

**Role**: [e.g., VP Sales at B2B AI/SaaS, 10-50M ARR]
**Context**: [e.g., Struggling with manual outbound, need PQL qualification, running hybrid PLG+SLG motion]
**Constraints**: [e.g., Limited SDR headcount, <12 month CAC payback target, need GDPR compliance]
**Buyer Type**: [Economic Buyer (CFO/CEO) | Champion (VP Sales/RevOps) | Technical Evaluator (CTO/RevOps Lead)]

### Target Tier(s)

- [ ] Individual/Prosumer
- [ ] Small team / SMB (10-100 employees)
- [ ] Enterprise (100-10K+ employees)

*Specify which tier(s) this feature primarily targets and why.*

### GTM Motion Applicability

- [ ] **PLG (Product-Led Growth)**: Self-serve onboarding, activation, in-product guidance
- [ ] **SLG (Sales-Led Growth)**: Complex deals, multi-stakeholder buying, POCs
- [ ] **ALG (Agent-Led Growth)**: Orchestration and continuous optimization (with governance)

*Explicitly state which motion(s) apply and why. Default: Hybrid (PLG + SLG). Include ALG only when justified.*

---

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
-->

### Functional Requirements

- **FR-001**: System MUST [specific capability, e.g., "allow users to create accounts"]
- **FR-002**: System MUST [specific capability, e.g., "validate email addresses"]
- **FR-003**: Users MUST be able to [key interaction, e.g., "reset their password"]
- **FR-004**: System MUST [data requirement, e.g., "persist user preferences"]
- **FR-005**: System MUST [behavior, e.g., "log all security events"]

*Example of marking unclear requirements:*

- **FR-006**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]
- **FR-007**: System MUST retain user data for [NEEDS CLARIFICATION: retention period not specified]

### Key Entities *(include if feature involves data)*

- **[Entity 1]**: [What it represents, key attributes without implementation]
- **[Entity 2]**: [What it represents, relationships to other entities]

### Agent Governance Constraints *(required for AI/agent-driven GTM features)*

<!--
  SALES-AI-KIT: Treat agent-driven GTM as a safety and trust problem per constitution.
  Default: Human-in-the-loop (HITL) for autonomous actions unless explicitly justified.
-->

- **Human-in-the-loop (HITL)**: [Required | Optional | Not applicable]
  - If optional: Justify why full autonomy is safe and define rollback procedures.
- **Autonomous Actions**: [List any autonomous outbound actions: email, DM, dialing, pricing changes, CRM mutation]
  - MUST require explicit approval gate OR justify full autonomy with rollback plan.
- **Auditability**: [Required | Not applicable]
  - If required: Automated recommendations/actions MUST be traceable to inputs and produce audit logs.
- **Truthfulness Constraints**: [Required | Not applicable]
  - Generated outreach MUST avoid fabricated claims, metrics, customers, or case studies.
- **Cost & ROI Discipline**: [Required | Not applicable]
  - Plans MUST account for variable inference cost and unit economics when recommending automation.

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.

  SALES-AI-KIT: Success criteria MUST be outcome-first (pipeline, conversion, activation,
  retention, revenue). Avoid generic "best practices" - ground recommendations in concrete
  examples or label as assumptions.
-->

### Measurable Outcomes (GTM-Focused)

<!--
  Examples of outcome-first success criteria for Sales/GTM features:
  - Pipeline: "Generate $X qualified pipeline per month"
  - Conversion: "Improve MQL-to-SQL conversion from X% to Y%"
  - Activation: "Achieve X% Day-7 retention for new signups"
  - Retention: "Reduce churn from X% to Y% (monthly)"
  - Revenue: "Achieve $X ARR within 12 months", "NRR >120%"
  - Cycle Time: "Reduce sales cycle from X days to Y days"
  - CAC/LTV: "CAC payback <12 months", "LTV:CAC ≥3:1"
-->

- **SC-001**: [Pipeline/Revenue metric, e.g., "Generate $500K qualified pipeline per quarter"]
- **SC-002**: [Conversion metric, e.g., "Improve trial-to-paid conversion from 15% to 25%"]
- **SC-003**: [Activation metric, e.g., "Achieve 40% Day-7 activation for free tier users"]
- **SC-004**: [Retention metric, e.g., "Reduce monthly churn from 8% to 5%"]
- **SC-005**: [Unit economics metric, e.g., "CAC payback <9 months", "LTV:CAC ≥3:1"]
- **SC-006**: [Cycle time metric, e.g., "Reduce average sales cycle from 120 days to 90 days"]

### Evidence & Assumptions

<!--
  SALES-AI-KIT: Recommendations SHOULD be grounded in concrete examples, observed patterns,
  or referenced sources. Unsupported "best practices" MUST be labeled as assumptions.
-->

**Evidence** (grounded in data/examples):
- [e.g., "Cursor achieved 5% freemium conversion vs. 1-2% industry baseline (Anysphere case study)"]
- [e.g., "Glean reduced knowledge retrieval time by 60% (CNBC Disruptor 50 profile)"]

**Assumptions** (not yet validated):
- [ASSUMPTION] [e.g., "AI-powered personalization may improve email reply rates by 20-30%"]
- [ASSUMPTION] [e.g., "PQL-based scoring may increase SQL conversion to 25%+ (industry benchmark)"]

*Note: Assumptions should be tested via MVPs, pilots, or A/B tests before full rollout.*
