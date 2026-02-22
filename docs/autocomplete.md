# How Autocomplete Works

This dotfiles repo sets up autocomplete in two environments: the ZSH shell and
Neovim.

## Shell (ZSH)

Configured in `zsh/functions.zsh`:

1. **zsh-completions** (installed via Homebrew) provides completion scripts for
   common CLI tools. Added to the function path with:

   ```zsh
   FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
   ```

2. **compinit** initializes the ZSH completion system, which indexes all
   completion functions found in `FPATH`:

   ```zsh
   autoload -Uz compinit
   compinit
   ```

3. **Fuzzy matching** via `zstyle` enables case-insensitive and mid-word
   completion:

   ```zsh
   zstyle ':completion:*' matcher-list \
     'm:{[:lower:]}={[:upper:]}' \
     'r:|[._-]=* r:|=*' \
     'l:|=* r:|=*'
   ```

4. **FZF** (`zsh/env_vars.zsh`) adds interactive fuzzy completion for files and
   shell history with `source <(fzf --zsh)`.

## Neovim

### Completion engine: blink.cmp

Configured in `lua/plugins/lsp.lua`, [blink.cmp](https://github.com/saghen/blink.cmp)
is a fast, Rust-based completion engine. It aggregates four sources:

| Source     | What it provides                                      |
| ---------- | ----------------------------------------------------- |
| `lsp`      | Language-aware completions from LSP servers            |
| `path`     | File path completions                                 |
| `snippets` | Snippet expansions via LuaSnip (`lua/05_snippets.lua`) |
| `lazydev`  | Neovim Lua API completions                            |

Default keybindings:

- `<C-n>` / `<C-p>` — navigate the menu
- `<C-y>` — accept the selected item
- `<C-e>` — dismiss the menu
- `<C-Space>` — toggle menu and documentation
- `<C-k>` — toggle signature help

### LSP servers

Installed and managed by [Mason](https://github.com/mason-org/mason.nvim).
Enabled servers: `bashls`, `cssls`, `dockerls`, `html`, `jsonls`, `lua_ls`,
`svelte`, `tailwindcss`, `yamlls`, and `typescript-tools`.

Each server advertises blink.cmp's capabilities so the completions include
snippets, documentation, and resolve support.

### Snippets (LuaSnip)

Custom snippets are defined in `lua/05_snippets.lua` and cover JavaScript,
TypeScript, and Svelte. Examples:

- `af` — arrow function
- `cl` — `console.log()`
- `try` — try/catch block
- `c` — const declaration

### GitHub Copilot

Configured in `lua/plugins/copilot.lua`. Provides AI-powered inline suggestions
accepted with `<C-l>`.

### completeopt

Set in `lua/00_settings.lua`:

```lua
vim.opt.completeopt = { "menu", "menuone", "noselect" }
```

This shows the completion menu even for a single match and does not auto-select
the first item.
