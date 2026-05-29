---
disable-model-invocation: true
context: fork
argument-hint: [push] [issue-number]
allowed-tools: Bash(git commit:*), Bash(git --no-pager diff:*), Bash(git push:*), Bash(git rev-parse:*)
model: claude-haiku-4-5
---

# Commit STAGED changes, optionally push

## Context

- Current staged changes only: !`git --no-pager diff --staged`
- Current branch: !`git rev-parse --abbrev-ref HEAD`
- Arguments (issue number and/or `push`, empty if none): `$ARGUMENTS`

## Your task

Create a commit for the STAGED changes above using `git commit`.

The arguments above may contain an issue number, the literal token `push`, both, or neither (order does not matter):

- Issue number: any numeric token (e.g. `72`).
- Push flag: the literal token `push`.

REQUIRED:

- Commit mode is inferred from the current branch shown above:
  - Base branches (`alpha`, `main`, `master`, `beta`, `production`): normal commit.
  - Any other branch: WIP commit.
- Prioritize brevity over grammar:
  Keep messages short, even if grammatically imperfect
- Subject line:
  - Normal commit: conventional commits format
    E.g.: `<type>(<scope>): <description>`
  - WIP commit: `WIP(<current-branch>): <description>`
    Using the current branch as the scope and a brief conventional-style description of the staged changes.
    Also pass `--no-verify` to `git commit`.
- Body: include if and only if an issue number is present.
  - Present (e.g. `72`): body MUST be exactly `Close #72`. Pass it via a second `-m`.
  - Absent: omit the body entirely.
- Push: run `git push` after committing if and only if the `push` token is present.

NEVER:

- Run additional Git commands
