#!/bin/bash
# Renders the Claude Code statusline. Runs on every prompt, so:
#   - never block (no network calls, no unbounded subprocesses)
#   - never write to stderr (terminals show it)
#   - never exit non-zero (parent treats that as render failure)
# These constraints explain the `2>/dev/null` everywhere, the `// 0` jq
# defaults, and why `set -e`/`set -u` are deliberately not used: a single
# failed sub-command should degrade one segment, not wipe the whole line.

set -o pipefail
LC_ALL=C # stable decimal separator for printf '$%.2f' across locales

SHOW_COST=false
SHOW_SESSION_ID=false
SHOW_ADVISOR=true
SHOW_CONTEXT_PCT=false
SHOW_VERSION=false

# Colors
bold='\033[1m'
italic='\033[3m'
blue='\033[34m'
green='\033[32m'
yellow='\033[33m'
cyan='\033[36m'
red='\033[31m'
gray='\033[90m'
reset='\033[0m'

input=$(cat)

# Validate once up front: if the harness ever pipes us malformed or empty input,
# fall back to an empty object so each downstream `jq` call doesn't spew
# "parse error" to stderr.
if ! printf '%s' "$input" | jq -e . > /dev/null 2>&1; then
    input='{}'
fi

current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
current_dir_display=${current_dir##*/}
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // empty')
project_dir_display=${project_dir##*/}

project_divergence_display=""
if [[ -n "$project_dir_display" && "$project_dir_display" != "$current_dir_display" ]]; then
    # Alert prefix so a `cd` away from the original project dir is impossible to
    # miss: it changes the meaning of every relative path and git context below.
    project_divergence_display="🚨 ← ${project_dir_display}"
fi

# Two worktree signals exist, and they differ in scope: `worktree.*` is only set
# while Claude Code itself runs a worktree session (EnterWorktree, --worktree),
# whereas `workspace.git_worktree` is set for any linked `git worktree add` tree.
# Prefer the session one (it also carries the path) and fall back to the plain
# one, so the segment fires whichever way the second working directory came about.
{
    read -r worktree_session_name
    read -r worktree_session_path
    read -r git_worktree_name
} < <(
    echo "$input" | jq -r '.worktree.name // "", .worktree.path // "", .workspace.git_worktree // ""'
)

worktree_name="${worktree_session_name:-$git_worktree_name}"
worktree_path="${worktree_session_path:-$current_dir}"

model=$(echo "$input" | jq -r '.model.display_name')
# The "/1M" context segment already conveys the 1M window, so drop the suffix.
model=${model% (1M context)}
effort_level=$(echo "$input" | jq -r '.effort.level // "?"')

case "$effort_level" in
max) effort_display="🟪" ;;
xhigh) effort_display="🟦" ;;
high) effort_display="🟩" ;;
medium) effort_display="🟨" ;;
low) effort_display="🟥" ;;
*) effort_display="$effort_level" ;;
esac

thinking_enabled=$(echo "$input" | jq -r '.thinking.enabled // false')
fast_mode_enabled=$(echo "$input" | jq -r '.fast_mode // false')
model_id=$(echo "$input" | jq -r '.model.id // empty')

# The payload reports these models' thinking as on regardless of the setting
# (capability `rejects_disabled_thinking` in Claude Code 2.1.286), so a lock
# says "on, and not toggleable" rather than a dot that looks flippable. Globs
# match substrings so 3P ids (Bedrock/Vertex prefixes, `[1m]` suffixes) still
# hit; `claude-fable-5*` covers both Fable 5 and 5.1.
is_thinking_forced=false
case "$model_id" in
*claude-fable-5* | *claude-mythos-5-1* | *claude-opus-5-5* | *claude-sonnet-5-5*)
    is_thinking_forced=true
    ;;
esac

if [[ "$is_thinking_forced" == "true" ]]; then
    thinking_display="🔒"
