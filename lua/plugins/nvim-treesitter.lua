-- Treesitter provides syntax highlighting and code parsing.
-- Highlight, edit, and navigate code
-- See: `:h lsp-vs-treesitter`
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- NOTE: this plugin does not support lazy-loading.
  build = ":TSUpdate",
  ---@alias lazyvim.TSConfig: TSConfig
  opts = {
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
      "luap",
      "make",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "scss",
      "svelte",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  },
  config = function(_, opts)
    local TS = require("nvim-treesitter")

    TS.setup(opts)
  end,
}

-- WARN: Don't delete this, kept for reference.

-- See `:h nvim-treesitter`
-- A list of parser names, or "all"
--   See:
--     https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
--   To update all parsers:
--     :TSUpdate
--   List installed:
--     :TSInstallInfo
--   To list all available commands:
--     :h nvim-treesitter-commands

--[[
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
  "luap",
  "make",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "query",
  "regex",
  "scss",
  "svelte",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
},
--]]
