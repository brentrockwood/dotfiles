#!/usr/bin/env bash
# Installs the Sway desktop dependencies on Arch/CachyOS.
set -euo pipefail

sudo pacman -Syu --needed \
  blueman brightnessctl ghostty grim libqalculate mako networkmanager network-manager-applet \
  pavucontrol playerctl polkit-kde-agent power-profiles-daemon slurp sway swayidle \
  swaylock upower waybar wob wofi wireplumber pipewire-pulse

sudo systemctl enable --now NetworkManager bluetooth
