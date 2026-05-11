#!/bin/sh
# Install the recommended pre-commit and pre-push hooks into the vault's
# .git/hooks directory. Run from the vault root.
#
# Usage:
#   cd ~/your-vault
#   sh /path/to/claude-health-coach/examples/vault-hooks/install.sh

set -e

if [ ! -f ".is-personal-vault" ]; then
  echo "❌ Run this from your personal vault root (.is-personal-vault marker missing)." >&2
  exit 1
fi

if [ ! -d ".git" ]; then
  echo "❌ This vault is not a git repository. Run 'git init' first." >&2
  exit 1
fi

here=$(cd "$(dirname "$0")" && pwd)

for hook in pre-commit pre-push; do
  src="$here/$hook"
  dst=".git/hooks/$hook"
  if [ -e "$dst" ] && ! cmp -s "$src" "$dst"; then
    backup="$dst.backup-$(date +%Y%m%d-%H%M%S)"
    echo "⚠️  $dst already exists; backing up to $backup"
    mv "$dst" "$backup"
  fi
  cp "$src" "$dst"
  chmod +x "$dst"
  echo "✓ installed $hook"
done

echo
echo "Done. Test by trying a commit and a push."
