-- Yazi file manager integration.
---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  dependencies = {
    -- Lua utility library used by many plugins
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  opts = {
    floating_window_scaling_factor = 1.0,
  },
  keys = {
    { "<Leader>f", "<cmd>Yazi<CR>", desc = "Open file manager at the current file" },
    -- Commented to free up <Leader>F for folding keymaps
    -- I almost never use these keymaps.
    -- { "<Leader>Fc", "<cmd>Yazi cwd<CR>", desc = "Open file manager focused on the cwd" },
    -- { "<Leader>Fl", "<cmd>Yazi toggle<CR>", desc = "Resume last yazi session" },
  },
}
