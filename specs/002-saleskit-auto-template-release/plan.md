# Implementation Plan: Automated Sales-AI-Kit Template Release Generation

**Feature**: Automated template release generation for multiple AI agents from `.saleskit/` source
**Branch**: 002-saleskit-auto-template-release
**Created**: 2025-12-18
**Status**: Design Phase

---

## Executive Summary

This plan implements automated generation and publication of 36 Sales-AI-Kit template variants (18 AI agents × 2 script types) to GitHub releases.

The system follows the same proven workflow shape used by other *-kits in this repo: build 36 archives, validate them, then publish a GitHub release containing the ZIP assets and checksums.

**Key Objectives**:

1. Generate 36 template ZIP files with Sales-AI-Kit branding and `saleskit.*` commands sourced from `.saleskit/`
2. Automate release creation on main branch pushes affecting `.saleskit/` and release-relevant paths
3. Validate templates to ensure correct structure and eliminate unintended cross-kit references
4. Publish to GitHub releases with checksums and release notes

**Success Criteria**:

- Each release publishes exactly 36 assets (18 agents × 2 scripts)
- All assets validate successfully (structure + required files + namespace)
- Local build script can reproduce the same artifacts as CI

---

## Technical Context

### Source Architecture

**Sales-AI-Kit Source Structure** (`.saleskit/` directory):

```
.saleskit/
├── memory/
│   └── constitution.md
├── scripts/
│   └── bash/
│       ├── common.sh
│       ├── setup-plan.sh
│       ├── check-prerequisites.sh
│       ├── update-agent-context.sh
│       └── create-new-feature.sh
├── templates/
│   ├── spec-template.md
│   ├── plan-template.md
│   ├── tasks-template.md
│   └── commands/
│       ├── saleskit.constitution.md
│       ├── saleskit.specify.md
│       ├── saleskit.plan.md
│       ├── saleskit.tasks.md
│       ├── saleskit.implement.md
│       ├── saleskit.clarify.md
│       ├── saleskit.analyze.md
│       ├── saleskit.checklist.md
│       └── saleskit.taskstoissues.md
```

**Target Template Structure** (extracted in a generated project):

```
project-root/
├── .saleskit/
│   ├── memory/
│   │   └── constitution.md
│   ├── scripts/
│   │   ├── bash/
│   │   └── powershell/            # for ps variants
│   └── templates/
│       ├── spec-template.md
│       ├── plan-template.md
│       ├── tasks-template.md
│       └── commands/
│           └── saleskit.*.md
└── .{agent}/
    └── ...                        # agent-specific command/workflow dirs
```

### Existing Infrastructure Assumptions

This plan assumes a release workflow will:

- Choose a `vX.Y.Z` version (typically auto-incremented)
- Build 36 variants into a staging directory (e.g., `.genreleases/`)
- Validate the built artifacts
- Publish a GitHub release with all artifacts attached

### Technology Stack

- **Build Tooling**: Bash + standard Unix tools (sed, awk, grep, zip)
- **CI/CD**: GitHub Actions (ubuntu-latest)
- **Release**: GitHub Releases via `gh`

---

## Constitution Check

### Multi-Kit Namespace Isolation (NON-NEGOTIABLE) ✅

**Compliance**: The plan maintains Sales-AI-Kit’s distinct namespaces:

- Executable: `sales`
- Python distribution: `sales-cli`
- Python module: `saleskit`
- Kit folder: `.saleskit/`
- Workflows: `saleskit.*`

**Validation Gate**: Template validation MUST fail if `speckit.*` is present where `saleskit.*` is required.

---

## Architecture Overview

### System Components

```
GitHub Actions Workflow (.github/workflows/release.yml)
Trigger: Push to main (paths: .saleskit/**, release scripts, etc.)

  Step 1: Get Next Version
    Script: .github/workflows/scripts/get-next-version.sh

  Step 2: Check Release Exists
    Script: .github/workflows/scripts/check-release-exists.sh

  Step 3: Build Template Variants (36)
    Script: .github/workflows/scripts/create-release-packages.sh

  Step 4: Validate Templates
    Script: scripts/validate-templates.sh

  Step 5: Generate Release Notes
    Script: .github/workflows/scripts/generate-release-notes.sh

  Step 6: Create GitHub Release
    Script: .github/workflows/scripts/create-github-release.sh
```

### Build Process Detail

Per agent/script variant:

1. Create a staging directory
2. Copy `.saleskit/` into the staging directory as `.saleskit/`
3. Generate agent-specific command/workflow assets from `.saleskit/templates/commands/`
4. Zip the staging directory into `spec-kit-template-{agent}-{script}-v{version}.zip`
5. Compute SHA-256 checksum

---

## Phase 0: Research & Design

**Goal**: Confirm assumptions from other kits and adapt for Sales-AI-Kit

Deliverables:

- Confirmation of the agent list and directory mappings
- Confirmation of the expected release asset naming pattern
- Confirmation of Sales-AI-Kit’s template source-of-truth (`.saleskit/`)

---

## Phase 1: Local Build Infrastructure

**Goal**: Enable local template generation for testing before CI integration

Key outputs:

- `scripts/build-templates.sh` wrapper that writes to `dist/templates/`
- Core build script at `.github/workflows/scripts/create-release-packages.sh`
- Build manifest generation (JSON)

---

## Phase 2: Validation Infrastructure

**Goal**: Create automated validation to prevent publishing bad templates

Key outputs:

- `scripts/validate-templates.sh`
- Validation checks for:
  - command namespace (`saleskit.*`)
  - required `.saleskit/` files present
  - directory structure correctness
  - zip integrity

---

## Phase 3: CI/CD Integration

**Goal**: Integrate template generation into GitHub Actions workflow

Key outputs:

- `.github/workflows/release.yml` for releases
- `.github/workflows/ci.yml` for PR validation (build + validate)

---

## Phase 4: First Release & Validation

**Goal**: Publish first Sales-AI-Kit template release and verify downloads

Key checks:

- Release page contains all 36 assets with checksums
- A sample extracted template contains `.saleskit/` and correct agent assets

---

## Phase 5: Ongoing Maintenance

**Goal**: Establish a repeatable process for future template updates

- Update `.saleskit/` templates or scripts
- Run `./scripts/build-templates.sh vX.Y.Z-test` locally
- Merge to main
- Release workflow triggers and publishes a new release

---

**Plan Version**: 1.0
**Last Updated**: 2025-12-18
**Status**: Ready for Task Generation
