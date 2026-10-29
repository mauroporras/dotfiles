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
# Off because the mode takes a long time to refresh in the statusline, so the
# indicator lags behind the real vim mode and misleads more than it helps.
SHOW_VIM_MODE=false

bold='\033[1m'
italic='\033[3m'
green='\033[32m'
yellow='\033[33m'
cyan='\033[36m'
red='\033[31m'
gray='\033[90m'

# Truecolor values from the lualine `codedark` theme, so the mode reads the same
# as the neovim statusline.
vim_normal_color='\033[38;2;96;139;78m'
vim_insert_color='\033[38;2;86;156;214m'
vim_visual_color='\033[38;2;197;134;192m'
reset='\033[0m'

# Splits a meter's percentage from its countdown (`12%·2h19m`) without adding
# width, leaving plain spaces to mean "next segment".
value_separator="·"

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
    project_divergence_display="⏪🚨"
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
# (capability `rejects_disabled_thinking` in Claude Code 2.1.295), so a lock
# says "on, and not toggleable" rather than a dot that looks flippable. Globs
# match substrings so 3P ids (Bedrock/Vertex prefixes, `[1m]` suffixes) still
# hit; `claude-fable-5*` covers both Fable 5 and 5.1.
is_thinking_forced=false
case "$model_id" in
*claude-fable-5* | *claude-mythos-5-1* | *claude-opus-5-5* | *claude-sonnet-5-5* | *claude-haiku-5-5*)
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
# a `viewMode` setting wins outright, and only when none is set does the
# `/focus` toggle persisted in the global config apply.
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

# Focus view only exists in the fullscreen renderer, so an on/off dot next to a
# known-off fullscreen would describe a mode that can't be active. An unknown
# ("?") renderer keeps the real value, since fullscreen may well be on.
is_focus_unavailable=false
if [[ "$fullscreen_display" == "⚪️" ]]; then
    is_focus_unavailable=true
fi

if [[ "$is_focus_unavailable" == "true" ]]; then
    focus_mode_segment="🎯➖"
    focus_mode_url_anchor="enable-fullscreen-rendering"
else
    focus_mode_segment="🎯${focus_mode_display}"
    focus_mode_url_anchor="search-and-review-the-conversation"
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
    context_display="$((context_k / 1000))${italic}M${reset}"
else
    context_display="${context_k}${italic}k${reset}"
fi

# The harness already reports how full the window is, so take its number rather
# than re-deriving it from the token counts: it accounts for the same reserved
# overhead the in-app /context view does, and stays correct if that math changes.
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')

cd "$current_dir" 2> /dev/null || cd /

git_branch=""
git_branch_is_repo=false
git_branch_upstream_display=""

# Detect repo membership via rev-parse rather than `git branch --show-current`,
# which returns empty during rebase / detached HEAD and would otherwise falsely
# read as not being in a repo.
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    git_branch_is_repo=true
    current_branch=$(git branch --show-current 2> /dev/null)

    if [[ -n "$current_branch" ]]; then
        git_branch="$current_branch"

        # Reads local refs only (no fetch), so it never blocks on the network.
        # `@{upstream}` also fails when the configured remote branch is gone
        # (e.g. deleted after a merge + prune), which correctly reads as "not
        # on the remote", so only a tracked branch shows the cloud. Detached
        # HEAD / rebasing have no branch to track, so they get no indicator.
        has_upstream=false
        if git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' > /dev/null 2>&1; then
            has_upstream=true
        fi

        if [[ "$has_upstream" == "true" ]]; then
            git_branch_upstream_display="☁️"
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

# Lets the session label open the raw JSONL of this conversation.
transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

session_id=""
if [[ "$SHOW_SESSION_ID" == "true" ]]; then
    session_id="${session_id_value:-unknown}"
fi

claude_version=""
if [[ "$SHOW_VERSION" == "true" ]]; then
    claude_version=$(echo "$input" | jq -r '.version // empty')
fi
output_style=$(echo "$input" | jq -r '.output_style.name // empty')

# Depth can also be requested in-conversation ("walk me through why ...") rather
# than by switching the global style.
output_style_display="${output_style:-default}"

