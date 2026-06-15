#!/usr/bin/env bash
set -euo pipefail

# Copies all skills in the repository to:
# - ~/.claude/skills (for local Claude CLI)
# - ~/.gemini/antigravity/skills (for legacy global Antigravity)
# - ~/.gemini/config/skills (for standard global Antigravity)

REPO="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DEST="$HOME/.claude/skills"
ANTIGRAVITY_DEST="$HOME/.gemini/antigravity/skills"
GEMINI_CONFIG_DEST="$HOME/.gemini/config/skills"

check_dest_symlink() {
  local dest="$1"
  if [ -L "$dest" ]; then
    resolved="$(readlink -f "$dest")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $dest is a symlink into this repo ($resolved)." >&2
        echo "Remove it (rm \"$dest\") and re-run; the script will recreate it as a real dir." >&2
        exit 1
        ;;
    esac
  fi
}

check_dest_symlink "$CLAUDE_DEST"
check_dest_symlink "$ANTIGRAVITY_DEST"
check_dest_symlink "$GEMINI_CONFIG_DEST"

mkdir -p "$CLAUDE_DEST"
mkdir -p "$ANTIGRAVITY_DEST"
mkdir -p "$GEMINI_CONFIG_DEST"

copy_skill() {
  local src="$1"
  local name="$2"
  local dest_dir="$3"
  local target="$dest_dir/$name"

  if [ -e "$target" ] || [ -L "$target" ]; then
    rm -rf "$target"
  fi

  cp -R "$src" "$target"
  echo "Copied $name -> $target"
}

# Find all SKILL.md files in the repo (excluding node_modules, deprecated, and .git)
find "$REPO" -name SKILL.md -not -path '*/node_modules/*' -not -path '*/deprecated/*' -not -path '*/.git/*' -print0 |
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"

  copy_skill "$src" "$name" "$CLAUDE_DEST"
  copy_skill "$src" "$name" "$ANTIGRAVITY_DEST"
  copy_skill "$src" "$name" "$GEMINI_CONFIG_DEST"
done
