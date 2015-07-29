" Install vim-plug if not present.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')
Plug 'bling/vim-airline'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'lokaltog/vim-easymotion'
Plug 'mattn/emmet-vim'
Plug 'mhinz/vim-startify'
Plug 'mustache/vim-mustache-handlebars'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ngmy/vim-rubocop'
Plug 'sunaku/vim-ruby-minitest'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
call plug#end()

filetype plugin on
filetype indent on

" Leader.
let mapleader=','

" Custom maps.
noremap <Leader>w :update<Return>
noremap <Leader>s :wall<Return>
noremap <Leader>q :bdelete<Return>
noremap <Leader>a :edit #<Return>
noremap <Leader>r :edit!<Return>

" Automatically jump to end of pasted text.
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Color scheme.
syntax enable
set background=dark
let base16colorspace=256
silent! colorscheme base16-solarized

" Current line.
set cursorline
highlight CursorLine guibg=#003F30
highlight Cursor guibg=Green

" Associate file extensions.
autocmd BufRead,BufNewFile *.es6 setfiletype javascript

" Highlighting and completion for MiniTest.
set completefunc=syntaxcomplete#Complete

" Make it obvious where 80 characters is.
set textwidth=80
set colorcolumn=+1

set guifont=Inconsolata\ Medium\ 14
" For MacVim.
if has('gui_macvim')
  set guifont=Inconsolata:h16
endif

set encoding=utf-8
set ruler
set laststatus=2
set cmdheight=2
"set hidden
set wildmenu
set showcmd
set autowrite

" Searching.
set hlsearch
set ignorecase
set smartcase
set noincsearch
highlight Search ctermbg=38 ctermfg=0

" Clear search with Escape key.
nnoremap <Esc> :nohlsearch<Return><Esc>

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
set relativenumber
set number
set numberwidth=5
set scrolloff=5

" CtrlP settings.
map <Leader>b :CtrlPBuffer<Return>
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" Rainbow Parentheses settings.
autocmd VimEnter * silent! RainbowParentheses

" Netrw settings.
" Caution: liststyle 3 leaves multiple dirs in the buffer.
"let g:netrw_liststyle=3

" vim-airline settings.
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1

" vim-indent-guides settings.
"let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1
let g:indent_guides_start_level=2

" vim-expand-region settings.
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" vim-fugitive settings.
noremap <Leader>g :Git<Space>

" Open splits to right and bottom, which feels more natural.
set splitbelow
set splitright

" All splits at least 1 line and current one 10 lines.
set winminheight=1
set winheight=10

" Remove menu bar, toolbar, and right and left scroll bars.
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
