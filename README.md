# Dotfiles

Minimal, boring, modern dotfiles.

## Philosophy

- Prefer defaults over cleverness
- One tool at a time
- No plugin unless it earns its keep
- Vim muscle memory everywhere
- Easy to delete, easy to rebuild

---

## What's included

| Tool | Purpose |
|------|---------|
| zsh | Shell with vi-mode, history, minimal aliases |
| starship | Prompt (git-aware, fast) |
| nvim | Editor with LSP, Treesitter, Telescope |
| tmux | Terminal multiplexer with Solarized theme |
| zoxide | Smarter `cd` (replaces it via `alias cd='z'`) |
| fzf | Fuzzy history search (`Ctrl-R`) and file picker (`Ctrl-T`) |
| zsh-autosuggestions | Fish-style history completions (press `→` to accept) |
| zsh-syntax-highlighting | Red/green command validation as you type |

---

## Prerequisites

```sh
brew install neovim tmux fzf zoxide ripgrep starship \
             zsh-autosuggestions zsh-syntax-highlighting
```

`ripgrep` is required for Telescope's live grep (`<leader>fg`).

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
|-----|--------|
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
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | List references |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` / `]d` | Previous / next diagnostic |

**Other**

| Key | Action |
|-----|--------|
| `<leader>sc` | Open scratchpad (`~/.scratchpad.md`) |
| `<leader>tw` | Toggle word wrap |
| `jj` (insert mode) | Exit insert mode |

---

## Themes

### How it works

Both tmux and Neovim follow the macOS system appearance setting automatically:

- **macOS dark mode** → Solarized Dark
- **macOS light mode** → Solarized Light
- **SSH / Linux** → Solarized Dark (fallback — `defaults` command not available)

tmux re-checks appearance whenever it gains focus. Neovim re-checks on `FocusGained`.

### Changing the tmux theme

Theme files are `tmux/solarized-dark.conf` and `tmux/solarized-light.conf`.
Edit the hex values in either file, then reload with `prefix + r`.

To use a completely different theme, create `tmux/mytheme.conf` following the same
structure (`status-style`, `window-status-*`, `pane-border-*`, etc.), then edit
`tmux/theme.sh` to source your file.

### Changing the Neovim theme

The colorscheme plugin is `maxmx03/solarized.nvim` in `nvim/init.lua`. To switch:

1. Replace the plugin entry in `require("lazy").setup({...})` with your chosen plugin.
2. Update `apply_solarized()` to call the new colorscheme name.
3. Remove or adapt the `vim.o.background` line if the new theme doesn't use it.

Run `:Lazy` inside Neovim to manage plugins interactively.

---

## Language servers

These install automatically on first `nvim` launch:

| Language | Server |
|----------|--------|
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

