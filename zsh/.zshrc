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

# Fix bracketed paste in vi mode: without this, the trailing ~ of the
# \e[201~ end-sequence is interpreted as vi's toggle-case command,
# capitalizing the last pasted character.
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

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
alias ji='zi'
alias cls='clear'
alias rst='reset'
alias gss='git status'
alias gco='git checkout'
alias sp='nvim +$ ~/tmp/scratch.md'
alias td='nvim +$ ~/tmp/todo.md'

# --- Local, machine-specific overrides ----------------------------

if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# --- Make directory and immediately move to it -------------------- 

mdm() {
  mkdir -p "$1"
  cd "$1"
}

# --- Prompt (Starship) --------------------------------------------

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

export PATH=$HOME/bin:$HOME/.local/bin:$PATH

# --- Optional tools (add one at a time) ----------------------------
# zsh-autosuggestions + zsh-syntax-highlighting
# Install: brew install zsh-autosuggestions zsh-syntax-highlighting
# zsh-syntax-highlighting must be sourced last
if brew_prefix=$(brew --prefix 2>/dev/null); then
  [[ -f "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
    source "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -f "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# --- Supply-chain wrappers ----------------------------------------
# npm-safe: checks each package's latest-version publish age before installing.
# Blocks anything published less than 5 days ago.
npm-safe() {
  local blocked=0
  for pkg in "$@"; do
    [[ "$pkg" == -* ]] && continue
    local info version published age
    info=$(npm view "$pkg" version time --json 2>/dev/null) || {
      echo "supply-chain: WARNING could not check $pkg, proceeding"
      continue
    }
    version=$(echo "$info" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('version',''))" 2>/dev/null)
    published=$(echo "$info" | python3 -c "
import json, sys
d = json.load(sys.stdin)
v = d.get('version', '')
print(d.get('time', {}).get(v, ''))
" 2>/dev/null)
    if [[ -z "$published" || -z "$version" ]]; then
      echo "supply-chain: WARNING could not check age of $pkg, proceeding"
      continue
    fi
    age=$(python3 -c "
from datetime import datetime, timezone
pub = datetime.fromisoformat('$published'.replace('Z', '+00:00'))
print((datetime.now(timezone.utc) - pub).days)
" 2>/dev/null)
    if (( age < 5 )); then
      echo "supply-chain: BLOCKED $pkg@$version — published ${age}d ago (min 5)"
      blocked=1
    else
      echo "supply-chain: OK $pkg@$version — ${age}d old"
    fi
  done
  (( blocked )) && return 1
  npm install "$@"
}

# pip-safe: checks each package's latest-version publish age on PyPI before installing.
# Blocks anything published less than 5 days ago.
pip-safe() {
  local blocked=0
  for pkg in "$@"; do
    [[ "$pkg" == -* ]] && continue
    local name="${pkg%%[>=<!~^]*}"
    local age
    age=$(python3 - "$name" <<'PYEOF' 2>/dev/null
import urllib.request, json, sys
from datetime import datetime, timezone
name = sys.argv[1]
try:
    data = json.load(urllib.request.urlopen(f'https://pypi.org/pypi/{name}/json'))
    latest = data['info']['version']
    files = data['releases'].get(latest, [])
    if not files:
        print(-1)
    else:
        t = min(f['upload_time_iso_8601'] for f in files)
        pub = datetime.fromisoformat(t.replace('Z', '+00:00'))
        print((datetime.now(timezone.utc) - pub).days)
except Exception:
    print(-1)
PYEOF
)
    if [[ "$age" == "-1" || -z "$age" ]]; then
      echo "supply-chain: WARNING could not check age of $name, proceeding"
      continue
    fi
    if (( age < 5 )); then
      echo "supply-chain: BLOCKED $name — latest version published ${age}d ago (min 5)"
      blocked=1
    else
      echo "supply-chain: OK $name — ${age}d old"
    fi
  done
  (( blocked )) && return 1
  pip install "$@"
}

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/br/.lmstudio/bin"
# End of LM Studio CLI section

# --- Always keep this at the bottom ---

# fzf (history, completion)
source <(fzf --zsh)

# zoxide (directory jumping)
eval "$(zoxide init zsh)"

