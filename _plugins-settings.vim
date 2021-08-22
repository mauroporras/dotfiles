" Ag.
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(
  \   <q-args>,
  \   '--hidden --ignore .git',
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0
  \ )

" CoC.
source ~/.config/nvim/_coc.vim

" Emmet.
let g:user_emmet_mode='i'

" Fzf.
let g:fzf_action = {
\ 'ctrl-t': 'tab split',
\ 'ctrl-s': 'split',
\ 'ctrl-v': 'vsplit',
\}

" nvim-treesitter
"   See:
"     https://github.com/nvim-treesitter/nvim-treesitter#language-parsers
"   To update all parsers:
"     :TSUpdate
"   To list all available commands:
"     :h nvim-treesitter-commands
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

" Ranger.
"   Hide after picking a file.
let g:rnvimr_enable_picker = 1
