-- File explorer that lets you edit the filesystem like a buffer.
return {
  "stevearc/oil.nvim",
  event = "VimEnter",
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
}
