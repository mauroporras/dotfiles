-- This file is external to init.lua so that it doesn't
-- trigger `PackerSync` every time it changes.

-- Runs whenever this file is updated.
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Install "packer.nvim" if not present.
-- See:
-- https://github.com/wbthomason/packer.nvim#bootstrapping
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    print('Packer has been installed into "' .. install_path .. '". Restart Neovim and run `:PackerSync`.')
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Packer can manage itself.
  use 'wbthomason/packer.nvim'

  -- LSP and friends.
  -- See:
  -- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
  -- https://github.com/neovim/nvim-lspconfig/wiki/Snippets
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

  -- Fzf.
  use {
   'junegunn/fzf',
   run = ':call fzf#install()'
  }
  use 'junegunn/fzf.vim'

  -- Misc.
  use 'andrewradev/inline_edit.vim'
  use 'antonk52/vim-browserslist'
  use 'chentoast/marks.nvim'
  use 'editorconfig/editorconfig-vim'
  use 'euclidianAce/BetterLua.vim'
  use 'ggandor/leap.nvim'
  use 'jiangmiao/auto-pairs'
  use 'kevinhwang91/rnvimr'
  use 'kevinoid/vim-jsonc'
  use 'lewis6991/gitsigns.nvim'
  use 'liuchengxu/vista.vim'
  use {
    'liuchengxu/vim-which-key',
    cmd = { 'WhichKey', 'WhichKey!' },
  }
  use 'mattn/emmet-vim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  use 'p00f/nvim-ts-rainbow'
  use 'rakr/vim-one'
  use 'sbdchd/neoformat'
  use 'tpope/vim-commentary'
  use 'unblevable/quick-scope'
  use 'voldikss/vim-floaterm'

  -- Automatically set up your configuration after cloning packer.nvim.
  -- Put this at the end after all plugins.
  if packer_bootstrap then
    require('packer').sync()
  end
end)
