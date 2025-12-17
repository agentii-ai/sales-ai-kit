# Implementation Plan: Sales-AI-Kit Foundation (Namespace + Workflow)

**Branch**: `001-saleskit-foundation` | **Date**: 2025-12-17 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-saleskit-foundation/spec.md`

## Summary

Establish Sales-AI-Kit foundation: collision-free multi-kit coexistence via namespace isolation (executable, Python package, hidden folder, slash commands) while preserving Spec-Kit workflow shape. Adapt templates for Sales/GTM domain rigor (ICP-first, outcome-first, evidence-first, PLG/SLG/ALG awareness, agent governance).

## Technical Context

**Language/Version**: Python 3.11+
**Primary Dependencies**: None (pure Python CLI tool)
**Storage**: Filesystem (templates, memory, generated specs under `.saleskit/` and `specs/`)
**Testing**: Manual validation via multi-kit installation test
**Target Platform**: macOS, Linux
**Project Type**: CLI tool with template system
**Performance Goals**: N/A (file I/O bound)
**Constraints**:
- MUST NOT modify `.windsurf/` and `.claude/` in this repo.
- MUST remain safe to install alongside other `*-kit` variants (no collisions).
- MUST keep artifacts reviewable as markdown under `specs/<feature>/`.

## Constitution Check

✅ **Namespace Isolation (Principle II)**: Enforced via distinct executable (`sales`), Python package (`sales-cli`), module namespace (`saleskit`), and kit folder (`.saleskit/`).

✅ **Slash Command Namespacing (Principle III)**: All workflows use `saleskit.*` prefix (`/saleskit.specify`, `/saleskit.plan`, etc.).

✅ **Artifacts are the Product (Principle IV)**: Generated projects write to `.saleskit/`; this repo keeps `.specify/` for upstream compatibility.

✅ **Sales & Marketing Rigor (Principle V)**: Templates enforce ICP-first, outcome-first, evidence-first, hybrid GTM (PLG/SLG/ALG), signal-driven qualification, tier clarity.

✅ **Agent Governance (Principle VI)**: Templates enforce HITL for autonomous actions, auditability, truthfulness constraints, cost/ROI discipline.

## Canonical Namespace Matrix

| Isolation Layer | Sales-AI-Kit Value | Spec-Kit Value | Purpose |
|----------------|-------------------|----------------|----------|
| **CLI executable** | `sales` | `specify` | Invoke kit workflows from command line |
| **Python distribution name** | `sales-cli` | `specify-cli` | PyPI/pip package name (no collisions) |
| **Python module namespace** | `saleskit` | `speckit` | Import namespace (`import saleskit`) |
| **Kit package folder (generated projects)** | `.saleskit/` | `.specify/` | Where kit writes memory/templates in new projects |
| **Slash command namespace** | `saleskit.*` | `speckit.*` | Agent workflow commands (`/saleskit.specify`) |
| **Upstream verb (preserved)** | `./specify` | `./specify` | Workflow action ("specify a feature") - not a namespace |

## Naming Collision Checklist

### ✅ Keep from Upstream (No Collision Risk)

- Workflow **verbs** when describing actions: "specify a feature", "plan the implementation"
- References to upstream executable behavior: `./specify` (when documenting Spec-Kit compatibility)
- Workflow **shape**: constitution → specify → plan → tasks → implement
- Folder structure: `specs/<feature>/spec.md`, `specs/<feature>/plan.md`, `specs/<feature>/tasks.md`

### ❌ Must NOT Use (Collision Risk)

- `specify` as Sales-AI-Kit's:
  - Distribution/package name
  - Module import namespace
  - Hidden folder name (`.specify/`)
  - Slash command prefix (`/specify.*`)
- `speckit.*` as Sales-AI-Kit's slash command namespace

### ✅ Sales-AI-Kit Namespaces (Collision-Free)

- Executable: `sales`
- Distribution: `sales-cli` (or similar non-`specify` name)
- Module: `saleskit`
- Kit folder: `.saleskit/`
- Slash commands: `saleskit.*` (`/saleskit.specify`, `/saleskit.plan`, etc.)

## Working-Copy Constraint Checklist

### ✅ Safe to Modify

- `.saleskit/` (Sales-AI-Kit's template/memory working copy in this repo)
- `.specify/templates/` (but only for domain adaptation, not workflow shape changes)
- `.specify/memory/constitution.md` (Sales-AI-Kit constitution updates)
- `specs/` (feature specifications and plans)
- `refs/` (reference library for Sales-AI-Kit patterns)
- Python source under `src/saleskit/` (new implementation)
- `pyproject.toml` (packaging metadata for Sales-AI-Kit)

### ❌ MUST NOT Modify (Constraint Violations)

- `.windsurf/` (Windsurf agent working copy)
- `.claude/` (Claude Code agent working copy)

These are agent-specific configurations for **this repository** as a development environment. Generated projects will create their own agent configurations via `sales init --ai <agent>`.

## Project Structure

### Documentation (this feature)

```text
specs/001-saleskit-foundation/
├── spec.md              # Feature specification
├── plan.md              # This file (implementation plan)
├── tasks.md             # Task breakdown
└── checklists/          # Quality gates
    ├── requirements.md  # Spec quality checklist
    └── setup.md         # Precondition verification
