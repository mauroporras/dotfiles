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
  use {
    'L3MON4D3/LuaSnip', -- Snippets plugin
    tag = "v2.*",
    run = "make install_jsregexp",
  }

  -- Misc.
  use {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require('catppuccin').setup({
        integrations = {
          cmp = true,
          lsp_trouble = true,
          native_lsp = {
            enabled = true,
          },
          telescope = true,
          treesitter = true,
        }
      })
    end
  }

  use 'chentoast/marks.nvim'
  use 'euclidianAce/BetterLua.vim'

  use 'folke/trouble.nvim'

  -- Highlight other uses of the word under the cursor.
  use 'RRethy/vim-illuminate'

  use 'lewis6991/gitsigns.nvim'

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('ibl').setup({
        indent = {
          char = '│',
        },
        scope = {
          show_start = false,
          show_end = false,
        }
      })
    end
  }

  use 'mattn/emmet-vim'
  use 'mrjones2014/legendary.nvim'

  use {
    'numToStr/Comment.nvim',
    requires = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end
  }

  use 'nvim-lualine/lualine.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
      { "kkharji/sqlite.lua" }, -- Required by telescope-smart-history.nvim
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-frecency.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-smart-history.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    }
  }

  use 'nvim-tree/nvim-web-devicons'

  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    run = ':TSUpdate',
  }

  use {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          css = { 'prettierd' },
          html = { 'prettierd' },
          javascript = { 'prettierd' },
          javascriptreact = { 'prettierd' },
          json = { 'prettierd' },
          jsonc = { 'prettierd' },
          lua = { 'stylua' },
          markdown = { 'prettierd' },
          scss = { 'prettierd' },
          svelte = { 'prettierd' },
          typescript = { 'prettierd' },
          typescriptreact = { 'prettierd' },
          yaml = { 'prettierd' },
        },
        format_on_save = {},
      })
    end
  }

  use {
    'SmiteshP/nvim-navbuddy',
    requires = {
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('nvim-navbuddy').setup({
        lsp = {
          auto_attach = true,
        },
      })
    end
  }

  use({
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
      })
    end,
  })

  use 'unblevable/quick-scope'

  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        map_c_h = true,
        map_c_w = true
      })
    end
  }

  -- "nvim-navic" is used in "lualine".
  use {
    'SmiteshP/nvim-navic',
    config = function()
      require('nvim-navic').setup({
        icons = {
          File = ' ',
          Module = ' ',
          Namespace = ' ',
          Package = ' ',
          Class = ' ',
          Method = ' ',
          Property = ' ',
          Field = ' ',
          Constructor = ' ',
          Enum = ' ',
          Interface = ' ',
          Function = ' ',
          Variable = ' ',
          Constant = ' ',
          String = ' ',
          Number = ' ',
          Boolean = ' ',
          Array = ' ',
          Object = ' ',
          Key = ' ',
          Null = ' ',
          EnumMember = ' ',
          Struct = ' ',
          Event = ' ',
          Operator = ' ',
          TypeParameter = ' '
        },
        lsp = {
          auto_attach = true,
        },
        separator = ' › ',
      })
    end
  }

  use {
    'mikavilpas/yazi.nvim',
    requires = {
      { 'folke/snacks.nvim' },
    }
  }

  -- Automatically set up your configuration after cloning packer.nvim.
  -- Put this at the end after all plugins.
  if packer_bootstrap then
    require('packer').sync()
  end
end)
