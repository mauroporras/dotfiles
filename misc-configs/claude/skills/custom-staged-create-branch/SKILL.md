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

Unstaged and untracked changes do not exist for this skill: never mention them,
and never let them influence the branch name.

Guard clause: if the staged diff above is empty, do NOT create a branch (there
is nothing to derive a name from). Tell the user nothing is staged and stop.

ALWAYS:

- Prioritize brevity over grammar:
  Keep the branch name short, even if grammatically imperfect
- Name the branch `<type>/<short-kebab-description>`, where `<type>` is one of the widely known conventional commit types.
- Immediately invoke the Bash tool to create and switch to the new branch.
  Do not just print the command, actually run it: `git checkout -b <branch-name>`

NEVER:

- Run additional Git commands
