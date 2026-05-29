---
disable-model-invocation: true
allowed-tools: Read, Bash(git --no-pager diff:*)
model: haiku
---

# Summarize STAGED changes

## Context

- Current staged changes only: !`git --no-pager diff --staged`

## Your task

Summarize the changes purely based on the code (do not check the branch name, linked GitHub issues, PR descriptions, or any other contextual clues).

REQUIRED:

- Prioritize brevity over grammar:
  Keep messages short, even if grammatically imperfect

NEVER:

- Run additional Git commands
