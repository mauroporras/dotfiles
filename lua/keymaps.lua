-- To find what's using a key map:
--   :verbose nmap <leader>b

-- See:
-- https://github.com/nanotee/nvim-lua-guide#defining-mappings

-- Leader.
vim.g.mapleader = ' '

local optNRM = { noremap = true }

-- Command line (:h mapmode-c).
vim.api.nvim_set_keymap('c', '<C-a>', '<Home>', optNRM)
vim.api.nvim_set_keymap('c', '<C-b>', '<Left>', optNRM)
vim.api.nvim_set_keymap('c', '<C-d>', '<Del>', optNRM)
vim.api.nvim_set_keymap('c', '<C-f>', '<Right>', optNRM)

-- Terminal (:h mapmode-t).
vim.api.nvim_set_keymap('t', '<C-w>h', '<C-\\><C-n><C-w>h', optNRM)
vim.api.nvim_set_keymap('t', '<C-w>j', '<C-\\><C-n><C-w>j', optNRM)
vim.api.nvim_set_keymap('t', '<C-w>k', '<C-\\><C-n><C-w>k', optNRM)
vim.api.nvim_set_keymap('t', '<C-w>l', '<C-\\><C-n><C-w>l', optNRM)

-- Insert.
vim.api.nvim_set_keymap('i', '<C-a>', '<Home>', optNRM)
vim.api.nvim_set_keymap('i', '<C-b>', '<Left>', optNRM)
vim.api.nvim_set_keymap('i', '<C-d>', '<Del>', optNRM)
vim.api.nvim_set_keymap('i', '<C-e>', '<End>', optNRM)
vim.api.nvim_set_keymap('i', '<C-f>', '<Right>', optNRM)

-- Normal.
vim.api.nvim_set_keymap('n', '<Esc>', ':nohlsearch<CR><Esc>', optNRM)
vim.api.nvim_set_keymap('n', '<Down>', ':cnext<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Up>', ':cprevious<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>a', ':Rg<Space>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>i', ':FloatermNew lazygit<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>o', ':Files<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>S', ':GFiles?<CR>', optNRM)
--   Code.
vim.api.nvim_set_keymap('n', '<Leader>co', ':Vista!!<CR>', optNRM)
--   Scrolling.
vim.api.nvim_set_keymap('n', '<C-e>', '2<C-e>', optNRM)
vim.api.nvim_set_keymap('n', '<C-y>', '2<C-y>', optNRM)
vim.api.nvim_set_keymap('n', '<C-d>', '4<C-d>', optNRM)
vim.api.nvim_set_keymap('n', '<C-u>', '4<C-u>', optNRM)
--   LSP.
--     See `:help vim.diagnostic.*` for documentation on any of the functions below.
-- vim.api.nvim_set_keymap('i', '<C-j>', '<Plug>(coc-snippets-expand-jump)', {})
vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>lua vim.diagnostic.goto_next()<CR>', {})
vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>cd', '<cmd>lua vim.diagnostic.open_float()<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>ch', '<cmd>lua vim.lsp.buf.hover()<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', {})
-- vim.api.nvim_set_keymap('n', '<Leader>cz', '', {})
vim.api.nvim_set_keymap('n', '<Leader>E', ':LspRestart<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', {})
-- vim.api.nvim_set_keymap('n', '<Leader>O', ':CocCommand explorer<CR>', optNoremap)

--   Tabs.
vim.api.nvim_set_keymap('n', '<Leader>tt', ':$tabnew<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>tc', ':tabclose<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>th', ':-tabmove<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>tl', ':+tabmove<CR>', optNRM)

vim.api.nvim_set_keymap('n', '<Leader>w', ':Windows<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>yt', ':BTags<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>zh', ':History<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>zl', ':Lines<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>zm', ':Marks<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>zt', ':Tags<CR>', optNRM)

--   Buffers.
vim.api.nvim_set_keymap('n', '<Leader>b', ':Buffers<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>d', ':bdelete<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>e', ':edit!<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>l', ':edit #<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>n', ':bnext<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>p', ':bprevious<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>q', '<C-w>q', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>s', ':wall<CR>', optNRM)

--   gitsigns.
vim.api.nvim_set_keymap('n', '<Leader>vb', ':Gitsigns blame_line<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vD', ':Gitsigns toggle_deleted<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vd', ':Gitsigns diffthis<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vn', ':Gitsigns next_hunk<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vp', ':Gitsigns prev_hunk<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vR', ':Gitsigns reset_buffer<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vr', ':Gitsigns reset_hunk<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vS', ':Gitsigns stage_buffer<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vs', ':Gitsigns stage_hunk<CR>', optNRM)
vim.api.nvim_set_keymap('n', '<Leader>vu', ':Gitsigns undo_stage_hunk<CR>', optNRM)

--   leap.nvim
vim.api.nvim_set_keymap('n', '<Leader>/', '<Plug>(leap-forward-to)', {})
vim.api.nvim_set_keymap('n', '<Leader>?', '<Plug>(leap-backward-to)', {})

--   Ranger.
vim.api.nvim_set_keymap('n', '<Leader>r', ':RnvimrToggle<CR>', optNRM)
vim.api.nvim_set_keymap('t', '<M-r>', '<C-\\><C-n>:RnvimrResize<CR>', optNRM)

--   vim-which-key.
vim.api.nvim_set_keymap('n', '<Leader>', ":WhichKey '<Space>'<CR>", optNRM)
