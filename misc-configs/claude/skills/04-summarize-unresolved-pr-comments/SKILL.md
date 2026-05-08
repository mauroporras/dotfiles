---
disable-model-invocation: true
allowed-tools: Write, Bash(gh:*)
---

# Fetch and summarize this PR's UNRESOLVED comments

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
          id
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

ALWAYS:

- Filter the results to only show threads where `isResolved: false`
- Include comments from all authors, including automated reviewers (e.g., Copilot, bots)
- Do not skip or filter out comments based on the author

### Step 2: Fetch top-level "Changes Requested" reviews

Top-level review comments (the body of a review, not attached to a specific file line) are not captured by `reviewThreads`.
Fetch them separately:

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

ALWAYS:

Include reviews that have a non-empty `body` (skip reviews where the body is blank or only whitespace). These represent top-level change requests that aren't tied to a specific file/line.

### Step 3: Create file

Create a file named `pr-{pr-number}-comments.md` in the current directory, like this:

```markdown
# PR #{pr-number} Review Comments

Title: {pr-title}
URL: {pr-url}

## Files

### {path/to/file.ext}

#### #{unique-descriptive-tag}

- [ ] Done

Line: {path/to/file.ext:line}
Author: @{the-author}
Thread ID: {thread-id}
_Comment:_
{comment}

## Contentious Comments

{Highlight any comments that you'd push back on}
```

ALWAYS:

- Break comment lines at around 80 characters
- Use the checkboxes to track progress
- For inline comments:
  Group by file path if there are multiple in the same file
- For top-level reviews:
  Include a link to the review URL
- Omit any section that has no items
- If there are no unresolved comments, do not create the file
  Just inform the user that there are no unresolved comments
- When you're done:
  Suggest the first tag to start working on and ask if the user wants to address it
