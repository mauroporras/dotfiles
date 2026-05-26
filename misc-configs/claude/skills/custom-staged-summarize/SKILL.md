---
disable-model-invocation: true
allowed-tools: Read, Bash(git --no-pager diff:*)
model: claude-haiku-4-5
---

# Summarize STAGED changes

## Context

- Current staged changes only: !`git --no-pager diff --staged`

## Your task

Summarize the changes purely based on the code (do not check the branch name, linked GitHub issues, PR descriptions, or any other contextual clues).

NEVER:

- Run additional Git commands
