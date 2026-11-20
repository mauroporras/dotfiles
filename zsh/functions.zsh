# Tip:
# Rembember to check from time to time if the
# way to load the utilities has changed.

# zsh-completions
# See: https://github.com/zsh-users/zsh-completions
#
# If you're getting security warnings, run:
#   brew info zsh-completions
# and follow the instructions.
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

  autoload -Uz compinit
  compinit
fi

# Completion {{{
zmodload -i zsh/complist

setopt auto_menu       # a second Tab cycles through the completion menu
setopt always_to_end   # move cursor to end of the word after completing
unsetopt menu_complete # show the menu instead of inserting the first match
unsetopt flowcontrol   # free up ^s / ^q

# Colored completion picker; Tab cycles forward, Shift-Tab steps backward.
# Arrow keys also work but aren't required.
zstyle ':completion:*:*:*:*:*' menu select
bindkey -M menuselect '^[[Z' reverse-menu-complete

# Populate LS_COLORS (empty by default on macOS) so completion menus are
# colored by file type. Also affects `ls`; `eza` uses its own colors.
eval "$(dircolors -b)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# cd: prefer local dirs, then the pushd stack, then $cdpath
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
# }}}

# fzf
# See: https://github.com/junegunn/fzf#setting-up-shell-integration
source <(fzf --zsh)

# k3d
# See: https://k3d.io/stable/usage/commands/k3d_completion_zsh
source <(k3d completion zsh)

# https://direnv.net/docs/hook.html#zsh
eval "$(direnv hook zsh)"

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
eval "$(zoxide init zsh)"

# https://starship.rs/guide/#step-2-set-up-your-shell-to-use-starship
eval "$(starship init zsh)"

# Vi mode
bindkey -v
export KEYTIMEOUT=1 # Reduce escape delay

# Change cursor shape for different vi modes
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q' # Block cursor
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q' # Beam cursor
  fi
}
zle -N zle-keymap-select

# Start with beam cursor
function zle-line-init {
  echo -ne '\e[6 q'
}
zle -N zle-line-init

# Restore useful readline bindings in vi insert mode
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^k" kill-line
bindkey "^u" backward-kill-line
bindkey "^w" backward-kill-word
bindkey "^y" yank
bindkey "^d" delete-char
bindkey "^?" backward-delete-char
bindkey "^h" backward-delete-char
bindkey "^f" forward-char
bindkey "^b" backward-char

# Edit the current command line in $EDITOR (nvim); save-quit reloads it onto the
# prompt (press Enter to run). Handy for multi-line edits awkward at the prompt.
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M viins "^x^e" edit-command-line
bindkey -M vicmd "^x^e" edit-command-line

# Fuzzy history {{{
# Search on the text before the cursor, preserving cursor position
# (better than up-line-or-search, which jumps to end of line)
#bindkey "^p" up-line-or-search
#bindkey "^n" down-line-or-search
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# Keep the cursor where it is instead of jumping to end after each recall
# (the widgets run .end-of-line by default; leave-cursor=no opts out)
zstyle ':zle:up-line-or-beginning-search' leave-cursor no
zstyle ':zle:down-line-or-beginning-search' leave-cursor no
bindkey -M viins "^p" up-line-or-beginning-search
bindkey -M viins "^n" down-line-or-beginning-search
bindkey -M viins "^[[A" up-line-or-beginning-search   # Up arrow
bindkey -M viins "^[[B" down-line-or-beginning-search # Down arrow
# }}}

# Custom functions
take() {
  mkdir -p "$1" && cd "$1"
}

# `take` for throwaway work: make a temp dir and cd into it.
# The optional argument labels the directory so several somedir dirs stay
# distinguishable; %/ strips the trailing slash macOS puts on $TMPDIR.
taketemp() {
  local label="${1:-somedir}"
  local dir

  dir="$(mktemp -d "${${TMPDIR:-/tmp}%/}/${label}.XXXXXX")" || return

  cd "$dir"
}

