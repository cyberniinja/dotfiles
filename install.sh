#!/usr/bin/env bash
# Codespaces dotfiles install script
# Runs automatically when a new Codespace is created

set -euo pipefail

echo "🔧 Setting up dotfiles..."

# --- GitHub Copilot CLI ---
if gh extension list 2>/dev/null | grep -q "gh-copilot"; then
  echo "✅ gh-copilot already installed"
else
  echo "Installing gh-copilot..."
  gh extension install github/gh-copilot
  echo "✅ gh-copilot installed"
fi

# --- zsh config ---
ZSHRC="$HOME/.zshrc"

append_if_missing() {
  local line="$1"
  grep -qxF "$line" "$ZSHRC" 2>/dev/null || echo "$line" >> "$ZSHRC"
}

# Aliases
append_if_missing 'alias gs="git status"'
append_if_missing 'alias gl="git log --oneline --graph --decorate -20"'
append_if_missing 'alias gco="git checkout"'

echo "✅ dotfiles setup complete"
