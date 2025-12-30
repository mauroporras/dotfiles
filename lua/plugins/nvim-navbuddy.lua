-- Breadcrumb navigation popup for LSP symbols.
return {
  "SmiteshP/nvim-navbuddy",
  cmd = "Navbuddy",
  keys = {
    { "<leader>cn", "<cmd>Navbuddy<cr>", desc = "Navbuddy" },
  },
  dependencies = {
    -- Ensure lspconfig loads first since auto_attach hooks into LSP clients.
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lsp = {
      auto_attach = true,
    },
    window = {
      size = "80%",
      border = "rounded",
    },
  },
}
