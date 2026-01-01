---
description: Commit staged changes, don't push
---

Commit CURRENTLY STAGED CHANGES ONLY.

Use conventional commits format: `type(scope): description`

Do NOT Run `git add` or stage additional files
Do NOT Run `git log` or check commit history
Do NOT Run `git status`
Do NOT Add "Co-Authored-By", "Generated with Claude Code", or any Claude/Anthropic attribution. It only clutters the commit history with unnecessary information.
Do NOT Push to the remote

Only run two commands:

1. `git diff --cached` to check what's staged
2. `git commit -m "..."` to commit
