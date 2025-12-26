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

--[[
-- LSP {{{
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
--]]
