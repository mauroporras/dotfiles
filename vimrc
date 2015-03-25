execute pathogen#infect()

" @amporras
" Use Vim settings, rather then Vi settings.
" This setting must be as early as possible, as it has side effects.
set nocompatible

" Leader (default).
let mapleader="\\"

" Quick save.
noremap <Leader>w :update<Return>
noremap <Leader>s :wall<Return>

" Clear search with Escape key.
nnoremap <Esc> :nohlsearch<Return><Esc>

syntax enable
set background=dark
colorscheme solarized
hi CursorLine guibg=#003F30
hi Cursor guibg=Green

" Associate file extensions.
autocmd BufRead,BufNewFile *.es6 setfiletype javascript

" Word separators
:set iskeyword-=_

" Make it obvious where 80 characters is.
"set textwidth=80
"set colorcolumn=+1

set guifont=Ubuntu\ Mono\ 12
" For mVim.
" set guifont=Ubuntu\ Mono:h16
set cursorline
set ruler
set laststatus=2
set cmdheight=2
set hidden
set wildmenu
set showcmd
set hlsearch
set ignorecase
set smartcase

set nobackup
set nowritebackup
set noswapfile

" Remove spaces at the end and convert tabs to spaces before saving.
autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePre * :retab

" Softtabs, 2 spaces.
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Line numbers.
set number
set numberwidth=4

" CtrlP settings.
map <Leader>b :CtrlPBuffer<Return>
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" Netrw settings.
let g:netrw_liststyle=3

" vim-airline settings.
let g:airline_theme='powerlineish'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_z=''

" vim-indent-guides settings.
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1
let g:indent_guides_start_level=2

" Open splits to right and bottom, which feels more natural.
set splitbelow
set splitright

" All splits at least 5 lines and current one 30 lines.
set winheight=30
set winminheight=5

" Quicker window movement.
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

filetype plugin indent on

" Remove menu bar, toolbar, and right and left scroll bars.
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
