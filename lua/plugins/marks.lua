-- Show Vim marks in the sign column.
-- See:
--    :h mark
return {
  "chentoast/marks.nvim",
  event = "BufReadPost",
  opts = {
    default_mappings = false,
    refresh_interval = 333,
  },
}
