# Tip:
# Rembember to check from time to time if the
# way to load the utilities has changed.

# fzf
# See: https://github.com/junegunn/fzf#setting-up-shell-integration
source <(fzf --zsh)

# https://direnv.net/docs/hook.html#zsh
eval "$(direnv hook zsh)"

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
eval "$(zoxide init zsh)"

# https://starship.rs/guide/#step-2-set-up-your-shell-to-use-starship
eval "$(starship init zsh)"

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

# Custom bindings
bindkey "^p" up-line-or-search
bindkey "^n" down-line-or-search

# Custom functions
take() {
  mkdir -p "$1" && cd "$1"
}

# Misc.
# plugins=(colored-man-pages colorize docker httpie zsh-completions)
