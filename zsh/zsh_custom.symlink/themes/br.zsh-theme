autoload -U colors && colors

git_branch_name() {
  gitstat=$(git status 2>/dev/null | grep '\(# Untracked\|# Changes\|# Changed but not updated:\)')

  if [[ $(echo ${gitstat} | grep -c "^# Changes to be committed:$") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
  fi

  if [[ $(echo ${gitstat} | grep -c "^\(# Untracked files:\|# Changed but not updated:\)$") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi 

  if [[ $(echo ${gitstat} | wc -l | tr -d ' ') == 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

git_dirty_status() {
  gitstat=$(git status 2>/dev/null | grep '\(# Untracked\|# Changes\|# Changed but not updated:\)')

  if [[ $(echo ${gitstat} | grep -c "^# Changes to be committed:$") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
  fi

  if [[ $(echo ${gitstat} | grep -c "^\(# Untracked files:\|# Changed but not updated:\|# Changes not staged for commit:\)$") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi 

  if [[ $(echo ${gitstat} | grep -v '^$' | wc -l | tr -d ' ') == 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

git_remote_status() {
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
    if [[ -n ${remote} ]] ; then
        echo -n "%F{red}"
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

        if [ $ahead -eq 0 ] && [ $behind -gt 0 ]
        then
            echo -n " -";
        elif [ $ahead -gt 0 ] && [ $behind -eq 0 ]
        then
            echo -n " +";
        elif [ $ahead -gt 0 ] && [ $behind -gt 0 ]
        then
            echo -n " x";
        fi
        echo -n "%f"
    fi
}

git_merge_status() {
  INDEX=$(git status --porcelain -b 2> /dev/null)

  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    echo -n " unmerged"
  fi
}

git_stash_status() {
  if $(git rev-parse --verify refs/stash >/dev/null 2>&1); then
    echo -n " stash"
  fi
}

precmd() { print -rlP '' '%F{white}%~$(git_prompt_info)$(git_remote_status)%f' }
prompt='%F{white}%n@%m %f'

ZSH_THEME_GIT_PROMPT_PREFIX=" on "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" %{$fg[red]%}-"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" %{$fg[red]%}+"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE=" %{$fg[red]%}x"

local return_status="%{$fg[red]%}%(?..✘)%{$reset_color%}"
RPROMPT='${return_status}%{$reset_color%}'
