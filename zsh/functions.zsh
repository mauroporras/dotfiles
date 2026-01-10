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

# Vi mode
bindkey -v
export KEYTIMEOUT=1  # Reduce escape delay

# Change cursor shape for different vi modes
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'  # Block cursor
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'  # Beam cursor
  fi
}
zle -N zle-keymap-select

# Start with beam cursor
function zle-line-init {
  echo -ne '\e[6 q'
}
zle -N zle-line-init

# Restore useful emacs bindings in vi insert mode
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^k" kill-line
bindkey "^u" backward-kill-line
bindkey "^w" backward-kill-word
bindkey "^y" yank
bindkey "^d" delete-char
bindkey "^f" forward-char
bindkey "^b" backward-char
bindkey "^p" up-line-or-search
bindkey "^n" down-line-or-search

# Custom functions
take() {
  mkdir -p "$1" && cd "$1"
}

# Misc.
# plugins=(colored-man-pages colorize docker httpie zsh-completions)
