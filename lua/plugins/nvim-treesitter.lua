-- Treesitter provides syntax highlighting and code parsing.
-- Highlight, edit, and navigate code
-- See: `:h lsp-vs-treesitter`
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- NOTE: this plugin does not support lazy-loading.
  build = ":TSUpdate",
  -- See `:h nvim-treesitter`
  opts = {
    -- A list of parser names, or "all"
    --   See:
    --     https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
    --   To update all parsers:
    --     :TSUpdate
    --   To list all available commands:
    --     :h nvim-treesitter-commands
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      "cpp",
      "css",
      "diff",
      "dockerfile",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "json5",
      "jsonc",
      "lua",
      "luadoc",
      "make",
      "markdown",
      "markdown_inline",
      "query",
      "regex",
      "scss",
      "svelte",
      "toml",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { "ruby" },
    },
    indent = { enable = true, disable = { "ruby" } },
  },
}
