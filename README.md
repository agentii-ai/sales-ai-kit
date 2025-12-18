# Sales-AI-Kit

Sales-AI-Kit is a spec-driven toolkit for systematic **AI/LLM SaaS sales and marketing** execution.

It is a domain-focused variant of [Spec-Kit](https://github.com/github/spec-kit), adapted for GTM rigor: ICP definition, outcome metrics, evidence-based recommendations, and safe agent governance.

## Status

This project is in **alpha** and evolving quickly.

---

## What you get

- A collision-free, multi-kit friendly CLI (`sales`) and workflow namespace (`saleskit.*`)
- A complete Spec-Driven workflow shape:
  - constitution → specify → plan → tasks → implement
- Templates for **17** supported AI agents, for both script variants:
  - `sh` (bash/zsh)
  - `ps` (PowerShell)
- Automated template packaging + GitHub Releases (ZIPs + SHA-256 checksums)

---

## Namespace isolation (non-negotiable)

Sales-AI-Kit is designed to coexist with other *-kit variants (Spec-Kit, Blog-Tech-Kit, PMF-Kit, etc.) without collisions:

- **CLI executable**: `sales`
- **Python distribution name**: `sales-cli`
- **Python module namespace**: `saleskit`
- **Kit folder in generated projects**: `.saleskit/`
- **Slash command namespace**: `saleskit.*`

To verify the namespace wiring:

```bash
sales namespace
```

---

## Get started

### Option 1: One-time usage (recommended)

Run directly from Git without installing (always uses the latest version):

```bash
uvx --from git+https://github.com/agentii-ai/sales-ai-kit.git sales init my-sales-project
```

### Option 2: Persistent installation

Install once and use everywhere:

```bash
uv tool install sales-cli --from git+https://github.com/agentii-ai/sales-ai-kit.git
sales init my-sales-project
```

---

## Initialize a project

```bash
sales init my-sales-project
```

This creates `.saleskit/` in your project directory (templates + constitution).

### Generate agent workflows (optional)

You can also generate agent-specific command files during initialization:

```bash
sales init my-sales-project --ai claude
sales init my-sales-project --ai windsurf
sales init my-sales-project --ai cursor
```

---

## Workflow commands

Once initialized, open your AI agent in the project directory. You’ll use these kit-scoped slash commands:

```text
/saleskit.constitution
/saleskit.specify
/saleskit.clarify
/saleskit.plan
/saleskit.tasks
/saleskit.implement
```

These commands are implemented by the templates and scripts in `.saleskit/`.

---

## Supported AI agents

Sales-AI-Kit includes templates for these agents:

- `claude`
- `gemini`
- `copilot`
- `cursor-agent`
- `qwen`
- `opencode`
- `codex`
- `windsurf`
- `kilocode`
- `auggie`
- `roo`
- `codebuddy`
- `qoder`
- `amp`
- `shai`
- `q` (Amazon Q Developer CLI)
- `bob`

---

## Templates & releases

Sales-AI-Kit publishes template ZIPs to GitHub Releases.

- **Variants**:
  - 17 agents × 2 script types (`sh`, `ps`) = **34** release assets
- **Naming**:
  - `spec-kit-template-<agent>-<script>-v<version>.zip`
- **Checksums**:
  - Releases include SHA-256 checksums for all assets

See: https://github.com/agentii-ai/sales-ai-kit/releases

---

## Local development (template packaging)

Build + validate templates locally:

```bash
./scripts/build-templates.sh
```

Validation checks include:

- Correct ZIP structure
- Required kit files present
- No namespace collisions (kit-scoped `saleskit.*` and `.saleskit/` references)

---

## Repo structure

- `.saleskit/`
  - Source-of-truth templates and scripts for generated projects
- `src/saleskit/`
  - The `sales` CLI implementation
- `.github/workflows/`
  - CI + release workflows for building and publishing template assets
- `specs/`
  - Spec-driven feature history for this kit
- `refs/`
  - Reference materials and worked examples

---

## Project constitution

The kit’s governing principles live at:

- `.saleskit/memory/constitution.md`

In generated projects, the kit-owned source of truth is always under `.saleskit/`.
