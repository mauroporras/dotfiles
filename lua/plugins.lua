--[[
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
    },
  }

  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use {
    'L3MON4D3/LuaSnip', -- Snippets plugin
    tag = 'v2.*',
    run = 'make install_jsregexp',
  }

  -- Misc.
  use 'mrjones2014/legendary.nvim' -- NOTE: archived, consider migrating to which-key

  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
      { 'kkharji/sqlite.lua' }, -- Required by telescope-smart-history.nvim
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-frecency.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-smart-history.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
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
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup {
        view_options = {
          show_hidden = true,
        },
      }
    end,
  }

  -- Easy left and right motion.
  use 'unblevable/quick-scope'

  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {
        map_c_h = true,
        map_c_w = true,
      }
    end,
  }

  -- "nvim-navic" is used in "lualine".
  use {
    'SmiteshP/nvim-navic',
    config = function()
      require('nvim-navic').setup {
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
          TypeParameter = ' ',
        },
        lsp = {
          auto_attach = true,
        },
        separator = ' › ',
      }
    end,
  }

  use {
    'mikavilpas/yazi.nvim',
    requires = {
      { 'folke/snacks.nvim' },
    },
  }

  use 'github/copilot.vim'
--]]
