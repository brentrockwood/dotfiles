#!/bin/zsh

# Abort on error
set -e

# Determine the script's directory
root=$( cd "$(dirname "${(%):-%x}")" ; pwd -P )

# Initialize and update git submodules
git submodule init
git submodule update

# Source iTerm2 shell integration if available
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

alias get_idf='. ~/esp/esp-idf/export.sh'

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Flags for user choices
overwrite_all=false
backup_all=false
skip_all=false

# Function to create a symbolic link
symlink_item () {
  ln -s "$1" "$2"
  echo "Linked $1 to $2"
}

# Iterate over all .symlink files in the repository
for src in $(find "$root" -maxdepth 2 -name '*.symlink'); do
  dest="$HOME/.$(basename "${src%.*}")"
  
  if [ ! -e "$dest" ]; then
    symlink_item "$src" "$dest"
  else
    overwrite=false
    backup=false
    skip=false

    if [ "$overwrite_all" = "false" ] && [ "$backup_all" = "false" ] && [ "$skip_all" = "false" ]; then
      echo "\"$(basename "$dest")\" already exists: [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
      read -s -n 1 action
      echo  # Move to the next line after reading the input
      case "$action" in
        o )
          overwrite=true;;
        O )
          overwrite_all=true;;
        b )
          backup=true;;
        B )
          backup_all=true;;
        s )
          skip=true;;
        S )
          skip_all=true;;
        * )
          ;;
      esac
    fi

    if [ "$overwrite" = "true" ] || [ "$overwrite_all" = "true" ]; then
      rm -rf "$dest"
      echo "Removed $dest"
    fi

    if [ "$backup" = "true" ] || [ "$backup_all" = "true" ]; then
      mv "$dest" "${dest}.backup"
      echo "Moved $dest to ${dest}.backup"
    fi

    if [ "$skip" = "false" ] && [ "$skip_all" = "false" ]; then
      symlink_item "$src" "$dest"
    else
      echo "Skipped $dest"
    fi
  fi
done

