-- Easy left and right motion.
return {
  "unblevable/quick-scope",
  keys = { "f", "F", "t", "T" },
  init = function()
    vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
    vim.g.qs_buftype_blacklist = { "terminal", "nofile" }
  end,
}
