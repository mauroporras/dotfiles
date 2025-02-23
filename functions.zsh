eval "$(direnv hook zsh)"

# Misc.
plugins=(colored-man-pages colorize docker httpie zsh-completions)
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

# https://starship.rs/guide/#step-2-set-up-your-shell-to-use-starship
eval "$(starship init zsh)"