# The default style is always shown, so only a deliberately-chosen one gets color;
# otherwise it'd look like something unusual is in effect.
output_style_color="$cyan"
if [[ "$output_style_display" == "default" ]]; then
    output_style_color="$gray"
fi

# The payload omits `vim` entirely when vim mode is off, so a placeholder keeps
# the slot from shifting the rest of the line, the same way the cache, PR and
# rate-limit segments do.
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

vim_mode_label=""
vim_mode_color=""

case "$vim_mode" in
NORMAL)
    vim_mode_label="N"
    vim_mode_color="$vim_normal_color"
    ;;
INSERT)
    vim_mode_label="I"
    vim_mode_color="$vim_insert_color"
    ;;
VISUAL)
    vim_mode_label="V"
    vim_mode_color="$vim_visual_color"
    ;;
"VISUAL LINE")
    vim_mode_label="VL"
    vim_mode_color="$vim_visual_color"
    ;;
*)
    # An unknown (future) mode still shows up rather than vanishing.
    vim_mode_label="$vim_mode"
    ;;
esac

has_vim_mode=false
if [[ -n "$vim_mode" ]]; then
    has_vim_mode=true
fi

vim_mode_segment="⌨️➖"
if [[ "$has_vim_mode" == "true" ]]; then
    vim_mode_segment="⌨️${vim_mode_color}${vim_mode_label}${reset}"
fi

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
        echo "➖"
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
# flip needs no timer of its own.
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

# `review_state` can be absent while `pr` is present.
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

# Same color convention as the rate-limit meters below.
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
        prompt_cache_icon="🔥"
        prompt_cache_state="$(format_reset_short "$prompt_cache_expires_at" "$now_epoch")"

        # The countdown only means something against the lifetime it's racing
        # (5m vs 1h), so show the TTL next to it.
        if [[ -n "$prompt_cache_ttl" ]]; then
            prompt_cache_ttl_value="${prompt_cache_ttl%[a-z]}"
            prompt_cache_ttl_unit="${prompt_cache_ttl#"$prompt_cache_ttl_value"}"
            prompt_cache_state="${prompt_cache_state}/${prompt_cache_ttl_value}${italic}${prompt_cache_ttl_unit}${reset}"
        fi
    else
        prompt_cache_icon="❄️"
        prompt_cache_state=""
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

    # A cold cache has no countdown and a missing ratio has no percentage, so
    # the separator only appears when there are two values to split.
    prompt_cache_separator=""
    if [[ -n "$prompt_cache_hit_display" && -n "$prompt_cache_state" ]]; then
        prompt_cache_separator="$value_separator"
    fi

    prompt_cache_segment="${prompt_cache_icon}${prompt_cache_hit_display}${prompt_cache_separator}${prompt_cache_state}"
else
    # The harness omits `prompt_cache` until the first main-thread response after
    # startup, /clear, resume, fork, or remote attach.
    prompt_cache_segment="🔥➖"
fi


