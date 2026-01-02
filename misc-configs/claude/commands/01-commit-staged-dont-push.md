---
description: Commit staged changes, don't push
---

Use conventional commits format: "type(scope): description"

Run these commands and these commands ONLY:

1. `git diff --staged` to check what's staged
2. `git commit -m "..."` to commit

Do NOT run `git status`
Do NOT run `git log` or check commit history
Do NOT run `git add` or stage additional files
Do NOT add "Co-Authored-By", "Generated with Claude Code", or any Claude/Anthropic attribution. It only clutters the commit history with unnecessary information.
Do NOT push to the remote
