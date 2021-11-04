" To show the current scheme:
"   :colorscheme
" Use `:highlight` to list all color groups.
"   :h :highlight

" Enable 24-bit RGB color.
" See:
" https://neovim.io/doc/user/options.html#'termguicolors'
set termguicolors

set background=light

colorscheme solarized

highlight HighlightedyankRegion guibg=violet guifg=black

highlight Comment gui=italic

highlight StatusLine guibg=black guifg=white
highlight StatusLineNC guibg=gray guifg=white

highlight TabLine guibg=gray guifg=white
highlight TabLineFill guibg=gray guifg=white
highlight TabLineSel guibg=black guifg=white

highlight VertSplit guibg=gray guifg=gray

highlight IncSearch guibg=cyan guifg=black
highlight Search guibg=black guifg=cyan
highlight Substitute guibg=cyan guifg=black

highlight MatchParen guibg=black guifg=magenta

highlight QuickFixLine guibg=lime guifg=black

highlight Sneak guibg=black guifg=cyan
highlight SneakScope guibg=cyan guifg=black

highlight QuickScopePrimary guibg=cyan guifg=black
highlight QuickScopeSecondary guibg=black guifg=cyan
highlight CursorLine guibg=lightcyan

highlight LineNr guibg=#eee8d5 guifg=gray
