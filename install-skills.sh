#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DEST="$HOME/.agents/skills"
CLAUDE_DEST="$HOME/.claude/skills"
GEMINI_DEST="$HOME/.gemini/config/skills"
mkdir -p "$CLAUDE_DEST"
mkdir -p "$GEMINI_DEST"

find "$REPO" -name SKILL.md | while read -r skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"

  # Install to agents (to be used by all AI agents)
  cp -R "$src" "$AGENTS_DEST/$name"

  # Install to Claude Code
  cp -R "$src" "$CLAUDE_DEST/$name"

  # Install to Antigravity
  cp -R "$src" "$GEMINI_DEST/$name"

  echo "Installed $name -> Agents, Claude & Gemini"
done
