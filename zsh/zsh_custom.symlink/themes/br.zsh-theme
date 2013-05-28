autoload -U colors && colors

function git_prompt_status() {
  gitstatus="$(git status -zb 2>/dev/null)"

  if [ -n $gitstatus ] ; then
    lines=("${(0)gitstatus}")

    for line in $lines; do
      fields=("${(z)line}")

      case $fields[1] in
        '##')
          name=$fields[2]
          ;;
        'M')
          ;&
        'A')
          dirty="*"
          ;;
        '??')
          untracked=?
          ;;
      esac
    done

    echo on $name %{$fg[red]%}$dirty $untracked $(git_repo_delta) $(git_merge_status) $(git_stash_count)%{$reset_color%}
  fi
}

git_repo_delta() {
  remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

  if [[ -n ${remote} ]] ; then
    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

    if [ $ahead -eq 0 ] && [ $behind -gt 0 ]; then
      echo '-'
    elif [ $ahead -gt 0 ] && [ $behind -eq 0 ]; then
      echo '+'
    elif [ $ahead -gt 0 ] && [ $behind -gt 0 ]; then
      echo 'x'
    fi
  fi
}

git_merge_status() {
  INDEX=${$(git status --porcelain -b 2> /dev/null)}

  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    echo -n "%{$fg[red]%}!%{$reset_color%}"
  fi
}

git_stash_count() {
  if $(git rev-parse --verify refs/stash >/dev/null 2>&1); then
    echo -n " stash"
  fi
}

prompt='%F{white}%~ $(git_prompt_status)
%F{white}%n@%m %f'

local return_status="%{$fg[red]%}%(?..✘)%{$reset_color%}"
RPROMPT='${return_status}%{$reset_color%}'