elif [[ "$thinking_enabled" == "true" ]]; then
    thinking_display="🟢"
else
    thinking_display="⚪️"
fi

# The banknote flags that fast mode draws from usage credits at a higher rate.
if [[ "$fast_mode_enabled" == "true" ]]; then
    fast_mode_display="🟢"
else
    fast_mode_display="⚪️"
fi

# The payload doesn't carry focus view, so mirror how Claude Code resolves it:
# a `viewMode` setting wins outright (last of user < project < local), and only
# when none is set does the `/focus` toggle persisted in the global config apply.
claude_config_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
global_config_file="${CLAUDE_CONFIG_DIR:-$HOME}/.claude.json"

# Mirrors Claude Code's settings merge for the scopes we can see: the last
# non-null value of user < project < local wins.
read_merged_setting() {
    local retval
    retval=$(jq -rs --arg key "$1" '[.[][$key] // empty] | last // empty' \
        "$claude_config_dir/settings.json" \
        "${project_dir:-$current_dir}/.claude/settings.json" \
        "${project_dir:-$current_dir}/.claude/settings.local.json" 2> /dev/null)

    printf '%s' "$retval"
}

view_mode=$(read_merged_setting viewMode)

is_focus_mode=false
if [[ "$view_mode" == "focus" ]]; then
    is_focus_mode=true
elif [[ -z "$view_mode" ]]; then
    is_focus_mode=$(jq -r '.briefTranscript // false' "$global_config_file" 2> /dev/null)
fi

if [[ "$is_focus_mode" == "true" ]]; then
    focus_mode_display="🟢"
else
    focus_mode_display="⚪️"
fi

# Fullscreen isn't in the payload either. Mirror the deterministic part of how
# Claude Code picks the renderer: the env vars (inherited from the harness) win,
# then the `tui` setting. Past that it falls back to rollout flags and runtime
# probes (tmux -CC, crash auto-off, screen reader) we can't see, so say "?".
is_truthy_env() {
    case "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" in
    1 | true | yes | on) return 0 ;;
    *) return 1 ;;
    esac
}

is_falsy_env() {
    case "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" in
    0 | false | no | off) return 0 ;;
    *) return 1 ;;
    esac
}

tui_setting=$(read_merged_setting tui)

if is_falsy_env "$CLAUDE_CODE_NO_FLICKER" || is_truthy_env "$CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN"; then
    fullscreen_display="⚪️"
elif is_truthy_env "$CLAUDE_CODE_NO_FLICKER" || [[ "$tui_setting" == "fullscreen" ]]; then
    fullscreen_display="🟢"
elif [[ "$tui_setting" == "default" ]]; then
    fullscreen_display="⚪️"
else
    fullscreen_display="?"
fi

# Focus view only exists in the fullscreen renderer, so a focus indicator next
# to a known-off fullscreen would describe a mode that can't be active. An
# unknown ("?") renderer keeps it, since fullscreen may well be on.
focus_mode_segment="🎯${focus_mode_display}"
if [[ "$fullscreen_display" == "⚪️" ]]; then
    focus_mode_segment=""
fi

# Debug: uncomment to see raw input
# echo "$input" > /tmp/statusline-debug.json

# Input tokens only (fresh + cache writes + cache reads): that's what fills
# the window and what the harness's own `used_percentage` counts, so adding
# output tokens would make the bucket disagree with the percentage next to it.
total_input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
tokens_k=$((total_input_tokens / 1000))
context_k=$((context_size / 1000))

# Windows are clean multiples of 1000k (200k, 1M), so integer division is exact.
if [[ $context_k -ge 1000 ]]; then
    context_display="$((context_k / 1000))M"
else
    context_display="${context_k}k"
fi

# The harness already reports how full the window is, so take its number rather
# than re-deriving it from the token counts: it accounts for the same reserved
# overhead the in-app /context view does, and stays correct if that math changes.
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')

