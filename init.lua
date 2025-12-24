-- vim:foldmethod=marker

-- To reload config:
-- :source %
-- :so $MYVIMRC

-- Note: `:source %` won't reload required files (cached in package.loaded)
require("00_settings")
require("01_highlights")
require("02_keymaps")
require("03_autocommands")
require("04_lazy_plugin_manager")
-- require("plugins_packer_deprecated")
-- require("snippets") -- depends on LuaSnip plugin

local optNRM = { noremap = true }

--[[
-- LSP {{{
-- :LspInfo
-- :LspRestart

-- See:
-- https://github.com/neovim/nvim-lspconfig#suggested-configuration

-- Mappings.
-- See `:h vim.diagnostic.*` for documentation on any of the below functions.
vim.keymap.set("n", "<Leader>cd", vim.diagnostic.open_float, optNRM)
vim.keymap.set("n", "<Leader>n", vim.diagnostic.goto_next, optNRM)
vim.keymap.set("n", "<Leader>p", vim.diagnostic.goto_prev, optNRM)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Mappings.
  -- See `:h vim.lsp.*` for documentation on any of the below functions
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
