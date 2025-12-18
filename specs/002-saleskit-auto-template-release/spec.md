# Feature Specification: Automated Template Release Generation for Sales-AI-Kit

**Feature Branch**: `002-saleskit-auto-template-release`
**Created**: 2025-12-18
**Status**: Draft
**Input**: Automated template release generation for Sales-AI-Kit with templates from `.saleskit/` directory

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Release Manager Creates New Sales-AI-Kit Release (Priority: P1)

A Sales-AI-Kit maintainer wants to create a new release with templates for all supported AI agents (Claude, Cursor, Windsurf, Gemini, Copilot, Qoder, etc.) using both bash and PowerShell script variants. They should be able to trigger the release process that automatically generates 34 template ZIP files and publishes them to GitHub releases.

**Why this priority**: This is the core capability that enables Sales-AI-Kit to have its own releases and stop relying on Spec-Kit template fallback.

**Independent Test**: Can be fully tested by triggering the release workflow, verifying all 34 ZIP files are generated correctly, and confirming the GitHub release is published with proper naming and versioning.

**Acceptance Scenarios**:

1. **Given** the maintainer has merged changes to main branch, **When** they push to main (affecting `.saleskit/`, `src/saleskit/`, or related release scripting paths), **Then** the automated workflow triggers and generates all template variants
2. **Given** the workflow is running, **When** it processes each agent/script combination, **Then** it creates correctly structured ZIP files with Sales-AI-Kit branding and `/saleskit.*` commands
3. **Given** all templates are generated, **When** the workflow publishes the release, **Then** a GitHub release appears with all 34 ZIP files attached and proper release notes
4. **Given** a release is published, **When** users run `sales init my-project`, **Then** the CLI can use Sales-AI-Kit release assets (and does not require Spec-Kit template fallback)

---

### User Story 2 - Developer Tests Template Generation Locally (Priority: P2)

A developer wants to test template generation locally before pushing changes, ensuring their modifications to templates or scripts work correctly across all agent/script combinations.

**Why this priority**: Enables rapid iteration and validation without waiting for CI/CD, reducing the feedback loop for template development.

**Independent Test**: Can be tested by running the local build script and verifying all template ZIPs are created in the `dist/` directory with correct structure and content.

**Acceptance Scenarios**:

1. **Given** a developer has modified templates in `.saleskit/`, **When** they run `./scripts/build-templates.sh`, **Then** all 34 template variants are generated locally in `dist/templates/`
2. **Given** templates are built locally, **When** the developer inspects a ZIP file, **Then** it contains the correct directory structure with agent-specific commands and Sales-AI-Kit branding
3. **Given** a build completes, **When** errors occur in any template, **Then** the script reports which template failed and provides actionable error messages
4. **Given** local testing is complete, **When** the developer commits changes, **Then** CI validation runs the same build process to catch issues before release

---

### User Story 3 - CI System Validates Template Integrity (Priority: P2)

The continuous integration system should validate that all templates are correctly formatted, contain required files from `.saleskit/`, and have proper Sales-AI-Kit branding before allowing merge to main.

**Why this priority**: Prevents broken or incomplete templates from being released, maintaining quality standards.

**Independent Test**: Can be tested by triggering CI on a pull request and verifying it checks for required files, validates command references, and ensures no cross-kit references remain.

**Acceptance Scenarios**:

1. **Given** a pull request modifies templates, **When** CI runs validation, **Then** it verifies all templates contain required files (commands from `.saleskit/templates/commands/`, scripts, constitution from `.saleskit/memory/`)
2. **Given** CI is validating templates, **When** it finds `/speckit.*` references that should be `/saleskit.*`, **Then** the build fails with clear error messages
3. **Given** CI validation passes, **When** templates are generated, **Then** automated tests extract and verify the structure of each ZIP file
4. **Given** all validations pass, **When** maintainer merges the PR, **Then** the changes are ready for the next release

---

### Edge Cases

