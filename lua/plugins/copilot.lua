-- GitHub AI code completion.
return {
  "github/copilot.vim",
  event = "InsertEnter",
  init = function()
    vim.g.copilot_no_tab_map = true
  end,
  keys = {
    { "<C-l>", "<Plug>(copilot-accept-word)", mode = "i", desc = "Accept Copilot word" },
    { "<C-j>", "<Plug>(copilot-accept-line)", mode = "i", desc = "Accept Copilot suggestion" },
  },
}
