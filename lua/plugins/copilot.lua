-- TODO: check official docs
-- GitHub AI code completion.
return {
  "github/copilot.vim",
  event = "InsertEnter",
  -- See `:h copilot-maps`
  keys = {
    { "<C-l>", "<Plug>(copilot-accept-word)", mode = "i", desc = "Accept Copilot word" },
  },
}
