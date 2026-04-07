---
disable-model-invocation: true
allowed-tools: Read
---

# Get familiar with the current branch's changes

## Context

- Commits on this branch: !`git log origin/HEAD..HEAD --oneline`
- List of changed files: !`git diff origin/HEAD...HEAD --stat`
- Full diff: !`git diff origin/HEAD...HEAD`

## Your task

Analyze the changes purely based on the code (do not check the branch name, linked GitHub issues, PR descriptions, or any other contextual clues).

ALWAYS:

- Provide a summary that includes:
  - The purpose/theme of the branch based on the commits and changes
  - Key files modified and what kind of changes were made
  - Any potential concerns or areas worth highlighting
  - Be prepared to answer questions about the changes

NEVER:

- Run additional Git commands.
