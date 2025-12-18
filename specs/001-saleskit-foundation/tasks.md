# Tasks: Sales-AI-Kit Foundation

**Input**: Design documents from `/specs/001-saleskit-foundation/`
**Prerequisites**: `specs/001-saleskit-foundation/plan.md` (required), `specs/001-saleskit-foundation/spec.md` (required), `.saleskit/memory/constitution.md` (required), `refs/4_pm_tasking_for_tasks.md` (methodology)

**Tests**: Not requested. Validation via manual multi-kit installation testing and end-to-end workflow smoke checks.

**Organization**: Tasks are grouped by user story (US1–US4) to enable independent implementation and testing.

---

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., `[US1]`)
- Every task includes an exact file path in the description.

---

## Path Conventions

- **Upstream working copy (this repo)**: `.specify/` (do not rename)
- **Sales-AI-Kit generated-project root**: `.saleskit/` (kit-owned state)
- **Future Python package namespace**: `src/saleskit/`
- **Feature artifacts**: `specs/<feature>/spec.md`, `specs/<feature>/plan.md`, `specs/<feature>/tasks.md`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Verify starting state and protect constraints.

- [X] T001 Verify you are on branch `001-saleskit-foundation` and record output in `specs/001-saleskit-foundation/checklists/setup.md`
- [X] T002 Verify constraints are documented (no edits to `.windsurf/` and `.claude/`) in `specs/001-saleskit-foundation/plan.md`
- [X] T003 [P] Verify `refs/` is a normal tracked folder (not a submodule) and record output in `specs/001-saleskit-foundation/checklists/setup.md`
- [X] T004 [P] Verify feature docs exist and record output in `specs/001-saleskit-foundation/checklists/setup.md`
- [X] T005 [P] Identify and remove remaining user-facing `speckit.*` references in `.saleskit/**/*.md` and `specs/**/*.md` (do not touch `.windsurf/`, `.claude/`, or `.specify/`)

**Checkpoint**: Preconditions verified; safe to implement without breaking agent working copies.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Lock the namespace strategy and encode the "two meanings of specify" rule into the kit implementation.

- [X] T006 Define the canonical namespace matrix in `specs/001-saleskit-foundation/plan.md` (executable `sales`, workflows `/saleskit.*`, module `saleskit`, dist e.g. `sales-cli`, kit folder `.saleskit/`)
- [X] T007 Add a naming collision checklist section to `specs/001-saleskit-foundation/plan.md` (explicit: keep `./specify` verb/executable references; avoid `specify` for dist/module/folder)
- [X] T008 [P] Add a "working-copy constraint" checklist section to `specs/001-saleskit-foundation/plan.md` (explicit: do not modify `.windsurf/` or `.claude/` in this repo)

**Checkpoint**: Foundation rules are explicit; implementation tasks can reference them.

---

## Phase 3: User Story 1 — Coexist with other *-kit variants on one machine (Priority: P1) MVP

**Goal**: Make Sales-AI-Kit installable alongside Spec-Kit without collisions (dist name, import namespace, executable).

**Independent Test**: Install Spec-Kit and Sales-AI-Kit in the same environment and verify both `specify --help` and `sales --help` work, and `import saleskit` does not collide with upstream.

### Implementation for User Story 1

- [X] T009 [US1] Create `pyproject.toml` with a non-colliding distribution name (e.g., `sales-cli`) at `pyproject.toml`
- [X] T010 [P] [US1] Define console script entrypoint `sales` in `pyproject.toml` (e.g., `[project.scripts] sales = "saleskit.cli:main"`)
- [X] T011 [P] [US1] Create Python package root at `src/saleskit/__init__.py`
- [X] T012 [P] [US1] Implement minimal CLI entrypoint in `src/saleskit/cli.py` (prints help and supports subcommands scaffold)
- [X] T013 [US1] Add a "namespace self-check" command in `src/saleskit/cli.py` (prints resolved kit namespace values: dist/module/hidden-folder)
- [X] T014 [US1] Add a smoke-test script for local install in `scripts/smoke/test_install.sh` (install + `sales --help`)
- [X] T015 [US1] Document the multi-kit install test procedure in `specs/001-saleskit-foundation/validation/multi-kit-install.md`

