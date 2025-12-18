# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/saleskit.plan` command. The execution workflow is defined in `.saleskit/templates/commands/saleskit.plan.md` and copied to your agent's command directory during `sales init`.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: [e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]  
**Primary Dependencies**: [e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]  
**Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]  
**Testing**: [e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]  
**Target Platform**: [e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]
**Project Type**: [single/web/mobile - determines source structure]  
**Performance Goals**: [domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]  
**Constraints**: [domain-specific, e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]  
**Scale/Scope**: [domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

[Gates determined based on constitution file]

## Agent Governance (Sales/GTM Features)

<!--
  SALES-AI-KIT: For features involving AI-driven GTM automation (outbound, lead scoring,
  personalization, pricing), explicitly document governance constraints.

  Default: Human-in-the-loop (HITL) for autonomous actions unless explicitly justified.
-->

**Applies to this feature**: [Yes | No]

If yes, document:

- **Human-in-the-loop (HITL)**: [Required | Optional (with justification)]
  - For which actions? [e.g., sending emails, updating CRM, pricing changes]
  - Approval gates: [e.g., review queue, threshold-based auto-approval]
  - Rollback procedures: [e.g., undo queue, manual override]

- **Autonomous Actions**: [List any actions that may run without human approval]
  - Action 1: [e.g., "Score leads automatically"] - Justification: [Low risk, reversible]
  - Action 2: [e.g., "Send personalized emails"] - Requires: [HITL approval gate]

- **Auditability**: [Required | Not applicable]
  - All automated decisions logged: [Yes | No]
  - Trace inputs → outputs: [Yes | No]
  - Retention period: [e.g., 90 days, indefinite]

- **Truthfulness Constraints**: [Required | Not applicable]
  - Generated content reviewed for fabricated claims: [Yes | No]
  - Prohibited: Fake metrics, customers, case studies without validation

- **Cost & ROI Discipline**: [Required | Not applicable]
  - Inference cost per action: [Estimate or "NEEDS MEASUREMENT"]
  - Unit economics: [e.g., "Cost per qualified lead must be <$X"]
  - Spending limits: [e.g., "Max $Y/day on automated outreach"]

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/saleskit.plan command output)
├── research.md          # Phase 0 output (/saleskit.plan command)
├── data-model.md        # Phase 1 output (/saleskit.plan command)
├── quickstart.md        # Phase 1 output (/saleskit.plan command)
├── contracts/           # Phase 1 output (/saleskit.plan command)
└── tasks.md             # Phase 2 output (/saleskit.tasks command - NOT created by /saleskit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
