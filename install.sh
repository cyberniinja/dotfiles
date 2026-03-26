#!/usr/bin/env bash
# Codespaces dotfiles install script
# Runs automatically when a new Codespace is created

set -euo pipefail

echo "🔧 Setting up dotfiles..."

# --- Copilot CLI config ---
# Pre-seed config to skip first-run prompts in Codespaces
COPILOT_CONFIG_DIR="$HOME/.copilot"
COPILOT_CONFIG="$COPILOT_CONFIG_DIR/config.json"
mkdir -p "$COPILOT_CONFIG_DIR"
if [ ! -f "$COPILOT_CONFIG" ]; then
  cat > "$COPILOT_CONFIG" << 'COPILOT_CONFIG_EOF'
{
  "banner": "never",
  "trusted_folders": ["/workspaces"],
  "firstLaunchAt": "2026-01-01T00:00:00.000Z"
}
COPILOT_CONFIG_EOF
  echo "✅ copilot config pre-seeded"
fi

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

# --- issue-space function ---
append_if_missing '# Start a Codespace for a given issue number and open it in VS Code'
append_if_missing 'issue-space() {'
append_if_missing '  local issue=$1'
append_if_missing '  if [ -z "$issue" ]; then echo "Usage: issue-space <issue-number>"; return 1; fi'
append_if_missing '  local repo=$(gh repo view --json nameWithOwner --jq ".nameWithOwner" 2>/dev/null)'
append_if_missing '  if [ -z "$repo" ]; then echo "Not inside a GitHub repo"; return 1; fi'
append_if_missing '  echo "🛸 Creating Codespace for $repo issue #$issue..."'
append_if_missing '  local name=$(gh codespace create --repo "$repo" --display-name "#$issue" --machine basicLinux32gb 2>&1 | tail -1)'
append_if_missing '  echo "✅ Codespace ready: $name"'
append_if_missing '  gh codespace code --codespace "$name"'
append_if_missing '}'

echo "✅ dotfiles setup complete"
