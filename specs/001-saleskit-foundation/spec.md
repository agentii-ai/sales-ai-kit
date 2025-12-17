# Feature Specification: Sales-AI-Kit Foundation (Namespace + Workflow)

**Feature Branch**: `001-saleskit-foundation`  
**Created**: 2025-12-16  
**Status**: Draft  
**Input**: User description: "Define the foundation spec for sales-ai-kit (a fork of Spec-Kit) with multi-kit coexistence, Sales/GTM rigor, and agent workflow compatibility."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Install & coexist with other kits (Priority: P1)

As a user who installs multiple `*-kit` variants on the same machine (e.g., Spec-Kit + Sales-AI-Kit + Blog-Kit), I want each kit to have collision-free names for executables, packages, and kit-owned folders so I can use them side-by-side without breaking workflows.

**Why this priority**: If kits collide (executable name, Python distribution, or hidden folder), the entire workflow becomes unreliable and the kit cannot be safely adopted.

**Independent Test**: On a machine with at least two kits installed, I can invoke each kit’s workflows and verify each kit writes artifacts to its own namespace without overwriting the other.

**Acceptance Scenarios**:

1. **Given** Spec-Kit is installed, **When** Sales-AI-Kit is installed, **Then** both kits can be invoked without command-name collisions.
2. **Given** a project initialized by Sales-AI-Kit, **When** specs are generated, **Then** kit-owned files are written under `.saleskit/` (for generated projects) and do not overwrite another kit’s hidden folder.
3. **Given** two kits are installed, **When** I run agent workflows for each kit, **Then** the workflow namespaces do not collide (e.g., `saleskit.*` does not overlap `speckit.*`).

---

### User Story 2 - Run the Spec-Kit workflow shape for Sales/GTM work (Priority: P2)

As a founder/operator building an AI SaaS GTM motion (B2B and prosumer), I want the familiar Spec-Kit workflow shape (constitution → specify → plan → tasks → implement) adapted for Sales/GTM so I can generate durable, reviewable GTM artifacts and execute against them.

**Why this priority**: The workflow shape is the product experience; Sales-AI-Kit must preserve it while changing the domain focus.

**Independent Test**: Starting from a clean repo, I can generate a constitution, then a feature spec, and those artifacts are readable, auditable, and GTM-oriented.

**Acceptance Scenarios**:

1. **Given** a Sales-AI-Kit project, **When** I run the constitution workflow, **Then** the constitution documents non-negotiable namespace rules and GTM governance.
2. **Given** a constitution exists, **When** I run the specify workflow for a Sales/GTM feature, **Then** it produces `specs/<feature>/spec.md` with ICP, outcomes, and measurable success criteria.
3. **Given** a generated spec, **When** I proceed to plan/tasks, **Then** outputs remain consistent with the workflow shape and produce reviewable artifacts.

---

### User Story 3 - Use `refs/` as a worked example library for future kit variants (Priority: P3)

As a maintainer creating additional `*-kit` variants, I want `refs/` to contain worked examples, prompts, and principles that explain how the kit was built and how to update it over time.

**Why this priority**: The repository is also a reference implementation for creating new kits; the `refs/` library is part of the product.

**Independent Test**: A new contributor can read `refs/` and understand how the constitution/spec were produced and how to evolve the kit.

**Acceptance Scenarios**:

1. **Given** the repository, **When** I read `refs/0_overview.md` and `refs/1_principles_for_constitution.md`, **Then** I can derive the GTM principles that shape Sales-AI-Kit outputs.
2. **Given** the repository, **When** I browse `refs/`, **Then** I can find repeatable prompts and worked examples that explain how artifacts were generated.

---

### Edge Cases

- What happens when two kits are installed and both ship an executable named `specify`? (Collision must be prevented by design.)
- How does the system handle an existing project that already has `.specify/` and later adopts Sales-AI-Kit? (Must avoid overwriting; provide a clear migration path.)
- What happens when agent tooling is configured for `speckit.*` but the user expects `saleskit.*`? (Must be documented and deterministic.)
- How does the system handle users who run workflows from the wrong working directory or on a repo missing required folders?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The kit MUST preserve the upstream workflow shape: constitution → specify → plan → tasks → implement.
- **FR-002**: The kit MUST define a collision-free namespace strategy across:
  - CLI executable name
  - Python distribution/package name
  - Hidden kit folder name in generated projects
  - Agent workflow slash-command namespace
- **FR-003**: The kit MUST use the `saleskit.*` workflow namespace for Sales-AI-Kit workflows.
- **FR-004**: The kit MUST remain compatible with multiple agent environments (e.g., Claude Code, Cursor, Windsurf) without relying on agent-specific assumptions.
- **FR-005**: The kit MUST produce spec artifacts under `specs/<feature>/` using consistent file naming (`spec.md`, `plan.md`, `tasks.md`).
- **FR-006**: The kit SHOULD treat `refs/` as a first-class reference library and keep it in the main repo (not as a submodule), so `refs/*.md` are versioned and reviewable.
- **FR-007**: Outputs and templates MUST include Sales/GTM rigor:
  - ICP-first framing
  - outcome-first success criteria
  - evidence-first assumptions labeling
  - hybrid GTM awareness (PLG + SLG, with optional agentic layer)
- **FR-008**: The kit MUST include governance constraints for GTM automation (human-in-the-loop for outbound actions, auditability, truthfulness).
- **FR-009**: The kit MUST avoid modifying `.windsurf/` in this repository.
- **FR-010**: The kit’s packaging metadata MUST use a unique, non-colliding Python distribution name and module namespace (e.g., not `specify`).

### Assumptions

- This repository is a fork of upstream Spec-Kit and will continue to track upstream workflow shape changes intentionally.
- Primary users are founders/operators and GTM practitioners building AI/agent SaaS products; secondary users are maintainers creating additional `*-kit` variants.
- Agent environments (Claude Code, Cursor, Windsurf) can execute slash-command workflows, but workflow definitions must remain kit-namespaced.

### Out of Scope

- Implementing a full GTM automation product (Sales-AI-Kit is a kit/template/workflow system, not a standalone sales tool).
- Changing upstream Spec-Kit workflow ordering or inventing new mandatory phases.
- Modifying `.windsurf/` in this repository.

### Key Entities *(include if feature involves data)*

- **Kit Variant**: A distribution of the Spec-Kit workflow tailored to a domain (e.g., Sales-AI-Kit) with unique namespaces.
- **Namespace Strategy**: The set of names that avoid collisions (executable, distribution name, hidden folder, slash commands).
- **Workflow**: A deterministic sequence (constitution/specify/plan/tasks/implement) producing artifacts.
- **Artifact**: Durable markdown documents produced by workflows (`spec.md`, `plan.md`, `tasks.md`, checklists).
- **Reference Library (`refs/`)**: Worked examples and principles that guide future kit evolution.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user can install Sales-AI-Kit alongside at least one other kit variant and execute workflows without naming collisions.
- **SC-002**: For a generated project, kit-owned state is stored under `.saleskit/` and does not overwrite other kits’ hidden folders.
- **SC-003**: Given a Sales/GTM feature description, the specify workflow produces a spec containing ICP, measurable outcomes, and testable requirements (no implementation details).
- **SC-004**: Governance constraints are explicitly documented such that any autonomous outbound action requires an approval gate unless explicitly justified with rollback.
