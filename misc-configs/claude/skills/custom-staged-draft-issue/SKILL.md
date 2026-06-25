---
disable-model-invocation: true
context: fork
allowed-tools: Read, Write, Bash(git --no-pager diff:*), Bash(git rev-parse:*), Bash(gh issue create:*)
model: haiku
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
- After writing the file, ask the user whether to create an actual GitHub issue
  from the draft. Make clear they can edit the draft file first, since they may
  want to tweak the title or body before it becomes a real issue:
  - Only create it if the user confirms. If they decline (or do not answer),
    stop after writing the file.
  - On confirmation, create the issue from the file's current contents (so any
    edits the user made are picked up): run
    `gh issue create --title <title> --body-file <file>`, taking the title from
    the file's top-level `# ` heading and `<file>` as the path you wrote.

NEVER:

- Run additional Git commands.
- Commit or push.
- Create the GitHub issue without the user's explicit confirmation.

## Output

After writing the file (and, if confirmed, creating the issue), report the result
using EXACTLY this format, one field per line and nothing else:

```bash
Title: <the issue title you generated>
File: <absolute path to the file you wrote>
Issue: <the created issue URL, or `not created` if the user declined>
```
