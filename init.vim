" Install vim-plug if not present.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'chriskempson/base16-vim'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'francoiscabrol/ranger.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'mattn/emmet-vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'mxw/vim-jsx'
Plug 'ngmy/vim-rubocop'
Plug 'pangloss/vim-javascript'
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
Plug 'editorconfig/editorconfig-vim'
Plug 'sbdchd/neoformat'
" For snippets.
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'Valloric/YouCompleteMe'
Plug 'honza/vim-snippets'
call plug#end()
filetype plugin indent on

" Leader.
let mapleader=' '
set timeoutlen=3333

" Custom maps.
nnoremap <Esc> :nohlsearch<CR><Esc>
nnoremap <Leader>a :edit #<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>n :tabnext<CR>
nnoremap <Leader>o :Files<CR>
nnoremap <Leader>p :tabprevious<CR>
nnoremap <Leader>q :Bclose<CR>
nnoremap <Leader>r :edit!<CR>
nnoremap <Leader>s :wall<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>w :Neoformat<CR>
nnoremap <Leader>. :tabnew<CR>
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

" Enable mouse, sometimes it's useful.
set mouse=a

" Color scheme.
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
highlight IncSearch ctermbg=51 ctermfg=0
highlight MatchParen ctermbg=46 ctermfg=0
highlight Search ctermbg=38 ctermfg=0

" Highlighting and completion for MiniTest.
set completefunc=syntaxcomplete#Complete

" Right margin column.
set textwidth=80
set colorcolumn=+1

" Misc.
set cursorline
set cmdheight=2
set hidden
set confirm

" Searching.
set ignorecase
set smartcase
set inccommand=nosplit

" Line numbers.
set number
set scrolloff=4

" Open splits to right and bottom, which feels more natural.
set splitbelow
set splitright

" All splits at least 1 line and current one 10 lines.
set winminheight=1
set winheight=10


" Plugins settings.

" Neoformat and Prettier.
autocmd FileType javascript set formatprg=prettier\ --no-semi\ --single-quote\ --trailing-comma\ es5\ --stdin
" Use formatprg when available
let g:neoformat_try_formatprg=1

" vim-airline.
let g:airline_extensions=['branch', 'tabline']
let g:airline_powerline_fonts=1
let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#fnamemod=':t'
let g:airline#extensions#tabline#left_alt_sep=''
let g:airline#extensions#tabline#left_sep=''
let g:airline#extensions#tabline#right_alt_sep=''
let g:airline#extensions#tabline#right_sep=''
let g:airline#extensions#tabline#show_close_button=0
let g:airline#extensions#tabline#show_splits=0
let g:airline#extensions#tabline#tab_nr_type=1

" vim-expand-region.
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Emmet.
let g:user_emmet_mode='i'

" Rubocop.
let g:vimrubocop_keymap=0

" JSX.
let g:jsx_ext_required=0

" Make YouCompleteMe compatible with UltiSnips (using supertab).
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" Better key bindings for UltiSnipsExpandTrigger.
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"


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
