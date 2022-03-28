-- Emmet.
vim.g.user_emmet_mode = 'i'

-- LSP.
--   :LspInfo
--   :LspRestart
require'lspconfig'.bashls.setup{}
require'lspconfig'.cssls.setup{}
require'lspconfig'.dartls.setup{}
require'lspconfig'.diagnosticls.setup{}
require'lspconfig'.dockerls.setup{}
require'lspconfig'.html.setup{}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.stylelint_lsp.setup{}
require'lspconfig'.svelte.setup{}
require'lspconfig'.tailwindcss.setup{}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.yamlls.setup{}

-- {{{ nvim-cmp.
-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

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
  'stylelint_lsp',
  'svelte',
  'tailwindcss',
  'tsserver',
  'yamlls',
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
-- }}} nvim-cmp.

-- nvim-treesitter
--   See:
--     https://github.com/nvim-treesitter/nvim-treesitter#language-parsers
--   To update all parsers:
--     :TSUpdate
--   To list all available commands:
--     :h nvim-treesitter-commands
require('nvim-treesitter.configs').setup({
  -- one of: "all", "maintained" (parsers with maintainers), or a list of languages.
  ensure_installed = "maintained",
  -- Install languages synchronously (only applied to `ensure_installed`).
  sync_install = false,
  -- List of parsers to ignore installing.
  ignore_install = { },
  highlight = {
    -- false will disable the whole extension.
    enable = true,
    -- list of languages that will be disabled.
    disable = { },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

-- quick-scope.
vim.g.qs_highlight_on_keys = {
  'f',
  'F',
  't',
  'T',
}

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

-- vim-sneak.
--   For a minimalist alternative to EasyMotion.
vim.g['sneak#label'] = 1
