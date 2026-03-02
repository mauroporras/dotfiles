-- GitHub AI code completion.
return {
  "github/copilot.vim",
  event = "BufReadPost",
  -- See `:h copilot-maps`
  init = function()
    -- To avoid clashing with blink.cmp tab-for-snippet-jumping.
    vim.g.copilot_no_tab_map = true
  end,
  keys = {
    {
      "<C-l>",
      "copilot#AcceptWord()",
      mode = "i",
      expr = true,
      replace_keycodes = false,
      desc = "Accept Copilot word",
    },
    {
      "<C-j>",
      'copilot#Accept("\\<CR>")',
      mode = "i",
      expr = true,
      replace_keycodes = false,
      desc = "Accept Copilot full suggestion",
    },
  },
}
