-- Jump to next/previous LSP reference with <M-n>/<M-p>
return {
  "mawkler/refjump.nvim",
  event = "BufReadPost",
  opts = {
    keymaps = {
      next = "<M-n>",
      prev = "<M-p>",
    },
  },
}
