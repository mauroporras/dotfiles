-- To reload config:
-- :source %
-- :so $MYVIMRC

require('plugins')
require('plugins-settings')
require('keymaps')
require('colors-italics')

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
vim.opt.signcolumn = 'yes:1'
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
  autocmd BufWritePre * Neoformat
]])
