#!/usr/bin/env bash

# Diffs HEAD against the base branch it was cut from, passing any arguments
# (e.g. --stat) through to `git diff`. With --base, prints that base instead.
# The base is the candidate with the fewest commits between it and HEAD.
# Candidate list mirrors scripts/commit-mode.sh in custom-staged-commit.
# Shared by custom-branch-changes-analyze and custom-branch-changes-summarize.

set -euo pipefail

candidates=(alpha main master beta production)

base_ref=""
base_distance=""

for name in "${candidates[@]}"; do
  ref="origin/$name"

  has_ref=false
  if git rev-parse --verify --quiet "$ref" >/dev/null; then
    has_ref=true
  fi

  if [[ "$has_ref" == "false" ]]; then
    continue
  fi

  distance=$(git rev-list --count "$ref..HEAD")

  is_closer=false
  if [[ -z "$base_distance" || "$distance" -lt "$base_distance" ]]; then
    is_closer=true
  fi

  if [[ "$is_closer" == "true" ]]; then
    base_ref="$ref"
    base_distance="$distance"
  fi
done

# No candidate exists on this remote, so fall back to its default branch.
if [[ -z "$base_ref" ]]; then
  base_ref="origin/HEAD"
fi

if [[ "${1:-}" == "--base" ]]; then
  echo "$base_ref"

  exit 0
fi

git --no-pager diff "$@" "$base_ref...HEAD"
