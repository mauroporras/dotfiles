---
description: Get familiar with the current branch's changes
---

## Context

- Default branch: !`git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`
- Commits on this branch: !`git log $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')..HEAD --oneline`
- Files changed: !`git diff $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')...HEAD --stat`
- Full diff: !`git diff $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')...HEAD`

## Your task

Analyze the changes purely based on the code (do not check the branch name, linked GitHub issues, PR descriptions, or any other contextual clues).

Provide a summary that includes:

- The purpose/theme of the branch based on the commits and changes
- Key files modified and what kind of changes were made
- Any potential concerns or areas worth highlighting
- Be prepared to answer questions about the changes

Do NOT:

- Run additional git commands.
