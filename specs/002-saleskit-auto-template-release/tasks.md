# Tasks: Automated Sales-AI-Kit Template Release Generation

**Feature**: Automated template release generation for multiple AI agents from `.saleskit/` source
**Branch**: 002-saleskit-auto-template-release
**Created**: 2025-12-18
**Status**: Ready for Implementation

---

## Task Organization

Tasks are grouped by implementation phase and ordered by dependencies. Each task includes:

- **ID**: Unique task identifier
- **Phase**: Implementation phase (0-4)
- **Priority**: P0 (critical path), P1 (high), P2 (medium), P3 (low)
- **Dependencies**: Tasks that must complete first
- **Acceptance Criteria**: How to verify completion

---

## Phase 0: Quick Setup & Verification

### Task 0.1: Verify `.saleskit/` Directory Structure

**ID**: SALESREL-001
**Priority**: P0 (Critical Path)
**Dependencies**: None
**Status**: Not Started

**Description**:
Verify that all required files exist in `.saleskit/` source directory and are ready for template generation.

**Implementation Steps**:

1. Check `.saleskit/memory/constitution.md` exists
2. List all files in `.saleskit/scripts/bash/`
3. List all files in `.saleskit/templates/`
4. List all command files in `.saleskit/templates/commands/`
5. Document any missing files or gaps

**Validation Commands**:

```bash
# Verify structure
ls -la .saleskit/

# Count command files
ls .saleskit/templates/commands/saleskit.*.md | wc -l

# Check for unintended speckit references
grep -r "speckit\." .saleskit/ && echo "ERROR: Found speckit references"
```

**Acceptance Criteria**:

- ✅ `.saleskit/memory/constitution.md` exists
- ✅ `.saleskit/scripts/bash/` contains required scripts
- ✅ `.saleskit/templates/` contains spec/plan/tasks templates
- ✅ `.saleskit/templates/commands/` contains Sales-AI-Kit command templates
- ✅ No unintended `speckit.*` references in `.saleskit/`

---

### Task 0.2: Define Agent + Script Variant Matrix

**ID**: SALESREL-002
**Priority**: P0 (Critical Path)
**Dependencies**: SALESREL-001
**Status**: Not Started

**Description**:
Confirm the canonical agent list (18) and the two script variants (sh/ps), and define their expected output directories.

**Acceptance Criteria**:

- ✅ Documented list of supported agents (same as other kits)
- ✅ Documented mapping from agent name → expected command/workflow directory

---

## Phase 1: Local Build Infrastructure

### Task 1.1: Create Workflow Scripts Directory

**ID**: SALESREL-003
**Priority**: P0 (Critical Path)
**Dependencies**: SALESREL-002
**Status**: Not Started

**Description**:
Create `.github/workflows/scripts/` directory structure and placeholder scripts.

**Files to Create**:

- `.github/workflows/scripts/get-next-version.sh`
- `.github/workflows/scripts/check-release-exists.sh`
- `.github/workflows/scripts/create-release-packages.sh`
- `.github/workflows/scripts/generate-release-notes.sh`
- `.github/workflows/scripts/create-github-release.sh`

**Acceptance Criteria**:

- ✅ Directory exists
- ✅ All 5 scripts exist and are executable

---

### Task 1.2: Implement `create-release-packages.sh`

**ID**: SALESREL-004
**Priority**: P0 (Critical Path)
**Dependencies**: SALESREL-003
**Status**: Not Started

**Description**:
Implement the core build script that generates 36 template variants from `.saleskit/` source, packaging into `.saleskit/` structure.

**Key Requirements**:

- Builds 18 agents × 2 scripts = 36 variants
- Uses `.saleskit/` as source and `.saleskit/` inside each generated ZIP
- Generates agent-specific command/workflow files from `.saleskit/templates/commands/`
- Names output archives: `spec-kit-template-{agent}-{script}-v{version}.zip`

**Acceptance Criteria**:

- ✅ Produces 36 ZIP files
- ✅ Each ZIP contains `.saleskit/` with memory/templates/scripts
- ✅ Each ZIP contains agent-specific assets
- ✅ Script prints progress and exits non-zero on failure

---

### Task 1.3: Implement Helper Scripts

**ID**: SALESREL-005
**Priority**: P0 (Critical Path)
**Dependencies**: SALESREL-004
**Status**: Not Started

**Description**:
Implement supporting scripts used by CI.

