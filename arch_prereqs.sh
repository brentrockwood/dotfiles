#!/usr/bin/env bash
# Installs the prerequisites for this setup on Arch-based systems.
set -euo pipefail

sudo pacman -Syu --needed \
  base-devel curl fzf git go jq neovim nodejs npm python python-pip ripgrep rust starship \
  tree-sitter-cli tmux unzip wget wl-clipboard xclip zoxide zsh \
  zsh-autosuggestions zsh-syntax-highlighting

if ! command -v nvm >/dev/null; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
source "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default 'lts/*'

npm install -g @anthropic-ai/claude-code

if ! command -v uv >/dev/null; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
