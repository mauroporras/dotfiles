# Example configs

## Adding log4brains for ADR

```bash
pnpm install -D log4brains
```

And then:

```bash
pnpm exec log4brains init
```

## Updating Claude skills

Skills installed with the [`skills`](https://skills.sh) CLI are pinned in `skills-lock.json` and don't auto-update. Refresh them with:

```bash
npx skills update          # update all
npx skills update <name>   # update one
```
