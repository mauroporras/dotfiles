-- Treesitter provides syntax highlighting and code parsing.
-- Highlight, edit, and navigate code
-- See: `:h lsp-vs-treesitter`
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
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

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        -- List of parsers to ignore installing (for "all")
        ignore_install = {},

        highlight = {
          -- `false` will disable the whole extension
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          disable = {},

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
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
  -- "cpp", -- Takes too long
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
