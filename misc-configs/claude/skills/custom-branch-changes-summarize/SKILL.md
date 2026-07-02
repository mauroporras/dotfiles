---
disable-model-invocation: true
allowed-tools: Read, Bash(git --no-pager log *), Bash(git --no-pager diff *)
model: haiku
---

# Summarize the current branch's changes

## Context

- Commits on this branch: !`git --no-pager log origin/HEAD..HEAD --oneline`
- List of changed files: !`git --no-pager diff origin/HEAD...HEAD --stat`
- Full diff: !`git --no-pager diff origin/HEAD...HEAD`

## Your task

Summarize the changes purely based on the code (do not check the branch name, linked GitHub issues, PR descriptions, or any other contextual clues).

REQUIRED:

- Prioritize brevity over grammar:
  Keep messages short, even if grammatically imperfect

NEVER:

- Run additional Git commands
