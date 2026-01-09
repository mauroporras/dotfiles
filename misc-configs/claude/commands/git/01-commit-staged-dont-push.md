---
description: Commit staged changes, don't push
$BASH: git diff --staged
---

Here are the staged changes:

$BASH_OUTPUT

Use conventional commits format: "type(scope): description"
Based on the diff above, commit using `git commit -m "..."`.

Do NOT:

- Run `git status`, `git log`, `git diff`, or `git add`
- Add "Co-Authored-By", "Generated with Claude Code", or any Claude/Anthropic attribution. It only clutters the commit history with unnecessary information.
- Push to remote