# Process substitution (`< <(...)`) keeps the loop in the parent shell so the
# accumulated string isn't lost in a subshell.
added_dirs_index=0
while IFS= read -r added_dir; do
    if [[ -z "$added_dir" ]]; then
        continue
    fi

    added_dir_basename=${added_dir##*/}
    added_dir_link=$(osc8_link "statusline-added-${added_dirs_index}" "file://${added_dir}" "📁${added_dir_basename}")
    added_dir_segment="${added_dir_link}"

    if [[ $added_dirs_index -eq 0 ]]; then
        added_dirs_display="${added_dir_segment}"
    else
        added_dirs_display="${added_dirs_display} ${added_dir_segment}"
    fi

    added_dirs_index=$((added_dirs_index + 1))
done < <(echo "$input" | jq -r '.workspace.added_dirs // [] | .[]')

github_repo_display=""
if [[ -n "$github_repo_owner" && -n "$github_repo_name" ]]; then
    github_repo_label="${github_repo_owner}/${github_repo_name}"

    if [[ -n "$github_repo_host" ]]; then
        github_repo_url="https://${github_repo_host}/${github_repo_label}"
        github_repo_display=$(osc8_link "statusline-repo" "$github_repo_url" "📦${github_repo_label}")
    else
        github_repo_display="📦${github_repo_label}"
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

# Tighter than the rate-limit tiers: quality and cost degrade well before the
# window is full. Percent of the window (not raw tokens) keeps the tiers
# meaningful on both 200k and 1M windows.
context_pct_color() {
    local pct=$1

    if [[ -n "$pct" && $pct -ge 30 ]]; then
        echo "$red"
    elif [[ -n "$pct" && $pct -ge 20 ]]; then
        echo "$yellow"
    fi
}

# Green marks the one state that says the PR is ready to land; pending and
# unknown stay in the default foreground.
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
# same way the cache segment does.
five_hour_segment="⏱️➖"
if [[ -n "$five_hour_pct_int" ]]; then
    five_hour_color=$(rate_limit_color "$five_hour_pct_int")
    five_hour_emphasis=""
    if [[ -n "$five_hour_color" ]]; then
        five_hour_emphasis="$bold"
    fi

    five_hour_segment="⏱️${five_hour_color}${five_hour_emphasis}${five_hour_pct_int}%${reset}${value_separator}${five_hour_reset_display}"
fi

seven_day_segment="🗓️➖"
if [[ -n "$seven_day_pct_int" ]]; then
    seven_day_color=$(rate_limit_color "$seven_day_pct_int")
    seven_day_emphasis=""
    if [[ -n "$seven_day_color" ]]; then
        seven_day_emphasis="$bold"
    fi

    seven_day_segment="🗓️${seven_day_color}${seven_day_emphasis}${seven_day_pct_int}%${reset}${value_separator}${seven_day_reset_display}"
fi

# Unlike the two windows above, the spend limit only exists behind a Claude apps
# gateway (the harness omits it on subscription and API-key setups), so a `➖`
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

    spend_limit_segment="💳${spend_limit_color}${spend_limit_emphasis}${spend_limit_pct_int}%${reset}${value_separator}${spend_limit_reset_display}"
fi

# The statusline only shows the percentage and reset time; the usage page holds
# the full breakdown. Each meter gets its own link id so a terminal highlights
# them separately instead of as one link spanning the space between them.
usage_settings_url="https://claude.ai/new#settings/usage"

claude_code_docs_url="https://code.claude.com/docs/en"
five_hour_link=$(osc8_link "statusline-five-hour" "$usage_settings_url" "$five_hour_segment")
seven_day_link=$(osc8_link "statusline-seven-day" "$usage_settings_url" "$seven_day_segment")

rate_limits_display="${five_hour_link} ${seven_day_link}"

if [[ "$has_spend_limit" == "true" ]]; then
    spend_limit_link=$(osc8_link "statusline-spend-limit" "$usage_settings_url" "$spend_limit_segment")
    rate_limits_display="${rate_limits_display} ${spend_limit_link}"
fi

# Colored only after a `cd` away from the project dir, so the highlight flags the
# change instead of being the permanent look.
current_dir_name="$current_dir_display"
if [[ -n "$project_divergence_display" ]]; then
    current_dir_name="${cyan}${current_dir_display}${reset}"
fi

current_dir_link=$(osc8_link "statusline-dir" "file://${current_dir}" "🏠${current_dir_name}")
workspace_line="${current_dir_link}"

# Workspace decorations sit between the current dir and the branch bullet so
# they read as modifiers of the dir, not of the branch.
if [[ -n "$project_divergence_display" ]]; then
    project_dir_link=$(osc8_link "statusline-project-dir" "file://${project_dir}" "📁${project_dir_display}")
    divergence_link=$(osc8_link "statusline-divergence" "${claude_code_docs_url}/permissions#working-directories" "$project_divergence_display")
    workspace_line="${workspace_line} ${divergence_link} ${project_dir_link}"
fi

if [[ -n "$added_dirs_display" ]]; then
    workspace_line="${workspace_line} ${added_dirs_display}"
fi

# The repo identity precedes the worktree so the eye reads "which repo, then
# which tree of it" before the branch that tree has checked out.
if [[ "$git_branch_is_repo" != "true" ]]; then
    workspace_line="${workspace_line} 📦➖"
elif [[ -n "$github_repo_display" ]]; then
    workspace_line="${workspace_line} ${github_repo_display}"
fi

# A worktree moves the work into a second working directory the user isn't
# looking at, so it gets cyan styling rather than the neutral default of the
# other dir decorations.
is_in_worktree=false
if [[ -n "$worktree_name" ]]; then
    is_in_worktree=true
fi

if [[ "$is_in_worktree" == "true" ]]; then
    worktree_label="🌳${cyan}${worktree_name}${reset}"
    worktree_link=$(osc8_link "statusline-worktree" "file://${worktree_path}" "$worktree_label")
    workspace_line="${workspace_line} ${worktree_link}"
else
    workspace_line="${workspace_line} 🌳➖"
fi

if [[ "$git_branch_is_repo" == "true" ]]; then
    branch_label="🌿${git_branch_upstream_display}${git_branch}"

    # Detached HEAD and rebases leave `current_branch` empty, and there is no
    # branch page to open for them. Without repo info there is no host to link to.
    has_branch_url=false
    if [[ -n "$github_repo_url" && -n "$current_branch" ]]; then
        has_branch_url=true
    fi

    if [[ "$has_branch_url" == "true" ]]; then
        # Encode per path segment so `feature/x` keeps its slash but `#`/`?`/`%` can't
        # break the URL.
        branch_path=$(jq -rn --arg branch "$current_branch" '$branch | split("/") | map(@uri) | join("/")')
        branch_label=$(osc8_link "statusline-branch" "${github_repo_url}/tree/${branch_path}" "$branch_label")
    fi

    workspace_line="${workspace_line} ${branch_label}"
fi

# The PR belongs to the branch, so it follows the branch bullet. The harness
# drops `pr` once it merges or closes.
has_pr=false
if [[ -n "$pr_number" ]]; then
    has_pr=true
fi

if [[ "$has_pr" == "true" ]]; then
    pr_color=$(pr_review_color "$pr_review_state")
    pr_link=$(osc8_link "statusline-pr" "$pr_url" "🔀#${pr_number}")
    workspace_line="${workspace_line} ${pr_color}${pr_link}${reset}"
else
    workspace_line="${workspace_line} 🔀➖"
fi

context_color=$(context_pct_color "$context_pct")
context_emphasis=""
if [[ -n "$context_color" ]]; then
    context_emphasis="$bold"
fi

# Not in the payload, so read the setting `/advisor` persists. Flag-only or
# session-only advisors (--advisor, remote /advisor) and the account-level
# availability gate aren't visible from here, so this is the configured
# default rather than a guarantee the advisor is consulted.
advisor_model=$(read_merged_setting advisorModel)

advisor_display=""
if [[ "$SHOW_ADVISOR" == "true" ]]; then
    advisor_docs_url="${claude_code_docs_url}/advisor"
    advisor_value="${advisor_model:-off}"
    advisor_initial=$(printf '%s' "${advisor_value:0:1}" | tr '[:lower:]' '[:upper:]')
    advisor_segment="🤝🏻${advisor_initial}${advisor_value:1}"
    advisor_link=$(osc8_link "statusline-advisor" "$advisor_docs_url" "$advisor_segment")

    # The leading space lives here so a hidden advisor doesn't leave a double space.
    advisor_display=" ${advisor_link}"
fi

context_pct_display=""
if [[ "$SHOW_CONTEXT_PCT" == "true" ]]; then
    context_pct_display=" ${gray}${context_pct}%${reset}"
fi

context_segment="🪣${context_color}${context_emphasis}${tokens_k}${italic}k${reset}/${context_display}${context_pct_display}"
context_link=$(osc8_link "statusline-context" "${claude_code_docs_url}/context-window" "$context_segment")

model_link=$(osc8_link "statusline-model" "${claude_code_docs_url}/model-config" "✳️${model}")
effort_link=$(osc8_link "statusline-effort" "${claude_code_docs_url}/model-config#adjust-effort-level" "💪🏻${effort_display}")
thinking_link=$(osc8_link "statusline-thinking" "${claude_code_docs_url}/model-config#extended-thinking" "🧠${thinking_display}")
fast_mode_link=$(osc8_link "statusline-fast-mode" "${claude_code_docs_url}/fast-mode" "⚡️💵${fast_mode_display}")
focus_mode_link=$(osc8_link "statusline-focus" "${claude_code_docs_url}/fullscreen#${focus_mode_url_anchor}" "$focus_mode_segment")
vim_mode_link=$(osc8_link "statusline-vim-mode" "${claude_code_docs_url}/interactive-mode#vim-editor-mode" "$vim_mode_segment")

# `${var^}` needs bash 4 and /bin/bash on macOS is 3.2, hence `tr` on the first char.
output_style_initial=$(printf '%s' "${output_style_display:0:1}" | tr '[:lower:]' '[:upper:]')
output_style_title="${output_style_initial}${output_style_display:1}"

# Each style gets its own emoji after the generic 💅🏻 marker so a glance tells
# which one is in effect; names arrive capitalized for built-ins ("Concise") and
# lowercase for `default`, so match case-insensitively. `default` and unknown
# (custom) styles get no extra emoji, since the generic marker already covers them.
# The same branch picks the docs section that explains the style; custom styles
# have no section of their own, so they land on how to write one.
output_style_key=$(printf '%s' "$output_style_display" | tr '[:upper:]' '[:lower:]')

case "$output_style_key" in
proactive)
    output_style_emoji="🚀"
    output_style_anchor="proactive"
    ;;
