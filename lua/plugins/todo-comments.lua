-- Highlights in comments:
--
-- FIX: Something that needs to be fixed
-- FIXME: Something that needs to be fixed
-- BUG: A bug that needs to be resolved
-- FIXIT: Something that needs to be fixed
-- ISSUE: An issue that needs attention
--
-- TODO: Something that needs to be done
--
-- HACK: A workaround for a problem
--
-- WARN: Something that is potentially problematic
-- WARNING: Something that is potentially problematic
-- XXX: Something that is potentially problematic
--
-- PERF: A code section that could be optimized for better performance
-- OPTIM: A code section that could be optimized
-- PERFORMANCE: A code section that could be optimized for better performance
-- OPTIMIZE: A code section that could be optimized
--
-- NOTE: Something important to note
-- INFO: Informational comment
--
-- TEST: A section of code that is used for testing
-- TESTING: A section of code that is used for testing
-- PASSED: A test that has passed
-- FAILED: A test that has failed
--
-- NOTE: To see all the keywords and their settings, run the following command in Neovim:
-- :lua print(vim.inspect(require("todo-comments.config").options.keywords
return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  -- Lua utility library used by many plugins
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<Leader>ma", "<Cmd>TodoTelescope<CR>", desc = "Telescope all to-do marks" },
    { "<Leader>mf", "<Cmd>TodoTelescope keywords=FIX,FIXME,BUG,FIXIT,ISSUE<CR>", desc = "Telescope FIX to-do marks" },
    { "<Leader>mt", "<Cmd>TodoTelescope keywords=TODO<CR>", desc = "Telescope TODO to-do marks" },
  },
  opts = {
    signs = false,
  },
}
