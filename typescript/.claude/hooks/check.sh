#!/usr/bin/env bash
# Stop: Claude can't finish while checks fail. Exit 2 sends the output back to Claude.
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

# Files that define the checks, besides the scripts and tool settings in package.json.
guarded=('eslint.config.*' 'vitest.config.*' 'tsconfig*.json' '.prettierrc*' .prettierignore
  'knip.*' '.knip.*' pnpm-workspace.yaml Makefile .claude .github)

# Skip turns that left no uncommitted code, dependency, or check changes (e.g. Q&A).
if git rev-parse --git-dir >/dev/null 2>&1 &&
  [[ -z $(git status --porcelain --untracked-files=all -- '*.ts' '*.js' '*.json' pnpm-lock.yaml "${guarded[@]}") ]]; then
  exit 0
fi

# Changing the checks needs the user's OK. Blocks once per distinct change, so Claude has to
# raise it; the user approves by committing.
tool_settings() { jq -S '{scripts, knip, prettier, pnpm}'; }
if git rev-parse --verify -q HEAD >/dev/null; then
  changed=$(git status --porcelain --untracked-files=all -- "${guarded[@]}")
  settings=$(tool_settings <package.json)
  if git cat-file -e HEAD:package.json 2>/dev/null &&
    [[ $settings != "$(git show HEAD:package.json | tool_settings)" ]]; then
    changed+=$'\n M package.json (scripts / tool settings)'
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
        git diff --unified=0 HEAD -- "${guarded[@]}" package.json | grep -vE '^(diff --git|index |--- |\+\+\+ )' | head -40
      } >&2
      exit 2
    fi
  fi
fi

out=$(make check 2>&1) || { echo "$out" | tail -40 >&2; exit 2; }
