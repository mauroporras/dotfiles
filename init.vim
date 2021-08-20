" To reload config:
" :source %
" :so $MYVIMRC

" Install vim-plug if not present. See:
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" {{{ Plugins.
call plug#begin()
"   Fzf.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"   Misc.
Plug 'ap/vim-css-color'
Plug 'chriskempson/base16-vim'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'evanleck/vim-svelte', { 'branch': 'main' }
Plug 'ekalinin/Dockerfile.vim'
Plug 'gutenye/json5.vim'
Plug 'honza/vim-snippets'
Plug 'jiangmiao/auto-pairs'
Plug 'kevinhwang91/rnvimr'
Plug 'kevinoid/vim-jsonc'
Plug 'mattn/emmet-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'rbgrouleff/bclose.vim'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
call plug#end()
filetype plugin indent on
" }}} Plugins.

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
"     Expand and jump (expand is higher priority).
imap <C-j> <Plug>(coc-snippets-expand-jump)

"   {{{ Normal.
nnoremap <C-n> :call CocAction('diagnosticNext')<CR>
nnoremap <C-p> :call CocAction('diagnosticPrevious')<CR>
nnoremap <Esc> :nohlsearch<CR><Esc>
nnoremap <Down> :cnext<CR>
nnoremap <Up> :cprevious<CR>
nnoremap <Leader>a :Ag<Space>
nnoremap <Leader>g :call CocAction('jumpDefinition')<CR>
nnoremap <Leader>i :G<Space>
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
nnoremap <Leader>d :Bclose<CR>
nnoremap <Leader>e :edit!<CR>
nnoremap <Leader>l :edit #<CR>
nnoremap <Leader>n :bnext<CR>
nnoremap <Leader>p :bprevious<CR>
nnoremap <Leader>q <C-w>q
nnoremap <Leader>s :wall<CR>
"     Ranger.
nnoremap <Leader>r :RnvimrToggle<CR>
tnoremap <silent> <M-r> <C-\><C-n>:RnvimrResize<CR>
"   }}} Normal.

"   Terminal (:h mapmode-t).
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l

" }}} Custom key maps.

" {{{ Color scheme & italics.
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
" }}} Color scheme & italics.

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
set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
autocmd BufNewFile,BufRead *.json set syntax=json5

" {{{ Plugins settings.

"   Ag.
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(
  \   <q-args>,
  \   '--hidden --ignore .git',
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0
  \ )

"   CoC.
source ~/.config/nvim/_coc.vim

"   Emmet.
let g:user_emmet_mode='i'

"   Fzf.
let g:fzf_action = {
\ 'ctrl-t': 'tab split',
\ 'ctrl-s': 'split',
\ 'ctrl-v': 'vsplit',
\}

"   nvim-treesitter
"     See:
"       https://github.com/nvim-treesitter/nvim-treesitter#language-parsers
"     To update all parsers:
"       :TSUpdate
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

"   Ranger.
"     Hidde after picking a file.
let g:rnvimr_enable_picker = 1

" }}} Plugins settings.

" vim: foldmethod=marker
