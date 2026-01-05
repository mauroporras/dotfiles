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
  version = "*", -- use the latest stable version
  dependencies = {
    -- Lua utility library used by many plugins
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  opts = {
    -- Empty table disables the annoying highlight visual effect.
    highlight_groups = {
      hovered_buffer = {},
      hovered_buffer_in_same_directory = {},
    },
    -- INFO: out of the box fullscreen is broken, so we use a hook instead.
    --
    -- floating_window_scaling_factor = 1,
    -- yazi_floating_window_border = "none",
    hooks = {
      before_opening_window = function(window_options)
        window_options.width = vim.o.columns
        window_options.height = math.floor(vim.o.lines * 0.9)
      end,
    },
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
