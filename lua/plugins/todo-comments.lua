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
  keys = {
    { "<Leader>ma", "<Cmd>TodoTelescope<CR>", desc = "All to-do marks" },
    { "<Leader>mf", "<Cmd>TodoTelescope keywords=FIX<CR>", desc = "FIX to-do marks" },
    { "<Leader>mt", "<Cmd>TodoTelescope keywords=TODO<CR>", desc = "TODO to-do marks" },
    { "<Leader>mh", "<Cmd>TodoTelescope keywords=HACK<CR>", desc = "HACK to-do marks" },
    { "<Leader>mw", "<Cmd>TodoTelescope keywords=WARN<CR>", desc = "WARN to-do marks" },
    { "<Leader>mp", "<Cmd>TodoTelescope keywords=PERF<CR>", desc = "PERF to-do marks" },
    { "<Leader>mn", "<Cmd>TodoTelescope keywords=NOTE<CR>", desc = "NOTE to-do marks" },
    { "<Leader>ms", "<Cmd>TodoTelescope keywords=TEST<CR>", desc = "TEST to-do marks" },
    { "<Leader>mq", "<Cmd>TodoQuickFix<CR>", desc = "QuickFix all to-do marks" },
  },
  opts = {
    signs = false,
  },
}
