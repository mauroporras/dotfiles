--  See `:h lua-guide-autocommands`

-- Highlight on yank
--  See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "HighlightedyankRegion" })
  end,
})
