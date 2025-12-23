-- Yazi file manager integration.
return {
  "mikavilpas/yazi.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  keys = {
    { "<Leader>f", "<cmd>Yazi<CR>", desc = "Open file manager focused on the current file" },
    { "<Leader>Fc", "<cmd>Yazi cwd<CR>", desc = "Open file manager focused on the cwd" },
    { "<Leader>Fl", "<cmd>Yazi toggle<CR>", desc = "Resume last yazi session" },
  },
}
