-- Yazi file manager integration.
--
-- Default keybindings when Yazi is open:
--   <C-v> open selected file(s) in vertical splits
--   <C-x> open selected file(s) in horizontal splits
--   <C-t> open selected file(s) in new tabs
--   <C-q> send selected file(s) to quickfix list
--   <Tab> jump to open buffer
---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  dependencies = {
    -- Lua utility library used by many plugins
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  opts = {
    floating_window_scaling_factor = 1,
    yazi_floating_window_border = "none",
  },
  keys = {
    {
      "<Leader>f",
      mode = { "n", "v" },
      "<cmd>Yazi<CR>",
      desc = "Open file manager at the current file",
    },
    -- Commented to free up <Leader>F for folding keymaps
    -- I almost never use these keymaps.
    -- { "<Leader>Fc", "<cmd>Yazi cwd<CR>", desc = "Open file manager focused on the cwd" },
    -- { "<Leader>Fl", "<cmd>Yazi toggle<CR>", desc = "Resume last yazi session" },
  },
}
