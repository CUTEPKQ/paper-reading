#!/usr/bin/env bash
# install.sh — symlink this repo into ~/.claude/skills/paper-reading
#
# Run this from anywhere after cloning the repo:
#   ./install.sh
#
# What it does:
#   1. Ensures ~/.claude/skills/ exists
#   2. Backs up any existing ~/.claude/skills/paper-reading (real dir → timestamped backup, symlink → removed)
#   3. Creates a symlink from the repo to ~/.claude/skills/paper-reading
# After this, edits in the repo take effect in Claude Code immediately.

set -euo pipefail

SKILL_NAME="paper-reading"
SKILLS_DIR="${HOME}/.claude/skills"
TARGET="${SKILLS_DIR}/${SKILL_NAME}"
SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "${SKILLS_DIR}"

if [[ -L "${TARGET}" ]]; then
  existing="$(readlink "${TARGET}")"
  if [[ "${existing}" == "${SOURCE}" ]]; then
    echo "✓ Already installed: ${TARGET} -> ${SOURCE}"
    exit 0
  fi
  echo "Removing existing symlink: ${TARGET} -> ${existing}"
  rm "${TARGET}"
elif [[ -e "${TARGET}" ]]; then
  backup="${TARGET}.backup.$(date +%Y%m%d%H%M%S)"
  echo "Backing up existing directory: ${TARGET} -> ${backup}"
  mv "${TARGET}" "${backup}"
fi

ln -s "${SOURCE}" "${TARGET}"
echo "✓ Installed: ${TARGET} -> ${SOURCE}"
echo ""
echo "Verify by starting a new Claude Code session and asking:"
echo "  > list available skills"
echo "You should see 'paper-reading' in the list."
