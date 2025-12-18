#!/usr/bin/env bash

set -euo pipefail

version="${1:-}"
if [[ -z "$version" ]]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
GENRELEASES_DIR="${GENRELEASES_DIR:-$REPO_ROOT/.genreleases}"

checksums_file="$GENRELEASES_DIR/checksums-${version}.txt"
if [[ ! -f "$checksums_file" ]]; then
  echo "ERROR: Missing checksums file: $checksums_file" >&2
  exit 1
fi

notes_file="$GENRELEASES_DIR/release-notes-${version}.md"

{
  echo "# Sales-AI-Kit Templates ${version}"
  echo
  echo "This release contains Sales-AI-Kit templates for supported agents and script types."
  echo
  echo "## Assets"
  echo
  while IFS= read -r line; do
    sha="$(echo "$line" | awk '{print $1}')"
    name="$(echo "$line" | awk '{print $2}')"
    if [[ -n "$sha" && -n "$name" ]]; then
      echo "- \\`${name}\\`"
      echo "  - sha256: \\`${sha}\\`"
    fi
  done < "$checksums_file"
} > "$notes_file"

echo "Wrote release notes: $notes_file"

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "notes_file=$notes_file" >> "$GITHUB_OUTPUT"
fi
