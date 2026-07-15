---
name: custom-docs-doctor
description: "Audit and clean a repo's markdown docs for agent-context rot: completed-work logs, executed plans never rewritten, stale facts, internal contradictions, dead paths, superseded \"source of truth\" docs the code has outgrown."
disable-model-invocation: true
---

<!--
Inspired by:
  - The native `/doctor` skill
  - https://github.com/aka-luan/doc-cleanup/tree/main/skills/doc-cleanup
-->

# custom-docs-doctor: remove context rot from agent-facing docs

Docs that agents must read every session are paid for in context tokens and,
worse, in wrong conclusions: a stale fact in an "authoritative" doc beats a
correct fact an agent never looks up. This skill audits, then archives history
and rewrites live docs down to current facts.

**Two-stage contract: diagnosis (phases 1-3), then execution (phases 4-5)
only after the user approves the report.** Always surface the report and wait
for the user's approval before rewriting any doc.

## Phase 1: Inventory

1. Snapshot `git status --porcelain` before touching anything. The worktree
   may already be dirty; phase 5 can only verify "we changed nothing but the
   intended docs" by diffing against this baseline, not against clean. If any
   markdown is already modified, note it in the report (its on-disk content
   may not match what the user thinks is committed) and copy it as-is to a
   scratch directory: a status diff is blind to further edits to an
   already-dirty file, so phase 5 needs a content baseline for those.
2. `git ls-files -coz --exclude-standard '*.md' '*.mdx' '*.markdown' |
   xargs -0 wc -l | grep -v ' total$' | sort -rn`.
   `-co --exclude-standard` covers tracked _and_ untracked docs while
   `.gitignore` still excludes vendored dirs (`node_modules`, `dist`, ...) for
   free; `-z`/`-0` survives paths with spaces; the `grep -v` drops the `total`
   lines `wc` emits (one per `xargs` batch on large repos) so they don't
   pollute the ranking.
3. Read the agent-entry docs (`CLAUDE.md`, `AGENTS.md`, and every doc they
   instruct agents to read before working). Entry surfaces are broader than
   those two files: `.claude/rules/`, the repo's own skills (their bodies load
   on every invocation), and other agents' equivalents if present
   (`.cursor/rules`, `.github/copilot-instructions.md`). These cost context in
   _every_ session, so weight them highest. A 400-line doc read once a month
   is cheap; a 150-line doc on the "read before you code" list is expensive.

## Phase 2: Diagnose (read-only)

Scope: the full entry surface from phase 1, plus the largest non-entry docs
(top ~10 by line count). Cap the reading in a big repo: cover that bounded set,
and list what was skipped in the report so the user can extend the audit.

Scoping is fully automatic, this skill's own job, so the invoker stays
hands-off: the entry-surface + largest-docs rule plus the skipped list in the
report keep invocation zero-config; the user narrows or extends scope by
replying to the report, rather than guessing a path up front.

Before flagging anything, **verify against the code**: grep for referenced
files, symbols, constants, and line refs. Doc claims are hypotheses; the repo
is the evidence. This governs every pattern below, extending past stale facts.

Hunt six rot patterns. For each hit, note file, lines, and severity.

1. **Completed-work logs.** Checklists that are ~all `[x]`, phase logs full of
   ✅, implementation narratives, bug post-mortems, verification transcripts.
   History belongs in git and archives, not in every session's context.
2. **Executed plans never rewritten.** A plan/strategy doc whose steps all
   shipped reads as _intent_ but is consumed as _fact_, and its pre-decision
   analysis (superseded tables, rejected options) actively misleads.
3. **Internal contradictions.** A table "fixed" by a supersession note below
   it instead of being edited; the same fact stated with two values in one
   doc; stacked dated addenda where a later one reverses an earlier one.
4. **Stale facts vs code.** Typical finds: renamed components, changed config
   values, wrong `file.ts:NN` refs, "awaiting merge" statuses for work
   already on main (`git merge-base --is-ancestor`).
5. **Dead paths.** Old OS paths after a machine migration, moved sibling
   repos, deleted files, tooling that no longer exists.
