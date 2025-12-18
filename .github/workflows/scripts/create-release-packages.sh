#!/usr/bin/env bash

set -euo pipefail

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 <version>" >&2
  echo "Example: $0 v0.1.0" >&2
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SOURCE_DIR="$REPO_ROOT/.saleskit"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "ERROR: Missing source directory: $SOURCE_DIR" >&2
  exit 1
fi

GENRELEASES_DIR="${GENRELEASES_DIR:-$REPO_ROOT/.genreleases}"
mkdir -p "$GENRELEASES_DIR"

ALL_AGENTS=(
  claude
  gemini
  copilot
  cursor-agent
  qwen
  opencode
  codex
  windsurf
  kilocode
  auggie
  roo
  codebuddy
  qoder
  q
  amp
  shai
  bob
)

ALL_SCRIPTS=(sh ps)

split_csv_or_space() {
  python3 - <<'PY'
import os
val=os.environ.get('VALUE','').strip()
if not val:
  raise SystemExit(0)
for part in val.replace(',', ' ').split():
  print(part)
PY
}

emit_env_or_defaults() {
  local env_key="$1"
  shift

  local value="${!env_key:-}"
  if [[ -z "$value" ]]; then
    printf '%s\n' "$@"
    return 0
  fi

  VALUE="$value" split_csv_or_space
}

sha256_file() {
  local f="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$f" | awk '{print $1}'
  else
    shasum -a 256 "$f" | awk '{print $1}'
  fi
}

agent_dir() {
  local agent="$1"
  case "$agent" in
    claude) echo ".claude/commands" ;;
    gemini) echo ".gemini/commands" ;;
    copilot) echo ".github/agents" ;;
    cursor-agent) echo ".cursor/commands" ;;
    qwen) echo ".qwen/commands" ;;
    opencode) echo ".opencode/command" ;;
    codex) echo ".codex/commands" ;;
    windsurf) echo ".windsurf/workflows" ;;
    kilocode) echo ".kilocode/rules" ;;
    auggie) echo ".augment/rules" ;;
    roo) echo ".roo/rules" ;;
    codebuddy) echo ".codebuddy/commands" ;;
    qoder) echo ".qoder/commands" ;;
    q) echo ".amazonq/prompts" ;;
    amp) echo ".agents/commands" ;;
    shai) echo ".shai/commands" ;;
    bob) echo ".bob/commands" ;;
    *)
      echo "ERROR: Unknown agent '$agent'" >&2
      return 1
      ;;
  esac
}

agent_format() {
  local agent="$1"
  case "$agent" in
    gemini|qwen) echo "toml" ;;
    *) echo "md" ;;
  esac
}

extract_description() {
  local template="$1"
  local desc
  desc="$(awk 'BEGIN{in=0} $0=="---"{in++; next} in==1 && $0 ~ /^description:/ {sub(/^description:[[:space:]]*/, ""); print; exit}' "$template" || true)"
  desc="${desc%\"}"
  desc="${desc#\"}"
  echo "$desc"
}

render_md() {
  local template="$1"
  local agent="$2"
  local out_file="$3"

  sed "s/__AGENT__/${agent}/g" "$template" > "$out_file"
}

render_toml() {
  local template="$1"
  local out_file="$2"

  local description
  description="$(extract_description "$template")"

  python3 - <<'PY' "$template" "$out_file" "$description"
import sys
from pathlib import Path

template_path = Path(sys.argv[1])
out_path = Path(sys.argv[2])
description = sys.argv[3]

text = template_path.read_text(encoding='utf-8')
parts = text.split('\n---\n', 2)
if len(parts) >= 3:
  body = parts[2]
elif text.startswith('---'):
  # fallback: find second --- line
  lines = text.splitlines()
  idxs = [i for i,l in enumerate(lines) if l.strip()=='---']
  body = '\n'.join(lines[idxs[1]+1:]) if len(idxs) >= 2 else text
else:
  body = text

body = body.replace('$ARGUMENTS', '{{args}}')

# Basic escaping for TOML triple quotes: avoid accidental closing
body = body.replace('"""', '\\"\\"\\"')

out = f'description = "{description}"\n\nprompt = """\n{body.rstrip()}\n"""\n'
out_path.write_text(out, encoding='utf-8')
PY
}

generate_commands() {
  local agent="$1"
  local script="$2"
  local base_dir="$3"

  local dir
  dir="$(agent_dir "$agent")"

  mkdir -p "$base_dir/$dir"

  if [[ "$agent" == "copilot" ]]; then
    mkdir -p "$base_dir/.github/prompts"
  fi

  local format
  format="$(agent_format "$agent")"

  local template
  for template in "$SOURCE_DIR/templates/commands/"saleskit.*.md; do
    if [[ ! -f "$template" ]]; then
      continue
    fi

    local cmd_name
    cmd_name="$(basename "$template" .md)"

    if [[ "$format" == "toml" ]]; then
      local target_file="$base_dir/$dir/${cmd_name}.toml"
      render_toml "$template" "$target_file"
    else
      local target_file="$base_dir/$dir/${cmd_name}.md"
      render_md "$template" "$agent" "$target_file"

      if [[ "$agent" == "copilot" ]]; then
        render_md "$template" "$agent" "$base_dir/.github/prompts/${cmd_name}.md"
      fi
    fi
  done
}

build_variant() {
  local agent="$1"
  local script="$2"

  local variant_name="spec-kit-template-${agent}-${script}-${VERSION}"
  local base_dir="$GENRELEASES_DIR/$variant_name"

  echo "Building $variant_name"

  rm -rf "$base_dir"
  mkdir -p "$base_dir/.saleskit"

  cp -R "$SOURCE_DIR/memory" "$base_dir/.saleskit/"
  cp -R "$SOURCE_DIR/templates" "$base_dir/.saleskit/"

  mkdir -p "$base_dir/.saleskit/scripts"
  if [[ "$script" == "sh" ]]; then
    cp -R "$SOURCE_DIR/scripts/bash" "$base_dir/.saleskit/scripts/"
  else
    cp -R "$SOURCE_DIR/scripts/powershell" "$base_dir/.saleskit/scripts/"
  fi

  generate_commands "$agent" "$script" "$base_dir"

  (
    cd "$GENRELEASES_DIR"
    zip -qr "${variant_name}.zip" "$variant_name"
  )

  local zip_path="$GENRELEASES_DIR/${variant_name}.zip"
  local sha
  sha="$(sha256_file "$zip_path")"

  echo "$sha  $(basename "$zip_path")" >> "$GENRELEASES_DIR/checksums-${VERSION}.txt"

  rm -rf "$base_dir"
}

agents_to_build=()
while IFS= read -r a; do
  [[ -n "$a" ]] && agents_to_build+=("$a")
done < <(emit_env_or_defaults AGENTS "${ALL_AGENTS[@]}")

scripts_to_build=()
while IFS= read -r s; do
  [[ -n "$s" ]] && scripts_to_build+=("$s")
done < <(emit_env_or_defaults SCRIPTS "${ALL_SCRIPTS[@]}")

for agent in "${agents_to_build[@]}"; do
  for script in "${scripts_to_build[@]}"; do
    build_variant "$agent" "$script"
  done
done

count="$(ls -1 "$GENRELEASES_DIR"/*.zip 2>/dev/null | wc -l | tr -d ' ')"
echo "Generated $count template variants in $GENRELEASES_DIR"
