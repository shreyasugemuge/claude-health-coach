# Vault git hooks (recommended)

Two hooks for your personal vault repo. They are the outermost safety net, complementing the framework-side hooks and the Claude Code PreToolUse hook.

| Hook | What it blocks |
|---|---|
| `pre-commit` | Committing a framework file (`CLAUDE.md`, `llm-wiki.md`) as a regular file when it should be a symlink to your framework checkout. |
| `pre-push` | Pushing the vault to a remote whose GitHub visibility is `PUBLIC`. Override with `ALLOW_PUBLIC_VAULT_PUSH=1`. |

## Install

```sh
cd ~/your-vault
sh /path/to/claude-health-coach/examples/vault-hooks/install.sh
```

The installer copies the hooks into `.git/hooks/`, backs up any existing hooks with a timestamped suffix, and marks them executable.

## Why a separate `pre-push` for the vault

Your vault contains medical data. The framework's own `pre-push` cannot help you here, because the framework lives in a different repo. The vault hook is what catches "oops, I added the wrong remote."

`gh` is used to read the remote's visibility. If `gh` is not installed, the hook refuses to push (fail-closed). Install via `brew install gh` and `gh auth login`.
