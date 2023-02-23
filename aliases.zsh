alias rg="rg --follow --hidden --smart-case --no-ignore --glob '!{.git,dist,node_modules,tags}'"

# {{{ direnv.
alias dea='direnv allow'
alias deae='cp .envrc{.example,} && direnv allow'
alias dead='cp .envrc{.development,} && direnv allow'
alias deas='cp .envrc{.staging,} && direnv allow'
alias deap='cp .envrc{.production,} && direnv allow'
# }}} direnv.

# {{{ Docker.
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

# {{{ Docker Compose.
alias dkm='docker compose'
alias dkmb='docker compose build'
alias dkmd='docker compose down'
alias dkme='docker compose exec'
alias dkmu='docker compose up'
alias dkmub='docker compose up --build'
# }}}

alias kb='kubectl'

alias mkb='minikube'

alias ev='v ~/dotfiles/init.lua'
alias ez='v ~/.zshrc'

alias g='git'
alias gt='github' # GitHub CLI.
alias lg='lazygit'

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
alias yif='yarn install --force'
alias yis='yarn --ignore-scripts'

alias ya='yarn add'
alias yais='yarn add --ignore-scripts'
alias yad='yarn add --dev'
alias yadis='yarn add --dev --ignore-scripts'

alias yga='yarn global add'
alias ygl='yarn global list'

alias yrm='yarn remove'
alias yrmis='yarn remove --ignore-scripts'

alias yl='yarn link'
alias yul='yarn unlink'

alias yp='yarn publish'
alias ypp='yarn publish --access=public'

alias yr='yarn run'
alias yrb='yarn run build'
alias yrd='yarn run dev'
alias yrs='yarn run start'

alias yt='yarn test'

alias yui='yarn upgrade-interactive'
alias yuil='yarn upgrade-interactive --latest'
# }}}

# {{{ pnpm.
alias pn='pnpm'
alias pni='pnpm install'

alias pna='pnpm add'
alias pnad='pnpm add -D'

alias pnrm='pnpm remove'

alias pnl='pnpm link'
alias pnul='pnpm unlink'

alias pnp='pnpm publish'

alias pne='pnpm exec'

alias pnr='pnpm run'
alias pnrb='pnpm run build'
alias pnrd='pnpm run dev'
alias pnrs='pnpm run start'

alias pnrw='pnpm run -w'

alias pnt='pnpm test'
# }}}
