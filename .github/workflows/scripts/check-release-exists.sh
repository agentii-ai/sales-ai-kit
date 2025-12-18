#!/usr/bin/env bash

set -euo pipefail

tag="${1:-}"
if [[ -z "$tag" ]]; then
  echo "Usage: $0 <tag>" >&2
  exit 1
fi

exists="false"
if command -v gh >/dev/null 2>&1; then
  if gh release view "$tag" >/dev/null 2>&1; then
    exists="true"
  fi
else
  if git rev-parse "$tag" >/dev/null 2>&1; then
    exists="true"
  fi
fi

echo "Release exists: $exists"

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "exists=$exists" >> "$GITHUB_OUTPUT"
fi
