-- File explorer that lets you edit the filesystem like a buffer.
return {
  "stevearc/oil.nvim",
  event = "VeryLazy",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    skip_confirm_for_simple_edits = true,
    delete_to_trash = true,
    -- Free up <C-h>/<C-l> (oil binds them by default) so they fall through
    -- to the global window-navigation mappings.
    keymaps = {
      ["<C-h>"] = false,
      ["<C-l>"] = false,
    },
    view_options = {
      show_hidden = true,
    },
  },
}
