-- Easy left and right motion.
return {
  "unblevable/quick-scope",
  event = "VeryLazy",
  init = function()
    vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
  end,
}
