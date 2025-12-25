-- TODO: check official docs
-- Pretty list for diagnostics, quickfix, LSP references, etc.
return {
  "folke/trouble.nvim",
  -- Empty opts table tells lazy.nvim to call setup() with default settings.
  -- Without this, setup() won't be called and the plugin won't initialize.
  opts = {},
  keys = {
    { "<Leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
    { "<Leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
  },
}
