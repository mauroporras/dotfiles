---
disable-model-invocation: true
context: fork
background: false
allowed-tools: Read, Write, Bash(git --no-pager diff *), Bash(git rev-parse *), Bash(gh issue create *)
model: sonnet
effort: medium
---

# Draft a GitHub issue from STAGED changes

## Context

- Current staged changes only: !`git --no-pager diff --staged`
- List of staged files: !`git --no-pager diff --staged --stat`
- Repository root (write the file here): !`git rev-parse --show-toplevel`

## Your task

Draft a GitHub issue based purely on the STAGED changes above (do not check the
branch name, existing issues, PR descriptions, or any other contextual clues),
then write it to a new `.md` file.

Unstaged and untracked changes do not exist for this skill: never mention them,
and never let them influence the issue.

Guard clause: if the staged diff above is empty, do NOT write a file.
Tell the user nothing is staged and stop.

REQUIRED:

- Frame the issue around the problem or feature the staged changes address, not
  a line-by-line description of the diff.
- Prioritize brevity over grammar:
  Keep the writing short, even if grammatically imperfect.
- Issue body structure (Markdown):
  - Start with a top-level `# <Title>` heading.
  - `## Summary`: one or two sentences on what the issue is about.
  - `## Context`: why this matters / the motivation behind the change.
  - `## Proposed changes`: a short bullet list of what should be done.
  - `## Acceptance criteria`: a short checklist (`- [ ]`) of what "done" looks like.
  - Omit any section that the staged changes give you nothing meaningful to say about.
- File:
  - Write to `<repository root>/issue-<short-kebab-title>.md`, where
    `<short-kebab-title>` is a brief kebab-case version of the issue title.
  - Immediately invoke the Write tool to create the file. Do not just print the
    contents, actually write them.
- After writing the file, end your turn by asking the user whether to create an
  actual GitHub issue from the draft (see Output, step 1). Do not create the
  issue in the same turn.
- Only create it if the user confirms in their reply. If they decline, stop.
- On confirmation, create the issue from the file's current contents (so any
  edits the user made are picked up):
  1. Read the file. The title is its top-level `# ` heading; the body is
     everything after that heading.
  2. Write the body alone to `<repository root>/issue-<short-kebab-title>.body.md`,
     so the title doesn't appear twice in the created issue.
  3. Run `gh issue create --title <title> --body-file <body file>`.

NEVER:

- Run additional Git commands.
- Commit or push.
- Create the GitHub issue without the user's explicit confirmation.

## Output

The skill replies in two steps. Use EXACTLY these formats and nothing else.

1. After writing the file:

   ```markdown
   Title: <the issue title you generated>
   File: <absolute path to the file you wrote>

   Create a GitHub issue from this draft? Edit the file first if you want to change the title or body.
   ```

2. After the user answers:

   ```markdown
   Issue: <the created issue URL, or `not created` if the user declined>
   ```
