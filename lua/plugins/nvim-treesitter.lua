-- Treesitter provides syntax highlighting and code parsing.
-- Highlight, edit, and navigate code
-- See: `:h lsp-vs-treesitter`
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- NOTE: this plugin does not support lazy-loading.
  build = ":TSUpdate",
  config = function()
    -- Install parsers (no-op if already installed)
    require("nvim-treesitter").install({
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
    })

    -- Enable treesitter highlighting for all filetypes
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })

    -- Enable treesitter-based indentation (experimental)
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
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
--]]