# Avoid "unknown terminal type" errors on remote hosts.
# A function, not an alias: zsh completes an alias as the command it expands
# to (`ghostty`), which drops ssh's hostname completion.
ssh() {
  ghostty +ssh -- "$@"
}

# Copy the full working directory path to the clipboard.
# printf %s avoids the trailing newline that `pwd | pbcopy` would leave.
cpcwd() {
  printf %s "$PWD" | pbcopy
}

# Copy just the current folder name (basename of $PWD) to the clipboard.
# ${PWD:t} is the zsh "tail" modifier; printf %s avoids a trailing newline.
cpdirname() {
  printf %s "${PWD:t}" | pbcopy
}

# Copy current date
cpdate() {
  printf %s "$(date +'%Y-%m-%d')" | pbcopy
}

# Copy current date and time, no seconds
cpdatetime() {
  printf %s "$(date +'%Y-%m-%d %H:%M')" | pbcopy
}

# Copy current date and time, with seconds
cpdatetimews() {
  printf %s "$(date +'%Y-%m-%d %H:%M:%S')" | pbcopy
}

# AWS {{{
# A function, not an alias: it has to export into the current shell.
awsp() {
  export AWS_PROFILE="$1"
  echo "Switched to profile: $1"
}

# Usage: s3cat <bucket/key>  (streams the object to stdout)
s3cat() {
  aws s3 cp "s3://$1" -
}

# Usage: cwlogs <log-group>
cwlogs() {
  aws logs tail "$1" --follow
}

# Shell into an instance without SSH keys or open ports.
# Needs the session-manager-plugin.
# Usage: ssm <instance-id>
ssm() {
  aws ssm start-session --target "$1"
}

# Looks up the account first so expired credentials fail here instead of
# handing docker login a malformed registry host.
# Usage: ecr-login <region>
ecr-login() {
  local region="$1"
  local account_id

  account_id="$(aws sts get-caller-identity --query Account --output text)" || return

  aws ecr get-login-password --region "$region" |
    docker login --username AWS --password-stdin "${account_id}.dkr.ecr.${region}.amazonaws.com"
}
# }}}

# Docker {{{
# Minimal images often ship without bash, so sh is the default.
dsh() {
  docker exec -it "$1" /bin/sh
}

dbash() {
  docker exec -it "$1" /bin/bash
}

# Usage: dbuild <tag>  (builds the current directory)
dbuild() {
  docker build -t "$1" .
}
# }}}

# Kubernetes {{{
# Functions rather than aliases because the arguments must land before the
# trailing flags or `--`.
kl() {
  kubectl logs "$@" --tail=100 -f
}

# Logs from the previous container instance: what it printed before crashing.
klp() {
  kubectl logs "$@" --previous --tail=100
}

# Minimal images often ship without bash, so sh is the default.
kex() {
  kubectl exec -it "$1" -- /bin/sh
}

kexb() {
  kubectl exec -it "$1" -- /bin/bash
}

# Skips graceful shutdown: for pods stuck in Terminating.
kdelf() {
  kubectl delete pod "$1" --grace-period=0 --force
}

# Usage: kapply <manifest> <deployment>
kapply() {
  kubectl apply -f "$1" && kubectl rollout status deployment/"$2"
}

# Usage: kpf <pod|svc/name> <local:remote>
kpf() {
  kubectl port-forward "$1" "$2"
}
# }}}

# Terraform {{{
# Plan to a file, then apply exactly that file: what gets applied is what was
# reviewed, even if the code or remote state changed in between.
tfplan() {
  terraform plan -out=tfplan.out "$@"
}

tfapply() {
  terraform apply tfplan.out
}

# Releases a stuck *state* lock. .terraform.lock.hcl is the provider dependency
# lock (version pins + checksums); deleting it does not free a state lock.
# Usage: tfunlock <LOCK_ID>
tfunlock() {
  terraform force-unlock "$@"
}
# }}}

# Misc.
# plugins=(colored-man-pages colorize docker httpie zsh-completions)

# vim:foldmethod=marker
