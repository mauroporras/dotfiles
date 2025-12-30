-- Breadcrumb navigation popup for LSP symbols.
return {
  "SmiteshP/nvim-navbuddy",
  cmd = "Navbuddy",
  dependencies = {
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lsp = {
      auto_attach = true,
    },
  },
}
