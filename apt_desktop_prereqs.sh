#!/usr/bin/env bash
# Installs the Sway desktop dependencies on Debian/Ubuntu.
# Ghostty is not generally packaged by Debian; install it separately if desired.
set -euo pipefail

sudo apt-get update -qq
sudo apt-get install -y \
  blueman brightnessctl grim mako-notifier network-manager network-manager-gnome qalc \
  pavucontrol playerctl polkit-kde-agent-1 power-profiles-daemon slurp sway swayidle \
  swaylock upower waybar wob wofi wireplumber pipewire-pulse

sudo systemctl enable --now NetworkManager bluetooth
