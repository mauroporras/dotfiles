---
disable-model-invocation: true
context: fork
argument-hint: [issue-number]
allowed-tools: Bash(git commit:*)
model: claude-haiku-4-5
---

# Commit STAGED changes, don't push

## Context

- Current staged changes only: !`git diff --staged`
- Issue number argument (empty if none): `$ARGUMENTS`

## Your task

Create a commit for the STAGED changes above using `git commit`.

REQUIRED:

- Subject line:
  Conventional commits format, e.g. `type(scope): description`.
  Prioritize brevity over grammar:
  Keep messages short, even if grammatically imperfect
- Body: include if and only if the issue number argument above is non-empty.
  - Non-empty (e.g. `72`): body MUST be exactly `Close #72`. Pass it via a second `-m`.
  - Empty: omit the body entirely.

NEVER:

- Run additional Git commands
