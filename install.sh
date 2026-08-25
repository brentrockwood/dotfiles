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

mkdir -p "$HOME/.config/dotfiles-theme"
mkdir -p "$HOME/.config/ghostty"
mkdir -p "$HOME/.config/mako"
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/sway"
mkdir -p "$HOME/.config/tmux"
mkdir -p "$HOME/.config/waybar"
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/bin"

link "$DOTFILES_DIR/themes/oled-black" "$HOME/.config/dotfiles-theme/current"
link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
link "$DOTFILES_DIR/.config/ghostty/config" "$HOME/.config/ghostty/config"
link "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES_DIR/.config/mako/config" "$HOME/.config/mako/config"
link "$DOTFILES_DIR/.config/sway/config" "$HOME/.config/sway/config"
link "$DOTFILES_DIR/.config/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
link "$DOTFILES_DIR/.config/waybar/style.css" "$HOME/.config/waybar/style.css"
link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES_DIR/tmux/theme.sh" "$HOME/.config/tmux/theme.sh"
link "$DOTFILES_DIR/bin/claude-statusline.sh" "$HOME/bin/claude-statusline.sh"
link "$DOTFILES_DIR/bin/power-profile-policy" "$HOME/bin/power-profile-policy"
link "$DOTFILES_DIR/bin/audio-route" "$HOME/bin/audio-route"
link "$DOTFILES_DIR/bin/screenshot" "$HOME/bin/screenshot"
link "$DOTFILES_DIR/bin/tmux-copy" "$HOME/bin/tmux-copy"
link "$DOTFILES_DIR/bin/theme" "$HOME/bin/theme"
link "$DOTFILES_DIR/bin/claude-statusline.sh" "$HOME/.claude/statusline-command.sh"

echo
echo "✔ Dotfiles installed."
echo
echo "Next steps:"
echo "  1. Install Neovim if you want: https://neovim.io"
echo "  2. Restart your terminal, or run: exec zsh"
echo