- What happens if a template ZIP fails to generate for one agent but succeeds for others?
- How does the system handle version numbering when multiple releases happen on the same day?
- What if the GitHub API rate limit is exceeded during release publication?
- How are templates validated to ensure no Spec-Kit references remain and all `.saleskit/` content is included?
- What happens if the release workflow is triggered but no templates have changed?
- How does the system handle migration if `.saleskit/` structure changes in future versions?

## Requirements *(mandatory)*

### Functional Requirements

#### Template Generation

- **FR-001**: System MUST generate template variants for all 17 supported AI agents: claude, cursor-agent, windsurf, gemini, copilot, qoder, qwen, opencode, codex, kilocode, auggie, roo, codebuddy, amp, shai, q (Amazon Q), bob
- **FR-002**: System MUST generate both bash (sh) and PowerShell (ps) script variants for each agent, resulting in 34 total template combinations
- **FR-003**: Each template MUST include agent-specific command directory (e.g., `.claude/commands/`, `.cursor/commands/`, `.windsurf/workflows/`, etc.)
- **FR-004**: Each template MUST contain Sales-AI-Kit specific files from `.saleskit/` directory: constitution.md from `.saleskit/memory/`, Sales/GTM spec/plan/tasks templates from `.saleskit/templates/`, and Sales-AI-Kit command files from `.saleskit/templates/commands/`
- **FR-005**: All agent command files MUST use `/saleskit.*` command prefix (not `/speckit.*`)
- **FR-006**: Template naming MUST follow pattern: `spec-kit-template-{agent}-{script}-v{version}.zip` for compatibility with existing CLI downloaders
- **FR-007**: Each template ZIP MUST contain proper directory structure: `.{agent}/...` plus `.saleskit/` working directory (memory + templates + scripts)

#### Build System

- **FR-008**: System MUST provide local build script (`scripts/build-templates.sh`) that generates all 34 template variants in `dist/templates/` directory
- **FR-009**: Build script MUST copy content from `.saleskit/` source directory into `.saleskit/` structure in generated templates
- **FR-010**: Build script MUST be idempotent and support incremental rebuilds
- **FR-011**: Build script MUST validate template structure before creating ZIP files
- **FR-012**: Build script MUST report progress and any errors encountered during generation
- **FR-013**: Build script MUST calculate and verify SHA-256 checksums for each generated ZIP file

#### GitHub Actions Workflow

- **FR-014**: System MUST provide GitHub Actions workflow (`.github/workflows/release.yml`) that triggers on push to main when `.saleskit/**` and other relevant paths are modified
- **FR-015**: Workflow MUST execute the build script to generate all template variants
- **FR-016**: Workflow MUST create a GitHub release with generated templates as release assets
- **FR-017**: Workflow MUST generate release notes that include changelog, template list, and SHA-256 checksums
- **FR-018**: Workflow MUST support manual triggering via `workflow_dispatch` for testing

#### Template Validation

- **FR-019**: System MUST provide validation script (`scripts/validate-templates.sh`) that verifies template integrity
- **FR-020**: Validation MUST check for presence of required files in each template: command files from `.saleskit/templates/commands/`, templates from `.saleskit/templates/`, scripts, constitution from `.saleskit/memory/`
- **FR-021**: Validation MUST scan for unintended `/speckit.*` references that should be `/saleskit.*`
- **FR-022**: Validation MUST verify agent command frontmatter uses correct `agent: saleskit.{command}` format
- **FR-023**: Validation MUST confirm all templates reference Sales-AI-Kit (not Spec-Kit) in branding and documentation where appropriate

#### CI Integration

- **FR-024**: System MUST provide CI workflow (`.github/workflows/ci.yml`) that runs on pull requests
- **FR-025**: CI MUST execute template validation before allowing merge
- **FR-026**: CI MUST build all templates to ensure they can be generated successfully
- **FR-027**: CI MUST fail if any template contains Spec-Kit workflow namespace references or is missing required files from `.saleskit/`

### Key Entities