cd "$current_dir" 2> /dev/null || cd /

git_branch="no-repo"
git_branch_is_repo=false
git_branch_upstream_display=""

# Detect repo membership via rev-parse rather than `git branch --show-current`,
# which returns empty during rebase / detached HEAD and would otherwise falsely
# read as "no-repo".
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    git_branch_is_repo=true
    current_branch=$(git branch --show-current 2> /dev/null)

    if [[ -n "$current_branch" ]]; then
        git_branch="$current_branch"

        # Reads local refs only (no fetch), so it never blocks on the network.
        # `@{upstream}` also fails when the configured remote branch is gone
        # (e.g. deleted after a merge + prune), which correctly reads as "not
        # on the remote". Detached HEAD / rebasing have no branch to track, so
        # they get no indicator.
        has_upstream=false
        if git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' > /dev/null 2>&1; then
            has_upstream=true
        fi

        if [[ "$has_upstream" == "true" ]]; then
            git_branch_upstream_display="☁️🟢"
        else
            git_branch_upstream_display="☁️⚪️"
        fi
    else
        git_dir=$(git rev-parse --git-dir 2> /dev/null)
        rebase_merge_head_file="$git_dir/rebase-merge/head-name"
        rebase_apply_head_file="$git_dir/rebase-apply/head-name"

        if [[ -f "$rebase_merge_head_file" ]]; then
            rebase_branch_ref=$(< "$rebase_merge_head_file")
            git_branch="${rebase_branch_ref#refs/heads/} (rebasing)"
        elif [[ -f "$rebase_apply_head_file" ]]; then
            rebase_branch_ref=$(< "$rebase_apply_head_file")
            git_branch="${rebase_branch_ref#refs/heads/} (rebasing)"
        else
            short_sha=$(git rev-parse --short HEAD 2> /dev/null)
            git_branch="(detached @ ${short_sha:-?})"
        fi
    fi
fi
# Two different "names" exist, and the payload only carries the weaker one:
# `.session_name` is the conversation *title* (custom or AI-generated) and stays
# absent until one is produced. The name the session is actually addressable by
# (`/sessions`, cross-session messaging) lives in the concurrent-sessions
# registry, one small JSON per pid, so prefer that and match it on session id
# rather than on our parent pid, which assumes the harness spawns us directly.
session_registry_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/sessions"
session_id_value=$(echo "$input" | jq -r '.session_id // empty')
session_name=""

