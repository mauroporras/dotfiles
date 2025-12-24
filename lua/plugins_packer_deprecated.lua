--[[
-- LSP and friends.
-- See:
-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
-- https://github.com/neovim/nvim-lspconfig/wiki/Snippets
use("neovim/nvim-lspconfig") -- Collection of configurations for built-in LSP client

use({
  "hrsh7th/nvim-cmp", -- Autocompletion plugin
  requires = {
    { "hrsh7th/cmp-nvim-lsp" }, -- LSP source for nvim-cmp
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
  },
})

use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp
use({
  "L3MON4D3/LuaSnip", -- Snippets plugin
  tag = "v2.*",
  run = "make install_jsregexp",
})
--]]
