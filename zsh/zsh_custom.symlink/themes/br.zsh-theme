autoload -U colors && colors
precmd() { print -rlP '' '%F{white}%~$(git_prompt_info)$(git_remote_status)%f' }
prompt='%F{white}%n@%m %f'

ZSH_THEME_GIT_PROMPT_PREFIX=" on "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" %{$fg[red]%}-"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" %{$fg[red]%}+"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" %{$fg[red]%}x"

local return_status="%{$fg[red]%}%(?..✘)%{$reset_color%}"
RPROMPT='${return_status}%{$reset_color%}'
