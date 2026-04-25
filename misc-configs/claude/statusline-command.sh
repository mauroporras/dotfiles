#!/bin/bash

input=$(cat)

current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
effort_level=$(echo "$input" | jq -r '.effort.level // "?"')
thinking_enabled=$(echo "$input" | jq -r '.thinking.enabled // false')

if [[ "$thinking_enabled" == "true" ]]; then
  thinking_display="on"
else
  thinking_display="off"
fi

# Debug: uncomment to see raw input
# echo "$input" > /tmp/statusline-debug.json

# current_usage is an object
current_usage=$(echo "$input" | jq -r '[.context_window.current_usage | .input_tokens, .output_tokens, .cache_creation_input_tokens, .cache_read_input_tokens] | add')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size')
tokens_k=$((current_usage / 1000))
context_k=$((context_size / 1000))
context_pct=$((current_usage * 100 / context_size))

cd "$current_dir" 2>/dev/null || cd /
git_branch=$(git branch --show-current 2>/dev/null)
if [[ -z "$git_branch" ]]; then
  git_branch="Not a Git repo"
fi
session_id=$(echo "$input" | jq -r '.session.id // .session_id // "unknown"')

five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

format_reset_short() {
  local target=$1
  local now=$2

  if [[ -z "$target" ]]; then
    echo "-"
    return
  fi

  local secs=$((target - now))
  if [[ $secs -le 0 ]]; then
    echo "now"
    return
  fi

  local days=$((secs / 86400))
  local hours=$(( (secs % 86400) / 3600 ))
  local mins=$(( (secs % 3600) / 60 ))

  if [[ $days -gt 0 ]]; then
    echo "${days}d${hours}h"
  elif [[ $hours -gt 0 ]]; then
    echo "${hours}h${mins}m"
  else
    echo "${mins}m"
  fi
}

rate_limits_display=""
if [[ -n "$five_hour_pct" || -n "$seven_day_pct" ]]; then
  now_epoch=$(date +%s)
  five_hour_pct_display="${five_hour_pct:--}"
  seven_day_pct_display="${seven_day_pct:--}"
  five_hour_reset_display=$(format_reset_short "$five_hour_resets" "$now_epoch")
  seven_day_reset_display=$(format_reset_short "$seven_day_resets" "$now_epoch")
  rate_limits_display="5h:${five_hour_pct_display%.*}% (${five_hour_reset_display}) 7d:${seven_day_pct_display%.*}% (${seven_day_reset_display})"
fi

# Colors
bold='\033[1m'
blue='\033[34m'
green='\033[32m'
yellow='\033[33m'
cyan='\033[36m'
magenta='\033[35m'
reset='\033[0m'

line="${bold}${blue}${current_dir}${reset} (${bold}${green}${git_branch}${reset}) • ${bold}${magenta}${model}${reset} • ${bold}${cyan}effort:${effort_level} thinking:${thinking_display}${reset} • ${bold}${yellow}${tokens_k}k/${context_k}k${reset} (${bold}${cyan}${context_pct}%${reset})"

if [[ -n "$rate_limits_display" ]]; then
  line="${line} • ${bold}${green}${rate_limits_display}${reset}"
fi

line="${line} • ${bold}${session_id}${reset}"

echo -e "$line"
