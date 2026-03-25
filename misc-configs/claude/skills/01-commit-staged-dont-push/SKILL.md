---
description: Commit STAGED changes, don't push
disable-model-invocation: true
context: fork
argument-hint: [issue-number]
allowed-tools: Bash(git commit:*)
---

## Context

- Current Git diff (staged changes only): !`git diff --staged`

## Your task

Based on the above STAGED changes, create a new commit using this command: `git commit -m "..."`.

ALWAYS:

- Use a single-line message without a body, UNLESS an issue number is provided via $ARGUMENTS.
  If provided, add a body with `Close #<issue-number>`.
- Use conventional commits format. E.g.: "type(scope): description"
- Prioritize brevity over grammar. Keep messages short, even if grammatically imperfect.

NEVER:

- Run ADDITIONAL `git status`, `git log`, `git diff`, `git add`, or `git push` commands.
