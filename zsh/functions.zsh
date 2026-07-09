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

setopt auto_menu        # a second Tab cycles through the completion menu
setopt always_to_end    # move cursor to end of the word after completing
unsetopt menu_complete  # show the menu instead of inserting the first match
unsetopt flowcontrol    # free up ^s / ^q

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
bindkey -M viins "^[[A" up-line-or-beginning-search    # Up arrow
bindkey -M viins "^[[B" down-line-or-beginning-search  # Down arrow
# }}}

# Custom functions
take() {
  mkdir -p "$1" && cd "$1"
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

# Misc.
# plugins=(colored-man-pages colorize docker httpie zsh-completions)

# vim:foldmethod=marker
