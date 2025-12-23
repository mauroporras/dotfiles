-- Auto-close brackets, quotes, and other pairs.
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    map_c_h = true,
    map_c_w = true,
  },
}
