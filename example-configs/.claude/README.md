# settings.local.json in nested directories

When Claude Code is launched from a subdirectory of a git repo (e.g. `apps/web`), it loads `.claude/settings.local.json` from both that directory and the repo root. Launched from the root, it loads only the root's copy.

List settings merge across the two files: `additionalDirectories` from both apply, and spinner tips from both show. For single values the root file wins: with `outputStyle` set to `"Concise"` at the root and to `"Explanatory"` in `apps/web`, a session launched in `apps/web` still ran Concise.

So a nested copy can add list entries but can't override the root. Put shared values at the root, and only subdirectory extras in the nested file. To see what loaded, run `/status` and check "Setting sources".

Tested on 2026-11-26.
