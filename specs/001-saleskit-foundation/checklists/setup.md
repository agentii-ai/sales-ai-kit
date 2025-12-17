# Setup Verification Checklist

**Date**: 2025-12-17
**Feature**: Sales-AI-Kit Foundation

## T001: Branch Verification

```bash
$ git rev-parse --abbrev-ref HEAD
001-saleskit-foundation
```

✅ **PASS**: On correct feature branch

## T002: Constraints Documentation

```bash
$ grep -A3 "Constraints" specs/001-saleskit-foundation/plan.md
**Constraints**:
- MUST NOT modify `.windsurf/` and `.claude` in this repo.
- MUST remain safe to install alongside other `*-kit` variants (no collisions).
- MUST keep artifacts reviewable as markdown under `specs/<feature>/`.
```

✅ **PASS**: Constraints are explicitly documented in plan.md (lines 31-34)

## T003: Refs Directory Verification

```bash
$ git ls-files refs/ | wc -l
10
$ git submodule status 2>&1 | grep refs
(no output - not a submodule)
```

✅ **PASS**: refs/ is a normal tracked folder (not a git submodule)

## T004: Feature Documentation Verification

```bash
$ ls -1 specs/001-saleskit-foundation/
checklists
plan.md
spec.md
tasks.md
```

✅ **PASS**: All required feature docs exist (spec.md, plan.md, tasks.md)

