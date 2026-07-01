# FAQ

## Fonts

### Iosevka Term vs Iosevka Fixed

Why `Iosevka Fixed`:

- **Term** scales wide glyphs down to fit one cell. May look compressed.
- **Fixed** disables ligatures instead. No scaling, natural proportions.

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
  needed manual `fontforge` patching for Nerd Font glyphs, whereas Iosevka
  installs directly and Kitty added builtin Nerd symbols in v0.36.0.
- **2024** — **Operator Mono**. Never actually used; it was just Kitty's shipped
  example config comment, not a font I chose.
- **2024–2026** — **Iosevka Fixed**. ~2 years across Kitty then Ghostty.
- **2026** — revisited two old favorites and reverted both: **Inconsolata-g for
  Powerline** and **Input** (now a one-line `font-input` cask, so the old patching
  hassle is gone). Both feel outdated now.

## Terminal

### Never remap these keys

These are readline bindings used by the shell.

`ctrl` + `h`

Used to delete back.

`ctrl` + `a`

Used to go to the beginning of the line.

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

## Claude

### Why disable `autoMemoryEnabled`?

I prefer explicit CLAUDE.md over implicit memory. I don't want some comment I made to become the law.

## Nix

### Start a temporary Nix shell environment

```sh
nix-shell --command zsh -p go
```
