# Dotfiles

Minimal, boring, modern dotfiles.

## Philosophy

- Prefer defaults over cleverness
- One tool at a time
- No plugin unless it earns its keep
- Vim muscle memory everywhere
- Easy to delete, easy to rebuild

---

## Sway desktop

- [Setup reference](SWAY.md) — installation, architecture, services, power policy, and diagnostics
- [Sway cheatsheet](SWAY-CHEATSHEET.md) — daily keybindings and common workflows

---

## What's included

| Tool | Purpose |
| ------ | --------- |
| zsh | Shell with vi-mode, history, minimal aliases |
| starship | Prompt (git-aware, fast) |
| nvim | Editor with LSP, Treesitter, Telescope |
| ghostty | Terminal emulator |
| tmux | Terminal multiplexer |
| zoxide | Smarter `cd` (replaces it via `alias cd='z'`) |
| fzf | Fuzzy history search (`Ctrl-R`) and file picker (`Ctrl-T`) |
| zsh-autosuggestions | Fish-style history completions (press `→` to accept) |
| zsh-syntax-highlighting | Red/green command validation as you type |

---

## Prerequisites

macOS:

```sh
brew install neovim tmux fzf zoxide ripgrep starship \
             zsh-autosuggestions zsh-syntax-highlighting
```

Arch-based Linux:

```sh
./arch_prereqs.sh
```

Debian-based Linux:

```sh
./apt_prereqs.sh
```

Both scripts install the same interactive Zsh baseline: Zsh, tmux, fzf, zoxide, Starship, Neovim, ripgrep, Node/NVM, uv, Python/pip, Rust/Cargo, Go, and Zsh autosuggestions plus syntax highlighting.

For the optional Sway desktop stack, use `./arch_desktop_prereqs.sh` or `./apt_desktop_prereqs.sh`. Debian does not generally package Ghostty, so install it separately there or change the terminal command in the Sway config.

`ripgrep` is required for Telescope's live grep (`<leader>fg`); `tree-sitter-cli` builds parser updates.

---

## Bootstrap

```sh
git clone <this repo> ~/src/dotfiles
cd ~/src/dotfiles
./install.sh
```

### tmux session persistence (optional but recommended)

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then open tmux and press `prefix + I` (capital I) to install plugins.

### Neovim plugins + language servers

Open `nvim` — lazy.nvim auto-installs all plugins on first launch.
Language servers (TypeScript, Python, Go, Rust, Bash) install automatically via Mason.

---

## Keybindings

### tmux (prefix = `Ctrl-b`)

| Key | Action |
| ----- | -------- |
| `prefix + \|` | Split pane vertically |
| `prefix + -` | Split pane horizontally |
| `prefix + h/j/k/l` | Navigate panes (vim-style) |
| `prefix + r` | Reload tmux config |
| `prefix + [` then `v` | Enter copy mode, start selection |
| `y` (in copy mode) | Copy selection |
| `prefix + Ctrl-s` | Save session (tmux-resurrect) |
| `prefix + Ctrl-r` | Restore session (tmux-resurrect) |

### Neovim (leader = `Space`)

**Navigation**

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep across project (Telescope) |
| `<leader>fb` | Find open buffers (Telescope) |
| `<leader>fd` | Browse diagnostics (Telescope) |

**LSP** (active when a language server is attached)

| Key | Action |
| ----- | -------- |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | List references |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` / `]d` | Previous / next diagnostic |

**Other**

| Key | Action |
| ----- | -------- |
| `<leader>sp` | Open scratchpad (`~/tmp/scratch.md`) |
| `<leader>td` | Open todo (`~/tmp/todo.md`) |
| `<leader>tw` | Toggle word wrap |
| `jj` (insert mode) | Exit insert mode |

---

## Themes

Profiles in `themes/` change colors only; Sway bindings, services, and layouts stay static. The selector updates Sway, Waybar, Mako, Ghostty, tmux, and Neovim, and sets GTK's dark/light preference (which the local XDG portal exposes to supporting apps).

```sh
theme oled-black
theme amber-crt
theme solarized-dark
theme solarized-light
```

`oled-black` is the default. `amber-crt` uses warm amber phosphor colors on a near-black background. Ghostty needs its normal reload shortcut (`Ctrl+Shift+,`) after a switch; Neovim applies the selected profile when it gains focus.

To add a profile, copy an existing directory under `themes/`, then provide `appearance`, `sway.conf`, `waybar.css`, `mako.conf`, `ghostty.conf`, `tmux.conf`, and `nvim.lua`.

---

## Language servers

These install automatically on first `nvim` launch:

| Language | Server |
| ---------- | -------- |
| TypeScript / JS | `ts_ls` |
| Python | `pyright` |
| Go | `gopls` |
| Rust | `rust_analyzer` |
| Bash | `bashls` |

**To add a new language server:**

1. Open nvim and run `:Mason`
2. Find the server, press `i` to install
3. Add the server name to `ensure_installed` in `nvim/init.lua` so it auto-installs on new machines

---

## Machine-specific overrides

Create `~/.zshrc.local` for anything that shouldn't live in the repo (work tokens,
machine-specific paths, etc.). It's sourced automatically and is gitignored.

---

## What's intentionally missing

- Oh My Zsh / Prezto
- Heavy Neovim distros (LazyVim, AstroNvim)
- Auto-formatters / linters wired up globally (add per-project as needed)
- Anything I don't use weekly
