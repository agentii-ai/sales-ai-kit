<!--
 Sync Impact Report
 - Version change: 1.0.0 -> 1.1.0
 - Modified principles: Sales & Marketing Rigor (expanded)
 - Added sections: None
 - Removed sections: Template placeholders
 - Templates requiring updates:
   - updated: .saleskit/templates/plan-template.md
   - updated: .saleskit/templates/tasks-template.md
   - updated: .saleskit/templates/checklist-template.md
 - Follow-up TODOs:
   - TODO(RATIFICATION_DATE): set if different from first amendment date
 -->
 # Sales-AI-Kit Constitution
 
 ## Core Principles
 
 ### I. Spec-Kit Compatibility First
 Sales-AI-Kit MUST preserve the upstream Spec-Kit workflow shape and mental model:
 constitution -> specify -> plan -> tasks -> implement.
 
 Sales-AI-Kit MUST remain compatible with multiple AI agents (Claude Code, Cursor, Windsurf,
 etc.) and MUST avoid assumptions tied to a single agent.
 
 ### II. Namespace Isolation (Non-Negotiable)
 Users MUST be able to install and use multiple *-kit variants on the same machine without
 collisions.
 
 This requires isolation at three layers:
 
 - **CLI executable name**: Each kit MUST ship a distinct executable.
   - Spec-Kit: `specify`
   - Sales-AI-Kit: `sales`
   - Blog kit: `blog`
   - PMF kit: `pmf`
 - **Python package distribution name**: Each kit MUST use a unique distribution name
   (e.g., `sales-cli`) to avoid `pip/uv` conflicts.
 - **Project hidden folder (kit package folder)**: Each kit MUST write its templates/memory
   under its own hidden folder (e.g., `.saleskit/`, `.blogkit/`, `.pmfkit/`).
 
 The word `specify` is allowed as a workflow verb ("specify a feature") and as the upstream
 executable name; it MUST NOT be used as this kit's installable package or hidden folder
 namespace.
 
 ### III. Slash Command Namespacing
 All agent workflows in this kit MUST be invoked via the `saleskit.*` namespace:
 
 - `/saleskit.constitution`
 - `/saleskit.specify`
 - `/saleskit.clarify`
 - `/saleskit.plan`
 - `/saleskit.tasks`
 - `/saleskit.implement`
 
 Slash command namespaces MUST NOT overlap with other kits (e.g., `speckit.*`, `blogkit.*`).
 If a new workflow is added, it MUST follow the `saleskit.<verb>` convention.
 
 ### IV. Artifacts are the Product
 Sales-AI-Kit is a spec-driven system for producing durable, reviewable artifacts.
 
 The kit MUST treat these as first-class outputs.
 
 In a project initialized by Sales-AI-Kit, the kit-owned source of truth lives under
 `.saleskit/`.
 
 In this repository, the working copy is currently stored under `.specify/` to preserve
 compatibility with the upstream Spec-Kit layout and existing agent tooling.
 
 - `.saleskit/memory/constitution.md` as the governing source of truth (in a generated project)
 - `specs/<feature>/spec.md` as the authoritative "what/why"
 - `specs/<feature>/plan.md` as the authoritative "how"
 - `specs/<feature>/tasks.md` as the authoritative execution graph
 - `refs/` as the worked example and reference library for creating new kits
 
 ### V. Sales & Marketing Rigor (Evidence, ICP, Outcomes)
 Sales-AI-Kit outputs MUST optimize for real-world GTM execution.
 
 - **ICP-first**: Every spec MUST define a sharp ICP (role, context, constraints, buyer type).
 - **Outcome-first**: Every plan MUST tie work to measurable outcomes (pipeline, conversion,
   activation, retention, revenue).
 - **Evidence-first**: Recommendations SHOULD be grounded in concrete examples, observed
   patterns, or referenced sources; unsupported "best practices" MUST be labeled as
   assumptions.
 - **Hybrid GTM by default**: Work MUST assume PLG and SLG are complementary and MAY include
   an agentic layer (ALG) when justified. Plans MUST explicitly state which motion(s) apply
   and why:
   - PLG: self-serve onboarding, activation, in-product guidance
   - SLG: complex deals, multi-stakeholder buying, POCs
   - ALG: orchestration and continuous optimization (with governance)
 - **Signal-driven qualification**: When discussing pipeline creation, specs/plans SHOULD
   prefer PQL and intent/signal-based qualification over generic MQL language.
 - **Tier clarity**: Specs SHOULD distinguish target tier(s) explicitly:
   - Individual/prosumer
   - Small team / SMB
   - Enterprise
 
 ### VI. Agent Governance for GTM Automation
 Sales-AI-Kit MUST treat agent-driven GTM as a safety and trust problem, not only an
 automation problem.
 
 - **Human-in-the-loop by default**: Any autonomous outbound action (email, DM, dialing,
   pricing changes, CRM mutation) MUST require an explicit approval gate unless the plan
   justifies full autonomy and defines rollback.
 - **Auditability**: Automated recommendations and actions MUST be traceable to inputs
   (signals, customer data, docs) and MUST produce an audit log suitable for review.
 - **Truthfulness constraints**: Generated outreach MUST avoid fabricated claims, metrics,
   customers, or case studies.
 - **Cost and ROI discipline**: Plans MUST account for variable inference cost and unit
   economics when recommending automation.
 
 ## Kit Namespace & Coexistence
 
 This repo is a worked example of how to build Spec-Kit variants.
 
 Rules:
 
 - **Executable name**: This kit's executable SHOULD be `sales`.
 - **Slash commands**: This kit's workflow namespace MUST be `saleskit.*`.
 - **Kit package folder**: References to kit-owned assets MUST use `.saleskit/` paths
   (e.g., `.saleskit/memory/constitution.md`).
 - **Upstream compatibility**: If upstream uses a local helper executable like `./specify`,
   that name SHOULD remain `./specify` when referring to the command.
 
 ## Workflow & Quality Gates
 
 Sales-AI-Kit follows Spec-Driven Development with domain-adapted templates.
 
 Required order:
 
 - **Constitution**: Establish non-negotiable principles.
 - **Specify**: Define the problem, users, constraints, and measurable success.
 - **Clarify (optional but recommended)**: Resolve ambiguity before planning.
 - **Plan**: Choose approach, structure, and domain tactics.
 - **Tasks**: Produce a dependency-ordered execution list.
 - **Implement**: Execute tasks with checkpoints and quality gates.
 
 Quality gates:
 
 - **No namespace collisions**: New commands, folders, and package names MUST remain
   kit-scoped.
 - **Template consistency**: Templates MUST reference `saleskit.*` workflows and `.saleskit/`
   kit paths.
 - **Reviewability**: Generated artifacts MUST be readable and auditable by humans.
 
 ## Governance
 
 This constitution supersedes all other project guidance.
 
 - **Amendment process**: Changes MUST be made via explicit edits to this file and MUST
   include a rationale and a migration note when behavior expectations change.
 - **Versioning**: The constitution MUST follow semantic versioning (MAJOR.MINOR.PATCH).
   - MAJOR: breaking governance changes or principle removals/redefinitions
   - MINOR: new principles/sections or materially expanded guidance
   - PATCH: clarifications, wording, typo fixes
 - **Compliance checks**: Plans and tasks SHOULD include a brief constitution compliance
   checkpoint when changes impact naming, workflow shape, or cross-kit interop.
 
 **Version**: 1.1.0 | **Ratified**: TODO(RATIFICATION_DATE) | **Last Amended**: 2025-12-16
