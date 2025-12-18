# Multi-Kit Validation Checklist

This checklist validates that Sales-AI-Kit can coexist with Spec-Kit (and other *-kit variants) on the same machine without collisions.

## Scope

Validate isolation at these layers:

- **Executable**: `sales` vs `specify`
- **Python distribution**: `sales-cli` vs `specify-cli`
- **Python module**: `saleskit` vs `speckit`
- **Kit folder in generated projects**: `.saleskit/` vs `.specify/`
- **Agent slash commands**: `saleskit.*` vs `speckit.*`

## Preconditions

- You have a clean virtual environment OR you are using `uv tool` installs.
- You can access both repos or install sources for Spec-Kit and Sales-AI-Kit.

## Checklist

### 1) Install both kits

- [ ] Install Spec-Kit in a way that provides `specify` (e.g., `uv tool install specify-cli ...`)
- [ ] Install Sales-AI-Kit in a way that provides `sales` (e.g., `uv tool install sales-cli ...`)

### 2) Verify executables are distinct

- [ ] `specify --version` works
- [ ] `sales --version` works
- [ ] `specify namespace` shows `speckit.*`
- [ ] `sales namespace` shows `saleskit.*`

### 3) Verify Python import namespaces do not collide

- [ ] In Python: `import speckit` works
- [ ] In Python: `import saleskit` works
- [ ] Verify they can be imported in the same process without errors

### 4) Verify project scaffolding is isolated

- [ ] `sales init <DIR>` creates a project with `.saleskit/`
- [ ] Generated agent command/workflow files reference `saleskit.*`
- [ ] Separately, `specify init <DIR>` creates a project with `.specify/` (if applicable to the installed Spec-Kit version)

### 5) Regression checks

- [ ] No user-facing docs in Sales-AI-Kit instruct users to place kit-owned assets under `.specify/`
- [ ] No Sales-AI-Kit docs instruct running `/speckit.*` for Sales-AI-Kit workflows

## Expected Outcome

All checks pass, demonstrating multi-kit coexistence without collisions or namespace confusion.
