-- TODO:check that custom highlights are working as expected.
--
-- Note: If you run `:colorscheme <name>` mid-session, it will override these.
-- Use a ColorScheme autocmd if you need highlights to persist through colorscheme changes.
--
-- To show the current scheme:
--   :colorscheme
-- Use `:highlight` to list all color groups.
--   :h :highlight

vim.api.nvim_set_hl(0, "HighlightedyankRegion", { bg = "violet", fg = "black" })

vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "paleturquoise" })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "paleturquoise" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "paleturquoise" })

vim.api.nvim_set_hl(0, "IblIndent", { fg = "lavender" })
vim.api.nvim_set_hl(0, "IblScope", { fg = "lavender" })

vim.api.nvim_set_hl(0, "StatusLine", { bg = "black", fg = "white" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "gray", fg = "lightgray" })

vim.api.nvim_set_hl(0, "TabLine", { bg = "lightgray", fg = "black" })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "lightgray", fg = "black" })
vim.api.nvim_set_hl(0, "TabLineSel", { bg = "black", fg = "white" })

vim.api.nvim_set_hl(0, "VertSplit", { fg = "gray" })

vim.api.nvim_set_hl(0, "CurSearch", { bg = "black", fg = "cyan" })
vim.api.nvim_set_hl(0, "IncSearch", { bg = "cyan", fg = "black" })
vim.api.nvim_set_hl(0, "Search", { bg = "cyan", fg = "black" })
vim.api.nvim_set_hl(0, "Substitute", { bg = "cyan", fg = "black" })

vim.api.nvim_set_hl(0, "QuickScopePrimary", { bg = "cyan", fg = "black" })
vim.api.nvim_set_hl(0, "QuickScopeSecondary", { bg = "black", fg = "cyan" })
