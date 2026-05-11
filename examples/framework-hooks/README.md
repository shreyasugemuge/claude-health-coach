# Framework git hooks (recommended for contributors)

Two hooks for this framework repo. Last line of defense after `.gitignore` and the Claude Code PreToolUse hook.

| Hook | What it blocks |
|---|---|
| `pre-commit` | Staging any path that looks like personal data (`wiki/profile/`, `wiki/biomarkers/`, `raw/`, `hot.md`, `log.md`, `.is-personal-vault`, etc.) into the framework's index. |
| `pre-push` | Pushing commits that contain personal-data paths or sensitive content patterns (`HbA1c X.Y %`, `LDL XX mg/dL`). |

Both hooks anchor their path patterns to the repo root, so sanitized fixtures under `examples/sample-vault/` are unaffected.

## Install

From the framework repo root:

```sh
sh examples/framework-hooks/install.sh
```

The installer copies the hooks into `.git/hooks/`, backs up any existing hooks with a timestamped suffix, and marks them executable. It refuses to run from a personal vault (use `examples/vault-hooks/install.sh` instead).

## Extending the sensitive-patterns list

Open `.git/hooks/pre-push` and add patterns to `sensitive_patterns`. The list is intentionally short; resist the temptation to grep for everything. Path-based blocking via `forbidden_paths` is the primary control.

## Emergency bypass

If a hook fires on a false positive that you cannot quickly fix:

```sh
git commit --no-verify
git push --no-verify
```

Use sparingly. Each bypass is a small loss of guarantee.
