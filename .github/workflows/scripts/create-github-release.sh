#!/usr/bin/env bash

set -euo pipefail

version="${1:-}"
if [[ -z "$version" ]]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "ERROR: gh CLI is required" >&2
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
GENRELEASES_DIR="${GENRELEASES_DIR:-$REPO_ROOT/.genreleases}"

notes_file="$GENRELEASES_DIR/release-notes-${version}.md"
if [[ ! -f "$notes_file" ]]; then
  echo "ERROR: Missing release notes file: $notes_file" >&2
  exit 1
fi

shopt -s nullglob
assets=("$GENRELEASES_DIR"/*.zip)
if [[ ${#assets[@]} -eq 0 ]]; then
  echo "ERROR: No .zip assets found in $GENRELEASES_DIR" >&2
  exit 1
fi

if gh release view "$version" >/dev/null 2>&1; then
  echo "Release already exists for $version; skipping create." >&2
  exit 0
fi

gh release create "$version" \
  --title "Sales-AI-Kit Templates ${version}" \
  --notes-file "$notes_file" \
  "${assets[@]}"

echo "Created release $version with ${#assets[@]} assets."
