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
      size = { height = "97%", width = "100%" },
      border = "none",
      sections = {
        left = { border = "rounded" },
        mid = { border = "rounded" },
        right = { border = "rounded" },
      },
    },
  },
}
