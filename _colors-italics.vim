if filereadable(expand("~/.vimrc_background"))
  " See:
  " https://github.com/chriskempson/base16-vim#256-colorspace
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Use `:highlight` to list all color groups.
" Syntax: (group, guifg, guibg, ctermfg, ctermbg, [bold,italic,underline])
call Base16hi('Comment', '', '', '', '', 'italic')
call Base16hi('Error', '', '', '', 225)
call Base16hi('IncSearch', '', '', '', g:base16_cterm0C, 'bold')
call Base16hi('MatchParen', '', '', g:base16_cterm00, g:base16_cterm0E)
call Base16hi('QuickFixLine', '', '', g:base16_cterm00, g:base16_cterm0A)
call Base16hi('Search', '', '', '', g:base16_cterm0D)
call Base16hi('SpellBad', '', '', '', 225)
call Base16hi('SpellCap', '', '', '', 229)
call Base16hi('StatusLine', '', '', g:base16_cterm00, g:base16_cterm05)
call Base16hi('StatusLineNC', '', '', g:base16_cterm00, g:base16_cterm04)
call Base16hi('Substitute', '', '', '', g:base16_cterm0D)
call Base16hi('TabLine', '', '', g:base16_cterm02, g:base16_cterm05)
call Base16hi('TabLineFill', '', '', '', g:base16_cterm05)
call Base16hi('TabLineSel', '', '', g:base16_cterm05, g:base16_cterm00)
call Base16hi('VertSplit', '', '', g:base16_cterm04, g:base16_cterm04)
call Base16hi('WildMenu', '', '', g:base16_cterm07, g:base16_cterm0A)
