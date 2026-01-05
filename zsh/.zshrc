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

setopt autocd
setopt extendedglob
setopt histignorealldups
setopt sharehistory

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

# --- Optional tools (add one at a time) ----------------------------

# zoxide (directory jumping)
eval "$(zoxide init zsh)"

# fzf (history, completion)
# source <(fzf --zsh)

# --- Aliases (keep minimal) ---------------------------------------

alias ls='ls --color=auto'
alias ll='ls -halt --color=auto'
alias vi='nvim'
alias gss='git status'

# --- Local, machine-specific overrides ----------------------------

if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# --- Prompt (Starship) --------------------------------------------

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

