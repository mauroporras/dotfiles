-- Show Vim marks in the sign column.

-- See:
--   :h mark

-- 'x (single quote):
--   Jump to the beginning of the line where mark "x" was set.
-- `x (backtick):
--   Jump to the exact cursor position (row and column) where mark "x" was set.

-- The following default mappings are included:
--   dmx       Delete mark x
--   dm-       Delete all marks on the current line
--   dm<Space> Delete all marks in the current buffer
--   m]        Move to next mark
--   m[        Move to previous mark
--   m:        Preview mark. This will prompt you for a specific mark to
--             preview; press <cr> to preview the next mark.
return {
  "chentoast/marks.nvim",
  event = "BufReadPost",
  opts = {
    -- Disable all default keymaps
    -- default_mappings = false,
    refresh_interval = 333,
  },
}
