-- Fast navigation with search labels.
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    search = {
      multi_window = false,
      wrap = false,
    },
    modes = {
      char = {
        jump_labels = true,
        multi_line = false,
      },
    },
  },
  keys = {
    {
      "<Leader>/",
      mode = { "n" },
      function()
        require("flash").jump()
      end,
      desc = "Flash forward",
    },
    {
      "<Leader>?",
      mode = { "n" },
      function()
        require("flash").jump({ search = { forward = false } })
      end,
      desc = "Flash backward",
    },
  },
}
