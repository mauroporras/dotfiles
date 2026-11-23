#!/usr/bin/env bash

# Prints NORMAL when the current branch is a base branch, WIP otherwise.
# Branch list mirrors `branchColorPatterns` in misc-configs/lazygit/config.yml.
# custom-branch-changes-analyze/scripts/branch-diff.sh mirrors this list too.

set -euo pipefail

branch=$(git rev-parse --abbrev-ref HEAD)

if [[ "$branch" =~ ^(alpha|main|master|beta|production)$ ]]; then
  echo NORMAL
else
  echo WIP
fi
