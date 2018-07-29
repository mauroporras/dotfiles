" Install vim-plug if not present.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'chriskempson/base16-vim'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'mattn/emmet-vim'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'rafaqz/ranger.vim'
Plug 'terryma/vim-expand-region'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
" Fzf.
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
" Snippets.
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
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>
nnoremap <C-s> :wall<CR>
nnoremap <Leader>a :Ag<Space>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>n :cnext<CR>
nnoremap <Leader>p :cprevious<CR>
nnoremap <Leader>o :Files<CR>
nnoremap <Leader>q <C-w>q
nnoremap <Leader>ra :RangerAppend<CR>
nnoremap <Leader>rc :set operatorfunc=RangerChangeOperator<cr>g@
nnoremap <Leader>ri :RangerInsert<CR>
nnoremap <Leader>rr :RangerEdit<CR>
nnoremap <Leader>rs :RangerSplit<CR>
nnoremap <Leader>rt :RangerTab<CR>
nnoremap <Leader>rv :RangerVSplit<CR>
nnoremap <Leader>t :$tabnew<CR>
nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>y; :edit #<CR>
nnoremap <Leader>yf :ALEFix<CR>
nnoremap <Leader>yn :bnext<CR>
nnoremap <Leader>yp :bprevious<CR>
nnoremap <Leader>yr :edit!<CR>
nnoremap <Leader>yt :BTags<CR>
nnoremap <Leader>zh :History<CR>
nnoremap <Leader>zl :Lines<CR>
nnoremap <Leader>zm :Marks<CR>
nnoremap <Leader>zt :Tags<CR>
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" Enable mouse, sometimes it's useful.
set mouse=a

" Color scheme.
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
highlight IncSearch ctermbg=51 ctermfg=white
highlight QuickFixLine ctermbg=gray ctermfg=white
highlight Search ctermbg=45 ctermfg=white
highlight StatusLine ctermbg=white ctermfg=black
highlight StatusLineNC ctermbg=gray ctermfg=white
highlight TabLine ctermbg=gray ctermfg=black
highlight TabLineFill ctermbg=gray
highlight TabLineSel ctermbg=black ctermfg=white
highlight VertSplit ctermbg=gray ctermfg=gray
highlight Visual ctermbg=gray ctermfg=white
highlight WildMenu ctermbg=yellow ctermfg=white

" Misc.
set cmdheight=2
set number

" Searching.
set ignorecase
set smartcase
set inccommand=nosplit

" Open splits to right and bottom, which feels more natural.
set splitbelow
set splitright


" Plugins settings.

" Ale.
let g:ale_fixers = {
\  'css': ['prettier'],
\  'javascript': ['prettier'],
\  'json': ['prettier'],
\}

" vim-expand-region.
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Emmet.
let g:user_emmet_mode='i'

" vim-javascript.
let g:javascript_plugin_flow=1

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
