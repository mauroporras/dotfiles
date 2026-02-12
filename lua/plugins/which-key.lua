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
      -- spelling = { enabled = true },
    },
    spec = {
      { "<Leader>c", group = "[C]ode", icon = "💻" },
      { "<Leader>F", group = "[F]olding", icon = "📁" },
      { "<Leader>g", group = "[G]o to using LSP", icon = "🔍" },
      { "<Leader>m", group = "To-do [M]arks", icon = "✅" },
      { "<Leader>t", group = "[T]abs", icon = "📑" },
      { "<Leader>v", group = "[V]ersioning", icon = "🌿" },
      { "<Leader>x", group = "Diagnostics", icon = "⚠️" },
      { "<Leader>z", group = "Misc", icon = "🔧" },
    },
  },
}
