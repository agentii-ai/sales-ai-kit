# Feature Specification: Sales-AI-Kit Foundation

**Feature Branch**: `001-saleskit-foundation`  
**Created**: 2025-12-17  
**Status**: Draft  
**Input**: User description: "Create the Sales-AI-Kit foundation spec for a Spec-Kit fork, preserving the spec-driven workflow while enforcing multi-kit coexistence via namespacing (CLI, package, folder, slash commands)."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Coexist with other *-kit variants on one machine (Priority: P1)

As a user who installs multiple `*-kit` variants (e.g., Spec-Kit, Sales-AI-Kit, blog-tech-kit, pd-kit) on the same machine, I want each kit to be collision-free (executables, Python distributions, internal namespaces, and workflow commands) so I can use them side-by-side without breaking.

**Why this priority**: Collision-free coexistence is non-negotiable: if two kits conflict, users cannot safely adopt more than one kit.

**Independent Test**: Install at least two kits and verify:
- each kit has a distinct executable,
- each kit has distinct slash command namespaces,
- each kit writes to its own kit-owned folder in a generated project.

**Acceptance Scenarios**:

1. **Given** Spec-Kit is installed and provides an executable named `specify`, **When** Sales-AI-Kit is installed, **Then** Sales-AI-Kit does not overwrite or shadow the `specify` executable.
2. **Given** both kits are installed, **When** a user invokes each kit’s workflow commands, **Then** there is no conflict between workflow namespaces (e.g., `saleskit.*` and `speckit.*`).
3. **Given** a project initialized by Sales-AI-Kit, **When** the kit writes governing memory and templates, **Then** it writes to `.saleskit/` (in a generated project) and does not overwrite another kit’s hidden folder.

---

### User Story 2 - Use Spec-Driven Development for Sales/GTM artifacts (Priority: P2)

As a founder/operator building an AI SaaS (B2B and prosumer) who wants modern AI-driven sales and marketing growth, I want the Spec-Kit workflow shape (constitution → specify → plan → tasks → implement) adapted to Sales/GTM so I can produce durable, reviewable artifacts that guide execution.

**Why this priority**: The workflow shape is the core product experience. Sales-AI-Kit must preserve it, while changing the domain rigor and defaults.

**Independent Test**: Starting with a project that has a constitution, I can generate `specs/<feature>/spec.md` that includes ICP, outcomes, measurable success criteria, and governance constraints.

**Acceptance Scenarios**:

1. **Given** a Sales-AI-Kit project, **When** I run the constitution workflow, **Then** the constitution captures non-negotiable namespace isolation and GTM governance.
2. **Given** the constitution, **When** I run the specify workflow, **Then** the generated spec emphasizes ICP-first framing, outcome-first success criteria, and evidence-first assumptions.
3. **Given** a generated spec, **When** I proceed to plan and tasks, **Then** the resulting artifacts remain consistent with the spec-driven workflow and are reviewable as markdown.

---

### User Story 3 - Correct workflow invocation across agents (Priority: P2)

As a user running different AI agents (Claude Code, Cursor, Windsurf), I want a deterministic way to invoke Sales-AI-Kit workflows that won’t collide with other kits’ workflows so the correct agent workflow is triggered every time.

**Why this priority**: If workflow invocation is ambiguous, users will trigger the wrong workflow and produce incorrect artifacts.

**Independent Test**: Configure an agent environment with multiple kits’ workflows available and verify each kit’s commands remain distinct.

**Acceptance Scenarios**:

1. **Given** a workspace that includes multiple kits, **When** I run `/saleskit.specify`, **Then** Sales-AI-Kit’s workflow runs (not Spec-Kit’s) and writes output to the correct feature directory.
2. **Given** the same workspace, **When** I run `/speckit.specify`, **Then** Spec-Kit’s workflow runs independently.

---

### User Story 4 - Preserve upstream compatibility while changing kit namespaces (Priority: P3)

As a maintainer of this fork, I want to preserve upstream Spec-Kit’s mental model and references where appropriate (e.g., referring to `./specify` as a command), while changing Sales-AI-Kit’s package names and kit-owned folder namespaces to avoid collisions.

**Why this priority**: The fork should stay aligned with upstream documentation and workflows, while remaining safe to install alongside other kits.

