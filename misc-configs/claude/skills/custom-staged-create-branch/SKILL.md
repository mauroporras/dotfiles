---
disable-model-invocation: true
context: fork
allowed-tools: Bash(git checkout *), Bash(git --no-pager diff *)
model: haiku
---

# New branch for STAGED changes

## Context

- Current Git diff (staged changes only): !`git --no-pager diff --staged`

## Your task

Based on the above STAGED changes, create a new branch with a descriptive name.

ALWAYS:

- Prioritize brevity over grammar:
  Keep the branch name short, even if grammatically imperfect
- Name the branch `<type>/<short-kebab-description>`, where `<type>` is one of the widely known conventional commit types.
- Immediately invoke the Bash tool to create and switch to the new branch.
  Do not just print the command, actually run it: `git checkout -b <branch-name>`

NEVER:

- Run additional Git commands
