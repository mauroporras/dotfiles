---
description: Commit STAGED changes, don't push
disable-model-invocation: true
context: fork
argument-hint: [issue-number]
allowed-tools: Bash(git commit:*)
---

## Context

- Current Git status: !`git status --short`
- Current Git diff (staged changes only): !`git diff --staged`

## Your task

Based on the above STAGED changes, create a new commit using this command: `git commit -m "..."`.

ALWAYS:

- Use a single-line message.
- Use conventional commits format. E.g.: "type(scope): description"
- Prioritize brevity over grammar. Keep messages short, even if grammatically imperfect.

NEVER:

- Run ADDITIONAL `git status`, `git log`, `git diff`, or `git add` commands.
- Add "Co-Authored-By", "Generated with Claude Code", or any Claude/Anthropic attribution.
  If a human committed it, it's their responsibility regardless of whether AI generated it.
  Besides, it clutters the commit history.
- Add a commit body, UNLESS an issue number is provided via $ARGUMENTS.
  If provided, add a body with `Close #<issue-number>`.
- Push to remote.
