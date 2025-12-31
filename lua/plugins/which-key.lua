-- Show keybindings popup when pressing a prefix key.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-mini/mini.icons",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    delay = 1000, -- 1 second timeout
    -- Document existing key chains
    notify = true,
    plugins = {
      spelling = { enabled = true },
    },
    spec = {
      { "<leader>c", group = "[C]ode", icon = "💻" },
      { "<leader>F", group = "[F]olding", icon = "📁" },
      { "<leader>g", group = "[G]o to using LSP", icon = "🔍" },
      { "<leader>m", group = "To-do [M]arks", icon = "✅" },
      { "<leader>t", group = "[T]abs", icon = "📑" },
      { "<leader>v", group = "[V]ersioning", icon = "🌿" },
      { "<leader>x", group = "Diagnostics", icon = "⚠️" },
      { "<leader>z", group = "Misc", icon = "🔧" },
    },
  },
}
