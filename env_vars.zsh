export EDITOR='nvim'
export LC_COLLATE=C
export LESS='-R -i'

# fzf.
export FZF_DEFAULT_COMMAND="rg --files --hidden --smart-case --no-ignore --glob '!{.git,dist,node_modules,tags}'"
# --history=HISTORY_FILE
#   When enabled, CTRL-N and CTRL-P are automati-cally
#   remapped to next-history and previous-history.
export FZF_DEFAULT_OPTS="--cycle --history='$HOME/.fzf_history'"

# Spaceship prompt.
export SPACESHIP_BATTERY_SHOW=false
export SPACESHIP_BATTERY_THRESHOLD=45
export SPACESHIP_EXEC_TIME_SHOW=false
export SPACESHIP_NODE_SHOW=false
export SPACESHIP_PACKAGE_SHOW=false
export SPACESHIP_KUBECONTEXT_SHOW=false
export SPACESHIP_KUBECONTEXT_SYMBOL='☸️  '