concise)
    output_style_emoji="✂️"
    output_style_anchor="concise"
    ;;
explanatory)
    output_style_emoji="📖"
    output_style_anchor="explanatory"
    ;;
learning)
    output_style_emoji="🎓"
    output_style_anchor="learning"
    ;;
default)
    output_style_emoji=""
    output_style_anchor="default"
    ;;
*)
    output_style_emoji=""
    output_style_anchor="create-a-custom-output-style"
    ;;
esac

output_style_label="💅🏻${output_style_emoji}${output_style_color}${output_style_title}${reset}"
output_style_url="${claude_code_docs_url}/output-styles#${output_style_anchor}"
output_style_link=$(osc8_link "statusline-output-style" "$output_style_url" "$output_style_label")

# Follows the context bucket because both describe the same window.
prompt_cache_display=""
if [[ -n "$prompt_cache_segment" ]]; then
    prompt_cache_link=$(osc8_link "statusline-prompt-cache" "${claude_code_docs_url}/prompt-caching#check-cache-performance" "$prompt_cache_segment")
    prompt_cache_display=" ${prompt_cache_link}"
fi

state_line="${model_link}${advisor_display} ${output_style_link} ${effort_link} ${thinking_link} ${context_link}${prompt_cache_display} ${fast_mode_link} ${focus_mode_link}"

