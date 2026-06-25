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
