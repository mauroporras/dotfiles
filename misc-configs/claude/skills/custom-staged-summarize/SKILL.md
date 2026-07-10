---
disable-model-invocation: true
allowed-tools: Read, Bash(git --no-pager diff *)
model: haiku
---

# Summarize STAGED changes

## Context

- Current staged changes only: !`git --no-pager diff --staged`

## Your task

Summarize the changes purely based on the code (do not check the branch name, linked GitHub issues, PR descriptions, or any other contextual clues).

Unstaged and untracked changes do not exist for this skill: never mention them,
and never let them influence the summary.

Guard clause: if the staged diff above is empty, do NOT summarize anything.
Tell the user nothing is staged and stop.

REQUIRED:

- Prioritize brevity over grammar:
  Keep messages short, even if grammatically imperfect

NEVER:

- Run additional Git commands
