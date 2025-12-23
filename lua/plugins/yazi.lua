-- Yazi file manager integration.
return {
  "mikavilpas/yazi.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  keys = {
    { "<Leader>f", "<cmd>Yazi<CR>", desc = "Open file manager focused on the current file" },
    -- Commented to free up <Leader>F for folding keymaps
    -- I almost never use these keymaps.
    -- { "<Leader>Fc", "<cmd>Yazi cwd<CR>", desc = "Open file manager focused on the cwd" },
    -- { "<Leader>Fl", "<cmd>Yazi toggle<CR>", desc = "Resume last yazi session" },
  },
}
