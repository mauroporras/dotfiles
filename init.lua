-- To reload config:
-- :source %
-- :so $MYVIMRC

require('plugins')
require('snippets')

-- Leader.
vim.g.mapleader = ' '

local optNRM = { noremap = true }

-- {{{ LSP.
-- :LspInfo
-- :LspRestart

-- See:
-- https://github.com/neovim/nvim-lspconfig#suggested-configuration

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions.
vim.keymap.set('n', '<Leader>cd', vim.diagnostic.open_float, optNRM)
vim.keymap.set('n', '<Leader>n', vim.diagnostic.goto_next, optNRM)
vim.keymap.set('n', '<Leader>p', vim.diagnostic.goto_prev, optNRM)

vim.keymap.set('n', '<Leader>E', ':LspRestart<CR>', optNRM)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set('n', '<Leader>gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<Leader>ch', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<Leader>cr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
end

-- neoformat
vim.g.neoformat_try_node_exe = 1

-- {{{ nvim-cmp.
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

-- Put plugins with server-specific settings here:
require('lspconfig').lua_ls.setup({
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
})

-- luasnip setup
local luasnip = require('luasnip')

-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-5),
    ['<C-d>'] = cmp.mapping.scroll_docs(5),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  },
}
-- }}} nvim-cmp.
-- }}} LSP.

