#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DEST="$HOME/.claude/skills"
GEMINI_DEST="$HOME/.gemini/config/skills"
mkdir -p "$CLAUDE_DEST"
mkdir -p "$GEMINI_DEST"

find "$REPO" -name SKILL.md | while read -r skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  
  # Install to Claude Code
  rm -rf "${CLAUDE_DEST:?}/${name:?}"
  cp -R "$src" "$CLAUDE_DEST/$name"
  
  # Install to Antigravity
  rm -rf "${GEMINI_DEST:?}/${name:?}"
  cp -R "$src" "$GEMINI_DEST/$name"
  
  echo "Installed $name -> Claude & Gemini"
done
