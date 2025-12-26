-- GitHub AI code completion.
return {
  "github/copilot.vim",
  event = "BufReadPost",
  -- See `:h copilot-maps`
  keys = {
    { "<C-l>", "<Plug>(copilot-accept-word)", mode = "i", desc = "Accept Copilot word" },
  },
}
