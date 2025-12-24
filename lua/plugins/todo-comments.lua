-- Highlight todo, notes, etc in comments
return {
  "folke/todo-comments.nvim",
  event = "BufReadPost",
  -- Lua utility library used by many plugins
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
  },
}
