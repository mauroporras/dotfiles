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
  use {
    'hrsh7th/nvim-cmp', -- Autocompletion plugin
    requires = {
      { 'hrsh7th/cmp-nvim-lsp' }, -- LSP source for nvim-cmp
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
    }
  }

  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

  -- Misc.
  use 'andrewradev/inline_edit.vim'
  use 'antonk52/vim-browserslist'
  use {
    "catppuccin/nvim",
    as = "catppuccin",
  }
  use 'chentoast/marks.nvim'
  use 'editorconfig/editorconfig-vim'
  use 'euclidianAce/BetterLua.vim'
  use 'folke/trouble.nvim'
  use 'ggandor/leap.nvim'
  use {
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure({
        providers = {
          'lsp',
          'treesitter',
        },
        delay = 200,
      })
    end
  }
  use 'kevinhwang91/rnvimr'
  use 'kevinoid/vim-jsonc'
  use 'lewis6991/gitsigns.nvim'
  use 'liuchengxu/vista.vim'
  use 'mattn/emmet-vim'
  use 'mrjones2014/legendary.nvim'
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end
  }
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.x',
    requires = {
      { "kkharji/sqlite.lua" },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-smart-history.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    }
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      { 'JoosepAlviste/nvim-ts-context-commentstring' },
    }
  }
  use 'sbdchd/neoformat'
  use 'unblevable/quick-scope'
  use 'voldikss/vim-floaterm'
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim.
  -- Put this at the end after all plugins.
  if packer_bootstrap then
    require('packer').sync()
  end
end)
