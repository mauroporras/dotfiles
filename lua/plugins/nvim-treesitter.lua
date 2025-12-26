-- TODO: check official docs
-- Syntax highlighting and code parsing.
--
-- See
--   `:h lsp-vs-treesitter`
--   `:h nvim-treesitter`
-- NOTE: if troubles `:checkhealth nvim-treesitter`
return {
  "nvim-treesitter/nvim-treesitter",
  -- WARN:This plugin does not support lazy-loading.
  lazy = false,
  build = ":TSUpdate",
  config = function(_, opts)
    -- For a list of parser names:
    --   https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
    -- Update all parsers `:TSUpdate`
    -- List installed `:checkhealth nvim-treesitter`
    -- List all available commands `:h nvim-treesitter-commands`
    -- View treesitter AST `:InspectTree`
    require("nvim-treesitter").install({
      "bash",
      "c",
      "cmake",
      "cpp",
      "css",
      "diff",
      "dockerfile", -- TODO: fix docker
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
      "sql",
      "svelte",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    })
  end,
}
