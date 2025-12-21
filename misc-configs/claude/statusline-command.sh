#!/bin/bash

input=$(cat)

current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
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
session_id=$(echo "$input" | jq -r '.session.id // .session_id // "unknown"')

# Colors
bold='\033[1m'
blue='\033[34m'
green='\033[32m'
yellow='\033[33m'
cyan='\033[36m'
magenta='\033[35m'
reset='\033[0m'

echo -e "${bold}${blue}${current_dir}${reset} (${bold}${green}${git_branch}${reset}) • ${bold}${magenta}${model}${reset} • ${bold}${yellow}${tokens_k}k/${context_k}k${reset} (${bold}${cyan}${context_pct}%${reset}) • ${bold}${session_id}${reset}"