**Checkpoint**: You can install and invoke `sales` without replacing `specify`.

---

## Phase 4: User Story 2 — Use Spec-Driven Development for Sales/GTM artifacts (Priority: P2)

**Goal**: Adapt templates/prompts so generated artifacts are Sales/GTM-oriented (ICP-first, outcome-first, evidence-first) while preserving upstream workflow shape.

**Independent Test**: Run the workflows in an initialized project and verify `spec.md`, `plan.md`, and `tasks.md` are generated with Sales/GTM rigor and correct namespaces.

### Implementation for User Story 2

- [X] T016 [P] [US2] Update spec template language to be Sales/GTM oriented in `.saleskit/templates/spec-template.md`
- [X] T017 [P] [US2] Update plan template to reference `/saleskit.plan` (not `/speckit.plan`) in `.saleskit/templates/plan-template.md`
- [X] T018 [P] [US2] Update tasks template to reference `/saleskit.tasks` (not `/speckit.tasks`) in `.saleskit/templates/tasks-template.md`
- [X] T019 [P] [US2] Update checklist template to reference `/saleskit.checklist` (not `/speckit.checklist`) in `.saleskit/templates/checklist-template.md`
- [X] T020 [US2] Ensure all templates describe generated-project kit-owned assets using `.saleskit/` paths (not `.specify/`) in `.saleskit/templates/*.md`
- [X] T021 [US2] Add explicit governance guidance text (HITL for outbound, auditability, truthfulness) to `.saleskit/templates/spec-template.md` and `.saleskit/templates/plan-template.md`

**Checkpoint**: Templates consistently produce Sales-AI-Kit artifacts and use the `saleskit` namespace.

---

## Phase 5: User Story 3 — Correct workflow invocation across agents (Priority: P2)

**Goal**: Ensure `/saleskit.*` workflows can be invoked deterministically across Claude Code, Cursor, and Windsurf—without editing this repo’s `.claude/` or `.windsurf/` working copies.

**Independent Test**: Initialize a fresh directory via `sales init` and verify it contains the right agent command/workflow files for the selected agent.

### Implementation for User Story 3

- [X] T022 [US3] Implement `sales init` command to scaffold a project with `.saleskit/` at `src/saleskit/cli.py`
- [X] T023 [P] [US3] Copy the constitution into `.saleskit/memory/constitution.md` in initialized projects (source from this repo’s `.saleskit/memory/constitution.md`) in `src/saleskit/cli.py`
- [X] T024 [P] [US3] Copy Sales-AI-Kit templates into `.saleskit/templates/` in initialized projects (source from this repo’s `.saleskit/templates/`) in `src/saleskit/cli.py`
- [X] T025 [US3] Add agent targeting flag (e.g., `--ai claude|cursor|windsurf`) in `src/saleskit/cli.py`
- [X] T026 [US3] For Claude Code projects: generate agent command files under the *project’s* `.claude/commands/` (do not edit this repo’s `.claude/`) from templates in `src/saleskit/cli.py`
- [X] T027 [US3] For Windsurf projects: generate workflows under the *project’s* `.windsurf/workflows/` (do not edit this repo’s `.windsurf/`) from templates in `src/saleskit/cli.py`
- [X] T028 [US3] Create Sales-AI-Kit command/workflow templates in `.saleskit/templates/commands/` (e.g., `saleskit.specify.md`, `saleskit.plan.md`, `saleskit.tasks.md`, `saleskit.implement.md`)

**Checkpoint**: A new project contains `/saleskit.*` invocation assets for the chosen agent.

