" CoC recommended settings.
" See:
" https://github.com/neoclide/coc.nvim#example-vim-configuration

" To Open settings file:
"   :CocConfig
" To update all extensions:
"   :CocUpdate
" To list stuff:
"   :CocList
"   E.g.:
"     :CocList extensions
"     :CocList snippets
let g:coc_global_extensions = [
\ 'coc-css',
\ 'coc-emmet',
\ 'coc-eslint',
\ 'coc-explorer',
\ 'coc-flutter',
\ 'coc-git',
\ 'coc-highlight',
\ 'coc-html',
\ 'coc-json',
\ 'coc-lit-html',
\ 'coc-markdownlint',
\ 'coc-prettier',
\ 'coc-snippets',
\ 'coc-svelte',
\ 'coc-swagger',
\ 'coc-tailwindcss',
\ 'coc-tsserver',
\ 'coc-yaml',
\ 'coc-yank'
\]

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=333

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