**Independent Test**: I can read the repository docs and understand:
- what stays aligned with upstream (workflow shape, command semantics),
- what changes for coexistence (distribution name, module name, `.saleskit/` folder, `saleskit.*` workflows).

**Acceptance Scenarios**:

1. **Given** references to the upstream helper executable `./specify`, **When** documenting the workflow, **Then** the project retains `./specify` when it refers to the upstream command behavior.
2. **Given** references to kit-owned file paths (e.g., `./specify/memory/constitution.md`), **When** describing Sales-AI-Kit’s generated project layout, **Then** those paths are changed to `.saleskit/...` for this kit.

---

### Edge Cases

- What happens when a user has multiple kits installed that historically used the same executable name (e.g., `specify`)?
- What happens when a user runs `speckit.*` commands but expects Sales-AI-Kit behavior (or vice versa)?
- What happens when a project already contains `.specify/` (from upstream) and the user initializes Sales-AI-Kit in the same directory?
- What happens when users expect `refs/` to be available but it is accidentally treated as a git submodule?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The kit MUST preserve the upstream Spec-Kit workflow shape: constitution → specify → plan → tasks → implement.
- **FR-002**: The kit MUST enforce collision-free coexistence across:
  - executable name,
  - Python distribution name,
  - Python import/module namespace,
  - kit-owned hidden folder (generated projects),
  - slash command workflow namespace.
- **FR-003**: All Sales-AI-Kit workflows MUST be invoked via `saleskit.*` slash commands (e.g., `/saleskit.specify`, `/saleskit.plan`, `/saleskit.implement`).
- **FR-004**: Sales-AI-Kit MUST NOT overlap workflow namespaces with other kits (e.g., must not collide with `speckit.*`).
- **FR-005**: The kit MUST produce spec artifacts under `specs/<feature>/` using consistent file naming (`spec.md`, `plan.md`, `tasks.md`).
- **FR-006**: Generated specs MUST be Sales/GTM-oriented and include:
  - ICP-first framing,
  - measurable outcome-first success criteria,
  - evidence-first assumptions labeling,
  - PLG/SLG awareness (and optional agentic layer when justified),
  - GTM automation governance constraints.
- **FR-007**: The kit MUST treat autonomous outbound actions (email/DM/dialing/pricing changes/CRM mutation) as human-in-the-loop by default, unless explicitly justified with rollback.
- **FR-008**: In a Sales-AI-Kit generated project, kit-owned state and templates MUST live under `.saleskit/` (not `.specify/`).
- **FR-009**: In this repository (as a worked example fork), the working copy MAY remain under `.specify/` for upstream compatibility, but references to kit-owned assets for Sales-AI-Kit generated projects MUST use `.saleskit/` paths.
- **FR-010**: Sales-AI-Kit packaging metadata MUST use non-colliding names. The kit MUST NOT use `specify` as its installable distribution name or hidden-folder namespace.
- **FR-011**: The kit MUST avoid modifying `.windsurf/` in this repository.
- **FR-012**: The kit SHOULD keep `refs/` as normal tracked files (not a git submodule) so the reference library remains reviewable and versioned.
- **FR-013**: The kit MUST update `pyproject.toml` (and any related metadata) to reflect the new non-colliding package/distribution naming when implementing this foundation.

### Key Entities *(include if feature involves data)*

- **Kit Variant**: A distribution of the Spec-Kit workflow tailored to a domain with unique namespaces.
- **Namespace Strategy**: The set of collision-free names (executable, distribution, module namespace, hidden folder, slash commands).
- **Workflow**: A deterministic sequence producing artifacts (constitution/specify/plan/tasks/implement).
- **Artifact**: Durable markdown outputs in `specs/<feature>/`.
- **Reference Library (`refs/`)**: Worked examples and principles guiding kit evolution.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user can install Sales-AI-Kit alongside at least one other kit variant and invoke both without collisions (executables + slash commands).
- **SC-002**: A Sales-AI-Kit generated project writes kit-owned memory/templates to `.saleskit/` and does not overwrite any other kit’s hidden folder.
- **SC-003**: `/saleskit.specify` produces a spec that is testable, technology-agnostic, and contains ICP, outcomes, and measurable success criteria.
- **SC-004**: Workflow invocation remains deterministic: `saleskit.*` and `speckit.*` commands trigger different workflows in the same environment.
- **SC-005**: `refs/` remains normal tracked content (not a submodule) and can serve as a durable worked example library for future `*-kit` variants.
