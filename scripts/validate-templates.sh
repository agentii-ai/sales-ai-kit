#!/usr/bin/env bash

set -euo pipefail

target="${1:-}"
if [[ -z "$target" ]]; then
  echo "Usage: $0 <zip-file-or-directory>" >&2
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
WORK_DIR="${WORK_DIR:-$REPO_ROOT/.tmp-template-validate}"

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"

fail() {
  echo "ERROR: $1" >&2
  exit 1
}

validate_extracted_dir() {
  local extracted="$1"

  # Each archive should contain exactly one top-level folder (variant name)
  local top
  top="$(find "$extracted" -mindepth 1 -maxdepth 1 -type d | head -n 1 || true)"
  [[ -n "$top" ]] || fail "Zip extracted with no top-level directory"

  [[ -d "$top/.saleskit" ]] || fail "Missing .saleskit/ in $(basename "$top")"
  [[ -f "$top/.saleskit/memory/constitution.md" ]] || fail "Missing .saleskit/memory/constitution.md in $(basename "$top")"
  [[ -d "$top/.saleskit/templates" ]] || fail "Missing .saleskit/templates in $(basename "$top")"

  # Scripts present
  if [[ ! -d "$top/.saleskit/scripts" ]]; then
    fail "Missing .saleskit/scripts in $(basename "$top")"
  fi
  if [[ ! -d "$top/.saleskit/scripts/bash" ]] && [[ ! -d "$top/.saleskit/scripts/powershell" ]]; then
    fail "Missing scripts/bash or scripts/powershell in $(basename "$top")"
  fi

  # Namespace checks
  if grep -R -n "speckit\." "$top" >/dev/null 2>&1; then
    fail "Found forbidden 'speckit.' reference in $(basename "$top")"
  fi

  # Ensure command templates refer to saleskit.
  if ! grep -R -n "saleskit\." "$top" >/dev/null 2>&1; then
    fail "No 'saleskit.' references found in $(basename "$top"); unexpected"
  fi
}

validate_zip() {
  local zip_path="$1"
  [[ -f "$zip_path" ]] || fail "Not a file: $zip_path"

  local name
  name="$(basename "$zip_path")"

  local out="$WORK_DIR/${name%.zip}"
  mkdir -p "$out"

  unzip -q "$zip_path" -d "$out"
  validate_extracted_dir "$out"
}

if [[ -d "$target" ]]; then
  shopt -s nullglob
  zips=("$target"/*.zip)
  [[ ${#zips[@]} -gt 0 ]] || fail "No zip files found in directory: $target"
  for z in "${zips[@]}"; do
    validate_zip "$z"
  done
  echo "Validated ${#zips[@]} zip files in $target"
else
  validate_zip "$target"
  echo "Validated $target"
fi