if [[ -n "$session_id_value" ]]; then
    session_name=$(jq -r --arg session_id "$session_id_value" 'select(.sessionId == $session_id) | .name // empty' "$session_registry_dir"/*.json 2> /dev/null | head -n 1)
fi

if [[ -z "$session_name" ]]; then
    session_name=$(echo "$input" | jq -r '.session_name // empty')
fi

session_id=""
if [[ "$SHOW_SESSION_ID" == "true" ]]; then
    session_id="${session_id_value:-unknown}"
fi

# The harness's own `exceeds_200k_tokens` folds output tokens in, so it can fire
# while the bucket beside it still reads under 200k. Derive the tripwire from the
# same input-only count the bucket shows, so the two can never disagree.
# 200k is where 200k-window models compact and where 1M-window models used to
# flip to long-context pricing; Claude 4.6+ bill the full window at standard
# rates, so on those models this is a size marker rather than a cost cliff.
long_context_threshold_tokens=200000
exceeds_200k=false
if [[ $total_input_tokens -gt $long_context_threshold_tokens ]]; then
    exceeds_200k=true
fi
claude_version=""
if [[ "$SHOW_VERSION" == "true" ]]; then
    claude_version=$(echo "$input" | jq -r '.version // empty')
fi
output_style=$(echo "$input" | jq -r '.output_style.name // empty')

# Depth can also be requested in-conversation ("walk me through why ...") rather
# than by switching the global style.
output_style_display="${output_style:-default}"

# Only a deliberately-chosen (non-default) style ever renders, so it's always cyan.
output_style_color="$cyan"

added_dirs_display=""

cost_display=""
if [[ "$SHOW_COST" == "true" ]]; then
    cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // ""')

    if [[ -n "$cost_usd" ]]; then
        cost_display=$(printf '$%.2f' "$cost_usd")
    fi
fi

# One field per line so empty values don't collapse the way they would under
# IFS=$'\t' (POSIX "IFS whitespace" rule).
{
    read -r github_repo_host
    read -r github_repo_owner
    read -r github_repo_name
} < <(
    echo "$input" | jq -r '.workspace.repo.host // "", .workspace.repo.owner // "", .workspace.repo.name // ""'
)

five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
spend_limit_pct=$(echo "$input" | jq -r '.rate_limits.spend_limit.used_percentage // empty')
spend_limit_resets=$(echo "$input" | jq -r '.rate_limits.spend_limit.resets_at // empty')

# Build an OSC 8 hyperlink with a unique id. Without an id (or with an id
# shared across spans) some terminals (notably Ghostty) visually group
# adjacent hyperlinks on cmd-hover; the id-scoped close gives each span its
# own scope. BEL terminator (not ESC+\) so a trailing backslash doesn't
# collide with the next color escape's leading backslash on concatenation.
osc8_link() {
    local id=$1
    local url=$2
    local label=$3

    printf '\033]8;id=%s;%s\a%s\033]8;id=%s;\a' "$id" "$url" "$label" "$id"
}

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
    local hours=$(((secs % 86400) / 3600))
    local mins=$(((secs % 3600) / 60))

    if [[ $days -gt 0 ]]; then
        echo "${days}${italic}d${reset}${hours}${italic}h${reset}"
    elif [[ $hours -gt 0 ]]; then
        echo "${hours}${italic}h${reset}${mins}${italic}m${reset}"
    else
        echo "${mins}${italic}m${reset}"
    fi
}

now_epoch=$(date +%s)
five_hour_pct_int="${five_hour_pct%.*}"
seven_day_pct_int="${seven_day_pct%.*}"
spend_limit_pct_int="${spend_limit_pct%.*}"
five_hour_reset_display=$(format_reset_short "$five_hour_resets" "$now_epoch")
seven_day_reset_display=$(format_reset_short "$seven_day_resets" "$now_epoch")
spend_limit_reset_display=$(format_reset_short "$spend_limit_resets" "$now_epoch")

# Session-level cache stats come straight from the harness (v2.1.251+), which
# also re-runs this script the moment `expires_at` passes, so the warm→cold
# flip needs no timer of its own. One field per line, same as the repo fields
# below, so a null `hit_ratio` reads as empty instead of shifting the others.
{
    read -r prompt_cache_present
    read -r prompt_cache_warm
    read -r prompt_cache_expires_at
    read -r prompt_cache_hit_pct
    read -r prompt_cache_ttl
} < <(
    echo "$input" | jq -r '
      (.prompt_cache != null),
      (.prompt_cache.warm // false),
      (.prompt_cache.expires_at // ""),
      ((.prompt_cache.hit_ratio // "") | if . == "" then "" else (. * 100 | floor) end),
      (.prompt_cache.ttl // "")
    '
)

# One field per line again, so a missing `review_state` (it can be absent while
# `pr` is present) reads as empty instead of shifting a later field into its slot.
{
    read -r pr_number
    read -r pr_url
    read -r pr_review_state
} < <(
    echo "$input" | jq -r '
      (.pr.number // ""),
      (.pr.url // ""),
      (.pr.review_state // "")
    '
)

# Same convention as the rate-limit meters: a healthy ratio stays in the default
# foreground and only a degraded one gets color, so color means "pay attention".
# A sustained drop means the prefix changed (CLAUDE.md edited, tools added, TTL
# lapsed) and the next turns run slower and pricier until the cache rebuilds.
prompt_cache_hit_color() {
    local pct=$1

    if [[ -n "$pct" && $pct -lt 40 ]]; then
        echo "$red"
    elif [[ -n "$pct" && $pct -lt 70 ]]; then
        echo "$yellow"
    fi
}

prompt_cache_segment=""
if [[ "$prompt_cache_present" == "true" ]]; then
    if [[ "$prompt_cache_warm" == "true" ]]; then
        prompt_cache_state="🔥$(format_reset_short "$prompt_cache_expires_at" "$now_epoch")"

        # The countdown only means something against the lifetime it's racing
        # (5m vs 1h), so show the TTL next to it.
        if [[ -n "$prompt_cache_ttl" ]]; then
            prompt_cache_state="${prompt_cache_state}${gray}/${prompt_cache_ttl}${reset}"
        fi
    else
        prompt_cache_state="❄️"
    fi

    prompt_cache_hit_display=""
    if [[ -n "$prompt_cache_hit_pct" ]]; then
        prompt_cache_color=$(prompt_cache_hit_color "$prompt_cache_hit_pct")
        prompt_cache_emphasis=""
        if [[ -n "$prompt_cache_color" ]]; then
            prompt_cache_emphasis="$bold"
        fi

        prompt_cache_hit_display="${prompt_cache_color}${prompt_cache_emphasis}${prompt_cache_hit_pct}%${reset}"
    fi

    prompt_cache_segment="${prompt_cache_hit_display}${prompt_cache_state}"
else
    # The harness omits `prompt_cache` until the first main-thread response after
    # startup, /clear, resume, fork, or remote attach. A placeholder keeps the
    # segment from vanishing and shifting the rest of the line.
    prompt_cache_segment="🔥-"
fi

if [[ "$git_branch_is_repo" == "true" ]]; then
    git_branch_color="$green"
else
    git_branch_color="$red"
fi

# Process substitution (`< <(...)`) keeps the loop in the parent shell so the
# accumulated string isn't lost in a subshell.
added_dirs_index=0
while IFS= read -r added_dir; do
    if [[ -z "$added_dir" ]]; then
        continue
    fi

    added_dir_basename=${added_dir##*/}
    added_dir_link="$(osc8_link "statusline-added-${added_dirs_index}" "file://${added_dir}" "${added_dir_basename}")${reset}"

    if [[ $added_dirs_index -eq 0 ]]; then
        added_dirs_display="${blue}[${added_dir_link}"
    else
        added_dirs_display="${added_dirs_display}${gray},${blue}${added_dir_link}"
    fi

    added_dirs_index=$((added_dirs_index + 1))
