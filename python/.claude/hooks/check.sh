#!/usr/bin/env bash
# Stop: Claude can't finish while checks fail. Exit 2 sends the output back to Claude.
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

# Files that define the checks, besides the [tool.*] settings in pyproject.toml.
guarded=(Makefile conftest.py .claude .github)

# Skip turns that left no uncommitted code, dependency, or check changes (e.g. Q&A).
if git rev-parse --git-dir >/dev/null 2>&1 &&
  [[ -z $(git status --porcelain --untracked-files=all -- '*.py' pyproject.toml uv.lock "${guarded[@]}") ]]; then
  exit 0
fi

# Changing the checks needs the user's OK. Blocks once per distinct change, so Claude has to
# raise it; the user approves by committing.
tool_settings() {
  uv run -q --no-project python -c \
    'import json, sys, tomllib; print(json.dumps(tomllib.load(sys.stdin.buffer).get("tool", {}), sort_keys=True))'
}
if git rev-parse --verify -q HEAD >/dev/null; then
  changed=$(git status --porcelain --untracked-files=all -- "${guarded[@]}")
  settings=$(tool_settings <pyproject.toml)
  if git cat-file -e HEAD:pyproject.toml 2>/dev/null &&
    [[ $settings != "$(git show HEAD:pyproject.toml | tool_settings)" ]]; then
    changed+=$'\n M pyproject.toml ([tool.*] settings)'
  fi
  if [[ -n ${changed//[[:space:]]/} ]]; then
    state=$(
      echo "$changed" "$settings"
      git diff HEAD -- "${guarded[@]}"
      git ls-files --others --exclude-standard -- "${guarded[@]}" | while read -r f; do git hash-object -- "$f"; done
    )
    seen="$(git rev-parse --git-dir)/claude-checks-seen"
    if [[ $state != "$(cat "$seen" 2>/dev/null)" ]]; then
      printf '%s' "$state" >"$seen"
      {
        echo "Files that define this project's checks changed since the last commit:"
        echo "$changed" | sed '/^$/d'
        echo "If the user didn't ask for this change, revert it. If they did, tell them exactly what changed so they can review and commit it."
        git diff --unified=0 HEAD -- "${guarded[@]}" pyproject.toml | grep -vE '^(diff --git|index |--- |\+\+\+ )' | head -40
      } >&2
      exit 2
    fi
  fi
fi

out=$(make check 2>&1) || { echo "$out" | tail -40 >&2; exit 2; }
