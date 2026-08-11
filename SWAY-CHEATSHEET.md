# Sway cheatsheet

This is the quick reference for this dotfiles configuration. `Super` means the Windows/Command key.

## First five things

| Key | What it does |
| --- | --- |
| `Super+Enter` | Open Ghostty |
| `Super+D` | Open Wofi application launcher; type to search, `Enter` to launch |
| `Super+H/J/K/L` | Focus left/down/up/right |
| `Super+1` … `Super+0` | Switch to workspace 1 … 10 |
| `Super+Shift+Escape` | Lock immediately and turn off the OLED |

After locking, press any key or move the touchpad to wake the display; the screen remains locked until you enter your password.

## Windows and workspaces

### Focus and move

| Action | Vim keys | Arrow keys |
| --- | --- | --- |
| Focus window | `Super+H/J/K/L` | `Super+Left/Down/Up/Right` |
| Move focused window | `Super+Shift+H/J/K/L` | `Super+Shift+Left/Down/Up/Right` |

Moving the mouse does **not** change focus. This is deliberate.

### Workspaces

| Key | Action |
| --- | --- |
| `Super+1` … `Super+0` | Go to workspace 1 … 10 (`0` is 10) |
| `Super+Shift+1` … `Super+Shift+0` | Send focused window to workspace 1 … 10 |

A workspace exists when it has a window. The Waybar buttons show active workspaces; click one if you prefer the mouse.

### Layouts

| Key | Action |
| --- | --- |
| `Super+B` | Next split is horizontal (side by side) |
| `Super+V` | Next split is vertical (stacked) |
| `Super+E` | Toggle split orientation |
| `Super+S` | Stacking layout |
| `Super+W` | Tabbed layout |
| `Super+F` | Fullscreen focused window |
| `Super+Shift+Space` | Toggle focused window floating/tiling |
| `Super+Space` | Toggle focus between tiled and floating windows |
| `Super+A` | Focus the parent container |

### Resize

1. Press `Super+R` to enter resize mode.
2. Use `H/J/K/L` or arrow keys to resize.
3. Press `Enter` or `Escape` to leave resize mode.

## Everyday system actions

| Key | Action |
| --- | --- |
| `Super+Shift+C` | Reload Sway and restart Waybar/helpers |
| `Super+Shift+Q` | Close focused window |
| `Super+Shift+E` | Log out of Sway after confirmation |
| `Super+Shift+Escape` | Lock and power off display |
| `Print` | Select and save a screenshot |
| OmniBook screenshot/F11 key | Same screenshot action (`XF86Launch2`) |

Screenshots are selected with the pointer and saved to:

```text
~/Pictures/Screenshots/YYYY-MM-DDTHH-MM-SSZ.png
```

Press `Escape` to cancel a screenshot selection.

## Laptop keys

The physical media/brightness keys work even while Sway is locked.

| Key | Action |
| --- | --- |
| Volume down/up | Decrease/increase output volume by 5% |
| Mute | Toggle output mute |
| Microphone mute | Toggle microphone mute |
| Play/pause, previous, next, stop | Control the active media player |
| Brightness down/up | Change OLED brightness by 5% |

With F-lock enabled, use `Fn` as needed to access the hardware action printed on a function-row key.

## Top bar

From left to right:

- **Workspaces** — active workspace is highlighted.
- **Window title** — title of the focused application.
- **Volume icon** — icon shape shows volume level; hover for exact percentage; click to open Pavucontrol.
- **Battery icon** — hover for percentage and estimated remaining/charging time. Lightning means charging; plug means AC is present but the battery is not charging.
- **Power-profile icon** — lightning = performance, scales = balanced, leaf = power saver. Hover for details; click to cycle profile.
- **Clock** — click for ISO date; hover for calendar.
- **Tray** — graphical NetworkManager, Blueman, Tailscale, and other applets.

### Network and Bluetooth

- Click the **NetworkManager tray icon** to join Wi-Fi, manage Ethernet/VPN, or edit connections.
- Click the **Blueman tray icon** for Bluetooth controls. It may open Blueman Manager; use its context menu for compact actions.

## Automatic power behavior

The desktop changes power profile automatically:

| State | Profile |
| --- | --- |
| Charging/full | Performance |
| On battery, above 20% | Balanced |
| On battery, 20% or below | Power saver |
| Plugged but not charging | Balanced above 20%; power saver at/below 20% |

Clicking the profile icon is a temporary manual override. It lasts until a power or battery state change.

After five idle minutes, the session locks and the OLED powers off. Input wakes it to the lock screen. The machine locks before suspend, but does not automatically suspend yet.

## Clipboard and tmux

Normal applications: use normal `Ctrl+C` / `Ctrl+V`.

Ghostty: `Ctrl+Shift+C` and `Ctrl+Shift+V` use the system clipboard. Shift-drag selection remains a terminal-native option.

Tmux copy mode:

```text
Ctrl+B [     enter copy mode
v            begin selection
y            copy to the OS clipboard and exit
```

The tmux `y` binding works on Wayland, macOS, and X11. There is no clipboard history manager.

## Useful commands

```sh
swaymsg reload                              # reload this configuration
sway -C -c ~/.config/sway/config             # validate Sway config
powerprofilesctl get                         # current power profile
pavucontrol                                  # graphical audio controls
nmtui                                        # terminal network fallback
bluetoothctl                                 # terminal Bluetooth fallback
notify-send 'Test' 'Hello from Mako'         # test notifications
```

## Common beginner patterns

- Open terminal: `Super+Enter`.
- Put Chrome on workspace 2: focus it, then `Super+Shift+2`.
- Arrange two terminals side-by-side: terminal, `Super+B`, open second terminal.
- Make an occasional dialog float: focus it, `Super+Shift+Space`.
- Recover from a bad config edit: run `sway -C -c ~/.config/sway/config`; fix the reported line; reload with `Super+Shift+C`.
- If a key does nothing, inspect it with `wev` (see [SWAY.md](SWAY.md#screenshots-and-clipboard)).
