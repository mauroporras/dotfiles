" To show the current scheme:
"   :colorscheme
"   :h :highlight

" Enable 24-bit RGB color.
" See:
" https://neovim.io/doc/user/options.html#'termguicolors'
set termguicolors

if filereadable(expand("~/.vimrc_background"))
  " See:
  " https://github.com/chriskempson/base16-vim#256-colorspace
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Use `:highlight` to list all color groups.
" Syntax: (group, guifg, guibg, ctermfg, ctermbg, [bold,italic,underline])
call Base16hi('Comment', '', '', '', '', 'italic')
call Base16hi('StatusLine', g:base16_gui00, g:base16_gui05, g:base16_cterm00, g:base16_cterm05)
call Base16hi('StatusLineNC', g:base16_gui00, g:base16_gui04, g:base16_cterm00, g:base16_cterm04)
call Base16hi('TabLine', g:base16_gui02, g:base16_gui05, g:base16_cterm02, g:base16_cterm05)
call Base16hi('TabLineFill', '', g:base16_gui05, '', g:base16_cterm05)
call Base16hi('TabLineSel', g:base16_gui05, g:base16_gui00, g:base16_cterm05, g:base16_cterm00)
call Base16hi('VertSplit', g:base16_gui04, g:base16_gui04, g:base16_cterm04, g:base16_cterm04)

highlight HighlightedyankRegion guibg=violet guifg=black

highlight IncSearch guibg=cyan guifg=black
highlight Search guibg=black guifg=cyan
highlight Substitute guibg=cyan guifg=black

highlight MatchParen guibg=black guifg=magenta

highlight QuickFixLine guibg=lime guifg=black
