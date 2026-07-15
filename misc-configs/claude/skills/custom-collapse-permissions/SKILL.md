---
name: custom-collapse-permissions
description: "Collapse the current directory's .claude/settings.local.json permissions.allow list: fold one-off, machine-specific, and near-duplicate entries into a few broad wildcard patterns, dedupe, and group by tool for readability, keeping deny/ask exactly as they are."
disable-model-invocation: true
allowed-tools: Read, Edit
---

# Collapse a permissions.allow list

Claude Code settings files accrete `permissions.allow` entries over time: every
approved one-off command gets appended verbatim, so the list fills with
hardcoded commit hashes, absolute machine paths, and a dozen variants of the
same command. This skill rewrites the `allow` list down to a small set of broad
patterns that grant the same access, so it stays readable and portable.

**Only ever touch `permissions.allow`.** Keep `deny`, `ask`,
`additionalDirectories`, `hooks`, and every other key byte-for-byte identical.
Collapsing is about `allow`; a collapse must keep `deny`/`ask` exactly as narrow
as they already are.

## Which file

Only ever operate on `.claude/settings.local.json` in the current working
directory. Treat every other settings file (`.claude/settings.json`,
`~/.claude/settings.json`, or a user-supplied path) as off-limits and leave it
as-is. If that file is missing, tell the user and stop.

Read the file first. If `permissions.allow` is absent or already ≤ a handful of
entries, say there's nothing worth collapsing and stop.

## How to collapse

The goal: fewest entries that grant the **same or intentionally-broader** access,
always at least as broad as before (a narrower rewrite silently revokes a
permission the user relied on). Work rule by rule:

1. **Group by tool and command head.** Bucket every entry by its permission
   tool (`Bash`, `Read`, `WebFetch`, `PowerShell`, ...) and, for `Bash`, by the
   first meaningful token(s) of the command (`git`, `npx tsc`, `lsof`, `awk`).

2. **Fold a group into one wildcard when the head is safe to generalize.**
   Many specific invocations sharing a head collapse to `Bash(<head> *)`:
   - `git log ...`, `git diff ...`, `git show <hash> ...`,
     `git -C "C:/..." ...`, `git stash`, `git config` → `Bash(git *)`.
   - three `node .tmp_replace*.cjs` → `Bash(node .tmp_replace*)`.
   - `lsof -nP -iTCP ...` variants → `Bash(lsof *)`.
   - two `awk '...'` one-offs → `Bash(awk *)`; `echo` one-offs → `Bash(echo *)`.
   Prefer the tightest wildcard that still covers the group: collapse
   `node .tmp_replace*.cjs` to `Bash(node .tmp_replace*)` rather than `Bash(node *)`,
   because the latter grants far more than the group ever contained.

3. **Keep entries that resist safe generalization.** These stay verbatim:
   - **Domain-scoped `WebFetch`** (`WebFetch(domain:github.com)`): dropping the
     domain would widen it to fetching anywhere.
   - **Specific `Read`/path globs** (`Read(//tmp/**)`,
     `Read(//Users/.../boms/**)`): these are already scoped grants.
   - **A single complex command** that stands alone, lacking siblings to merge
     (e.g. the `PowerShell(Get-NetTCPConnection ...)` pipeline): generalizing a lone entry
     to `PowerShell(*)` widens access with negligible readability benefit. Leave
     it as-is.

4. **Keep each privilege boundary intact.** Fold heads together only when they
   share a privilege level; keep a read-only head and a mutating head in
   separate wildcards even when they share a binary. `git` is treated as one
   head here by the user's own prior grants (they already allowed
   `git stash`/`git config`), so `Bash(git *)` is fine; but leave a command like
   `Bash(rm -rf /tmp/x)` verbatim, and keep wildcards scoped to a specific head
   rather than a bare `Bash(*)`.

5. **Dedupe and sort.** Remove exact duplicates and any entry now subsumed by a
   wildcard you introduced. Then sort the survivors as a single flat list in
   case-insensitive ascending order (plain string comparison of each entry as
   written, so `Bash(...)` naturally clusters before `Read(...)` /
   `WebFetch(...)`). One deterministic order, driven purely by the sort so it
   stays stable. Preserve the file's existing indentation and JSON style exactly.

## Apply and report

- Rewrite only the `allow` array, via `Edit`. Keep valid JSON (trailing commas,
  quoting, indentation matching the surrounding file).
- After the `Edit`, stop there: leave running it through tooling and committing
  to the user.
- Report the before/after entry count and list the notable folds (e.g. "12 git
  entries → `Bash(git *)`") and what you deliberately kept verbatim and why.

## Guardrail

If collapsing would require guessing whether a rewrite widens or narrows access
(an ambiguous head, an unfamiliar command), keep the original entries and note
them as "left as-is: unsafe to collapse" rather than risk changing what the
user can do.
