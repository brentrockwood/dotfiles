#!/usr/bin/env bash
# Installs standard CLI prerequisites on a Debian/Ubuntu/Raspberry Pi OS machine.
# Safe to re-run. Does not touch ai1 or any machine with ROCm/GPU stacks.
set -e

echo "==> apt packages"
sudo apt-get update -qq
sudo apt-get install -y \
    fzf \
    starship \
    neovim \
    zoxide \
    git \
    curl \
    build-essential \
    jq \
    ripgrep \
    rustc \
    tree-sitter-cli \
    unzip \
    wget \
    wl-clipboard \
    xclip

# starship: fall back to curl installer if apt version is absent (older Pi OS)
if ! command -v starship &>/dev/null; then
    echo "==> starship not in apt, using curl installer"
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

echo "==> nvm + Node LTS"
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
fi
# shellcheck disable=SC1091
source "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default 'lts/*'

echo "==> Claude Code CLI"
npm install -g @anthropic-ai/claude-code

echo "==> uv (Python manager)"
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

echo "==> Done. Restart your shell or: source ~/.bashrc"
