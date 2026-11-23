---
disable-model-invocation: true
allowed-tools: Read, Bash(bash *)
model: sonnet
---

# Summarize the current branch's changes

## Context

<!--
The diffs go through scripts/branch-diff.sh (in custom-branch-changes-analyze)
because the base branch is detected at runtime, and skill `!` commands reject
the `$(...)` substitution that passing it to `git diff` would need.
-->

- Base branch (the one this branch was cut from): !`bash "$HOME/.claude/skills/custom-branch-changes-analyze/scripts/branch-diff.sh" --base`
- List of changed files: !`bash "$HOME/.claude/skills/custom-branch-changes-analyze/scripts/branch-diff.sh" --stat`
- Full diff: !`bash "$HOME/.claude/skills/custom-branch-changes-analyze/scripts/branch-diff.sh"`

## Your task

Summarize the changes purely based on the code (do not check commit messages, the branch name, linked GitHub issues, PR descriptions, or any other contextual clues).

REQUIRED:

- Prioritize brevity over grammar:
  Keep messages short, even if grammatically imperfect

NEVER:

- Run additional Git commands
