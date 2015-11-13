" Install vim-plug if not present.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'bling/vim-airline'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'lokaltog/vim-easymotion'
Plug 'mattn/emmet-vim'
Plug 'mhinz/vim-grepper'
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

filetype plugin indent on

" Leader.
let mapleader=','

" Custom maps.
nnoremap <Leader>a :bprevious<Return>
nnoremap <Leader>g :Git<Space>
nnoremap <Leader>q :bdelete<Return>
nnoremap <Leader>r :edit!<Return>
nnoremap <Leader>s :bnext<Return>
nnoremap <Leader>t :tabnew .<Return>
nnoremap <Leader>w :wall<Return>

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

" Associate file extensions.
autocmd BufRead,BufNewFile *.es6 setfiletype javascript

" Highlighting and completion for MiniTest.
set completefunc=syntaxcomplete#Complete

" Right margin column.
set textwidth=80
set colorcolumn=+1

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

" Disable backups.
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
set scrolloff=3

" Open splits to right and bottom, which feels more natural.
set splitbelow
set splitright

" All splits at least 1 line and current one 10 lines.
set winminheight=1
set winheight=10

" Disable parentheses matching.
let loaded_matchparen=1


" Plugins settings.

" CtrlP.
let g:ctrlp_user_command=['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" Rainbow Parentheses.
autocmd VimEnter * silent! RainbowParentheses

" Netrw.
" Caution: liststyle 3 leaves multiple dirs in the buffer.
"let g:netrw_liststyle=3

" vim-airline.
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemod=':t'

" vim-indent-guides.
"let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1
let g:indent_guides_start_level=2

" vim-expand-region.
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
