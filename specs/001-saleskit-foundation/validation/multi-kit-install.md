# Multi-Kit Installation Test Procedure

**Purpose**: Verify that Sales-AI-Kit can be installed alongside other `*-kit` variants without collisions.

**Date**: 2025-12-17
**Feature**: Sales-AI-Kit Foundation (001-saleskit-foundation)

## Test Scenario

Demonstrate collision-free coexistence by installing both Spec-Kit and Sales-AI-Kit in the same environment and verifying independent operation.

## Prerequisites

- Python 3.11+ installed
- Virtual environment recommended (`python3 -m venv .venv && source .venv/bin/activate`)
- Access to both Spec-Kit and Sales-AI-Kit repositories

## Test Steps

### 1. Install Spec-Kit

```bash
# Clone and install Spec-Kit
git clone https://github.com/specifyapp/specify-kit.git
cd specify-kit
pip install -e .

# Verify Spec-Kit installation
specify --version
specify namespace  # Should show speckit.* namespace
```

**Expected Result**:
- `specify` command available
- Displays Spec-Kit version
- Namespace shows `speckit.*` workflows

### 2. Install Sales-AI-Kit

```bash
# Clone and install Sales-AI-Kit (from same environment)
cd ..
git clone https://github.com/sales-ai-kit/sales-ai-kit.git
cd sales-ai-kit
pip install -e .

# Verify Sales-AI-Kit installation
sales --version
sales namespace  # Should show saleskit.* namespace
```

**Expected Result**:
- `sales` command available
- Displays Sales-AI-Kit version
- Namespace shows `saleskit.*` workflows
- **CRITICAL**: `specify` command still works (not overwritten)

### 3. Verify No Collisions

```bash
# Both commands should work independently
specify --help   # Spec-Kit help
sales --help     # Sales-AI-Kit help

# Both namespace checks should succeed
specify namespace
sales namespace

# Verify Python imports don't collide
python3 << 'EOF'
import speckit
import saleskit

print(f"Spec-Kit version: {speckit.__version__}")
print(f"Sales-AI-Kit version: {saleskit.__version__}")
print("✅ No import collisions")
EOF
```

**Expected Result**:
- Both `specify` and `sales` commands work
- Both namespace checks show distinct configurations
- Python imports succeed without conflicts

### 4. Test Workflow Invocation (via AI Agent)

Initialize a project with Sales-AI-Kit:

```bash
# Create a test project
mkdir test-multi-kit-project
cd test-multi-kit-project
sales init --ai claude

# Verify .saleskit/ was created (not .specify/)
ls -la .saleskit/

# If using Claude Code, verify /saleskit.* commands exist
ls -la .claude/commands/
cat .claude/commands/saleskit.specify.md
```

**Expected Result**:
- `.saleskit/` directory created (Sales-AI-Kit's kit folder)
- Agent command files use `saleskit.*` prefix (no collision with `speckit.*`)

Initialize a separate project with Spec-Kit:

```bash
cd ..
mkdir test-speckit-project
cd test-speckit-project
specify init --ai claude  # (if Spec-Kit supports this)

# Verify .specify/ was created
ls -la .specify/
```

**Expected Result**:
- `.specify/` directory created (Spec-Kit's kit folder)
- No interference with Sales-AI-Kit projects

## Collision Checklist

| Test Item | Sales-AI-Kit | Spec-Kit | Status |
|-----------|-------------|----------|--------|
| **CLI executable** | `sales` | `specify` | ✅ No collision |
| **Python distribution** | `sales-cli` | `specify-cli` | ✅ No collision |
| **Python module** | `saleskit` | `speckit` | ✅ No collision |
| **Kit folder** | `.saleskit/` | `.specify/` | ✅ No collision |
| **Slash commands** | `saleskit.*` | `speckit.*` | ✅ No collision |

## Known Limitations

- This test validates **installation coexistence**, not **runtime coexistence** within the same project.
- A single project should typically use **one** kit variant (either Spec-Kit or Sales-AI-Kit), not both simultaneously.
- The test does not cover edge cases like upgrading one kit while the other is installed.

## Troubleshooting

### Issue: `sales` command not found after installation

**Cause**: pip may not have updated the PATH, or virtual environment not activated.

**Solution**:
```bash
# Re-activate virtual environment
source .venv/bin/activate

# Or reinstall
pip install -e . --force-reinstall
```

### Issue: `sales` command overwrites `specify` command

**Cause**: Both kits are using the same executable name (CRITICAL BUG).

**Solution**: This should **never** happen. If it does, the namespace isolation has failed. Report this as a bug.

### Issue: Python import collision (`ImportError: cannot import name 'saleskit'`)

**Cause**: Module namespace collision (both kits using the same module name).

**Solution**: This should **never** happen. Verify `import saleskit` and `import speckit` work independently. If they don't, the namespace isolation has failed.

## Success Criteria

- [ ] Both `specify` and `sales` commands work after installation
- [ ] Both namespace checks show distinct configurations
- [ ] Python imports succeed without conflicts
- [ ] Generated projects use distinct kit folders (`.specify/` vs `.saleskit/`)
- [ ] Agent workflow commands use distinct prefixes (`speckit.*` vs `saleskit.*`)

## References

- [Spec-Kit Constitution](../../.specify/memory/constitution.md) - Namespace Isolation (Principle II)
- [Sales-AI-Kit Plan](../plan.md) - Canonical Namespace Matrix
- [Smoke Test Script](../../scripts/smoke/test_install.sh)
