# PDCA Checklist (Weekly)

This is a lightweight PDCA (Plan / Do / Check / Act) loop for maintaining Sales-AI-Kit’s multi-kit coexistence guarantees and avoiding namespace/template regressions.

## Plan

- [ ] Confirm the intended namespace matrix still holds:
  - [ ] Executable: `sales`
  - [ ] Python distribution: `sales-cli`
  - [ ] Python module: `saleskit`
  - [ ] Kit folder: `.saleskit/`
  - [ ] Slash commands: `saleskit.*`
- [ ] Review recent changes that could affect:
  - [ ] CLI entrypoints
  - [ ] Template copy/scaffold logic
  - [ ] Agent workflow templates
  - [ ] Documentation/prompt references

## Do

- [ ] Run a basic scaffold test:
  - [ ] `sales --version`
  - [ ] `sales namespace`
  - [ ] `sales init <temp-dir>` (or equivalent non-destructive target)
- [ ] Ensure generated project contains `.saleskit/` with:
  - [ ] `.saleskit/memory/constitution.md`
  - [ ] `.saleskit/templates/`
  - [ ] `.saleskit/templates/commands/`

## Check

- [ ] Run a scoped grep for user-facing namespace drift:
  - [ ] No `/speckit.*` instructions for Sales-AI-Kit
  - [ ] No `.specify/` paths when describing Sales-AI-Kit generated projects
  - [ ] No references to missing docs (e.g., `tasking_methodology.md`)
- [ ] Validate multi-kit coexistence assumptions:
  - [ ] Installing Spec-Kit does not shadow `sales`
  - [ ] Installing Sales-AI-Kit does not shadow `specify`
  - [ ] `import saleskit` and `import speckit` can coexist

## Act

- [ ] If drift is found:
  - [ ] Fix the doc/template reference at the source (prefer `.saleskit/templates/**`)
  - [ ] Add or update a validation note under `specs/001-saleskit-foundation/validation/`
  - [ ] Re-run the Check section
- [ ] If no drift is found:
  - [ ] Record a short note in the relevant validation doc (optional)
