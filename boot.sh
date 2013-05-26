#!/bin/bash

# abort on error
set -e

root=$( cd $(dirname $0) ; pwd -P )

git submodule init
git submodule update

link () {
  ln -s $1 $2
  echo "Linked $1 to $2"
}

overwrite_all=false
backup_all=false
skip_all=false

for src in `find $root -maxdepth 2 -name \*.symlink`; do
  dest="$HOME/.`basename \"${src%.*}\"`"

  if [ ! -f $dest ] && [ ! -d $dest ]; then
    link $src $dest
  else
    overwrite=false
    backup=false
    skip=false

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then
      echo "\"`basename $dest`\" already exists: [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
      read -s -n 1 action

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

    if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]; then
      rm -rf $dest
      echo "Removed $dest"
    fi

    if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]; then
      mv $dest $dest\.backup
      echo "Moved $dest to $dest.backup"
    fi

    if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]; then
      link $src $dest
    else
      echo "Skipped $dest"
    fi
  fi
done

