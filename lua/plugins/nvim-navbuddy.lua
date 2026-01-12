-- Breadcrumb navigation popup for LSP symbols.
-- Useful keymaps inside Navbuddy:
--   j/k: move up/down, h/l: navigate panels
--   o/<CR>: jump to symbol, y: yank name, r: rename
--   v: visual select, i/a: insert/append
--   c: comment scope, d: delete scope
--   <C-v>: vsplit, <C-s>: hsplit, <C-t>: new tab
return {
  "SmiteshP/nvim-navbuddy",
  cmd = "Navbuddy",
  keys = {
    { "<Leader>cn", "<cmd>Navbuddy<cr>", desc = "Navbuddy" },
  },
  dependencies = {
    -- Ensure lspconfig loads first since auto_attach hooks into LSP clients.
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    icons = {
      File = " ",
      Module = " ",
      Namespace = " ",
      Package = " ",
      Class = " ",
      Method = " ",
      Property = " ",
      Field = " ",
      Constructor = " ",
      Enum = " ",
      Interface = " ",
      Function = " ",
      Variable = " ",
      Constant = " ",
      String = " ",
      Number = " ",
      Boolean = " ",
      Array = " ",
      Object = " ",
      Key = " ",
      Null = " ",
      EnumMember = " ",
      Struct = " ",
      Event = " ",
      Operator = " ",
      TypeParameter = " ",
    },
    lsp = {
      auto_attach = true,
    },
    window = {
      size = { height = "97%", width = "100%" },
      border = "none",
      sections = {
        left = { border = "rounded" },
        mid = { border = "rounded" },
        right = { border = "rounded" },
      },
    },
  },
}