done < <(echo "$input" | jq -r '.workspace.added_dirs // [] | .[]')

if [[ -n "$added_dirs_display" ]]; then
    added_dirs_display="${added_dirs_display}${blue}]${reset}"
fi

github_repo_display=""
if [[ -n "$github_repo_owner" && -n "$github_repo_name" ]]; then
    github_repo_label="${github_repo_owner}/${github_repo_name}"

    if [[ -n "$github_repo_host" ]]; then
        github_repo_url="https://${github_repo_host}/${github_repo_label}"
        github_repo_display=$(osc8_link "statusline-repo" "$github_repo_url" "$github_repo_label")
    else
        github_repo_display="$github_repo_label"
    fi
fi

# Only the elevated tiers get a color; a healthy/low percentage stays in the
# default foreground (like the context counter) so colors mean "pay attention".
rate_limit_color() {
    local pct=$1

    if [[ -n "$pct" && $pct -ge 80 ]]; then
        echo "$red"
    elif [[ -n "$pct" && $pct -ge 50 ]]; then
        echo "$yellow"
    fi
}

# Same "color means pay attention" rule, plus green for the one state that says
# the PR is ready to land; pending and unknown stay in the default foreground.
pr_review_color() {
    local review_state=$1

    case "$review_state" in
    approved) echo "$green" ;;
    changes_requested) echo "${bold}${red}" ;;
    draft) echo "$gray" ;;
    esac
}

