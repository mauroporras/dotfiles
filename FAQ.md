# FAQ

## Fonts

### Why not use slab fonts?

Slab serifs add weight to each glyph, so they need a bigger font size to stay
legible. That eats screen space for no real readability gain over a clean
sans-serif monospace at a smaller size.

### Font history

Fonts this repo has used over time, and where they lived:

- **2015** — **Ubuntu Mono**. The original GVim `guifont`, lasted ~3 months.
- **2015–2018** — **Inconsolata / Inconsolata-g for Powerline**. GVim `guifont`.
- **2018** — **FiraCode**. First real terminal font, in iTerm2, ~9 months. Left it
  because I don't use ligatures.
- **2018–2019** — **Roboto Mono**. iTerm2's non-ASCII/fallback font, never primary.
- **2018–2024** — **Input** (InputMono → InputMonoNarrow, later patched to Nerd
  Font). ~6 years across iTerm2, Hyper, and Alacritty. Longest-serving font by far.
  Dropped when I moved from Alacritty to Kitty: Input wasn't a Homebrew cask and
  needed manual `fontforge` patching for Nerd Font glyphs, whereas cask fonts
  install directly and Kitty added builtin Nerd symbols in v0.36.0.
- **2024** — **Operator Mono**. Never actually used; it was just Kitty's shipped
  example config comment, not a font I chose.
- **2024–2026** — **Iosevka Fixed**. ~2 years across Kitty then Ghostty.
- **2026** — revisited two old favorites and reverted both: **Inconsolata-g for
  Powerline** and **Input** (now a one-line `font-input` cask, so the old patching
  hassle is gone). Both feel outdated now.
- **2026** — **JetBrains Mono NL**.
  - Renders better in small sizes.
  - Feels modern, clean, and legible.
  - The NL variant doesn't have ligatures.
  - It's the default font for the other JetBrains products I use.

## Terminal

### Never remap these keys

These are readline bindings used by the shell.

`ctrl` + `h`

Used to delete back.

`ctrl` + `a`

Used to go to the beginning of the line.

## Git

### Why not use mergiraf?

[mergiraf](https://mergiraf.org/) is a syntax-aware merge driver: it compares parse trees instead of lines, so it can resolve conflicts that are only conflicts because someone reindented or reformatted. Tried it, dropped it.

- **It forces `merge.conflictStyle = diff3`.** That rules out `zdiff3`, which hoists the lines common to both sides out of the conflict region instead of repeating them inside it. Since most conflicts still land on me (see below), losing `zdiff3` costs more than mergiraf gives back. It also fails silently: under `zdiff3` it simply stops resolving, with no warning.
- **It doesn't help with the common cases.** Conflicting additions to an ordered sequence (statements in a block, items in a list, arguments to a call) are left unresolved by design, because insertion order carries meaning it can't infer. That's most real conflicts. What it does solve is the reindent/reformat class.
- **Where it does merge, the result can break linting.** Two branches each adding an import merges cleanly but in arbitrary order, which fails a sorted-imports rule.
- **It resolves silently.** Same objection as `rerere`, which is disabled here for the same reason: a wrong resolution lands in a commit under my name with nothing marking it. `mergiraf review` can inspect a resolution, but only if you remember to ask.

Worth revisiting if it ever drops the `diff3` requirement.

## Neovim

### Why use `quick-scope` over `flash.nvim`'s char mode?

flash.nvim's char mode requires pressing two keys for change motions (e.g., `cf` then two characters), which makes simple `f/F/t/T` motions slower. quick-scope just highlights the unique characters on the line without changing how the motions work.

### Why not use `scrolloff`?

It adds extra lines above and below the cursor, which can be disorienting. The cursor should stay exactly where you put it without the editor shifting content around. Use `zz` to manually center the cursor when needed.

### Useful commands

#### Open files in diff mode

```sh
nvim -d file1.txt file2.txt
```

#### Use a session file

Write:

`:mks`

Load:

```sh
nvim -S [Session.vim]
```

#### Use an alternate shada file

If you work on multiple projects and want different histories, registers, marks, and command histories for each, you can save and load a project-specific shada file.

Write:

`:wsha custom.shada`

Load:

```sh
nvim -i custom.shada
```

## Agents

### Why keep the ground rules in `AGENTS.md`?

[AGENTS.md](https://agents.md) is the file most coding agents already look for, so a
single copy in `misc-configs/agents/AGENTS.md` covers all of them. A per-vendor copy of
the same rules would drift the moment one of them is edited and the other isn't.

Claude Code is the exception: it reads `CLAUDE.md`, not `AGENTS.md`. `bootstrap` handles
that by symlinking `~/.claude/CLAUDE.md` to the shared file. Projects do the same with an
`@AGENTS.md` import, see `example-configs/CLAUDE.md`.

## Claude

### Why disable `autoMemoryEnabled`?

I prefer explicit CLAUDE.md over implicit memory. I don't want some comment I made to become the law.

## Nix

### Start a temporary Nix shell environment

```sh
nix-shell --command zsh -p go
```
