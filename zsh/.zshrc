# --- Shell basics -------------------------------------------------

# --- Editor -------------------------------------------------------

if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
  export VISUAL=nvim
elif command -v vim >/dev/null 2>&1; then
  export EDITOR=vim
  export VISUAL=vim
else
  export EDITOR=vi
  export VISUAL=vi
fi

# --- History ------------------------------------------------------
setopt autocd
setopt extendedglob
setopt SHARE_HISTORY        # Share history between all sessions
setopt EXTENDED_HISTORY     # Timestamps
setopt HIST_IGNORE_DUPS     # Ignore duplicates and space-prefixed commands
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"

# --- Vi-style command line editing --------------------------------

bindkey -v
export KEYTIMEOUT=1

# Cursor shape indicates mode (works in most modern terminals)
function zle-keymap-select {
  case $KEYMAP in
    vicmd) echo -ne '\e[1 q';;      # block cursor
    viins|main) echo -ne '\e[5 q';; # beam cursor
  esac
}

zle -N zle-keymap-select
echo -ne '\e[5 q'  # ensure insert mode cursor on startup

# --- Completion ---------------------------------------------------

autoload -Uz compinit
compinit

# --- Aliases (keep minimal) ---------------------------------------

alias ls='ls --color=auto'
alias ll='ls -halt --color=auto'
alias vi='nvim'
alias cd='z'
alias j='z'
alias f='fuck'
alias cls='clear'
alias gss='git status'
alias gco='git checkout'
alias clc='claude --dangerously-skip-permissions --chrome'

# --- Local, machine-specific overrides ----------------------------

if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# --- Make directory and immediately move to it -------------------- 

mmdir() {
  mkdir -p "$1"
  cd "$1"
}

# --- Prompt (Starship) --------------------------------------------

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# opencode

export PATH=$HOME/.opencode/bin:$HOME/bin:$PATH
#
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)

# Ruby

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

# --- Optional tools (add one at a time) ----------------------------

# zoxide (directory jumping)
eval "$(zoxide init zsh)"

# fzf (history, completion)
source <(fzf --zsh)

