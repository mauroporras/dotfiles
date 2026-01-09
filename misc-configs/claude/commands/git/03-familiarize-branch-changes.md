---
description: Get familiar with the current branch's changes
---

Get familiar with the current branch's changes compared to the default branch.

Do not check the branch name, linked GitHub issues, PR descriptions, or any other contextual clues - analyze the changes purely based on the code.

1. Determine the default branch by running `git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`
2. Run `git log <default-branch>..HEAD --oneline` to see the commits on this branch
3. Run `git diff <default-branch>...HEAD --stat` to see which files changed and how much
4. Run `git diff <default-branch>...HEAD` to review the actual changes

Provide a summary that includes:

- The purpose/theme of the branch based on the commits and changes
- Key files modified and what kind of changes were made
- Any potential concerns or areas worth highlighting
- Be prepared to answer questions about the changes
