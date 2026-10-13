#!/usr/bin/env bash
# install-skills.sh - Install agent skills locally (cwd) or globally (~/...)
# Supports running locally from repo OR remotely via curl piped to bash:
#   curl -fsSL https://raw.githubusercontent.com/davidw-philips/skills/main/install-skills.sh | bash -s -- <cwd|global> <target...>

set -eo pipefail

SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
fi

TEMP_CLONE=""
cleanup() {
  if [ -n "$TEMP_CLONE" ] && [ -d "$TEMP_CLONE" ]; then
    rm -rf "$TEMP_CLONE"
  fi
}
trap cleanup EXIT

if [ $# -lt 2 ]; then
  cat << 'HELP'
Usage:
  install-skills.sh <cwd|global> <target...>

Scope:
  cwd       Install into current working directory (e.g. ./<target>/skills/...)
  global    Install into user home directory (e.g. ~/.<target>/skills/...)

Targets:
  copilot   GitHub Copilot skills (.github/skills in cwd, ~/.copilot/skills in global)
  claude    Claude Code skills (.claude/skills in cwd, ~/.claude/skills in global)
  codex     OpenAI Codex skills (.codex/skills in cwd, ~/.codex/skills in global)
  agents    Universal Agent skills (.agents/skills in cwd, ~/.agents/skills in global)
  all       Install all of the above

One-Liner Remote Execution:
  curl -fsSL https://raw.githubusercontent.com/davidw-philips/skills/main/install-skills.sh | bash -s -- cwd all
  curl -fsSL https://raw.githubusercontent.com/davidw-philips/skills/main/install-skills.sh | bash -s -- global copilot claude
HELP
  exit 1
fi

SCOPE="$1"
shift

# If running directly via curl piped to bash or outside repo, download archive
if [ -z "$SCRIPT_DIR" ] || [ ! -d "$SCRIPT_DIR/.github/skills" ]; then
  echo "Downloading skills archive from GitHub..."
  TEMP_CLONE="$(mktemp -d)"
  curl -fsSL https://github.com/davidw-philips/skills/archive/refs/heads/main.tar.gz | tar -xz -C "$TEMP_CLONE" --strip-components=1
  SOURCE_BASE="$TEMP_CLONE"
else
  SOURCE_BASE="$SCRIPT_DIR"
fi

# Collect targets
TARGETS=("$@")

declare -A TARGET_MAP
for t in "${TARGETS[@]}"; do
  tl="$(echo "$t" | tr '[:upper:]' '[:lower:]')"
  if [ "$tl" = "all" ]; then
    TARGET_MAP["copilot"]=1
    TARGET_MAP["claude"]=1
    TARGET_MAP["codex"]=1
    TARGET_MAP["agents"]=1
  else
    TARGET_MAP["$tl"]=1
  fi
done

install_target() {
  local target_name="$1"
  local src_dir="$2"
  local dest_dir="$3"

  if [ ! -d "$src_dir" ]; then
    echo "Warning: Source skills directory not found: $src_dir"
    return
  fi

  echo "Installing $target_name skills -> $dest_dir"
  mkdir -p "$dest_dir"
  cp -r "$src_dir"/* "$dest_dir"/
  echo "✓ Installed $target_name skills successfully."
}

# Determine base paths
for target in "${!TARGET_MAP[@]}"; do
  case "$target" in
    copilot)
      src="$SOURCE_BASE/.github/skills"
      if [ "$SCOPE" = "global" ]; then
        dest="$HOME/.copilot/skills"
      elif [ "$SCOPE" = "cwd" ]; then
        dest="$(pwd)/.github/skills"
      else
        echo "Error: Unknown scope '$SCOPE'. Must be 'cwd' or 'global'." >&2
        exit 1
      fi
      install_target "GitHub Copilot" "$src" "$dest"
      ;;
    claude)
      src="$SOURCE_BASE/.claude/skills"
      if [ "$SCOPE" = "global" ]; then
        dest="$HOME/.claude/skills"
      elif [ "$SCOPE" = "cwd" ]; then
        dest="$(pwd)/.claude/skills"
      else
        echo "Error: Unknown scope '$SCOPE'. Must be 'cwd' or 'global'." >&2
        exit 1
      fi
      install_target "Claude Code" "$src" "$dest"
      ;;
    codex)
      src="$SOURCE_BASE/.codex/skills"
      if [ "$SCOPE" = "global" ]; then
        dest="$HOME/.codex/skills"
      elif [ "$SCOPE" = "cwd" ]; then
        dest="$(pwd)/.codex/skills"
      else
        echo "Error: Unknown scope '$SCOPE'. Must be 'cwd' or 'global'." >&2
        exit 1
      fi
      install_target "OpenAI Codex" "$src" "$dest"
      ;;
    agents)
      src="$SOURCE_BASE/.agents/skills"
      if [ "$SCOPE" = "global" ]; then
        dest="$HOME/.agents/skills"
      elif [ "$SCOPE" = "cwd" ]; then
        dest="$(pwd)/.agents/skills"
      else
        echo "Error: Unknown scope '$SCOPE'. Must be 'cwd' or 'global'." >&2
        exit 1
      fi
      install_target "Universal Agents" "$src" "$dest"
      ;;
    *)
      echo "Warning: Unrecognized target '$target'. Supported: copilot, claude, codex, agents, all"
      ;;
  esac
done

echo ""
echo "Installation complete!"
