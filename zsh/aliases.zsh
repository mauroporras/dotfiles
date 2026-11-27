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
# Advisor is the next model up; Fable is the top tier, so it runs without one.
alias aifable='claude --model fable'
alias ai='claude --model opus --advisor fable'
alias aiopusplan='claude --model opusplan --advisor fable'
alias aisonnet='claude --model sonnet --advisor opus'
alias aihaiku='claude --model haiku --advisor sonnet'
alias aiupgrade='brew upgrade --cask claude-code@latest'

# Relative path is intentional: per-project shada (history, registers, marks).
# Ignored globally via *.shada.
alias e='nvim -i custom.shada'

alias f='yazi'
alias g='git'
# Replacement for 'ls -lAhF --group-directories-first'
alias l='eza -agl --group-directories-first --time-style=long-iso'
alias s="rg --follow --hidden --smart-case --no-ignore --glob '!{.git,dist,node_modules,tags}'"
alias t='task'
alias v='lazygit'

# AWS {{{
# Named so `awsl<TAB>` completes it in one keystroke: no other command starts with "awsl".
alias awslogin='aws login'
alias awswhoami='aws sts get-caller-identity'
alias awsec2ls='aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId,State.Name,Tags[?Key==\`Name\`].Value|[0],PrivateIpAddress]" --output table'
alias awss3ls='aws s3 ls'
# }}}

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
alias dlogs='docker logs -f --tail=100'
# -a removes every image no container uses (not just dangling ones).
# Volumes are left alone, which is why dvolprune exists.
alias dprune='docker system prune -af'
# Cleaner ps output
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"'
alias drm='docker rm'
alias drmi='docker rmi'
alias dstop='docker stop'
alias dvolprune='docker volume prune -f'
# }}}

# Docker Compose {{{
alias dkm='docker compose'
alias dkmb='docker compose build'
alias dkmd='docker compose down'
alias dkme='docker compose exec'
alias dkmu='docker compose up'
alias dkmub='docker compose up --build'
# }}}

# Kubernetes {{{
alias k='kubectl'
alias kctx='kubectx'
alias kdn='kubectl describe node'
alias kdp='kubectl describe pod'
alias kgd='kubectl get deployments'
alias kge='kubectl get events --sort-by=.lastTimestamp'
alias kgn='kubectl get nodes'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgs='kubectl get svc'
alias kns='kubens'
alias kwhere='kubectl config current-context'
# }}}

# Terraform {{{
alias tf='terraform'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
# Disabled on purpose: destroy wipes every resource in the current workspace,
# and a three-letter alias next to tfa/tfp is one typo away from running it
# (tfda wouldn't even ask for "yes"). Type `terraform destroy` out in full.
# alias tfd='terraform destroy'
# alias tfda='terraform destroy -auto-approve'
alias tffmt='terraform fmt -recursive'
alias tfi='terraform init'
alias tfo='terraform output'
alias tfp='terraform plan'
alias tfs='terraform show'
alias tfv='terraform validate'
alias tfwl='terraform workspace list'
alias tfws='terraform workspace show'
# }}}

# Jobs {{{
alias j='jobs'
alias k1='kill %1'
alias k2='kill %2'
alias k3='kill %3'
# }}}