- **Template Variant**: A combination of agent type and script type (e.g., claude-sh, cursor-agent-ps), resulting in 36 unique variants
- **Agent Configuration**: Metadata for each supported agent including name, command directory name, and file format requirements
- **Template ZIP**: A compressed archive containing all files needed for a specific agent/script combination
- **Release Asset**: A ZIP file attached to a GitHub release with versioned naming and SHA-256 checksum
- **Build Manifest**: JSON file documenting all generated templates with metadata (agent, script, size, checksum, timestamp)
- **Template Base**: Source directory structure (`.saleskit/`) containing Sales-AI-Kit specific files before agent/script customization

## Success Criteria *(mandatory)*

### Measurable Outcomes

#### Release Automation Success

- **SC-001**: Maintainer can create a new release by pushing changes to main (affecting `.saleskit/` paths), with full automation completing in under 10 minutes
- **SC-002**: Each release generates exactly 34 template ZIP files (17 agents × 2 script types) with correct naming and structure
- **SC-003**: GitHub release page displays all templates with proper versioning, release notes, and SHA-256 checksums

#### Template Quality

- **SC-004**: 100% of generated templates pass validation checks: correct structure, required files from `.saleskit/` present, no unintended cross-kit references
- **SC-005**: All templates contain `/saleskit.*` command references (zero `/speckit.*` references remain)
- **SC-006**: Templates extract successfully and create functional projects when used via `sales init`

#### Developer Experience

- **SC-007**: Developers can build all templates locally in under 5 minutes using `./scripts/build-templates.sh`
- **SC-008**: Local builds produce identical results to CI builds (byte-for-byte reproducible)
- **SC-009**: CI validation catches template issues before merge

#### Maintainability

- **SC-010**: Adding a new AI agent requires modifying only the AGENTS list in the build script
- **SC-011**: Template structure changes in `.saleskit/` automatically propagate to all 36 variants without manual editing
- **SC-012**: Release process is fully automated with zero manual steps required after push to main

## Out of Scope *(optional)*

- Automated testing of templates with actual AI agents (manual testing required)
- Generating templates for agents not listed in the 18 supported agents
- Creating a separate naming convention that breaks `spec-kit-template-*` compatibility
- Hosting templates outside GitHub releases (S3, CDN, etc.)
- Automatic version bumping in `pyproject.toml` (manual version management)

## Assumptions *(optional)*

- GitHub Actions is available and workflows can be enabled in the repository
- Repository has proper permissions to create releases and upload assets
- Build environment has bash, zip, and standard Unix utilities available
- PowerShell templates can be generated on Unix systems (script copying only, no execution needed)
- Version tags follow semantic versioning (v{major}.{minor}.{patch})

## Dependencies *(optional)*

- **GitHub Actions**: Required for automated releases and CI validation
- **GitHub Releases API**: For publishing releases and uploading assets
- **Bash**: Required for build and validation scripts
- **zip utility**: Required for creating template archives
- **Git**: Required for versioning and tag-based triggering
- **sed/awk/grep**: Required for text processing during template generation
- **`.saleskit/` directory**: Source for all Sales-AI-Kit specific content (constitution, templates, commands)

## Constraints *(optional)*

- Must maintain CLI compatibility by using `spec-kit-template-*` naming convention
- Must support all 18 agents that Spec-Kit supports
- Must generate both bash and PowerShell variants for each agent
- Build scripts must work on Unix-like systems (macOS, Linux)
- Template ZIPs must be under GitHub’s release asset limit
- Must not require Docker or containerization for local builds

## Related Features or Documentation *(optional)*

- Blogkit reference spec: `specs/003-blogkit-auto-template-release/`
- Spec-Kit release process: `.github/workflows/release.yml` in upstream Spec-Kit
- PMF-Kit release implementation: (reference pattern; used by other kits)
- Sales-AI-Kit templates: `.saleskit/templates/`
- Sales-AI-Kit commands: `.saleskit/templates/commands/`
