-- vim:foldmethod=marker

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- To find what's using a key map:
--   :verbose nmap <leader>b

-- See:
-- https://github.com/nanotee/nvim-lua-guide#defining-mappings

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Save all buffers
vim.keymap.set("n", "<Leader>s", "<cmd>wall<CR>", { desc = "Save all buffers" })

-- Reload file and preserve scroll position
vim.keymap.set("n", "<Leader>e", function()
  local view = vim.fn.winsaveview()
  vim.cmd("edit!")
  vim.fn.winrestview(view)
end, { desc = "Reload file preserving position" })

-- Restart LSP server(s)
vim.keymap.set("n", "<Leader>E", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })

-- Windows (disabled to unlearn shortcuts)
vim.keymap.set("n", "<C-w><C-w>", "<Nop>", { desc = "Disabled" })
vim.keymap.set("n", "<C-w>h", "<Nop>", { desc = "Disabled" })
vim.keymap.set("n", "<C-w>l", "<Nop>", { desc = "Disabled" })
vim.keymap.set("n", "<C-w>j", "<Nop>", { desc = "Disabled" })
vim.keymap.set("n", "<C-w>k", "<Nop>", { desc = "Disabled" })

-- Tabs
vim.keymap.set("n", "<Leader>tn", "<cmd>tabnew<CR>", { desc = "New tab after current" })
vim.keymap.set("n", "<Leader>tp", "<cmd>-tabnew<CR>", { desc = "New tab before current" })
vim.keymap.set("n", "<Leader>tt", "<cmd>$tabnew<CR>", { desc = "New tab at end" })
vim.keymap.set("n", "<Leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<Leader>ts", "<cmd>tab split<CR>", { desc = "Split to new tab" }) -- <C-w>T moves instead of copying
vim.keymap.set("n", "<M-h>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<M-l>", "<cmd>tabnext<CR>", { desc = "Next tab" })

-- Buffers
vim.keymap.set("n", "<Leader>d", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<Leader>l", "<cmd>edit #<CR>", { desc = "Alternate buffer" })
vim.keymap.set("n", "<Left>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<Right>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Windows
vim.keymap.set("n", "<Leader>q", "<C-w>q", { desc = "Close window" })

-- Command line (:h mapmode-c)
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-b>", "<Left>")
vim.keymap.set("c", "<C-d>", "<Del>")
vim.keymap.set("c", "<C-f>", "<Right>")
