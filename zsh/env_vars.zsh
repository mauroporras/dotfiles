export EDITOR='nvim'
export LC_COLLATE=C
export LESS='-R -i'

# fzf
export FZF_DEFAULT_COMMAND="rg --files --follow --hidden --smart-case --no-ignore-vcs --glob '!{.git,dist,node_modules,tags}'"
# --history=HISTORY_FILE
#   When enabled, CTRL-N and CTRL-P are automati-cally
#   remapped to next-history and previous-history
export FZF_DEFAULT_OPTS="--cycle --history='$HOME/.fzf_history'"

# lazygit
export CONFIG_DIR=~/.config/lazygit

# zsh
# Characters considered part of a word
export WORDCHARS='$'
# Number of commands to keep in memory
export HISTSIZE=1000000
# Number of commands to save in the history file
export SAVEHIST=1000000

# Write the history file in the ":start:elapsed;command" format
setopt EXTENDED_HISTORY
# Write to the history file immediately, not when the shell exits
setopt INC_APPEND_HISTORY
# Share history between all sessions
#   I don't like it because I want to keep context in each terminal
# setopt SHARE_HISTORY
# Expire duplicate entries first when trimming history
setopt HIST_EXPIRE_DUPS_FIRST
# Don\'t record an entry that was just recorded again
setopt HIST_IGNORE_DUPS
# Delete old recorded entry if new entry is a duplicate
setopt HIST_IGNORE_ALL_DUPS
# Do not display a line previously found
setopt HIST_FIND_NO_DUPS
# Don\'t record an entry starting with a space
setopt HIST_IGNORE_SPACE
# Don\'t write duplicate entries in the history file
setopt HIST_SAVE_NO_DUPS
# Remove superfluous blanks before recording entry
setopt HIST_REDUCE_BLANKS
# Change directory by typing directory name without cd
setopt AUTO_CD
# Complete from both ends of a word
setopt COMPLETE_IN_WORD
# Allow comments in interactive shell commands
setopt INTERACTIVE_COMMENTS
# Prevent overwriting existing files with > redirection (use >| to force)
setopt NO_CLOBBER
# Case-insensitive globbing
setopt NO_CASE_GLOB
