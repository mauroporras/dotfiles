# Example configs

## Updating Claude skills

Skills installed with the [`skills`](https://skills.sh) CLI are pinned in `skills-lock.json` and don't auto-update. Refresh them with:

```bash
npx skills update          # update all
npx skills update <name>   # update one
```

## Agent instructions

Instructions shared by every agent go in `AGENTS.md`. `CLAUDE.md` pulls them in with an
`@AGENTS.md` import and adds only the Claude-specific rules below it, so there's one copy
of the shared rules instead of one per agent.