# The harness omits rate_limits until the first API response (and entirely on
# API-key billing), and each window can be absent independently. A placeholder
# keeps each meter's slot from vanishing and shifting the rest of the line, the
# same way the cache segment does. The `-n` guard ensures an empty (missing)
# percentage never renders a blank/zero value.
five_hour_segment="⏱️-"
if [[ -n "$five_hour_pct_int" ]]; then
    five_hour_color=$(rate_limit_color "$five_hour_pct_int")
    # A color is only assigned outside the normal range, so reuse its presence as
    # the signal to also bold the percentage for extra emphasis.
    five_hour_emphasis=""
    if [[ -n "$five_hour_color" ]]; then
        five_hour_emphasis="$bold"
    fi

    five_hour_segment="${five_hour_color}${five_hour_emphasis}${five_hour_pct_int}%${reset}⏱️${five_hour_reset_display}"
fi

seven_day_segment="🗓️-"
if [[ -n "$seven_day_pct_int" ]]; then
    seven_day_color=$(rate_limit_color "$seven_day_pct_int")
    seven_day_emphasis=""
    if [[ -n "$seven_day_color" ]]; then
        seven_day_emphasis="$bold"
    fi

    seven_day_segment="${seven_day_color}${seven_day_emphasis}${seven_day_pct_int}%${reset}🗓️${seven_day_reset_display}"
fi

# Unlike the two windows above, the spend limit only exists behind a Claude apps
# gateway (the harness omits it on subscription and API-key setups), so a `-`
# placeholder would be a permanent dead slot there. Render it only when present.
has_spend_limit=false
if [[ -n "$spend_limit_pct_int" ]]; then
    has_spend_limit=true
fi

spend_limit_segment=""
if [[ "$has_spend_limit" == "true" ]]; then
    spend_limit_color=$(rate_limit_color "$spend_limit_pct_int")
    spend_limit_emphasis=""
    if [[ -n "$spend_limit_color" ]]; then
        spend_limit_emphasis="$bold"
    fi

    spend_limit_segment="${spend_limit_color}${spend_limit_emphasis}${spend_limit_pct_int}%${reset}💳${spend_limit_reset_display}"
fi

# The statusline only shows the percentage and reset time; the usage page holds
# the full breakdown. Each meter gets its own link id so a terminal highlights
# them separately instead of as one link spanning the space between them.
usage_settings_url="https://claude.ai/new#settings/usage"
five_hour_link=$(osc8_link "statusline-five-hour" "$usage_settings_url" "$five_hour_segment")
seven_day_link=$(osc8_link "statusline-seven-day" "$usage_settings_url" "$seven_day_segment")

rate_limits_display="${five_hour_link} ${seven_day_link}"

if [[ "$has_spend_limit" == "true" ]]; then
    spend_limit_link=$(osc8_link "statusline-spend-limit" "$usage_settings_url" "$spend_limit_segment")
    rate_limits_display="${rate_limits_display} ${spend_limit_link}"
fi

current_dir_link=$(osc8_link "statusline-dir" "file://${current_dir}" "$current_dir_display")
workspace_line="📁${blue}${current_dir_link}${reset}"

# Workspace decorations sit between the current dir and the branch bullet so
# they read as modifiers of the dir, not of the branch.
if [[ -n "$project_divergence_display" ]]; then
    workspace_line="${workspace_line} ${blue}${project_divergence_display}${reset}"
fi

if [[ -n "$added_dirs_display" ]]; then
    workspace_line="${workspace_line} ${added_dirs_display}"
fi

# The repo identity precedes the worktree so the eye reads "which repo, then
# which tree of it" before the branch that tree has checked out.
if [[ -n "$github_repo_display" ]]; then
    workspace_line="${workspace_line} 📦${blue}${github_repo_display}${reset}"
