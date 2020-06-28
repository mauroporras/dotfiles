" To reload config:
" :source %

" Install vim-plug if not present.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" {{{ Plugins.
call plug#begin('~/.config/nvim/plugged')
Plug 'ap/vim-css-color'
Plug 'chriskempson/base16-vim'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'GutenYe/json5.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'mattn/emmet-vim'
Plug 'mxw/vim-jsx'
Plug 'othree/yajs.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'rafaqz/ranger.vim'
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
" For JS and TS support, add --ts-completer when calling install.py
Plug 'Valloric/YouCompleteMe'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'
call plug#end()
filetype plugin indent on
" }}}

" Leader.
let mapleader=' '
set timeoutlen=3000

" {{{ Custom key maps.

"   Command line (:h mapmode-c).
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-f> <Right>

"   Insert.
inoremap <C-d> <Del>

"   {{{ Normal.
nnoremap <C-n> :ALENext<CR>
nnoremap <C-p> :ALEPrevious<CR>
nnoremap <Esc> :nohlsearch<CR><Esc>
nnoremap <Down> :cnext<CR>
nnoremap <Up> :cprevious<CR>
nnoremap <Leader>a :Ag<Space>
nnoremap <Leader>g :YcmCompleter GoTo<CR>
nnoremap <Leader>Gr :YcmCompleter RefactorRename<Space>
nnoremap <Leader>o :Files<CR>
nnoremap <Leader>t :$tabnew<CR>
nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>yt :BTags<CR>
nnoremap <Leader>zh :History<CR>
nnoremap <Leader>zl :Lines<CR>
nnoremap <Leader>zm :Marks<CR>
nnoremap <Leader>zt :Tags<CR>
"     Buffers.
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>d :bdelete<CR>
nnoremap <Leader>l :edit #<CR>
nnoremap <Leader>n :bnext<CR>
nnoremap <Leader>p :bprevious<CR>
nnoremap <Leader>s :wall<CR>
"     Ranger.
nnoremap <Leader>r :RangerEdit<CR>
nnoremap <Leader>Rc :set operatorfunc=RangerChangeOperator<cr>g@
"   }}}

"   Terminal (:h mapmode-t).
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l

" }}}

" {{{ Color scheme & italics.
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Use `:highlight` to list all color groups.
" Syntax: (group, guifg, guibg, ctermfg, ctermbg, [bold,italic,underline])
call Base16hi('ALEError', '', '', '', 225)
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
" }}}

" Searching.
set ignorecase
set smartcase
set inccommand=nosplit

" Misc.
set cmdheight=2
set number
set splitbelow
set splitright
set mouse=a
autocmd BufNewFile,BufRead *.json set syntax=json5

" {{{ Plugins settings.
"   Ale.
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\ '*': ['prettier'],
\}

"   Emmet.
let g:user_emmet_mode='i'
let g:user_emmet_settings = {
\ 'javascript.jsx': {
\   'extends': 'jsx',
\ },
\}

"   JSX.
let g:jsx_ext_required=0

"   Make YouCompleteMe compatible with UltiSnips (using supertab).
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

"   Better key bindings for UltiSnipsExpandTrigger.
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

"   Fzf.
let g:fzf_action = {
\ 'ctrl-t': 'tab split',
\ 'ctrl-s': 'split',
\ 'ctrl-v': 'vsplit',
\}
" }}}

" vim: foldmethod=marker
