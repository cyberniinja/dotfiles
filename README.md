# dotfiles

Personal dotfiles applied automatically to every GitHub Codespace.

## What's included

- **gh-copilot** extension installed via `gh`
- zsh aliases (`gs`, `gl`, `gco`)

## How it works

GitHub Codespaces detects this repo and runs `install.sh` when a new Codespace is created.
Enable it at: **github.com → Settings → Codespaces → Dotfiles**

## Adding more

Edit `install.sh` to add tools, shell config, or any other personal setup.
