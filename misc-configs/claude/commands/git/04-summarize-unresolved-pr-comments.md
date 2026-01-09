---
description: Fetch and summarize this PR's UNRESOLVED comments
---

Create a markdown tracking file for unresolved PR comments.

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

Output a markdown file named `pr-{number}-comments.md` (using the actual PR number) in the current directory with this format:

```markdown
# PR Review Comments

> [PR Title](PR URL)

## Unresolved Comments

- [ ] **@author** `#fix-null-check` in `path/to/file.ext:line`
  > Add null check before accessing property

- [ ] **@author** `#rename-variable` in `path/to/file.ext:line`
  > Use more descriptive variable name
```

Generate descriptive tags based on the comment content (e.g., `#fix-null-check`, `#add-error-handling`, `#rename-variable`) so I can copy-paste them to reference specific comments. Summarize each comment concisely instead of quoting the full text. Group comments by file path if there are multiple in the same file. Use checkboxes so I can track progress.

If there are no unresolved comments, do not create the file. Just inform me that there are no unresolved comments.