fi

# A worktree moves the work into a second working directory the user isn't
# looking at, so it gets alert styling (yellow) rather than the muted blue
# of the other dir decorations. The label links to the tree so a cmd-click lands
# in the right place.
is_in_worktree=false
if [[ -n "$worktree_name" ]]; then
    is_in_worktree=true
fi

if [[ "$is_in_worktree" == "true" ]]; then
    worktree_link=$(osc8_link "statusline-worktree" "file://${worktree_path}" "$worktree_name")
    workspace_line="${workspace_line} 🌳${yellow}${worktree_link}${reset}"
fi

workspace_line="${workspace_line} 🌿${git_branch_upstream_display}${git_branch_color}${git_branch}${reset}"

# The PR belongs to the branch, so it follows the branch bullet. The harness
# drops `pr` once it merges or closes, and "no open PR" is the common state, so
# there is no placeholder.
has_pr=false
if [[ -n "$pr_number" ]]; then
    has_pr=true
fi

if [[ "$has_pr" == "true" ]]; then
    pr_color=$(pr_review_color "$pr_review_state")
    pr_link=$(osc8_link "statusline-pr" "$pr_url" "#${pr_number}")
    workspace_line="${workspace_line} 🔀${pr_color}${pr_link}${reset}"
fi

tokens_used_color=""
tokens_used_alert=""
if [[ "$exceeds_200k" == "true" ]]; then
    tokens_used_color="${bold}${red}"
    tokens_used_alert="🚨"
fi

# Not in the payload, so read the setting `/advisor` persists. Flag-only or
# session-only advisors (--advisor, remote /advisor) and the account-level
# availability gate aren't visible from here, so this is the configured
# default rather than a guarantee the advisor is consulted.
advisor_model=$(read_merged_setting advisorModel)

advisor_display=""
if [[ "$SHOW_ADVISOR" == "true" ]]; then
    advisor_docs_url="https://code.claude.com/docs/en/advisor"
    advisor_segment="🤝🏻${cyan}${advisor_model:-off}${reset}"
    advisor_display=$(osc8_link "statusline-advisor" "$advisor_docs_url" "$advisor_segment")
fi

context_pct_display=""
if [[ "$SHOW_CONTEXT_PCT" == "true" ]]; then
    context_pct_display=" ${gray}${context_pct}%${reset}"
fi

state_line="✳️${cyan}${model}${reset}${advisor_display} 🪣${tokens_used_alert}${tokens_used_color}${tokens_k}k${reset}/${context_display}${context_pct_display} 💪🏻${effort_display}🧠${thinking_display} ⚡️💵${fast_mode_display} 🖥️${fullscreen_display}${focus_mode_segment}"

# The default style is the common case, so only surface the segment when a
# non-default style is deliberately in effect.
if [[ "$output_style_display" != "default" ]]; then
    state_line="${state_line} ${gray}style:${reset}${bold}${output_style_color}${output_style_display}${reset}"
fi

if [[ -n "$prompt_cache_segment" ]]; then
    state_line="${state_line} ${prompt_cache_segment}"
fi

state_line="${state_line} ${rate_limits_display}"

if [[ -n "$cost_display" ]]; then
    state_line="${state_line} ${gray}${cost_display}${reset}"
fi

if [[ -n "$session_id" ]]; then
    state_line="${state_line} • ${gray}${session_id}${reset}"
fi

if [[ -n "$claude_version" ]]; then
    state_line="${state_line} • ${gray}v${claude_version}${reset}"
fi

# Trails the state line: it identifies the session rather than describing its
# state, so it sits past the segments that change from turn to turn.
if [[ -n "$session_name" ]]; then
    state_line="${state_line} 🏷️${cyan}${session_name}${reset}"
fi

echo -e "$workspace_line"
echo -e "$state_line"

