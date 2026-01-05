# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Philosophy

This is a minimal, opinionated dotfiles repository following these principles:
- **Prefer defaults over cleverness** - avoid complex abstractions
- **One tool at a time** - incremental adoption of optional tools
- **No plugin unless it earns its keep** - only include tools used weekly
- **Vim muscle memory everywhere** - vi-style keybindings in shell and editor
- **Easy to delete, easy to rebuild** - simple structure, no hidden complexity

The repository intentionally avoids heavy frameworks like Oh My Zsh and auto-installing plugin managers.

## Installation & Setup

Install dotfiles by creating symlinks from this repo to home directory:
```bash
./install.sh
```

The script:
- Creates symlinks for `~/.zshrc` and `~/.config/nvim/init.lua`
- Skips files that already exist (non-destructive)
- Does not overwrite existing configurations

After installation, restart your shell with `exec zsh`.

## Architecture

### Two-file structure
- `zsh/.zshrc` - Shell configuration with vi-mode editing
- `nvim/init.lua` - Neovim configuration with relative line numbers

### Local overrides
Machine-specific configurations should go in `~/.zshrc.local` (gitignored). The `.zshrc` sources this file if it exists, allowing per-machine customization without modifying tracked files.

### Optional tools
The `.zshrc` includes commented-out integration for optional tools like `fzf`. Current active tools:
- **zoxide** - Directory jumping (enabled by default in .zshrc)
- **fzf** - Fuzzy finding (commented out, can be enabled)

When adding optional tools, add them one at a time and verify they're actually used before committing.

## Key Configuration Details

### Zsh
- Vi-mode editing enabled via `bindkey -v`
- Cursor shape changes based on mode (block for command, beam for insert)
- `KEYTIMEOUT=1` for fast mode switching
- History shared across sessions with 10,000 line limit
- Editor priority: nvim → vim → vi (automatically detected)

### Neovim
- 2-space indentation (tabs expanded to spaces)
- Relative line numbers with absolute current line
- Leader key: `<Space>`
- System clipboard integration enabled
- No plugins or plugin manager (intentional)

## Testing Changes

After modifying dotfiles:

1. **Test zsh changes**: `exec zsh` or open new terminal
2. **Test nvim changes**: Open nvim and verify settings with `:set <option>?`
3. **Test installation**: Run `./install.sh` in clean environment to verify symlinks

## Common Modifications

When editing configurations:
- Keep `.zshrc` sections clearly labeled with comment headers
- Maintain minimalism - remove features that aren't used weekly
- Test that optional tool integrations gracefully handle missing binaries
- Use `command -v` checks before enabling optional tools
