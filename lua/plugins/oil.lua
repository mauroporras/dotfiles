-- File explorer that lets you edit the filesystem like a buffer.
return {
  "stevearc/oil.nvim",
  event = "VeryLazy",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    skip_confirm_for_simple_edits = true,
    delete_to_trash = true,
    view_options = {
      show_hidden = true,
    },
  },
}
