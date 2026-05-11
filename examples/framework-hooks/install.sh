#!/bin/sh
# Install the framework-side pre-commit and pre-push hooks into this repo's
# .git/hooks directory. Run from the framework repo root.
#
# Usage (from the framework repo):
#   sh examples/framework-hooks/install.sh

set -e

if [ -f ".is-personal-vault" ]; then
  echo "❌ This looks like a personal vault (.is-personal-vault marker present)." >&2
  echo "   Run examples/vault-hooks/install.sh instead." >&2
  exit 1
fi

if [ ! -d ".git" ]; then
  echo "❌ Not in a git repository root." >&2
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
echo "Done. The framework will now refuse to commit or push personal-data paths"
echo "or sensitive content patterns (HbA1c values, raw LDL mg/dL readings)."
