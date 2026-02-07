#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1"
  local dst="$2"

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "Skipping $dst (already exists)"
    return
  fi

  echo "Linking $dst → $src"
  ln -s "$src" "$dst"
}

echo "Installing dotfiles from $DOTFILES_DIR"
echo

mkdir -p "$HOME/.config/nvim"

link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

echo
echo "✔ Dotfiles installed."
echo
echo "Next steps:"
echo "  1. Install Neovim if you want: https://neovim.io"
echo "  2. Restart your terminal, or run: exec zsh"
echo

