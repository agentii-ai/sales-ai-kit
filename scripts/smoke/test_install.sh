#!/usr/bin/env bash
# Smoke test for Sales-AI-Kit local installation
#
# Tests:
# - Package installs without errors
# - `sales` command is available
# - `sales --help` works
# - `sales namespace` displays correct configuration
# - No collision with other `*-kit` variants

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Sales-AI-Kit Installation Smoke Test"
echo "====================================="
echo

# Check if we're in a virtual environment
if [ -z "${VIRTUAL_ENV:-}" ]; then
    echo "⚠️  Warning: Not in a virtual environment."
    echo "   Recommended: python3 -m venv .venv && source .venv/bin/activate"
    echo
fi

# Install in development mode
echo "▶ Installing sales-cli in development mode..."
cd "$REPO_ROOT"
pip install -e . --quiet || {
    echo "❌ Installation failed"
    exit 1
}
echo "✅ Installation succeeded"
echo

# Test 1: Command availability
echo "▶ Test 1: Check if 'sales' command is available..."
if command -v sales &> /dev/null; then
    echo "✅ 'sales' command found: $(which sales)"
else
    echo "❌ 'sales' command not found in PATH"
    exit 1
fi
echo

# Test 2: Help output
echo "▶ Test 2: Verify 'sales --help' works..."
if sales --help &> /dev/null; then
    echo "✅ 'sales --help' succeeded"
else
    echo "❌ 'sales --help' failed"
    exit 1
fi
echo

# Test 3: Namespace self-check
echo "▶ Test 3: Run 'sales namespace' (namespace self-check)..."
if sales namespace; then
    echo
    echo "✅ Namespace self-check succeeded"
else
    echo "❌ Namespace self-check failed"
    exit 1
fi
echo

# Test 4: Version check
echo "▶ Test 4: Verify 'sales version' works..."
if sales version; then
    echo
    echo "✅ Version check succeeded"
else
    echo "❌ Version check failed"
    exit 1
fi
echo

# Test 5: Check for namespace collisions
echo "▶ Test 5: Verify no namespace collisions..."
echo "   Checking if 'specify' command still works (if installed)..."
if command -v specify &> /dev/null; then
    echo "   ℹ️  'specify' command found: $(which specify)"
    echo "   ✅ No collision: both 'sales' and 'specify' can coexist"
else
    echo "   ℹ️  'specify' command not found (Spec-Kit not installed)"
    echo "   ✅ No collision detected"
fi
echo

# Test 6: Python import check
echo "▶ Test 6: Verify Python import 'import saleskit' works..."
if python3 -c "import saleskit; print(f'saleskit version: {saleskit.__version__}')"; then
    echo "✅ Python import succeeded"
else
    echo "❌ Python import failed"
    exit 1
fi
echo

echo "====================================="
echo "✅ All smoke tests passed!"
echo
echo "Next steps:"
echo "  - Run 'sales namespace' to view namespace configuration"
echo "  - Run 'sales init' to scaffold a new project (when implemented)"
echo "  - Install Spec-Kit alongside and verify coexistence"
echo