6. **Authority drift.** A doc crowned "source of truth" (design spec, API
   contract) that the code has legitimately outgrown. Agents will "fix"
   correct code back toward the stale spec.

Also mark what is **load-bearing and must survive**: hard rules, recurring
traps/gotchas, do-not-do warnings, domain glossaries. Recurring traps count as
live guidance even when they were discovered historically.

**Leave these alone.** Some docs are historical by design and legitimately so:
`CHANGELOG.md`, release notes, ADRs (Architecture Decision Records),
post-mortem directories, and archive dirs (`docs/archive/`, `docs/history/`,
`attic/`, ...), including this skill's own output from a previous run, which
is completed-work logs by construction. They look like pattern 1, but agents
skip them in normal sessions, so they cost little context; leave them off the
report.

## Phase 3: Report

Present findings worst-first, each with concrete evidence (quote the
contradiction, show the failed grep). Rank by context cost × misdirection
risk. For each file to be removed or gutted, propose archive vs. delete
(git history retains deleted content anyway; an archive dir is more
discoverable for humans but adds markdown to the repo) and let the user
choose per file. Exception: the git-history safety net is absent for
untracked docs (phase 1 includes them via `-o`; confirm with
`git ls-files --error-unmatch <file>`), so deleting one is permanent. Propose
archive for those, and if the user still wants delete, mark it as
irrecoverable in the report. Propose the cleanup plan and stop for approval.

## Phase 4: Execute (after approval)

Per-file playbook:

- **Archive by default; delete only where the user chose it in the report.**
  If the repo already has an archive convention (`docs/history/`, `attic/`,
  ...), use it; otherwise default to `docs/archive/`. Copy the old doc (or
  extracted section) verbatim to
  `docs/archive/<path-with-dashes>-<YYYY-MM>.md`, encoding the original path
  so same-named docs from different dirs can't collide (`api/README.md` →
  `docs/archive/api-README-<YYYY-MM>.md`). If the archive file already exists,
  stop and ask instead of overwriting; this is also the backstop for the rare
  dash-encoding collision (`api/README.md` vs a literal `api-README.md` map
  to the same name). Verify the copy _before_ rewriting the
  live doc: `diff <file> <archive-file>` (for an extracted section, re-read
  the archived text against the original instead).
- **Rewrite the live doc to current facts only**, with a one-line pointer to
  the archive. Every fact you write must be re-verified against code at write
  time; re-derive each claim rather than copying it forward from the old doc.
- **Point at sources of truth instead of duplicating them** (the config
  constant, the schema file), so the doc stays anchored against future drift.
- **Collapse done checklists** to one-line `✅` summaries; keep only open
  items, with their original wording.
- **Keep the traps.** Extract recurring gotchas from archived logs into the
  live doc (short, imperative) before archiving the log.
- **Banner superseded authorities** rather than rewriting them: a status
  block at the top saying what drifted and that code + the deviation log win.
- **Fix entry docs** (CLAUDE.md/AGENTS.md/README): dead paths, feature claims
  for things the code lacks, absent pointers to the cleaned docs.

## Phase 5: Verify

- Every relative link in touched live docs resolves. New archive files are
  exempt: they are verbatim copies moved to a new directory, so their
  relative links may dangle by construction. Rewriting them would break the
  verbatim `diff` guarantee, and dead links in an archive cost little since
  agents skip it in most sessions (see "Leave these alone").
- `git status --porcelain`, diffed against the phase 1 snapshot, shows only
  the intended markdown files as new changes. The status diff is blind to
  files that were already dirty at phase 1; `diff` those against their
  phase 1 scratch copies instead.

## Delegation

The execute phase is bulk clear-spec work, suitable for a cheaper model via
subagent, with a self-contained spec listing every verified fact it needs (it
should rely on those facts rather than re-deriving them). Diagnosis and the
final diff review need judgment:
do those in the main thread. Always review the subagent's diff line-by-line;
expect to catch small semantic errors (e.g. "unlocks manual moderation"
flattened to "moderation: manual").
