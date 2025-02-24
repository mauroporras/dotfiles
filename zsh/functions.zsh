# Tip:
# Rembember to check from time to time if the
# way to load the utilities has changed.

# https://github.com/junegunn/fzf#setting-up-shell-integration
source <(fzf --zsh)

# https://direnv.net/docs/hook.html#zsh
eval "$(direnv hook zsh)"

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
eval "$(zoxide init zsh)"

# https://starship.rs/guide/#step-2-set-up-your-shell-to-use-starship
eval "$(starship init zsh)"

# Custom bindings
bindkey "^p" up-line-or-search
bindkey "^n" down-line-or-search

# Misc.
# plugins=(colored-man-pages colorize docker httpie zsh-completions)
