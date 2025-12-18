#!/usr/bin/env bash

set -euo pipefail

latest_tag=""
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  latest_tag="$(git tag --list 'v*' --sort=-v:refname | head -n 1 || true)"
fi

if [[ -z "$latest_tag" ]]; then
  new_version="v0.0.1"
else
  if [[ ! "$latest_tag" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    echo "ERROR: Latest tag '$latest_tag' is not a semantic version tag (vMAJOR.MINOR.PATCH)" >&2
    exit 1
  fi
  major="${BASH_REMATCH[1]}"
  minor="${BASH_REMATCH[2]}"
  patch="${BASH_REMATCH[3]}"
  patch="$((patch + 1))"
  new_version="v${major}.${minor}.${patch}"
fi

echo "New version: $new_version"

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "new_version=$new_version" >> "$GITHUB_OUTPUT"
fi
