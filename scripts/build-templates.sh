#!/usr/bin/env bash

set -euo pipefail

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 <version>" >&2
  echo "Example: $0 v0.1.0-test" >&2
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
DIST_DIR="$REPO_ROOT/dist/templates"
GENRELEASES_DIR="$REPO_ROOT/.genreleases"

mkdir -p "$DIST_DIR"

chmod +x "$REPO_ROOT/.github/workflows/scripts/create-release-packages.sh"

# Build into .genreleases (same convention used by CI scripts)
AGENTS="${AGENTS:-}" \
SCRIPTS="${SCRIPTS:-}" \
GENRELEASES_DIR="$GENRELEASES_DIR" \
  "$REPO_ROOT/.github/workflows/scripts/create-release-packages.sh" "$VERSION"

# Copy artifacts to dist
shopt -s nullglob
cp -f "$GENRELEASES_DIR"/*.zip "$DIST_DIR/"

# Generate build manifest
REPO_ROOT="$REPO_ROOT" python3 - <<'PY'
import hashlib
import json
import os
from pathlib import Path
import time

repo_root = Path(os.environ.get('REPO_ROOT', os.getcwd()))
dist_dir = repo_root / 'dist' / 'templates'

items = []
for p in sorted(dist_dir.glob('*.zip')):
  h = hashlib.sha256()
  with p.open('rb') as f:
    for chunk in iter(lambda: f.read(1024 * 1024), b''):
      h.update(chunk)
  items.append({
    'file': p.name,
    'size_bytes': p.stat().st_size,
    'sha256': h.hexdigest(),
    'modified_unix': int(p.stat().st_mtime),
  })

manifest = {
  'generated_unix': int(time.time()),
  'count': len(items),
  'items': items,
}

(dist_dir / 'manifest.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')
print(f"Wrote manifest: {dist_dir/'manifest.json'}")
PY

# Validate
chmod +x "$REPO_ROOT/scripts/validate-templates.sh" || true
"$REPO_ROOT/scripts/validate-templates.sh" "$DIST_DIR"

echo "Templates available in: $DIST_DIR"
