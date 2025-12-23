-- vim:foldmethod=marker

-- To reload config:
-- :source %
-- :so $MYVIMRC

-- Note: `:source %` won't reload required files (cached in package.loaded)
require("00_settings")
require("01_lazy_plugin_manager")
require("02_keymaps")
-- require("plugins_packer_deprecated")
-- require("snippets") -- depends on LuaSnip plugin

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "HighlightedyankRegion" })
  end,
})

local optNRM = { noremap = true }

--[[
-- LSP {{{
-- :LspInfo
-- :LspRestart

-- See:
-- https://github.com/neovim/nvim-lspconfig#suggested-configuration

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions.
vim.keymap.set("n", "<Leader>cd", vim.diagnostic.open_float, optNRM)
vim.keymap.set("n", "<Leader>n", vim.diagnostic.goto_next, optNRM)
vim.keymap.set("n", "<Leader>p", vim.diagnostic.goto_prev, optNRM)

vim.keymap.set("n", "<Leader>E", ":LspRestart<CR>", optNRM)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "<Leader>gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "<Leader>ch", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<Leader>cr", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, bufopts)
end

-- nvim-cmp {{{
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure global LSP settings
vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Enable language servers with default settings
local servers = {
  "bashls",
  "cssls",
  "dartls",
  "diagnosticls",
  "dockerls",
  "html",
  "jsonls",
  "stylelint_lsp",
  "svelte",
  "tailwindcss",
  "ts_ls",
  "yamlls",
}

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end

-- Configure servers with specific settings
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
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

vim.lsp.enable("lua_ls")

-- luasnip setup
local luasnip = require("luasnip")

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-u>"] = cmp.mapping.scroll_docs(-3),
    ["<C-d>"] = cmp.mapping.scroll_docs(3),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    -- Tab is reserved for Copilot, so S-Tab is used for snippet forward jump.
    -- ['<Tab>'] = cmp.mapping(function(fallback)
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    -- Snippet jump backward (disabled, Tab is reserved for Copilot).
    -- ['<S-Tab>'] = cmp.mapping(function(fallback)
    --   if luasnip.jumpable(-1) then
    --     luasnip.jump(-1)
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
  },
})
-- }}}
-- }}}
--]]