---

## Phase 6: User Story 4 — Preserve upstream compatibility while changing kit namespaces (Priority: P3)

**Goal**: Keep upstream mental model intact (workflow shape, `./specify` references) while changing only kit-owned namespaces that must be isolated.

**Independent Test**: Repo docs clearly explain what stays upstream-compatible and what is Sales-AI-Kit-specific; no ambiguous naming.

### Implementation for User Story 4

- [ ] T029 [P] [US4] Update `README_spec-kit.md` fork notes (or add a Sales-AI-Kit README) to clarify naming: keep `./specify` when referring to upstream command behavior; use `.saleskit/` for kit-owned assets
- [ ] T030 [P] [US4] Update `refs/6_windsurf_prompts.md` to remove references to missing `tasking_methodology.md` or replace with the actual path (do not add new `.windsurf/` workflows here)
- [ ] T031 [US4] Verify the “Two meanings of specify” guidance is explicit in `.saleskit/memory/constitution.md` and record any needed follow-ups in `specs/001-saleskit-foundation/validation/two-meanings-of-specify.md`

**Checkpoint**: Documentation is unambiguous and supports multi-kit coexistence.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Add validation, tighten consistency, and ensure repeatable execution (PDCA-style checkpoints per `refs/4_pm_tasking_for_tasks.md`).

- [ ] T032 [P] Add a multi-kit validation checklist to `specs/001-saleskit-foundation/validation/multi-kit-validation.md` (install both kits, run both CLIs, verify namespaces)
- [ ] T033 [P] Add a weekly PDCA checklist section to `specs/001-saleskit-foundation/validation/pdca.md` (Plan/Do/Check/Act for naming collisions + template regressions)
- [ ] T034 Run a repo-wide grep for `speckit.` and replace remaining user-facing references with `saleskit.` where appropriate in `README_*.md`, `refs/**/*.md`, `specs/**/*.md`, and `.saleskit/**/*.md` (do not touch `.windsurf/`, `.claude/`, or `.specify/`)
- [ ] T035 Ensure no kit-owned paths mention `.specify/` when describing generated projects (use `.saleskit/`) in `.saleskit/templates/*.md` and `.saleskit/templates/commands/*.md`

**Checkpoint**: Repo is consistent, constraints are respected, and workflows are repeatable.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup
- **US1 (Phase 3)**: Depends on Foundational
- **US2–US4 (Phases 4–6)**: Depend on US1 being in place (so the CLI and namespace rules exist)
- **Polish (Phase 7)**: Depends on all user stories

### User Story Dependencies

```
US1 (namespace isolation + packaging)
  ↓
US2 (sales/gtm templates)
  ↓
US3 (agent workflow generation)
  ↓
US4 (docs + compatibility)
```

### Parallel Opportunities

- Template edits in `.saleskit/templates/` can be done in parallel (T016–T020)
- Project scaffolding work can be done in parallel with template authoring once `sales` CLI exists

---

## Parallel Example: Template Alignment (US2)

```bash
Task: "Update spec template in .saleskit/templates/spec-template.md"
Task: "Update plan template in .saleskit/templates/plan-template.md"
Task: "Update tasks template in .saleskit/templates/tasks-template.md"
Task: "Update checklist template in .saleskit/templates/checklist-template.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phases 1–2
2. Complete Phase 3 (US1)
3. **STOP and VALIDATE**: Install alongside Spec-Kit and verify no collisions

### Incremental Delivery

1. US1: collisions solved
2. US2: domain-specific templates
3. US3: deterministic agent workflows in initialized projects
4. US4: docs and compatibility clarity

---

## Task Summary

- **Total tasks**: 35
- **By story**:
  - US1: 7 tasks
  - US2: 6 tasks
  - US3: 7 tasks
  - US4: 3 tasks
  - Setup/Foundational/Polish: 12 tasks
