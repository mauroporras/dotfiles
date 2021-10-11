" To reload config:
" :source %
" :so $MYVIMRC

source ~/.config/nvim/_plugins.vim
source ~/.config/nvim/_plugins-settings.vim
source ~/.config/nvim/_keymaps.vim
source ~/.config/nvim/_colors-italics.vim

" Searching.
set ignorecase
set smartcase
set inccommand=nosplit

" Misc.
set cursorline
set cmdheight=2
set number
set splitbelow
set splitright
set mouse=a
set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
autocmd BufNewFile,BufRead *.json set syntax=json5

" vim: foldmethod=marker