--[[
-- nvim-treesitter {{{
--   See:
--     https://github.com/nvim-treesitter/nvim-treesitter#language-parsers
--   To update all parsers:
--     :TSUpdate
--   To list all available commands:
--     :h nvim-treesitter-commands
require("nvim-treesitter.configs").setup({
  -- A list of parser names, or "all"
  ensure_installed = {
    "bash",
    "c",
    "cmake",
    "cpp",
    "css",
    "diff",
    "dockerfile",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "jsonc",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "regex",
    "scss",
    "svelte",
    "toml",
    "typescript",
    "vim",
    "yaml",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

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
-- }}}
--]]

--[[
-- Emmet.
vim.g.user_emmet_mode = "i"
--]]

-- To find what's using a key map:
--   :verbose nmap <leader>b

-- See:
-- https://github.com/nanotee/nvim-lua-guide#defining-mappings

-- Command line (:h mapmode-c).
vim.api.nvim_set_keymap("c", "<C-a>", "<Home>", optNRM)
vim.api.nvim_set_keymap("c", "<C-b>", "<Left>", optNRM)
vim.api.nvim_set_keymap("c", "<C-d>", "<Del>", optNRM)
vim.api.nvim_set_keymap("c", "<C-f>", "<Right>", optNRM)

-- Terminal (:h mapmode-t).
vim.api.nvim_set_keymap("t", "<C-w>h", "<C-\\><C-n><C-w>h", optNRM)
vim.api.nvim_set_keymap("t", "<C-w>j", "<C-\\><C-n><C-w>j", optNRM)
vim.api.nvim_set_keymap("t", "<C-w>k", "<C-\\><C-n><C-w>k", optNRM)
vim.api.nvim_set_keymap("t", "<C-w>l", "<C-\\><C-n><C-w>l", optNRM)

-- Insert.
vim.api.nvim_set_keymap("i", "<C-a>", "<Home>", optNRM)
vim.api.nvim_set_keymap("i", "<C-b>", "<Left>", optNRM)
vim.api.nvim_set_keymap("i", "<C-d>", "<Del>", optNRM)
vim.api.nvim_set_keymap("i", "<C-e>", "<End>", optNRM)
vim.api.nvim_set_keymap("i", "<C-f>", "<Right>", optNRM)

--[[
-- Normal.
require("legendary").setup({
  keymaps = {
    {
      "<Leader>e",
      function()
        local view = vim.fn.winsaveview()
        vim.cmd("edit!")
        vim.fn.winrestview(view)
      end,
      description = "Reload file and preserve scroll position.",
    },
    -- Tabs.
    { "<Leader>tn", ":tabnew<CR>", description = "Opens tabpage after the current one." },
    { "<Leader>tp", ":-tabnew<CR>", description = "Opens tabpage before the current." },
    { "<M-h>", ":tabprevious<CR>", description = "Previous tab." },
    { "<M-l>", ":tabnext<CR>", description = "Nex tab." },
    -- Windows. Temporal.
    { "<C-w><C-w>", "", description = "Do nothing. To unlearn shortcut." },
    { "<C-w>h", "", description = "Do nothing. To unlearn shortcut." },
    { "<C-w>l", "", description = "Do nothing. To unlearn shortcut." },
    { "<C-w>j", "", description = "Do nothing. To unlearn shortcut." },
    { "<C-w>k", "", description = "Do nothing. To unlearn shortcut." },
    -- Misc.
    -- TODO: legendary is deprecated. Remove keymaps when migrating a plugin.
    -- They're now defined in their respective plugin files.
    { "<Leader>a", ":Telescope live_grep<CR>", description = "Search in all files." },
    { "<Leader>A", ":Telescope grep_string<CR>", description = "Searches string under your cursor." },
    { "<Leader>b", ":Telescope buffers<CR>", description = "List buffers." },
    { "<Leader>gd", ":Telescope lsp_definitions<CR>", description = "LSP definition of word under cursor." },
    { "<Leader>gi", ":Telescope lsp_implementations<CR>", description = "LSP implementations of word under cursor." },
    { "<Leader>gr", ":Telescope lsp_references<CR>", description = "LSP references of word under cursor." },
    { "<Leader>gs", ":Telescope lsp_document_symbols<CR>", description = "Lists LSP symbols in current buffer." },
    {
      "<Leader>O",
      ":Telescope frecency workspace=CWD<CR>",
      description = "Editing history with intelligent prioritization.",
    },
    { "<Leader>o", ":Telescope find_files<CR>", description = "Find files." },
    { "<Leader>f", ":Yazi<CR>", description = "Open file manager focused on the current file." },
    { "<Leader>Fc", ":Yazi cwd<CR>", description = "Open file manager focused on the `cwd`." },
    { "<Leader>Fl", ":Yazi toggle<CR>", description = "Open file manager focused on the `cwd`." },
    { "<Leader>vc", ":Telescope git_bcommits<CR>", description = "Lists buffer's Git commits." },
    { "<Leader>zl", ":Telescope current_buffer_fuzzy_find<CR>", description = "Fuzzy search in the current buffer." },
    { "<Leader>zh", ":Telescope oldfiles<CR>", description = "Lists previously open files." },
    { "<Leader>zr", ":Telescope resume<CR>", description = "Lists results of previous picker." },
  },
})
--]]

vim.api.nvim_set_keymap("n", "<C-n>", ":cnext<CR>", optNRM)
vim.api.nvim_set_keymap("n", "<C-p>", ":cprevious<CR>", optNRM)

--   Scrolling.
vim.api.nvim_set_keymap("n", "<C-d>", "5<C-d>", optNRM)
vim.api.nvim_set_keymap("n", "<C-u>", "5<C-u>", optNRM)

--   Tabs.
vim.api.nvim_set_keymap("n", "<Leader>tt", ":$tabnew<CR>", optNRM)
vim.api.nvim_set_keymap("n", "<Leader>tc", ":tabclose<CR>", optNRM)
vim.api.nvim_set_keymap("n", "<Leader>ts", ":tab split<CR>", optNRM)

--   Buffers.
vim.api.nvim_set_keymap("n", "<Leader>d", ":bdelete<CR>", optNRM)
vim.api.nvim_set_keymap("n", "<Leader>l", ":edit #<CR>", optNRM)
vim.api.nvim_set_keymap("n", "<Left>", ":bprevious<CR>", optNRM)
vim.api.nvim_set_keymap("n", "<Right>", ":bnext<CR>", optNRM)
vim.api.nvim_set_keymap("n", "<Leader>q", "<C-w>q", optNRM)
vim.api.nvim_set_keymap("n", "<Leader>s", ":wall<CR>", optNRM)

--[[
--   github/copilot.vim
vim.keymap.set("i", "<C-l>", "<Plug>(copilot-accept-word)")
--]]

-- To show the current scheme:
--   :colorscheme
-- Use `:highlight` to list all color groups.
--   :h :highlight

-- Enable 24-bit RGB color.
-- See:
-- https://neovim.io/doc/user/options.html#'termguicolors'
vim.o.termguicolors = true

--[[
vim.cmd([=[
  " Custom highlights.
  highlight HighlightedyankRegion guibg=violet guifg=black

  highlight IlluminatedWordText guibg=paleturquoise
  highlight IlluminatedWordRead guibg=paleturquoise
  highlight IlluminatedWordWrite guibg=paleturquoise

  highlight IblIndent guifg=lavender
  highlight IblScope guifg=lavender

  highlight StatusLine guibg=black guifg=white
  highlight StatusLineNC guibg=gray guifg=lightgray

  highlight TabLine guibg=lightgray guifg=black
  highlight TabLineFill guibg=lightgray guifg=black
  highlight TabLineSel guibg=black guifg=white

  highlight VertSplit guifg=gray

  highlight CurSearch guibg=black guifg=cyan
  highlight IncSearch guibg=cyan guifg=black
  highlight Search guibg=cyan guifg=black
  highlight Substitute guibg=cyan guifg=black

  highlight QuickScopePrimary guibg=cyan guifg=black
  highlight QuickScopeSecondary guibg=black guifg=cyan
]=])

vim.cmd([=[
  " Recognize some extensions known to have JSON with comments.
  autocmd BufNewFile,BufRead tsconfig.json setlocal filetype=jsonc
]=])
--]]
