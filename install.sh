#!/usr/bin/env bash
# Codespaces dotfiles install script
# Runs automatically when a new Codespace is created

set -euo pipefail

echo "🔧 Setting up dotfiles..."

# --- GitHub Copilot CLI ---
# Auth is handled via the GITHUB_TOKEN Codespaces secret — no login step needed.
# Set it up at: github.com → Settings → Codespaces → Secrets
if command -v copilot &>/dev/null; then
  echo "✅ copilot CLI already installed"
else
  echo "Installing copilot CLI..."
  curl -fsSL https://gh.io/copilot-install | bash
  echo "✅ copilot CLI installed"
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
