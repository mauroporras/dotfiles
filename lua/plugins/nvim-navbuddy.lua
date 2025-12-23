-- Breadcrumb navigation popup for LSP symbols.
return {
  "SmiteshP/nvim-navbuddy",
  cmd = "Navbuddy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lsp = {
      auto_attach = true,
    },
  },
}
