-- Show keybindings popup when pressing a prefix key.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- Document existing key chains
    spec = {
      { "<leader>c", group = "[C]ode" },
      { "<leader>F", group = "[F]olding" },
      { "<leader>g", group = "[G]o to using LSP" },
      { "<leader>m", group = "[M]isc" },
      { "<leader>t", group = "[T]abs" },
      { "<leader>v", group = "[V]ersioning" },
      { "<leader>x", group = "Diagnostics" },
      { "<leader>z", group = "Misc" },
    },
  },
}
