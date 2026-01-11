---
description: Get familiar with the current branch's changes
---

## Context

- Commits on this branch: !`git log origin/HEAD..HEAD --oneline`
- Files changed: !`git diff origin/HEAD...HEAD --stat`
- Full diff: !`git diff origin/HEAD...HEAD`

## Your task

Analyze the changes purely based on the code (do not check the branch name, linked GitHub issues, PR descriptions, or any other contextual clues).

Provide a summary that includes:

- The purpose/theme of the branch based on the commits and changes
- Key files modified and what kind of changes were made
- Any potential concerns or areas worth highlighting
- Be prepared to answer questions about the changes

Do NOT:

- Run additional git commands.
