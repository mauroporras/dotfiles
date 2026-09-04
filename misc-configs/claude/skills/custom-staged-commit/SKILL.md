---
disable-model-invocation: true
context: fork
background: false
argument-hint: [issue-number]
allowed-tools: Bash(git --no-pager diff *), Bash(git rev-parse *), Bash(git commit *), Bash(grep *), Bash(echo *), Bash(head *)
model: sonnet
---

# Commit STAGED changes

## Context

- Current staged changes only: !`git --no-pager diff --staged`
- Current branch: !`git rev-parse --abbrev-ref HEAD`
- Commit mode (`NORMAL` for base branches, `WIP` otherwise): !`git rev-parse --abbrev-ref HEAD | grep -qE '^(alpha|main|master|beta|production)$' && echo NORMAL || echo WIP`
- Arguments (`issue-number`, empty if none): `$ARGUMENTS`
- Issue number (first numeric token in arguments, empty if none): !`echo "$ARGUMENTS" | grep -oE '[0-9]+' | head -n1`

## Your task

Create a commit for the STAGED changes above using `git commit`.

Unstaged and untracked changes do not exist for this skill: never mention them,
and never let them influence the commit message, even when they touch the same
files as the staged diff.

Guard clause: if the staged diff above is empty, do NOT run `git commit`.
Tell the user nothing is staged and stop.

The arguments have already been parsed for you in the Context above. Use this
precomputed value verbatim; do NOT re-parse `$ARGUMENTS` yourself:

- `Issue number`: the issue number, or empty when none was given.

REQUIRED:

- Commit mode is the `Commit mode` value from the Context above. It is computed
  deterministically; use it verbatim and do NOT re-derive it from the branch name:
  <!--
  Branch list mirrors `branchColorPatterns` in misc-configs/lazygit/config.yml
  -->
  - `NORMAL`: normal commit.
  - `WIP`: WIP commit.
- Prioritize brevity over grammar in the subject line:
  Keep it short, even if grammatically imperfect
- Subject line:
  - Normal commit: conventional commits format
    E.g.: `<type>(<scope>): <description>`
  - WIP commit: `WIP(<current-branch>): <description>`
    Using the current branch as the scope and a brief conventional-style description of the staged changes.
    Also pass `--no-verify` to `git commit`.
- Body: optional, passed via a second `-m`. Add one only when the change carries
  context the subject line cannot: the WHY behind it, a constraint, a workaround,
  or non-obvious reasoning. Skip it for self-evident changes, and never use it to
  restate the subject or narrate the diff.
  - If `Issue number` (from Context) is non-empty, a body is required and its
    first line MUST be exactly `Close #<Issue number>` (e.g. `Close #72`).
    Any explanation follows after a blank line.

NEVER:

- Run additional Git commands
- Push. This skill commits only; pushing is the user's call.
