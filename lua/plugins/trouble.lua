return {
  "folke/trouble.nvim",
  opts = {},
  keys = {
    { "<Leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
    { "<Leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
  },
}
