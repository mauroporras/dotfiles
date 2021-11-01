" To show the current scheme:
"   :colorscheme
"   :h :highlight

" Enable 24-bit RGB color.
" See:
" https://neovim.io/doc/user/options.html#'termguicolors'
set termguicolors
set background=light

let g:neosolarized_contrast = "high"

colorscheme NeoSolarized

" Use `:highlight` to list all color groups.
" Syntax: (group, guifg, guibg, ctermfg, ctermbg, [bold,italic,underline])
" call Base16hi('Comment', '', '', '', '', 'italic')

highlight HighlightedyankRegion guibg=violet guifg=black

highlight StatusLine guibg=white guifg=black
highlight StatusLineNC guibg=white guifg=gray

highlight TabLine guibg=gray guifg=black
highlight TabLineFill guibg=gray guifg=black
highlight TabLineSel guibg=white guifg=black

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