state_line="${state_line} ${rate_limits_display}"

if [[ -n "$cost_display" ]]; then
    cost_link=$(osc8_link "statusline-cost" "${claude_code_docs_url}/costs" "$cost_display")
    state_line="${state_line} ${gray}${cost_link}${reset}"
fi

if [[ -n "$session_id" ]]; then
    state_line="${state_line} • ${gray}${session_id}${reset}"
fi

if [[ -n "$claude_version" ]]; then
    version_link=$(osc8_link "statusline-version" "${claude_code_docs_url}/changelog" "v${claude_version}")
    state_line="${state_line} • ${gray}${version_link}${reset}"
fi

# Trails the state line: it identifies the session rather than describing its
# state, so it sits past the segments that change from turn to turn.
session_label="🏷️➖"

has_session_name=false
if [[ -n "$session_name" ]]; then
    has_session_name=true
fi

if [[ "$has_session_name" == "true" ]]; then
    session_label="🏷️${session_name}"

    has_transcript_path=false
    if [[ -n "$transcript_path" ]]; then
        has_transcript_path=true
    fi

    if [[ "$has_transcript_path" == "true" ]]; then
        session_label=$(osc8_link "statusline-session" "file://${transcript_path}" "🏷️${session_name}")
    fi
fi

state_line="${state_line} ${session_label}"

# Prepended here because the link is built after the workspace line; the mode
# leads so it sits at a fixed position regardless of how long the dir names are.
if [[ "$SHOW_VIM_MODE" == "true" ]]; then
    workspace_line="${vim_mode_link} ${workspace_line}"
fi

echo -e "$workspace_line"
echo -e "$state_line"

