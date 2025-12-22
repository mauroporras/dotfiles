return {
  "lewis6991/gitsigns.nvim",
  opts = {},
  keys = {
    { "<Leader>vb", ":Gitsigns blame_line<CR>", desc = "Blame line" },
    { "<Leader>vD", ":Gitsigns toggle_deleted<CR>", desc = "Toggle deleted" },
    { "<Leader>vd", ":Gitsigns diffthis<CR>", desc = "Diff this" },
    { "<Leader>vn", ":Gitsigns next_hunk<CR>", desc = "Next hunk" },
    { "<Leader>vp", ":Gitsigns prev_hunk<CR>", desc = "Prev hunk" },
    { "<Leader>vR", ":Gitsigns reset_buffer<CR>", desc = "Reset buffer" },
    { "<Leader>vr", ":Gitsigns reset_hunk<CR>", desc = "Reset hunk" },
    { "<Leader>vS", ":Gitsigns stage_buffer<CR>", desc = "Stage buffer" },
    { "<Leader>vs", ":Gitsigns stage_hunk<CR>", desc = "Stage hunk" },
    { "<Leader>vu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk" },
  },
}
