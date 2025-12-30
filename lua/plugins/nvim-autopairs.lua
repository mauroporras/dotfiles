-- Auto-close brackets, quotes, and other pairs.
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    -- Map the <C-h> key to delete a pair.
    map_c_h = true,
    -- Map <c-w> to delete a pair if possible.
    map_c_w = true,
  },
}
