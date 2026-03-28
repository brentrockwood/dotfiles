#!/usr/bin/env bash
# Detects macOS system appearance and sources the matching Solarized tmux theme.
# On non-macOS systems (SSH, Linux console) falls back to Solarized Dark.

if ! command -v defaults >/dev/null 2>&1; then
  tmux source-file ~/.config/tmux/solarized-dark.conf
  exit 0
fi

if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
  tmux source-file ~/.config/tmux/solarized-dark.conf
else
  tmux source-file ~/.config/tmux/solarized-light.conf
fi
