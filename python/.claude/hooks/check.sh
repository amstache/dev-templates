#!/usr/bin/env bash
# Stop: Claude can't finish while checks fail. Exit 2 sends the output back to Claude.
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
# Skip turns that left no uncommitted Python or dependency changes (e.g. Q&A).
if git rev-parse --git-dir >/dev/null 2>&1 &&
  [[ -z $(git status --porcelain --untracked-files=all -- '*.py' pyproject.toml uv.lock) ]]; then
  exit 0
fi
out=$(make check 2>&1) || { echo "$out" | tail -40 >&2; exit 2; }
