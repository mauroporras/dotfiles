return {
  "lewis6991/gitsigns.nvim",
  opts = {},
  keys = {
    { "<Leader>vb", "<cmd>Gitsigns blame_line<CR>", desc = "Blame line" },
    { "<Leader>vD", "<cmd>Gitsigns toggle_deleted<CR>", desc = "Toggle deleted" },
    { "<Leader>vd", "<cmd>Gitsigns diffthis<CR>", desc = "Diff this" },
    { "<Leader>vn", "<cmd>Gitsigns next_hunk<CR>", desc = "Next hunk" },
    { "<Leader>vp", "<cmd>Gitsigns prev_hunk<CR>", desc = "Prev hunk" },
    { "<Leader>vR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset buffer" },
    { "<Leader>vr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset hunk" },
    { "<Leader>vS", "<cmd>Gitsigns stage_buffer<CR>", desc = "Stage buffer" },
    { "<Leader>vs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage hunk" },
    { "<Leader>vu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk" },
  },
}
