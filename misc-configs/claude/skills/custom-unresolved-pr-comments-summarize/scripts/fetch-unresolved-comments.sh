#!/usr/bin/env bash

# Emits a single JSON object with everything the skill needs, already filtered:
# resolved threads dropped, blank-body reviews dropped. Lives in a script because
# skill `!` Context commands are statically analyzed and reject the `$(...)`
# command substitution this fetch requires.

set -euo pipefail

owner=$(gh repo view --json owner -q .owner.login)
repo=$(gh repo view --json name -q .name)
pr=$(gh pr view --json number -q .number)

threads=$(gh api graphql -f query='query($owner:String!,$repo:String!,$pr:Int!){repository(owner:$owner,name:$repo){pullRequest(number:$pr){url title reviewThreads(first:100){nodes{id isResolved comments(first:10){nodes{author{login} body path line}}}}}}}' -f owner="$owner" -f repo="$repo" -F pr="$pr")

reviews=$(gh api graphql -f query='query($owner:String!,$repo:String!,$pr:Int!){repository(owner:$owner,name:$repo){pullRequest(number:$pr){reviews(first:100,states:[CHANGES_REQUESTED]){nodes{author{login} body url state submittedAt}}}}}' -f owner="$owner" -f repo="$repo" -F pr="$pr")

jq -n --argjson t "$threads" --argjson r "$reviews" --arg pr "$pr" '{
  prNumber: ($pr | tonumber),
  filename: ("pr-" + $pr + "-comments.md"),
  url: $t.data.repository.pullRequest.url,
  title: $t.data.repository.pullRequest.title,
  unresolvedThreads: [
    $t.data.repository.pullRequest.reviewThreads.nodes[]
    | select(.isResolved == false)
    | {threadId: .id, comments: [.comments.nodes[] | {author: .author.login, body, path, line}]}
  ],
  reviews: [
    $r.data.repository.pullRequest.reviews.nodes[]
    | select((.body // "" | gsub("\\s"; "")) != "")
    | {author: .author.login, body, url, state, submittedAt}
  ]
}'
