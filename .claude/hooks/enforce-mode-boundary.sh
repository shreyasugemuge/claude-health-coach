#!/bin/sh
# Mode-aware Claude Code PreToolUse hook for Edit / Write / MultiEdit / NotebookEdit.
# Enforces the framework-vs-vault boundary at tool-call time, before the model
# can write a wrong file in a wrong place.
#
# Mode is determined by presence of `.is-personal-vault` in $CLAUDE_PROJECT_DIR.
#
# Behavior:
#   PERSONAL VAULT mode  -> block edits on framework symlinks
#                            (CLAUDE.md, llm-wiki.md, .claude/, wiki/knowledge/)
#   FRAMEWORK DEV mode   -> block writes to personal-data paths
#                            (wiki/profile/, wiki/biomarkers/, raw/, hot.md, ...)
#
# Override (rare, intentional): user removes the .is-personal-vault marker, OR
# they explicitly invoke from the right repo. There is no --no-verify equivalent
# at this layer, by design: this is the strict interior gate.

input=$(cat)

# Extract file_path from the tool_input JSON. Use python3 (always on macOS).
file_path=$(printf '%s' "$input" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
    ti = d.get("tool_input", {}) or {}
    print(ti.get("file_path") or ti.get("notebook_path") or "")
except Exception:
    pass
' 2>/dev/null)

# If we cannot extract a path, allow (do not block opaque operations).
if [ -z "$file_path" ]; then
  exit 0
fi

# Resolve to absolute path.
case "$file_path" in
  /*) abs="$file_path" ;;
  *)  abs="$PWD/$file_path" ;;
esac

# Determine mode by checking for the marker at project root.
if [ -f "${CLAUDE_PROJECT_DIR}/.is-personal-vault" ]; then
  mode="vault"
else
  mode="framework"
fi

# Compute path relative to project root. If outside project, we have no opinion.
case "$abs" in
  "${CLAUDE_PROJECT_DIR}"/*)
    relative="${abs#${CLAUDE_PROJECT_DIR}/}"
    ;;
  *)
    exit 0
    ;;
esac

if [ "$mode" = "vault" ]; then
  framework_paths='^(CLAUDE\.md$|llm-wiki\.md$|\.claude(/|$)|wiki/knowledge(/|$))'
  if printf '%s' "$relative" | grep -qE "$framework_paths"; then
    cat >&2 <<EOF
🛑 PERSONAL VAULT mode: blocked edit on a framework file.

  Path: $relative

  This file is a SYMLINK to your framework checkout. Editing here would
  silently modify the framework while leaving your vault history out of
  sync.

  To develop a feature, switch to the framework repo, make the change
  there, then return to your vault to test.

  (There is no override at this layer; the framework's git hooks will
   gate the actual commit and push.)
EOF
    exit 2
  fi
else
  personal_paths='^(wiki/profile/|wiki/biomarkers/|wiki/logs/|wiki/targets/|wiki/plans/|wiki/food-library/|wiki/calendar/|wiki/reviews/|wiki/design/|raw/|index\.md$|hot\.md$|log\.md$|\.is-personal-vault$)'
  if printf '%s' "$relative" | grep -qE "$personal_paths"; then
    cat >&2 <<EOF
🛑 FRAMEWORK DEV mode: blocked write to a personal-data path.

  Path: $relative

  Personal-data paths must NEVER be created in the framework repo.
  They belong in your personal vault. Switch to your vault directory
  and try again.

  If you intended to write a sanitized template or example for the
  framework, place it under 'wiki-template/' or 'examples/' instead.
EOF
    exit 2
  fi
fi

exit 0