```

### Sales-AI-Kit Template System (Working Copy in This Repo)

```text
.saleskit/
├── memory/
│   └── constitution.md          # Sales-AI-Kit constitution (source template)
├── templates/
│   ├── spec-template.md         # Sales/GTM-oriented spec template
│   ├── plan-template.md         # Plan template (references saleskit.*)
│   ├── tasks-template.md        # Tasks template (references saleskit.*)
│   ├── checklist-template.md    # Checklist template (references saleskit.*)
│   └── agent-file-template.md   # Agent command/workflow template
└── scripts/
    └── bash/
        ├── create-new-feature.sh  # Feature scaffolding script
        ├── setup-plan.sh          # Plan initialization script
        └── [other helpers]
```

### Sales-AI-Kit Python Package (New Implementation)

```text
src/saleskit/
├── __init__.py          # Package entry point
├── cli.py               # Main CLI implementation
└── [future modules]

tests/
└── [future test structure]

pyproject.toml           # Package metadata (sales-cli distribution)
```

### Upstream Compatibility Layer (Preserved)

```text
.specify/
├── templates/           # Upstream-compatible templates (adapted for Sales/GTM)
├── memory/
│   └── constitution.md  # Points to .saleskit/ for Sales-AI-Kit
└── [upstream structure preserved for compatibility]
```

## Structure Decision

**Chosen**: Single project (Python CLI tool + template system)

The implementation consists of:
1. **Python CLI** (`src/saleskit/`) - Provides `sales` executable and project initialization
2. **Template System** (`.saleskit/`) - Domain-adapted Spec-Kit templates for Sales/GTM
3. **Reference Library** (`refs/`) - Worked examples and principles for Sales-AI-Kit

No database, no API, no complex architecture. Pure filesystem-based template rendering with Python CLI for project initialization and namespace enforcement.

## Implementation Phases (from tasks.md)

### Phase 1: Setup ✅ (Complete)
- Verified feature branch, constraints, refs/ status, feature docs exist

### Phase 2: Foundational (Current)
- Define canonical namespace matrix ✅ (this section)
- Add naming collision checklist ✅ (this section)
- Add working-copy constraint checklist ✅ (this section)

### Phase 3: User Story 1 — Packaging & Namespace Isolation
- Create `pyproject.toml` with `sales-cli` distribution name
- Define `sales` console script entrypoint
- Implement `src/saleskit/` Python package
- Add namespace self-check command
- Document multi-kit install test

### Phase 4: User Story 2 — Sales/GTM Template Adaptation
- Update spec template for Sales/GTM orientation
- Update plan/tasks/checklist templates to reference `saleskit.*`
- Ensure templates use `.saleskit/` paths for generated projects
- Add governance guidance (HITL, auditability, truthfulness)

### Phase 5: User Story 3 — Agent Workflow Generation
- Implement `sales init` command to scaffold projects
- Copy constitution/templates into `.saleskit/` in new projects
- Add agent detection and targeting flags
- Generate agent command/workflow files for selected agent
- Create Sales-AI-Kit command/workflow templates

### Phase 6: User Story 4 — Documentation Compatibility
- Update README with fork notes and naming clarifications
- Fix broken refs in documentation
- Add "Two meanings of specify" section to constitution (if needed)

### Phase 7: Polish & Cross-Cutting
- Add multi-kit validation checklist
- Add PDCA checklist
- Global replace of user-facing `speckit.` → `saleskit.`
- Ensure no `.specify/` paths when describing generated projects (use `.saleskit/`)

## Complexity Tracking

*No violations to justify. Implementation follows constitution principles without introducing complexity.*
