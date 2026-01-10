---
description: New branch for STAGED changes
---

## Context

- Current Git status: !`git status --short`
- Current Git diff (staged changes only): !`git diff --staged`

## Your task

Based on the above STAGED changes, create a new branch with a descriptive name.

Use one of the following prefixes based on the type of change:

- build/some-build-change
- chore/some-chore
- ci/some-ci-change
- docs/some-docs-update
- feat/some-feature
- fix/some-fix
- perf/some-performance-improvement
- refactor/some-refactor
- style/some-style-change
- test/some-test

Run this command to create and switch to the new branch: `git checkout -b <branch-name>`

Do NOT:

- Commit the changes
- Push to remote
