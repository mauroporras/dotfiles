---
description: Fetch and summarize this PR's UNRESOLVED comments
---

Format them as "Author: #unique-tag" so we can address them one by one.

Use the GraphQL API to get only unresolved review threads:

```bash
gh api graphql -f query='
query($owner: String!, $repo: String!, $pr: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $pr) {
      url
      title
      reviewThreads(first: 100) {
        nodes {
          isResolved
          comments(first: 10) {
            nodes {
              author { login }
              body
              path
              line
            }
          }
        }
      }
    }
  }
}' -f owner="$(gh repo view --json owner -q .owner.login)" -f repo="$(gh repo view --json name -q .name)" -F pr="$(gh pr view --json number -q .number)"
```

Filter the results to only show threads where `isResolved: false`.
