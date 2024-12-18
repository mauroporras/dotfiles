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

# {{{ Neovim.
alias v='nvim'
alias vd='nvim -d'
alias vs='nvim -S'
alias vv='nvim --noplugin'
# }}}

alias wa='which -a'
# }}}
