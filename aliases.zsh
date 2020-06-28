alias ag='ag --hidden'

# {{{ Docker.
alias dk='docker'
alias dkce='docker container exec'
alias dkc='docker container'
alias dkcl='docker container ls'
alias dkcla='docker container ls -a'
alias dkcr='docker container run'
alias dkcsa='docker container stop $(docker container list -aq)'
alias dki='docker image'
alias dkil='docker image ls'
alias dkila='docker image ls -a'
alias dkv='docker volume'
alias dkvl='docker volume ls'
# }}}

# {{{ Docker Compose.
alias dkm='docker-compose'
alias dkmb='docker-compose build'
alias dkmd='docker-compose down'
alias dkmu='docker-compose up'
alias dkmub='docker-compose up --build'
# }}}

alias kb='kubectl'

alias mkb='minikube'

alias ev='v ~/dotfiles/init.vim'
alias ez='v ~/.zshrc'

alias g='git'

# {{{ Jobs.
alias j='jobs'
alias k1='kill %1'
alias k2='kill %2'
alias k3='kill %3'
# }}}

# alias l='ls -lAhFX'
alias l='ls -lAhF'
alias r='ranger'
alias sz='source ~/.zshrc'
alias t='tmux'
alias tpl='tmuxp load .'

# {{{ Neovim.
alias v='nvim'
alias vd='nvim -d'
alias vs='nvim -S'
alias vv='nvim --noplugin'
# }}}

alias wa='which -a'

# {{{ Yarn.
alias y='yarn'
alias yis='yarn --ignore-scripts'

alias ya='yarn add'
alias yais='yarn add --ignore-scripts'
alias yad='yarn add --dev'
alias yadis='yarn add --dev --ignore-scripts'

alias yrm='yarn remove'
alias yrmis='yarn remove --ignore-scripts'

alias yl='yarn link'
alias yul='yarn unlink'

alias yp='yarn publish'
alias ypp='yarn publish --access=public'

alias yr='yarn run'
alias yrb='yarn run build'
alias yrs='yarn run start'

alias yt='yarn test'

alias yui='yarn upgrade-interactive'
alias yuil='yarn upgrade-interactive --latest'
# }}}
