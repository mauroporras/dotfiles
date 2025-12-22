return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    integrations = {
      cmp = true,
      gitsigns = true,
      illuminate = true,
      lsp_trouble = true,
      native_lsp = { enabled = true },
      telescope = true,
      treesitter = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin-latte")
  end,
}
