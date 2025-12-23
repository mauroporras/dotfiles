-- Git signs in the sign column, plus hunk actions.
return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
  keys = {
    { "<Leader>vb", "<cmd>Gitsigns blame_line<CR>", desc = "Blame line" },
    { "<Leader>vB", "<cmd>Gitsigns blame<CR>", desc = "Blame current buffer" },
    { "<Leader>vd", "<cmd>Gitsigns diffthis<CR>", desc = "Diff this" },
    { "<Leader>vD", "<cmd>Gitsigns toggle_deleted<CR>", desc = "Toggle deleted" },
    { "<Leader>vn", "<cmd>Gitsigns nav_hunk next<CR>", desc = "Next hunk" },
    { "<Leader>vp", "<cmd>Gitsigns nav_hunk prev<CR>", desc = "Prev hunk" },
    { "<Leader>vP", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk inline" },
    { "<Leader>vr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset hunk" },
    { "<Leader>vR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset buffer" },
    { "<Leader>vs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage hunk" },
    { "<Leader>vS", "<cmd>Gitsigns stage_buffer<CR>", desc = "Stage buffer" },
    { "<Leader>vu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk" },
    { "<Leader>vq", "<cmd>Gitsigns setqflist<CR>", desc = "Hunks to quickfix" },
  },
  -- Empty opts table tells lazy.nvim to call setup() with default settings.
  -- Without this, setup() won't be called and the plugin won't initialize.
  opts = {},
  --[[
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  },
  --]]
}
