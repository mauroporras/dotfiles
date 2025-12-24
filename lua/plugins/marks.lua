-- Show Vim marks in the sign column.
-- See:
--    :h mark
--
-- 'a (single quote):
--   Jump to the beginning of the line where mark "a" was set.
-- `a (backtick):
--   Jump to the exact cursor position (row and column) where mark "a" was set.
return {
  "chentoast/marks.nvim",
  event = "BufReadPost",
  opts = {
    -- Disable all default keymaps
    -- default_mappings = false,
    refresh_interval = 333,
  },
}
