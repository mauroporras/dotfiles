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

  highlight Sneak guibg=black guifg=cyan
  highlight SneakScope guibg=cyan guifg=black

  highlight QuickScopePrimary guibg=cyan guifg=black
  highlight QuickScopeSecondary guibg=black guifg=cyan

  highlight CursorLine guibg=lightcyan
]])
