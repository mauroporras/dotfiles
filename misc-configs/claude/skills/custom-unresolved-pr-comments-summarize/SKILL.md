---
disable-model-invocation: true
allowed-tools: Write, Bash(bash:*)
---

# Fetch and summarize this PR's UNRESOLVED comments

## Context

The data has already been fetched and filtered for you below. Use this
precomputed JSON verbatim; do NOT re-run any commands or re-fetch anything.

<!--
The fetch lives in fetch-unresolved-comments.sh because skill `!` commands are
statically analyzed and reject the `$(...)` substitution the GraphQL calls need.
The script resolves owner/repo/pr, queries the API, and applies every filter
(drops resolved threads and blank-body reviews), so the model only writes prose.
-->

- Unresolved comments data (JSON): !`bash "$HOME/.claude/skills/custom-unresolved-pr-comments-summarize/fetch-unresolved-comments.sh"`

The JSON has this shape:

```json
{
  "prNumber": 0,
  "filename": "pr-0-comments.md",
  "url": "https://github.com/owner/repo/pull/0",
  "title": "PR title",
  "unresolvedThreads": [
    {
      "threadId": "…",
      "comments": [{ "author": "…", "body": "…", "path": "…", "line": 0 }]
    }
  ],
  "reviews": [
    {
      "author": "…",
      "body": "…",
      "url": "…",
      "state": "CHANGES_REQUESTED",
      "submittedAt": "…"
    }
  ]
}
```

`unresolvedThreads` already excludes resolved threads (all authors kept,
including bots). `reviews` already excludes blank/whitespace-only bodies.

## Your task

Write a markdown file summarizing the unresolved comments above. Everything
mechanical (fetching, filtering resolved threads, dropping blank-body reviews)
is already done; build the file purely from the precomputed Context JSON.

### Guard clause

If both `unresolvedThreads` and `reviews` are empty, do NOT create the file.
Just inform the user that there are no unresolved comments and stop.

### Create the file

Create the file named by the `filename` field (from the Context JSON) in the
current directory, like this:

```markdown
# PR #{prNumber} Review Comments

Title: {title}
URL: {url}

## Files

### {path/to/file.ext}

#### #{unique-descriptive-tag}

- [ ] Done

Line: {path/to/file.ext:line}
Author: @{the-author}
Thread ID: {threadId}
Comment:
{comment}

## Contentious Comments

{Highlight any comments that you'd push back on}
```

ALWAYS:

- Source every field from the precomputed Context JSON:
  - `{prNumber}`/`{title}`/`{url}` from the top-level fields
  - inline comments from `unresolvedThreads`, top-level reviews from `reviews`
- Break comment lines at around 80 characters
- Use the checkboxes to track progress
- For inline comments:
  Group by file path if there are multiple in the same file
- For top-level reviews:
  Include a link to the review URL
- Omit any section that has no items
- When you're done:
  Suggest the first tag to start working on and ask if the user wants to address it
