# Sway desktop setup

This is the portable, dark Sway setup for the HP OmniBook X Flip. It is intentionally small: Sway owns window management; Waybar owns status; the tray owns graphical network and Bluetooth controls.

## Canonical files

All user-editable configuration lives in this repository and is symlinked into `~` by [`install.sh`](install.sh).

| Repository path | Installed path | Purpose |
| --- | --- | --- |
| `.config/sway/config` | `~/.config/sway/config` | Sway, bindings, startup processes, input, lock/idle policy |
| `.config/waybar/config.jsonc` | `~/.config/waybar/config.jsonc` | Waybar modules |
| `.config/waybar/style.css` | `~/.config/waybar/style.css` | Dark Waybar styling |
| `.config/mako/config` | `~/.config/mako/config` | Dark notification popups |
| `bin/power-profile-policy` | `~/bin/power-profile-policy` | Automatic power-profile policy |
| `bin/screenshot` | `~/bin/screenshot` | Region screenshots saved with UTC filenames |
| `bin/tmux-copy` | `~/bin/tmux-copy` | Cross-platform tmux-to-system-clipboard bridge |
| `tmux/tmux.conf` | `~/.tmux.conf` | tmux bindings, including clipboard copy mode |
| `zsh/.zshrc` | `~/.zshrc` | Shell setup; includes the systemd SSH-agent socket export |

`install.sh` is deliberately non-destructive: an existing destination is **skipped**, not replaced. On this first machine, the stock Sway file was preserved as `~/.config/sway/config.before-dotfiles` before the canonical Sway config was linked.

## Installing on Arch/CachyOS

Install the desktop packages once:

```sh
sudo pacman -S --needed \
  sway waybar wofi ghostty \
  swaylock swayidle mako \
  networkmanager network-manager-applet blueman polkit-kde-agent \
  pipewire-pulse wireplumber pavucontrol playerctl \
  brightnessctl grim slurp wl-clipboard \
  power-profiles-daemon upower
sudo systemctl enable --now NetworkManager bluetooth
```

`wev` is useful only for identifying unusual laptop keys:

```sh
sudo pacman -S --needed wev
```

Then clone the repository and run:

```sh
./install.sh
```

Start Sway from the display manager/session launcher. After editing Sway or Waybar configuration, reload it with `Super+Shift+C`; the config restarts Waybar and all Sway-managed helpers.

The general CLI prerequisite scripts also install `wl-clipboard` and `xclip` so tmux clipboard copy works on Wayland and X11. macOS uses its built-in `pbcopy`.

## Current machine assumptions

- **Machine:** HP OmniBook X Flip 2-in-1
- **Panel:** `eDP-1`, 1920×1200 OLED, 60 Hz, scale `1.0`
- **Theme:** dark, solid `#101216` OLED-friendly background
- **Primary applications:** Ghostty, tmux, Neovim, Google Chrome
- **Interaction model:** keyboard-first tiling; no focus-follows-mouse; a touchpad gets natural scrolling while mouse wheels keep traditional scrolling
- **Tablet mode:** touchscreen and stylus are detected but no rotation/tablet automation is configured; this is intentional because tablet use is rare
- **Nerd Font:** Waybar uses `MesloLGLDZ Nerd Font Mono`; install an equivalent Nerd Font before using this config elsewhere

## Sway behavior

### Input and focus

- `Super` is Sway's modifier (`Mod4`, normally the Windows/Command key).
- `Super+H/J/K/L` changes focus left/down/up/right.
- `Super+Shift+H/J/K/L` moves the focused window left/down/up/right.
- Arrow keys are equivalent for focus and moving.
- Pointer movement never changes focus (`focus_follows_mouse no`).
- The pointer hides on keyboard input and returns when moved.
- Touchpad tapping, natural scrolling, and disable-while-typing are enabled.

### Locking and idle policy

`Super+Shift+S` locks with a black Swaylock screen, then powers off the outputs. Any input wakes the OLED back to the still-locked screen.

`swayidle` also:

1. waits five minutes of inactivity;
2. locks with Swaylock and powers off the OLED;
3. powers outputs back on when input resumes; and
4. locks before system suspend.

It does **not** automatically suspend. Automatic suspend by power mode is intentionally deferred.

### Startup services

Sway starts or maintains the following on each config reload:

- `power-profile-policy` — one instance is protected by a runtime lock
- KDE PolicyKit agent — required for privileged graphical network/Bluetooth changes
- `nm-applet --indicator` — NetworkManager tray menu
- `blueman-applet` — Bluetooth tray menu and manager
- `mako` — notification daemon
- `swayidle` — lock/display power policy
- `waybar` — status bar

NetworkManager and `bluetooth.service` must be enabled system services. PipeWire/WirePlumber provide audio; Sway binds media keys through `pactl` and `playerctl`.

## Waybar

The 32 px top bar contains:

