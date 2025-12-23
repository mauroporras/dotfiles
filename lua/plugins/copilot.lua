-- GitHub AI code completion.
return {
  "github/copilot.vim",
  event = "InsertEnter",
  keys = {
    { "<C-l>", "<Plug>(copilot-accept-word)", mode = "i", desc = "Accept Copilot word" },
  },
}
