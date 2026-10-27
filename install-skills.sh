#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DEST="$HOME/.agents/skills"
CLAUDE_DEST="$HOME/.claude/skills"
GEMINI_DEST="$HOME/.gemini/config/skills"
MUSE_DEST="$HOME/.config/muse/skills"

mkdir -p "$AGENTS_DEST"
mkdir -p "$CLAUDE_DEST"
mkdir -p "$GEMINI_DEST"
mkdir -p "$MUSE_DEST"

find "$REPO" -name SKILL.md | while read -r skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"

  # Remove existing destination first to prevent nested directories (e.g. name/name)
  rm -rf "$AGENTS_DEST/$name"
  rm -rf "$CLAUDE_DEST/$name"
  rm -rf "$GEMINI_DEST/$name"
  rm -rf "$MUSE_DEST/$name"

  # Install to agents (to be used by all AI agents)
  cp -R "$src" "$AGENTS_DEST/$name"

  # Install to Claude Code
  cp -R "$src" "$CLAUDE_DEST/$name"

  # Install to Antigravity
  cp -R "$src" "$GEMINI_DEST/$name"

  # Install to Meta Muse Code
  cp -R "$src" "$MUSE_DEST/$name"

  echo "Installed $name -> Agents, Claude, Gemini & Muse folder"
done
