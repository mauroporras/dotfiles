# More OSC 8 links for the statusline

## Context

`misc-configs/claude/statusline-command.sh` already links the current dir, the added dirs,
the worktree, the repo, the PR, the rate-limit meters (usage page), and the advisor (docs).
Several segments are still plain text. The user picked two groups to add: the session name
linking to its transcript, and doc links for the state-line indicators. Field names and doc
URLs were checked against the current statusline docs and `code.claude.com/docs/llms.txt`.

All new links reuse the existing `osc8_link <id> <url> <label>` helper (line 317), each with
its own `statusline-*` id.

## Changes (single file: `misc-configs/claude/statusline-command.sh`)

### 1. Session name → transcript

- Read `transcript_path` with the other `jq` reads (`.transcript_path // empty`).
- In the 🏷️ block (line ~676): when `has_transcript_path` is true, wrap `session_name`
  as `osc8_link "statusline-session" "file://${transcript_path}" "$session_name"`;
  otherwise keep the plain label.

### 2. Doc links

Add `claude_code_docs_url="https://code.claude.com/docs/en"` next to `advisor_docs_url`
(and point `advisor_docs_url` at it). Link only each segment's label/indicator, not the
separating spaces, so adjacent links stay distinct.

| Segment | Link id | Page |
|---|---|---|
| ✳️ model | `statusline-model` | `model-config` |
| 💪🏻 effort | `statusline-effort` | `model-config#adjust-effort-level` |
| ⚡️💵 fast mode | `statusline-fast-mode` | `fast-mode` |
| 🖥️ fullscreen (and 🎯 focus) | `statusline-fullscreen` / `statusline-focus` | `fullscreen` |
| 🔥 prompt cache (incl. `🔥-` placeholder) | `statusline-prompt-cache` | `prompt-caching#check-cache-performance` |
| style:… | `statusline-output-style` | `output-styles` |
| v… (when `SHOW_VERSION`) | `statusline-version` | `changelog` |
| $ cost (when `SHOW_COST`) | `statusline-cost` | `costs` |

Build each linked piece into its own `*_link` variable before assembling `state_line`
(line 646), mirroring how `five_hour_link` / `advisor_display` are built.

## Verification

- `echo '<sample payload>' | bash misc-configs/claude/statusline-command.sh 2>&1 >/dev/null`
  prints nothing (no stderr), with and without `transcript_path`, `prompt_cache`, `output_style`.
- `... | cat -v`: every new link has a unique `id=` and a matching close, and labels render
  as before.
- In a live session, cmd-hover each segment in Ghostty and confirm the targets open.
