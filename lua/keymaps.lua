-- To find what's using a key map:
--   :verbose nmap <leader>b

-- See:
-- https://github.com/nanotee/nvim-lua-guide#defining-mappings

-- Leader.
vim.g.mapleader = ' '

-- Command line (:h mapmode-c).
vim.api.nvim_set_keymap('c', '<C-a>', '<Home>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-b>', '<Left>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-d>', '<Del>', { noremap = true })
vim.api.nvim_set_keymap('c', '<C-f>', '<Right>', { noremap = true })

-- Terminal (:h mapmode-t).
vim.api.nvim_set_keymap('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true })
vim.api.nvim_set_keymap('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true })
vim.api.nvim_set_keymap('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true })
vim.api.nvim_set_keymap('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true })

-- Insert.
vim.api.nvim_set_keymap('i', '<C-a>', '<Home>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-b>', '<Left>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-d>', '<Del>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-e>', '<End>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-f>', '<Right>', { noremap = true })

-- Normal.
vim.api.nvim_set_keymap('n', '<Esc>', ':nohlsearch<CR><Esc>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Down>', ':cnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Up>', ':cprevious<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>a', ':Rg<Space>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>i', ':FloatermNew lazygit<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>o', ':Files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>S', ':GFiles?<CR>', { noremap = true })
--   Scrolling.
vim.api.nvim_set_keymap('n', '<C-e>', '2<C-e>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-y>', '2<C-y>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-d>', '4<C-d>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-u>', '4<C-u>', { noremap = true })
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
-- vim.api.nvim_set_keymap('n', '<Leader>O', ':CocCommand explorer<CR>', { noremap = true })

--   Tabs.
vim.api.nvim_set_keymap('n', '<Leader>tt', ':$tabnew<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>tc', ':tabclose<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>th', ':-tabmove<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>tl', ':+tabmove<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<Leader>w', ':Windows<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>yt', ':BTags<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>zh', ':History<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>zl', ':Lines<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>zm', ':Marks<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>zt', ':Tags<CR>', { noremap = true })

--   Buffers.
vim.api.nvim_set_keymap('n', '<Leader>b', ':Buffers<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>d', ':bdelete<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>e', ':edit!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>l', ':edit #<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>n', ':bnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>p', ':bprevious<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>q', '<C-w>q', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>s', ':wall<CR>', { noremap = true })

-- gitsigns.
vim.api.nvim_set_keymap('n', '<Leader>vD', ':Gitsigns toggle_deleted<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>vd', ':Gitsigns diffthis<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>vn', ':Gitsigns next_hunk<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>vp', ':Gitsigns prev_hunk<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>vR', ':Gitsigns reset_buffer<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>vr', ':Gitsigns reset_hunk<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>vS', ':Gitsigns stage_buffer<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>vs', ':Gitsigns stage_hunk<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>vu', ':Gitsigns undo_stage_hunk<CR>', { noremap = true })

--   Ranger.
vim.api.nvim_set_keymap('n', '<Leader>r', ':RnvimrToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('t', '<M-r>', '<C-\\><C-n>:RnvimrResize<CR>', { noremap = true })

--   vim-which-key.
vim.api.nvim_set_keymap('n', '<Leader>', ":WhichKey '<Space>'<CR>", { noremap = true })

--   vim-sneak.
vim.api.nvim_set_keymap('n', '<Leader>/', '<Plug>Sneak_s', {})
vim.api.nvim_set_keymap('n', '<Leader>?', '<Plug>Sneak_S', {})
vim.api.nvim_set_keymap('v', '<Leader>/', '<Plug>Sneak_s', {})
vim.api.nvim_set_keymap('v', '<Leader>?', '<Plug>Sneak_S', {})
vim.api.nvim_set_keymap('n', ';', ';', { noremap = true })
vim.api.nvim_set_keymap('n', ',', ',', { noremap = true })