| Position | Module | Behavior |
| --- | --- | --- |
| Left | Sway workspaces | Active workspace is highlighted; scroll switching is disabled |
| Center | Focused window title | Truncated to 60 characters |
| Right | Volume | Nerd Font level icon; hover shows percentage; click opens Pavucontrol |
| Right | Power group | Battery icon plus power-profile icon |
| Right | Clock | Click to show ISO date; hover shows calendar |
| Right | Tray | NetworkManager, Blueman, Tailscale, and other tray apps |

The NetworkManager tray icon is the only Wi-Fi status/control. Its menu manages Wi-Fi, Ethernet, VPN, and connections. Blueman is the Bluetooth control; normal click may open Blueman Manager and its context menu supplies compact actions.

### Battery and profile indicators

Battery is icon-only in the bar. Hover shows percentage and estimated remaining/charging time.

- charging: lightning icon
- plugged but not charging: plug icon
- discharging: capacity icon
- warning at 30%; critical at 15%

The adjacent profile icon is lightning (**performance**), scales (**balanced**), or leaf (**power-saver**). Hover shows the profile and driver. Clicking it cycles profiles; the automatic policy intentionally does not immediately undo that manual choice.

## Power-profile policy

`bin/power-profile-policy` watches UPower events and sets `power-profiles-daemon` profiles:

| Condition | Profile |
| --- | --- |
| Charging or fully charged | `performance` |
| Discharging above 20% | `balanced` |
| Battery at or below 20% | `power-saver` |
| Plugged but not charging / unknown state | `balanced` above 20%, otherwise `power-saver` |

The process remembers the last automatic decision. A Waybar click can set another profile and it remains in effect until a relevant power/battery state changes. This prevents ordinary manual use from being immediately overwritten.

Run a one-off policy evaluation with:

```sh
~/bin/power-profile-policy --once
powerprofilesctl get
```

## Notifications

Mako displays at most three dark, top-right notifications. Default timeout is five seconds. There is no notification history or notification center by design.

Test it with:

```sh
notify-send 'Mako is ready' 'Test notification'
```

## Screenshots and clipboard

### Screenshots

Both `Print` and the OmniBook screenshot key (`XF86Launch2`; the screenshot/F11 physical key) run `~/bin/screenshot`.

1. Press the key.
2. Drag a region using Slurp.
3. The image is saved to `~/Pictures/Screenshots/` as UTC ISO-like `YYYY-MM-DDTHH-MM-SSZ.png`.
4. Press `Escape` while selecting to cancel safely.

Screenshots save to disk and do **not** copy to the clipboard. This matches the preferred macOS-like workflow.

To identify an unknown laptop key, run this from a shell with the Sway environment:

```sh
WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/$(id -u) wev
```

Press the key and inspect the `sym:` value. Long-lived tmux shells can retain stale Wayland environment variables; the explicit command avoids that.

### Clipboard

Graphical applications use the normal Wayland clipboard. Neovim already uses `unnamedplus`; `wl-copy` and `wl-paste` are available for shell use.

In tmux copy mode, `v` begins a vi-style selection and `y` copies it to the system clipboard through `~/bin/tmux-copy`:

1. `Ctrl+B [` enters copy mode.
2. Move with vi keys.
3. `v` starts selection.
4. `y` copies and exits.

The helper chooses `wl-copy` on Wayland, `pbcopy` on macOS, then `xclip`/`xsel` on X11. Ghostty's native `Ctrl+Shift+C`/`Ctrl+Shift+V` and Shift-drag selection remain unchanged.

There is no clipboard-history daemon. Add one only if history becomes a repeated need.

## SSH agent and local security state

The zsh configuration exports Arch's systemd user socket when it exists:

```sh
SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
```

The socket service is enabled by the OS. Unlock a key once per login session:

```sh
ssh-add ~/.ssh/ws2
ssh-add -l
```

Loaded identities remain available until logout/reboot. `~/.ssh/config`'s `AddKeysToAgent yes` also adds a key after its first successful use.

This machine additionally has a local `/etc/sudoers.d/` passwordless-sudo rule created outside this repository. It is a security decision, not portable dotfile configuration; do not copy it to another machine without explicitly deciding to accept passwordless root access.

## Deliberately deferred

Do not add these until they solve an observed problem:

- fixed application-to-workspace assignments or window rules
- clipboard history
- automatic tablet rotation, stylus workflows, or tablet mode
- automatic suspend policy
- a dedicated power-profile popup menu
- a notification history center
- extra CPU/RAM/temperature/media Waybar modules

## Diagnostics and safe iteration

Useful checks:

```sh
sway -C -c ~/.config/sway/config        # validate Sway syntax
swaymsg reload                          # apply Sway config
swaymsg -t get_config                   # inspect the live loaded config
pgrep -af 'waybar|mako|swayidle'        # inspect desktop helpers
powerprofilesctl get                    # active power profile
upower -i /org/freedesktop/UPower/devices/DisplayDevice
nmcli general status                    # NetworkManager state
bluetoothctl show                       # Bluetooth state
```

When changing this setup: edit the repository file, validate it, reload Sway, and test the one behavior changed. Do not edit a symlink target through an unrelated copy in `~`.
