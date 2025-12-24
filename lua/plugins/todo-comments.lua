-- Highlights in comments:
-- FIX: Something that needs to be fixed
-- TODO: Something that needs to be done
-- HACK: A workaround for a problem
-- WARN: Something that is potentially problematic
-- PERF: A code section that could be optimized for better performance
-- NOTE: Something important to note
-- TEST: A section of code that is used for testing
return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  -- Lua utility library used by many plugins
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
  },
}
