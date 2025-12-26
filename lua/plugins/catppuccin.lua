-- TODO: check official docs
-- Soothing pastel colorscheme.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    flavour = "latte",
    -- Automatically detect installed plugins and enable their integrations.
    -- WARN: available on lazy.nvim only.
    auto_integrations = true,
    --[[
    integrations = {
      cmp = true,
      gitsigns = true,
      illuminate = true,
      lsp_trouble = true,
      native_lsp = { enabled = true },
      telescope = true,
      treesitter = true,
    },
    --]]
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