- `get-next-version.sh`: determine next tag (patch increment)
- `check-release-exists.sh`: check if release tag already exists
- `generate-release-notes.sh`: create markdown notes including checksums
- `create-github-release.sh`: publish release and upload assets

**Acceptance Criteria**:

- ✅ Scripts behave correctly in CI environment
- ✅ Notes contain asset list + sha256

---

### Task 1.4: Create Local Build Wrapper `scripts/build-templates.sh`

**ID**: SALESREL-006
**Priority**: P0 (Critical Path)
**Dependencies**: SALESREL-004
**Status**: Not Started

**Description**:
Create a local wrapper that outputs to `dist/templates/` and supports filtering by agent/script.

**Acceptance Criteria**:

- ✅ Accepts version argument
- ✅ Outputs to `dist/templates/`
- ✅ Supports environment filtering (AGENTS, SCRIPTS)
- ✅ Produces a build manifest JSON

---

## Phase 2: Validation Infrastructure

### Task 2.1: Create Template Validation Script

**ID**: SALESREL-007
**Priority**: P0 (Critical Path)
**Dependencies**: SALESREL-006
**Status**: Not Started

**Description**:
Implement `scripts/validate-templates.sh` to validate either a directory of ZIPs or a single ZIP.

**Validation Checks**:

- Frontmatter namespace uses `saleskit.*`
- Required `.saleskit/` files exist (constitution + templates + commands)
- No unintended `speckit.*` references
- Directory structure is correct for each agent
- ZIP integrity (extractable)

**Acceptance Criteria**:

- ✅ Exit 0 if all pass, non-zero if any fail
- ✅ Clear error messages

---

### Task 2.2: Integrate Validation into Local Build

**ID**: SALESREL-008
**Priority**: P0 (Critical Path)
**Dependencies**: SALESREL-007
**Status**: Not Started

**Description**:
Update `scripts/build-templates.sh` to automatically run validation after build.

**Acceptance Criteria**:

- ✅ Build fails if validation fails
- ✅ Build only prints success message when validation passes

---

## Phase 3: CI/CD Integration

### Task 3.1: Create Release Workflow

**ID**: SALESREL-009
**Priority**: P0 (Critical Path)
**Dependencies**: SALESREL-008
**Status**: Not Started

**Description**:
Create `.github/workflows/release.yml` that triggers on push to main (paths include `.saleskit/**`) and publishes a GitHub release.

**Acceptance Criteria**:

- ✅ Workflow triggers on `.saleskit/**` changes
- ✅ Workflow supports manual `workflow_dispatch`
- ✅ Workflow publishes release only if validation passes

---

### Task 3.2: Create CI Workflow

**ID**: SALESREL-010
**Priority**: P1 (High)
**Dependencies**: SALESREL-008
**Status**: Not Started

**Description**:
Create `.github/workflows/ci.yml` that runs on pull requests and executes build + validation.

**Acceptance Criteria**:

- ✅ CI fails on validation errors
- ✅ CI builds all 36 variants (or a representative subset, if time-constrained)

---

## Phase 4: First Release & Validation

### Task 4.1: Publish First Release

**ID**: SALESREL-011
**Priority**: P1 (High)
**Dependencies**: SALESREL-009
**Status**: Not Started

**Description**:
Trigger the first release and verify assets.

**Acceptance Criteria**:

- ✅ Release exists on GitHub
- ✅ 36 assets attached
- ✅ Release notes include checksums

---

### Task 4.2: Verify Template Extraction

**ID**: SALESREL-012
**Priority**: P1 (High)
**Dependencies**: SALESREL-011
**Status**: Not Started

**Description**:
Extract a couple representative templates locally and verify `.saleskit/` exists and command namespace is correct.

**Acceptance Criteria**:

- ✅ Extracted template contains `.saleskit/`
- ✅ Agent assets exist
- ✅ No unintended `speckit.*` references

---

## Parallel Opportunities

- Tasks in **Phase 1** can be parallelized by file, except `create-release-packages.sh` should be done before wrapper/validation work.
- Validation script development can proceed in parallel once there is at least one build variant to validate.

---

## Completion Checklist

- [ ] Local build script produces 36 ZIPs
- [ ] Validation script passes for all ZIPs
- [ ] Release workflow publishes a release with 36 assets
- [ ] Release notes include checksums
- [ ] Templates contain `.saleskit/` and correct `saleskit.*` namespace
