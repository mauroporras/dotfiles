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
    -- Neovim 0.12+ ships a builtin "catppuccin" scheme; the official plugin
    -- renamed its scheme to "catppuccin-nvim" to avoid clashing with it.
    vim.cmd.colorscheme("catppuccin-nvim")
  end,
}
