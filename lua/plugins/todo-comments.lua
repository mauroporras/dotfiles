-- Highlight todo, notes, etc in comments
return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  -- Lua utility library used by many plugins
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
  },
}
