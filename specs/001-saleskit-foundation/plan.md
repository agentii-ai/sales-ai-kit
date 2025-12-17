# Implementation Plan: Sales-AI-Kit Foundation
 
 **Branch**: `001-saleskit-foundation` | **Date**: 2025-12-17 | **Spec**: [`specs/001-saleskit-foundation/spec.md`](./spec.md)
 **Input**: Feature specification from `specs/001-saleskit-foundation/spec.md`
 
 **Note**: This plan is the output of the `/saleskit.plan` workflow (Sales-AI-Kit command namespace).

 ## Summary
 
 This feature establishes Sales-AI-Kit as a Spec-Kit-compatible fork focused on Sales/GTM artifacts, while guaranteeing **multi-kit coexistence** via strict namespace isolation.
 
 Primary delivery:
 - **Namespace isolation** across:
   - **Executable** (`sales`, not `specify`)
   - **Distribution** (non-colliding install name, e.g. `sales-cli`)
   - **Import/module** (`saleskit`)
   - **Kit-owned project folder** (`.saleskit/` in generated projects)
   - **Agent workflows** (`/saleskit.*`)
 - **Workflow shape preserved**: constitution -> specify -> plan -> tasks -> implement.
 - **GTM rigor**: plans and templates emphasize ICP-first framing, measurable outcomes, and evidence vs assumptions.

 ## Technical Context
 
 **Language/Version**: Python (version pinned at implementation time; target 3.11+)  
 **Primary Dependencies**: Spec-Kit-derived tooling (CLI + templates); exact Python deps to be set when adding packaging metadata  
 **Storage**: N/A (documentation/templates + small scripts)  
 **Testing**: Shell script smoke tests + Python unit tests (when Python package is introduced)  
 **Target Platform**: macOS/Linux (developer tooling)  
 **Project Type**: Kit + templates (not an application)  
 **Performance Goals**: N/A (human-scale CLI workflow execution)  
 **Constraints**:
 - MUST NOT modify `.windsurf/` and `.claude` in this repo.
 - MUST remain safe to install alongside other `*-kit` variants (no collisions).
 - MUST keep artifacts reviewable as markdown under `specs/<feature>/`.
 **Scale/Scope**: Foundation naming + workflow namespace work (no production GTM automation shipped here)

 ## Constitution Check
 
 *GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*
 
 Gates derived from `/.specify/memory/constitution.md`:
 - **Spec-Kit compatibility**: preserve the workflow shape and upstream mental model.
 - **Namespace isolation (non-negotiable)**:
   - executable name must be `sales` (not `specify`)
   - distribution + import/module names must not collide with Spec-Kit or other variants
   - generated-project kit folder must be `.saleskit/`
 - **Slash command namespacing**: all workflows invoked via `/saleskit.*`.
 - **Artifacts are the product**: durable markdown outputs under `specs/<feature>/`.
 - **Sales & marketing rigor**: outcome-first, ICP-first, evidence-first.
 - **Agent governance**: human-in-the-loop for outbound actions by default; auditability and truthfulness constraints.
 - **Repo constraint**: do not modify `.windsurf/` and `.claude`.

 ## Project Structure

### Documentation (this feature)

 ```text
 specs/[###-feature]/
 ├── spec.md              # This file (/saleskit.specify output)
 ├── plan.md              # This file (/saleskit.plan output)
 └── tasks.md             # Phase 2 output (/saleskit.tasks output)
 ```
 
 Notes:
 - For this foundation feature, `research.md`, `data-model.md`, `quickstart.md`, and `contracts/` are intentionally deferred until we introduce concrete workflows or APIs that require them.

 ### Source Code (repository root)
 
 ```text
 .specify/
 ├── memory/
 ├── scripts/
 └── templates/
 
 .saleskit/
 └── (reserved for generated-project parity; keep empty or mirror selectively)
 
 refs/
 specs/
 
 # Proposed (to be introduced by tasks for this feature)
 pyproject.toml
 src/
 └── saleskit/
     ├── __init__.py
     ├── cli/
     ├── workflows/
     └── templates/
 tests/
 └── unit/
 ```
 
 **Structure Decision**: This repo remains a worked-example fork where upstream-compatible assets live under `.specify/`, while Sales-AI-Kit generated-project semantics and references use `.saleskit/` paths and the `saleskit` Python namespace.

 ## Complexity Tracking
 
 > **Fill ONLY if Constitution Check has violations that must be justified**
 
 | Violation | Why Needed | Simpler Alternative Rejected Because |
 |-----------|------------|-------------------------------------|
 | [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
 | [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
