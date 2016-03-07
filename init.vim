" Install vim-plug if not present.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'lokaltog/vim-easymotion'
Plug 'mattn/emmet-vim'
Plug 'mhinz/vim-grepper'
Plug 'mustache/vim-mustache-handlebars'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ngmy/vim-rubocop'
Plug 'rbgrouleff/bclose.vim'
Plug 'sunaku/vim-ruby-minitest'
Plug 'terryma/vim-expand-region'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-ruby/vim-ruby'

call plug#end()

filetype plugin indent on

" Leader.
let mapleader=','
set timeoutlen=3333

" Custom maps.
nnoremap <Leader>a :edit #<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>m :CtrlPMRUFiles<CR>
nnoremap <Leader>n :bnext<CR>
nnoremap <Leader>p :bprevious<CR>
nnoremap <Leader>q :bdelete<CR>
nnoremap <Leader>r :edit!<CR>
nnoremap <Leader>s :wall<CR>
nnoremap <Leader>t :CtrlPTag<CR>
nnoremap <Leader>w :update<CR>
nnoremap <Leader>. :tabnew<CR>
nnoremap - :call OpenRanger()<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-l> :wincmd l<CR>
nnoremap <C-h> :wincmd h<CR>

" Automatically jump to end of pasted text.
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" ALWAYS use the clipboard for ALL operations.
set clipboard+=unnamedplus

" Color scheme.
syntax enable
set cursorline
set background=dark
let base16colorspace=256
silent! colorscheme base16-solarized

" Associate file extensions.
autocmd BufRead,BufNewFile *.es6 setfiletype javascript

" Highlighting and completion for MiniTest.
set completefunc=syntaxcomplete#Complete

" Right margin column.
set textwidth=80
set colorcolumn=+1

" Misc.
set encoding=utf-8
set ruler
set laststatus=2
set cmdheight=2
set wildmenu
set showcmd
set hidden
set confirm

" Searching.
set hlsearch
set ignorecase
set smartcase
set noincsearch
highlight Search ctermbg=38 ctermfg=0
" Clear search with Escape key.
nnoremap <Esc> :nohlsearch<CR><Esc>

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
set scrolloff=5

" Open splits to right and bottom, which feels more natural.
set splitbelow
set splitright

" All splits at least 1 line and current one 10 lines.
set winminheight=1
set winheight=10

" Disable parentheses matching.
let loaded_matchparen=1


" Plugins settings.

" Rainbow Parentheses.
autocmd VimEnter * silent! RainbowParentheses

" vim-airline.
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemod=':t'
let g:airline#extensions#tabline#left_sep=''
let g:airline#extensions#tabline#left_alt_sep=''

" vim-indent-guides.
"let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1
let g:indent_guides_start_level=2

" vim-expand-region.
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Emmet.
let g:user_emmet_mode='i'

" CtrlP.
let g:ctrlp_match_window='max:15'

" Rubocop.
let g:vimrubocop_keymap=0

" The Silver Searcher.
if executable('ag')
  " Use ag over grep.
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files.
  let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching=0

  " Bind \ to grep shortcut.
  command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  nnoremap \ :Ag<Space>
endif


" Custom functions.

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif
