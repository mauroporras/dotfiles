#!/bin/bash

input=$(cat)

current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
current_dir_display=${current_dir/#$HOME/\~}
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // empty')
project_dir_display=${project_dir/#$HOME/\~}

project_divergence_display=""
if [[ -n "$project_dir_display" && "$project_dir_display" != "$current_dir_display" ]]; then
  project_divergence_display="← ${project_dir_display}"
fi
model=$(echo "$input" | jq -r '.model.display_name')
# The "/1000k" context segment already conveys the 1M window, so drop the suffix.
model=${model% (1M context)}
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

git_branch="no-repo"
git_branch_is_repo=false

# Detect repo membership via rev-parse rather than `git branch --show-current`,
# which returns empty during rebase / detached HEAD and would otherwise falsely
# read as "no-repo".
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_branch_is_repo=true
  current_branch=$(git branch --show-current 2>/dev/null)

  if [[ -n "$current_branch" ]]; then
    git_branch="$current_branch"
  else
    git_dir=$(git rev-parse --git-dir 2>/dev/null)
    rebase_merge_head_file="$git_dir/rebase-merge/head-name"
    rebase_apply_head_file="$git_dir/rebase-apply/head-name"

    if [[ -f "$rebase_merge_head_file" ]]; then
      rebase_branch_ref=$(<"$rebase_merge_head_file")
      git_branch="${rebase_branch_ref#refs/heads/} (rebasing)"
    elif [[ -f "$rebase_apply_head_file" ]]; then
      rebase_branch_ref=$(<"$rebase_apply_head_file")
      git_branch="${rebase_branch_ref#refs/heads/} (rebasing)"
    else
      short_sha=$(git rev-parse --short HEAD 2>/dev/null)
      git_branch="(detached @ ${short_sha:-?})"
    fi
  fi
fi
session_id=$(echo "$input" | jq -r '.session.id // .session_id // "unknown"')

# On 1M-context models, crossing 200k input tokens flips the whole request
# to the long-context pricing tier (~2x input, ~1.5x output), so we surface it
# as a tripwire rather than a generic threshold.
exceeds_200k=$(echo "$input" | jq -r '.exceeds_200k_tokens // false')
claude_version=$(echo "$input" | jq -r '.version // empty')
output_style=$(echo "$input" | jq -r '.output_style.name // empty')

# Depth can also be requested in-conversation ("walk me through why ...") rather
# than by switching the global style.
output_style_display="${output_style:-default}"

added_dirs_basenames=$(echo "$input" | jq -r '.workspace.added_dirs // [] | map(. | split("/") | last) | join(",")')
added_dirs_display=""
if [[ -n "$added_dirs_basenames" ]]; then
  added_dirs_display="+${added_dirs_basenames}"
fi

# Cache hit ratio for this turn's input tokens. A sustained drop means the
# prompt prefix changed (TTL lapsed, CLAUDE.md edited, /compact ran, etc.)
# and the next turns will be ~10x slower and pricier until the cache rebuilds.
usage_input=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
usage_cache_creation=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
usage_cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
cache_input_total=$((usage_input + usage_cache_creation + usage_cache_read))

if [[ $cache_input_total -gt 0 ]]; then
  cache_pct=$((usage_cache_read * 100 / cache_input_total))
else
  cache_pct=0
fi

cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
cost_display=""
if [[ -n "$cost_usd" ]]; then
  cost_display=$(printf '$%.2f' "$cost_usd")
fi

github_repo_owner=$(echo "$input" | jq -r '.workspace.repo.owner // empty')
github_repo_name=$(echo "$input" | jq -r '.workspace.repo.name // empty')

pr_number=$(echo "$input" | jq -r '.pr.number // empty')
pr_review_state=$(echo "$input" | jq -r '.pr.review_state // empty')

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

now_epoch=$(date +%s)
five_hour_pct_int="${five_hour_pct%.*}"
seven_day_pct_int="${seven_day_pct%.*}"
five_hour_reset_display=$(format_reset_short "$five_hour_resets" "$now_epoch")
seven_day_reset_display=$(format_reset_short "$seven_day_resets" "$now_epoch")

# Colors
bold='\033[1m'
blue='\033[34m'
green='\033[32m'
yellow='\033[33m'
cyan='\033[36m'
magenta='\033[35m'
red='\033[31m'
gray='\033[90m'
reset='\033[0m'

github_repo_display=""
if [[ -n "$github_repo_owner" && -n "$github_repo_name" ]]; then
  github_repo_display="${github_repo_owner}/${github_repo_name}"
fi

pr_display=""
if [[ -n "$pr_number" ]]; then
  case "$pr_review_state" in
    approved)          pr_color="$green" ;;
    changes_requested) pr_color="$red" ;;
    pending)           pr_color="$yellow" ;;
    draft)             pr_color="$gray" ;;
    *)                 pr_color="$cyan" ;;
  esac

  pr_state_label="${pr_review_state:-open}"
  pr_display="${pr_color}#${pr_number} ${pr_state_label}${reset}"
fi

rate_limit_color() {
  local pct=$1

  if [[ -z "$pct" ]]; then
    echo "$gray"
    return
  fi

  if [[ $pct -ge 80 ]]; then
    echo "$red"
  elif [[ $pct -ge 50 ]]; then
    echo "$yellow"
  else
    echo "$green"
  fi
}

five_hour_color=$(rate_limit_color "$five_hour_pct_int")
seven_day_color=$(rate_limit_color "$seven_day_pct_int")
five_hour_pct_text="${five_hour_pct_int:--}"
seven_day_pct_text="${seven_day_pct_int:--}"
rate_limits_display="${five_hour_color}5h:${bold}${five_hour_pct_text}%${reset} ${gray}${five_hour_reset_display}${reset} ${seven_day_color}7d:${bold}${seven_day_pct_text}%${reset} ${gray}${seven_day_reset_display}${reset}"

if [[ "$git_branch_is_repo" == "true" ]]; then
  git_branch_color="$green"
else
  git_branch_color="$red"
fi

line="${blue}${current_dir_display}${reset}:${git_branch_color}${git_branch}${reset}"

if [[ -n "$github_repo_display" ]]; then
  line="${line} ${gray}${github_repo_display}${reset}"
fi

if [[ -n "$pr_display" ]]; then
  line="${line} ${pr_display}"
fi

if [[ -n "$project_divergence_display" ]]; then
  line="${line} ${blue}${project_divergence_display}${reset}"
fi

if [[ -n "$added_dirs_display" ]]; then
  line="${line} ${blue}${added_dirs_display}${reset}"
fi

if [[ "$exceeds_200k" == "true" ]]; then
  tokens_used_color="$red"
  tokens_used_prefix="!"
else
  tokens_used_color=""
  tokens_used_prefix=""
fi

line="${line} • ${cyan}${model}${reset} ${gray}advisor:${reset}${cyan}?${reset} • ${bold}${tokens_used_color}${tokens_used_prefix}${tokens_k}k${reset}/${context_k}k ${gray}${context_pct}%${reset} • ${gray}effort:${reset}${bold}${cyan}${effort_level}${reset} ${gray}thinking:${reset}${bold}${cyan}${thinking_display}${reset}"

line="${line} ${gray}style:${reset}${bold}${cyan}${output_style_display}${reset}"

line="${line} • ${rate_limits_display}"

is_cache_healthy=$((cache_pct >= 70))
is_cache_mediocre=$((cache_pct >= 40))

if [[ $is_cache_healthy -eq 1 ]]; then
  cache_color="$green"
elif [[ $is_cache_mediocre -eq 1 ]]; then
  cache_color="$yellow"
else
  cache_color="$red"
fi

line="${line} • ${cache_color}cache:${bold}${cache_pct}%${reset}"

if [[ -n "$cost_display" ]]; then
  line="${line} ${gray}${cost_display}${reset}"
fi

line="${line} • ${gray}${session_id}${reset}"

if [[ -n "$claude_version" ]]; then
  line="${line} • ${gray}v${claude_version}${reset}"
fi

echo -e "$line"
