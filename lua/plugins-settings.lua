-- CoC.
vim.cmd([[
  source ~/.config/nvim/_coc.vim
]])

-- Emmet.
vim.g.user_emmet_mode = 'i'

-- nvim-treesitter
--   See:
--     https://github.com/nvim-treesitter/nvim-treesitter#language-parsers
--   To update all parsers:
--     :TSUpdate
--   To list all available commands:
--     :h nvim-treesitter-commands
require'nvim-treesitter.configs'.setup({
  -- one of: "all", "maintained" (parsers with maintainers), or a list of languages.
  ensure_installed = "maintained",
  -- List of parsers to ignore installing.
  ignore_install = { },
  highlight = {
    -- false will disable the whole extension
    enable = true,
    -- list of language that will be disabled
    disable = { },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

-- quick-scope.
vim.g.qs_highlight_on_keys = {
  'f',
  'F',
  't',
  'T',
}

-- Ranger.
--   Hide after picking a file.
vim.g.rnvimr_enable_picker = 1

-- Rg.
vim.cmd([[
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   "rg --follow --hidden --smart-case --no-ignore --glob '!{.git,dist,node_modules,tags}' --column --line-number --no-heading --color=always -- ".shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0
    \ )
]])

-- vim-sneak.
--   For a minimalist alternative to EasyMotion.
vim.g['sneak#label'] = 1
