# settings.local.json in nested directories

Since v2.1.211, Claude Code keeps `.claude/settings.local.json` at the git repo root, and "Yes, don't ask again" approvals are saved there.

When launched from a subdirectory (e.g. `apps/web`), it also still reads a `settings.local.json` in that directory. The docs treat that nested copy as one "an earlier version left there", so this may be backward compatibility that a later release drops. Launched from the root, it reads only the root's copy.

When both load:

- List settings merge: `additionalDirectories` from both apply, and spinner tips from both show.
- For single values the root file wins: with `outputStyle` set to `"Concise"` at the root and to `"Explanatory"` in `apps/web`, a session launched in `apps/web` still ran Concise.

So a nested copy can add list entries but can't override the root. Prefer putting everything in the root file.

## Exceptions and related rules

- The local file stays in the starting directory when there's no git repo, when the repo root is your home directory, on Windows, or when the repo root, its `.git`, or its `.claude` isn't owned by you.
- The shared `.claude/settings.json` is different: it's read only from the directory you start in, with no repo-root fallback.
- Relative paths in `additionalDirectories` and permission rules resolve against the starting directory, not the file's location. `plansDirectory` resolves "relative to the project root", which the docs leave undefined.

## Checking

Run `/status` and check "Setting sources": it lists the files that loaded, but not which file supplied each key.

Tested on 2026-11-26 and checked against https://code.claude.com/docs/en/settings.
