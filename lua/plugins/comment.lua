-- Toggle comments
--
-- Neovim already has built-in commenting functionality, but this plugin provides
-- more advanced features.
--
-- Keymaps:
--   Normal:
--     gcc        Toggle line (linewise)
--     gbc        Toggle line (blockwise)
--     gco        Insert comment below, enter insert mode
--     gcO        Insert comment above, enter insert mode
--     gcA        Insert comment at end of line, enter insert mode
return {
  "numToStr/Comment.nvim",
  event = "BufReadPost",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  opts = function()
    return {
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    }
  end,
}
