---
disable-model-invocation: true
allowed-tools: Read, Bash(git --no-pager diff *)
model: sonnet
---

# Summarize the current branch's changes

## Context

- List of changed files: !`git --no-pager diff origin/HEAD...HEAD --stat`
- Full diff: !`git --no-pager diff origin/HEAD...HEAD`

## Your task

Summarize the changes purely based on the code (do not check commit messages, the branch name, linked GitHub issues, PR descriptions, or any other contextual clues).

REQUIRED:

- Prioritize brevity over grammar:
  Keep messages short, even if grammatically imperfect

NEVER:

- Run additional Git commands
