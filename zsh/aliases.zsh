# Best parts of:
# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/directories.zsh
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'
alias d='dirs -v | head -10'
alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# Claude Code
alias aiexpensive='claude --model fable'
alias ai='claude --model opus'
alias aicheap='claude --model sonnet'
alias aicheapest='claude --model haiku'

# Relative path is intentional: per-project shada (history, registers, marks).
# Ignored globally via *.shada.
alias e='nvim -i custom.shada'

alias f='yazi'
alias g='git'
alias k='kubectl'
# Replacement for 'ls -lAhF --group-directories-first'
alias l='eza -agl --group-directories-first --time-style=long-iso'
alias s="rg --follow --hidden --smart-case --no-ignore --glob '!{.git,dist,node_modules,tags}'"
alias t='task'
alias v='lazygit'

# Docker {{{
alias dk='docker'
alias dkc='docker container'
alias dkce='docker container exec'
alias dkcl='docker container ls'
alias dkcla='docker container ls -a'
alias dkcr='docker container run'
alias dkcsa='docker container stop $(docker container list -aq)'
alias dki='docker image'
alias dkib='docker image build'
alias dkil='docker image ls'
alias dkila='docker image ls -a'
alias dkv='docker volume'
alias dkvl='docker volume ls'
# }}}

# Docker Compose {{{
alias dkm='docker compose'
alias dkmb='docker compose build'
alias dkmd='docker compose down'
alias dkme='docker compose exec'
alias dkmu='docker compose up'
alias dkmub='docker compose up --build'
# }}}

# Jobs {{{
alias j='jobs'
alias k1='kill %1'
alias k2='kill %2'
alias k3='kill %3'
# }}}
