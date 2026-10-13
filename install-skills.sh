#!/usr/bin/env bash
# install-skills.sh - Install agent skills locally (cwd) or globally (~/...)
# Usage: ./install-skills.sh <cwd|global> <target...>
# Targets: codex, claude, copilot, agents, all

set -euo pipefail

# Determine script root directory (where skill bundles reside)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $# -lt 2 ]; then
  cat << 'EOF'
Usage:
  ./install-skills.sh <cwd|global> <target...>

Scope:
  cwd       Install into current working directory (e.g. ./<target>/skills/...)
  global    Install into user home directory (e.g. ~/.<target>/skills/...)

Targets:
  copilot   GitHub Copilot skills (.github/skills in cwd, ~/.copilot/skills in global)
  claude    Claude Code skills (.claude/skills in cwd, ~/.claude/skills in global)
  codex     OpenAI Codex skills (.codex/skills in cwd, ~/.codex/skills in global)
  agents    Universal Agent skills (.agents/skills in cwd, ~/.agents/skills in global)
  all       Install all of the above

Examples:
  ./install-skills.sh cwd all
  ./install-skills.sh global copilot claude
  ./install-skills.sh cwd codex claude
EOF
  exit 1
fi

SCOPE="$1"
shift

# Collect targets
TARGETS=("$@")

# Normalize targets
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
      src="$SCRIPT_DIR/.github/skills"
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
      src="$SCRIPT_DIR/.claude/skills"
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
      src="$SCRIPT_DIR/.codex/skills"
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
      src="$SCRIPT_DIR/.agents/skills"
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
