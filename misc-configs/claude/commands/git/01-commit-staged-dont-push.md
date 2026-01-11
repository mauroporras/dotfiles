---
description: Commit STAGED changes, don't push
---

## Context

- Current Git status: !`git status --short`
- Current Git diff (staged changes only): !`git diff --staged`

## Your task

Based on the above STAGED changes, create a new commit using this command: `git commit -m "..."`.

Use conventional commits format. E.g.: "type(scope): description"

Do NOT:

- Run additional `git status`, `git log`, `git diff`, or `git add` commands.
- Add "Co-Authored-By", "Generated with Claude Code", or any Claude/Anthropic attribution.
  If a human committed it, it's their responsibility regardless of whether AI generated it.
  Besides, it clutters commit history.
- Push to remote