-- {{{ nvim-treesitter
--   See:
--     https://github.com/nvim-treesitter/nvim-treesitter#language-parsers
--   To update all parsers:
--     :TSUpdate
--   To list all available commands:
--     :h nvim-treesitter-commands
require('nvim-treesitter.configs').setup({
  -- A list of parser names, or "all"
  ensure_installed = {
    'bash',
    'c',
    'cmake',
    'cpp',
    'css',
    'diff',
    'dockerfile',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'json5',
    'jsonc',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'regex',
    'rust',
    'scss',
    'svelte',
    'toml',
    'typescript' ,
    'vim',
    'yaml',
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

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

  -- See:
  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
})
-- }}} nvim-treesitter

-- Emmet.
vim.g.user_emmet_mode = 'i'

-- gitsigns.
require('gitsigns').setup()

-- floaterm.
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.9

-- folke/trouble.nvim
require("trouble").setup {
  icons = false,
  fold_open = "v", -- icon used for open folds
  fold_closed = ">", -- icon used for closed folds
  indent_lines = false, -- add an indent guide below the fold icons
  signs = {
    -- icons / text used for a diagnostic
    error = "error",
    information = "info",
    hint = "hint",
    warning = "warn",
  },
  use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
}

-- lualine
local custom_lualine_theme = require('lualine.themes.codedark')

custom_lualine_theme.inactive = {
  c = {
    bg = 'gray',
    fg = 'lightgray',
  }
}

require('lualine').setup({
  options = {
    theme = custom_lualine_theme,
  },
  sections = {
    lualine_a = {},
    lualine_b = { 'diff', 'diagnostics' },
    lualine_c = {
      {
        'filename',
        path = 1,
      },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        path = 1,
      }
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_b = { 'branch' },
    lualine_c = {
      {
        'tabs',
        mode = 2,
        separator = { right = '' },
      },
    },
  },
  winbar = {
    lualine_a = { 'filename' },
    lualine_c = { 'navic' },
  },
  inactive_winbar = {
    lualine_c = { 'filename' },
  },
})

-- nvim-telescope/telescope.nvim
-- Old command for fzf was:
-- ```bash
-- rg --files --follow --hidden --smart-case --no-ignore-vcs --glob '!{.git,dist,node_modules,tags}'
-- ```
local telescope = require('telescope')

telescope.setup({
  defaults = {
    dynamic_preview_title = true,
    history = {
      path = '~/.local/share/nvim/telescope_history.sqlite3',
      limit = 100,
    },
    -- :h telescope.layout
    layout_strategy = 'vertical',
    layout_config = {
      height = 999,
      prompt_position = 'top',
      scroll_speed = 4,
      width = 999,
    },
    sorting_strategy = 'ascending',
    -- :h telescope.defaults.vimgrep_arguments
    vimgrep_arguments = {
      "rg",
      -- Defaults:
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      -- Custom:
      "--follow",
      "--hidden",
      "--no-ignore-vcs",
    },
    -- See:
    -- :h telescope.mappings
    -- If the function you want is part of `telescope.actions`,
    -- then you can simply give a string.
    mappings = {
      i = {
        ['<C-n>'] = 'cycle_history_next',
        ['<C-p>'] = 'cycle_history_prev',
        ['<C-j>'] = 'move_selection_next',
        ['<C-k>'] = 'move_selection_previous',
        ['<C-q>'] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist ,
        ['<C-d>'] = false,
        ['<C-u>'] = false,
      },
    },
    prompt_prefix = '',
  },
  extensions = {
    frecency = {
      show_scores = true,
    }
  },
  pickers = {
    -- :h telescope.builtin.find_files
    find_files = {
      find_command = {
        "rg",
        "--files",
        "--follow",
        "--hidden",
        "--smart-case",
        "--no-ignore-vcs",
      }
    },
  },
})

telescope.load_extension('frecency')
telescope.load_extension('fzf')
telescope.load_extension('smart_history')
telescope.load_extension('ui-select')

-- quick-scope.
vim.g.qs_highlight_on_keys = {
  'f',
  'F',
  't',
  'T',
}

-- ranger.nvim
require("ranger-nvim").setup({
  ui = {
    border = "rounded",
    height = 0.8,
    width = 0.9,
  }
})

-- vista.vim
vim.g.vista_blink = { 0, 0 }
vim.g.vista_sidebar_width = 50
vim.cmd([[
  let g:vista#renderer#enable_icon = 0
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
require('legendary').setup({
  keymaps = {
    { '<Esc>', ':nohlsearch<CR><Esc>', description = 'Stop the highlighting for the search.' },
    { '<Leader>a', ':Telescope live_grep<CR>', description = 'Search in all files.' },
    { '<Leader>A', ':Telescope grep_string<CR>', description = 'Searches string under your cursor.' },
    { '<Leader>b', ':Telescope buffers<CR>', description = 'List buffers.' },
    { '<Leader>gd', ':Telescope lsp_definitions<CR>', description = 'LSP definition of word under cursor.' },
    { '<Leader>gi', ':Telescope lsp_implementations<CR>', description = 'LSP implementations of word under cursor.' },
    { '<Leader>gr', ':Telescope lsp_references<CR>', description = 'LSP references of word under cursor.' },
    { '<Leader>gs', ':Telescope lsp_document_symbols<CR>', description = 'Lists LSP symbols in current buffer.' },
    { '<Leader>O', ':Telescope frecency workspace=CWD<CR>', description = 'Editing history with intelligent prioritization.' },
    { '<Leader>o', ':Telescope find_files<CR>', description = 'Find files.' },
    {
      '<Leader>R',
      function()
        require("ranger-nvim").open(false)
      end,
      description = 'Open Ranger focused on the `cwd`.'
    },
    {
      '<Leader>r',
      function()
        require("ranger-nvim").open(true)
      end,
      description = 'Open Ranger focused on the file.'
    },
    { '<Leader>vc', ':Telescope git_bcommits<CR>', description = "Lists buffer's Git commits." },
    { '<Leader>zl', ':Telescope current_buffer_fuzzy_find<CR>', description = 'Fuzzy search in the current buffer.' },
    { '<Leader>zh', ':Telescope oldfiles<CR>', description = 'Lists previously open files.' },
    { '<Leader>zr', ':Telescope resume<CR>', description = 'Lists results of previous picker.' },
  },
})
vim.api.nvim_set_keymap('n', '<C-n>', ':cnext<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<C-p>', ':cprevious<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>i', ':FloatermNew lazygit<CR>', optNRM)
--   Code.
vim.api.nvim_set_keymap('n', '<Leader>co', ':Vista!!<CR>', optNRM)
--   Scrolling.
vim.api.nvim_set_keymap('n', '<C-e>', '3<C-e>', optNRM)
vim.api.nvim_set_keymap('n', '<C-y>', '3<C-y>', optNRM)
vim.api.nvim_set_keymap('n', '<C-d>', '5<C-d>', optNRM)
vim.api.nvim_set_keymap('n', '<C-u>', '5<C-u>', optNRM)

--   Tabs.
vim.api.nvim_set_keymap('n', '<Leader>tt', ':$tabnew<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>tc', ':tabclose<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>th', ':-tabmove<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>tl', ':+tabmove<CR>', optNRM)

--   Buffers.
vim.api.nvim_set_keymap('n', '<Leader>d', ':bdelete<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>e', ':edit!<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>l', ':edit #<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Left>', ':bnext<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Right>', ':bprevious<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>q', '<C-w>q', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>s', ':wall<CR>', optNRM)

--   folke/trouble.nvim
vim.keymap.set("n", "<Leader>xx", ":TroubleToggle<CR>", optNRM)
vim.keymap.set("n", "<Leader>xw", ":TroubleToggle workspace_diagnostics<CR>", optNRM)

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

-- To show the current scheme:
--   :colorscheme
-- Use `:highlight` to list all color groups.
--   :h :highlight

-- Enable 24-bit RGB color.
-- See:
-- https://neovim.io/doc/user/options.html#'termguicolors'
vim.opt.termguicolors = true

vim.cmd.colorscheme "catppuccin-latte"

vim.cmd([[
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup = "HighlightedyankRegion", timeout = 400 })

  " Custom highlights.
  highlight HighlightedyankRegion guibg=violet guifg=black

  highlight LeapLabelPrimary guibg=cyan guifg=black
  highlight LeapLabelSecondary guibg=black guifg=cyan

  highlight IlluminatedWordText guibg=paleturquoise
  highlight IlluminatedWordRead guibg=paleturquoise
  highlight IlluminatedWordWrite guibg=paleturquoise

  highlight IblIndent guifg=lavender
  highlight IblScope guifg=plum

  highlight StatusLine guibg=black guifg=white
  highlight StatusLineNC guibg=gray guifg=lightgray

  highlight TabLine guibg=lightgray guifg=black
  highlight TabLineFill guibg=lightgray guifg=black
  highlight TabLineSel guibg=black guifg=white

  highlight VertSplit guibg=gray guifg=gray

  highlight CurSearch guibg=black guifg=cyan
  highlight IncSearch guibg=cyan guifg=black
  highlight Search guibg=cyan guifg=black
  highlight Substitute guibg=cyan guifg=black

  highlight QuickScopePrimary guibg=cyan guifg=black
  highlight QuickScopeSecondary guibg=black guifg=cyan
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
