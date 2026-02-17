---
description: Fetch and summarize this PR's UNRESOLVED comments
disable-model-invocation: true
allowed-tools: Write, Bash(gh:*)
---

## Context

- OWNER: !`gh repo view --json owner -q .owner.login`
- REPO: !`gh repo view --json name -q .name`
- PR_NUMBER: !`gh pr view --json number -q .number`

## Your task

### Step 1: Fetch unresolved inline review threads

Use this GraphQL query (substitute OWNER, REPO, PR_NUMBER from context above):

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
}' -f owner="OWNER" -f repo="REPO" -F pr=PR_NUMBER
```

Filter the results to only show threads where `isResolved: false`. Include comments from all authors, including automated reviewers (e.g., Copilot, bots). Do not skip or filter out comments based on the author.

### Step 2: Fetch top-level "Changes Requested" reviews

Top-level review comments (the body of a review, not attached to a specific file line) are not captured by `reviewThreads`. Fetch them separately:

```bash
gh api graphql -f query='
query($owner: String!, $repo: String!, $pr: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $pr) {
      reviews(first: 100, states: [CHANGES_REQUESTED]) {
        nodes {
          author { login }
          body
          url
          state
          submittedAt
        }
      }
    }
  }
}' -f owner="OWNER" -f repo="REPO" -F pr=PR_NUMBER
```

Include reviews that have a non-empty `body` (skip reviews where the body is blank or only whitespace). These represent top-level change requests that aren't tied to a specific file/line.

Create a markdown file named `pr-{number}-comments.md` (using the actual PR number) in the current directory with this format:

```markdown
# PR Review Comments

> [PR Title](PR URL)

## Unresolved Inline Comments

- [ ] **@author** `#fix-null-check` in `path/to/file.ext:line`

  > Add null check before accessing property

- [ ] **@author** `#rename-variable` in `path/to/file.ext:line`

  > Use more descriptive variable name

## Changes Requested (top-level reviews)

- [ ] **@author** `#descriptive-tag` ([review](review URL))

  > Concise summary of the top-level review feedback
```

Generate unique descriptive tags based on the comment content (e.g., `#fix-null-check`, `#add-error-handling`, `#rename-variable`) so I can copy-paste them to reference specific comments. Summarize each comment concisely instead of quoting the full text.

For inline comments: group by file path if there are multiple in the same file.
For top-level reviews: include a link to the review URL.

Use checkboxes so I can track progress. Omit any section that has no items (e.g., if there are no top-level reviews, omit the "Changes Requested" section).

If there are no unresolved comments, do not create the file. Just inform me that there are no unresolved comments.

After creating the file, suggest the first tag to start working on and ask if I want to address it. I'll reference comments by their tag (e.g., `#fix-null-check`).
