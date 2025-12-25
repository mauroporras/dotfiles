-- Treesitter provides syntax highlighting and code parsing.
-- Highlight, edit, and navigate code
-- See: `:h lsp-vs-treesitter`
return {
  "nvim-treesitter/nvim-treesitter",
  -- WARN:This plugin does not support lazy-loading.
  lazy = false,
  build = ":TSUpdate",
  config = function(_, opts)
    require("nvim-treesitter").install({})
  end,
}
