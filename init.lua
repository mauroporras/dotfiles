-- To reload config:
-- :source %
-- :so $MYVIMRC

-- Leader.
vim.g.mapleader = ' '

local optNRM = { noremap = true }

-- {{{ Plugins installation.
-- Runs whenever this file is updated.
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
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

require('packer').startup(function(use)
  -- Packer can manage itself.
  use 'wbthomason/packer.nvim'

  -- Fzf.
  use {
   'junegunn/fzf',
   run = ':call fzf#install()'
  }
  use 'junegunn/fzf.vim'

  -- LSP and friends.
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

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
-- }}} Plugins installation.

-- Emmet.
vim.g.user_emmet_mode = 'i'

-- gitsigns.
require('gitsigns').setup()

-- floaterm.
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.9

-- {{{ LSP.
-- :LspInfo
-- :LspRestart

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions.
vim.keymap.set('n', '<Leader>cd', vim.diagnostic.open_float, {})
vim.keymap.set('n', '<C-p>', vim.diagnostic.goto_prev, {})
vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_next, {})

vim.keymap.set('n', '<Leader>E', ':LspRestart<CR>', {})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set('n', '<Leader>gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<Leader>gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<Leader>ch', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<Leader>cr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<Leader>gr', vim.lsp.buf.references, bufopts)
end

-- neoformat
vim.g.neoformat_try_node_exe = 1

-- {{{ nvim-cmp.
-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {
  'bashls',
  'cssls',
  'dartls',
  'diagnosticls',
  'dockerls',
  'html',
  'jsonls',
  'rust_analyzer',
  'stylelint_lsp',
  'svelte',
  'tailwindcss',
  'tsserver',
  'yamlls',
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Server-specific settings:
require'lspconfig'.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- luasnip setup
require('luasnip')

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
-- }}} nvim-cmp.
-- }}} LSP.

-- nvim-treesitter
--   See:
--     https://github.com/nvim-treesitter/nvim-treesitter#language-parsers
--   To update all parsers:
--     :TSUpdate
--   To list all available commands:
--     :h nvim-treesitter-commands
require('nvim-treesitter.configs').setup({
  -- A list of parser names, or "all"
  ensure_installed = 'all',

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
})

-- quick-scope.
vim.g.qs_highlight_on_keys = {
  'f',
  'F',
  't',
  'T',
}

-- vista.vim
vim.g.vista_blink = { 0, 0 }
vim.g.vista_sidebar_width = 50
vim.cmd([[
  let g:vista#renderer#enable_icon = 0
]])

-- Ranger.
--   Hide after picking a file.
vim.g.rnvimr_enable_picker = 1

-- Rg.
vim.cmd([[
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   "rg --follow --hidden --smart-case --no-ignore --glob '!{.git,dist,node_modules,tags}' --column --line-number --no-heading --color=always -- ".shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0
    \ )
]])

-- marks.
require'marks'.setup {
  default_mappings = false,
  refresh_interval = 333,
}

-- To find what's using a key map:
--   :verbose nmap <leader>b

-- See:
-- https://github.com/nanotee/nvim-lua-guide#defining-mappings

-- Command line (:h mapmode-c).
vim.api.nvim_set_keymap('c', '<C-a>', '<Home>', optNRM)
vim.api.nvim_set_keymap('c', '<C-b>', '<Left>', optNRM)
vim.api.nvim_set_keymap('c', '<C-d>', '<Del>', optNRM)
vim.api.nvim_set_keymap('c', '<C-f>', '<Right>', optNRM)

-- Terminal (:h mapmode-t).
vim.api.nvim_set_keymap('t', '<C-w>h', '<C-\\><C-n><C-w>h', optNRM)
vim.api.nvim_set_keymap('t', '<C-w>j', '<C-\\><C-n><C-w>j', optNRM)
vim.api.nvim_set_keymap('t', '<C-w>k', '<C-\\><C-n><C-w>k', optNRM)
vim.api.nvim_set_keymap('t', '<C-w>l', '<C-\\><C-n><C-w>l', optNRM)

-- Insert.
vim.api.nvim_set_keymap('i', '<C-a>', '<Home>', optNRM)
vim.api.nvim_set_keymap('i', '<C-b>', '<Left>', optNRM)
vim.api.nvim_set_keymap('i', '<C-d>', '<Del>', optNRM)
vim.api.nvim_set_keymap('i', '<C-e>', '<End>', optNRM)
vim.api.nvim_set_keymap('i', '<C-f>', '<Right>', optNRM)

-- Normal.
vim.api.nvim_set_keymap('n', '<Esc>', ':nohlsearch<CR><Esc>', optNRM)
vim.api.nvim_set_keymap('n', '<Down>', ':cnext<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Up>', ':cprevious<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>a', ':Rg<Space>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>i', ':FloatermNew lazygit<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>o', ':Files<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>S', ':GFiles?<CR>', optNRM)
--   Code.
vim.api.nvim_set_keymap('n', '<Leader>co', ':Vista!!<CR>', optNRM)
--   Scrolling.
vim.api.nvim_set_keymap('n', '<C-e>', '2<C-e>', optNRM)
vim.api.nvim_set_keymap('n', '<C-y>', '2<C-y>', optNRM)
vim.api.nvim_set_keymap('n', '<C-d>', '4<C-d>', optNRM)
vim.api.nvim_set_keymap('n', '<C-u>', '4<C-u>', optNRM)

--   Tabs.
vim.api.nvim_set_keymap('n', '<Leader>tt', ':$tabnew<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>tc', ':tabclose<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>th', ':-tabmove<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>tl', ':+tabmove<CR>', optNRM)

vim.api.nvim_set_keymap('n', '<Leader>w', ':Windows<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>yt', ':BTags<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>zh', ':History<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>zl', ':Lines<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>zm', ':Marks<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>zt', ':Tags<CR>', optNRM)

--   Buffers.
vim.api.nvim_set_keymap('n', '<Leader>b', ':Buffers<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>d', ':bdelete<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>e', ':edit!<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>l', ':edit #<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>n', ':bnext<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>p', ':bprevious<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>q', '<C-w>q', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>s', ':wall<CR>', optNRM)

--   gitsigns.
vim.api.nvim_set_keymap('n', '<Leader>vb', ':Gitsigns blame_line<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vD', ':Gitsigns toggle_deleted<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vd', ':Gitsigns diffthis<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vn', ':Gitsigns next_hunk<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vp', ':Gitsigns prev_hunk<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vR', ':Gitsigns reset_buffer<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vr', ':Gitsigns reset_hunk<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vS', ':Gitsigns stage_buffer<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vs', ':Gitsigns stage_hunk<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vu', ':Gitsigns undo_stage_hunk<CR>', optNRM)

--   leap.nvim
vim.api.nvim_set_keymap('n', '<Leader>/', '<Plug>(leap-forward-to)', {})
vim.api.nvim_set_keymap('n', '<Leader>?', '<Plug>(leap-backward-to)', {})

--   Ranger.
vim.api.nvim_set_keymap('n', '<Leader>r', ':RnvimrToggle<CR>', optNRM)
vim.api.nvim_set_keymap('t', '<M-r>', '<C-\\><C-n>:RnvimrResize<CR>', optNRM)

--   vim-which-key.
vim.api.nvim_set_keymap('n', '<Leader>', ":WhichKey '<Space>'<CR>", optNRM)

-- To show the current scheme:
--   :colorscheme
-- Use `:highlight` to list all color groups.
--   :h :highlight

-- Enable 24-bit RGB color.
-- See:
-- https://neovim.io/doc/user/options.html#'termguicolors'
vim.opt.termguicolors = true

vim.opt.background = 'light'

vim.cmd([[
  " See:
  " https://github.com/rakr/vim-one#italic-support
  let g:one_allow_italics = 1

  colorscheme one

  autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup = "HighlightedyankRegion", timeout = 400 })

  " Custom highlights.
  highlight HighlightedyankRegion guibg=violet guifg=black

  highlight LeapLabelPrimary guibg=cyan guifg=black

  highlight Comment gui=italic

  highlight StatusLine guibg=black guifg=white
  highlight StatusLineNC guibg=black guifg=lightgray

  highlight TabLine guibg=lightgray guifg=black
  highlight TabLineFill guibg=lightgray guifg=black
  highlight TabLineSel guibg=black guifg=white

  highlight VertSplit guibg=white guifg=black

  highlight IncSearch guibg=cyan guifg=black
  highlight Search guibg=cyan guifg=black
  highlight Substitute guibg=cyan guifg=black

  highlight clear MatchParen
  highlight MatchParen guibg=black guifg=magenta

  highlight QuickFixLine guibg=lime guifg=black

  highlight QuickScopePrimary guibg=cyan guifg=black
  highlight QuickScopeSecondary guibg=black guifg=cyan

  highlight CursorLine guibg=lightcyan
]])

-- Searching.
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Substituting.
vim.opt.inccommand = 'nosplit'

-- Misc.
vim.opt.completeopt = {
 'menu',
 'menuone',
 'noselect',
}
vim.opt.cursorline = true
vim.opt.cmdheight = 2
vim.opt.number = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.mouse = 'a'
vim.opt.signcolumn = 'auto:2'
vim.opt.listchars = {
  tab = '→ ',
  space = '·',
  nbsp = '␣',
  trail = '•',
  eol = '¶',
  precedes = '«',
  extends = '»',
}

vim.cmd([[
  " Recognize some extensions known to have JSON with comments.
  autocmd BufNewFile,BufRead tsconfig.json setlocal filetype=jsonc

  " To have Neoformat run Prettier on save:
  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END
]])
