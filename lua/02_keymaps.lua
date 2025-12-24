-- vim:foldmethod=marker

-- See
--   `:h vim.keymap.set()`
--   https://github.com/nanotee/nvim-lua-guide#defining-mappings

-- To find what's using a key map:
--   :verbose nmap <leader>b

-- Clear highlights on search when pressing <Esc> in normal mode
--   See `:h hlsearch`
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

-- Window navigation {{{
-- See:
--   :h wincmd
--
-- Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
-- }}}

-- Reload buffer preserving position
vim.keymap.set("n", "<Leader>e", function()
  local view = vim.fn.winsaveview()
  vim.cmd("edit!")
  vim.fn.winrestview(view)
end, { desc = "Reload buffer preserving position" })

-- Restart LSP server(s)
vim.keymap.set("n", "<Leader>E", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })

-- Open Lazy plugin manager
vim.keymap.set("n", "<Leader>L", "<cmd>Lazy<CR>", { desc = "Open Lazy plugin manager" })

-- Disabled keymaps {{{
-- Disabled to unlearn shortcuts
vim.keymap.set("n", "<C-w><C-w>", "<Nop>", { desc = "Disabled" })
vim.keymap.set("n", "<C-w>h", "<Nop>", { desc = "Disabled" })
vim.keymap.set("n", "<C-w>l", "<Nop>", { desc = "Disabled" })
vim.keymap.set("n", "<C-w>j", "<Nop>", { desc = "Disabled" })
vim.keymap.set("n", "<C-w>k", "<Nop>", { desc = "Disabled" })
-- }}}

-- Tabs {{{
vim.keymap.set("n", "<Leader>tn", "<cmd>tabnew<CR>", { desc = "New tab after current" })
vim.keymap.set("n", "<Leader>tp", "<cmd>-tabnew<CR>", { desc = "New tab before current" })
vim.keymap.set("n", "<Leader>tt", "<cmd>$tabnew<CR>", { desc = "New tab at end" })
vim.keymap.set("n", "<Leader>tT", "<cmd>0tabnew<CR>", { desc = "New tab at beginning" })
vim.keymap.set("n", "<Leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<Leader>to", "<cmd>tabonly<CR>", { desc = "Close other tabs" })
vim.keymap.set("n", "<Leader>ts", "<cmd>tab split<CR>", { desc = "Split to new tab" }) -- <C-w>T moves instead of copying
vim.keymap.set("n", "<Leader>tf", "<cmd>tabfirst<CR>", { desc = "First tab" })
vim.keymap.set("n", "<Leader>tl", "<cmd>tablast<CR>", { desc = "Last tab" })
vim.keymap.set("n", "<M-h>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<M-l>", "<cmd>tabnext<CR>", { desc = "Next tab" })
-- }}}

-- Buffers {{{
vim.keymap.set("n", "<Leader>d", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<Leader>l", "<cmd>edit #<CR>", { desc = "Alternate buffer" })
vim.keymap.set("n", "<Leader>s", "<cmd>wall<CR>", { desc = "Save all buffers" })
vim.keymap.set("n", "<Left>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<Right>", "<cmd>bnext<CR>", { desc = "Next buffer" })
-- }}}

-- Windows
vim.keymap.set("n", "<Leader>q", "<C-w>q", { desc = "Close window" })

-- Quickfix
vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "<C-p>", "<cmd>cprevious<CR>", { desc = "Previous quickfix item" })

-- Folding {{{
-- See:
--   :h foldmethod
--
-- In visual mode, use zf to create a fold from the selection.
--
-- Modelines are special comments that set Vim options for a specific file.
-- Place them at the top or bottom of a file (within first/last 5 lines).
-- See :h modeline
--
-- Examples:
--   -- vim:foldmethod=marker
--   -- vim:foldmethod=indent
--   # vim:foldmethod=syntax   (for shell scripts)
--   // vim:foldmethod=manual  (for C/JS/etc)
vim.keymap.set("n", "<Leader>Fd", "<cmd>set nofoldenable<CR>", { desc = "Disable folding" })
vim.keymap.set("n", "<Leader>Fe", "<cmd>set foldmethod=expr<CR>", { desc = "Fold via foldexpr (Treesitter)" })
vim.keymap.set("n", "<Leader>Fi", "<cmd>set foldmethod=indent<CR>", { desc = "Fold based on indentation level" })
vim.keymap.set(
  "n",
  "<Leader>FM",
  "<cmd>set foldmethod=marker<CR>",
  { desc = "Fold between commented {{{ and }}} markers" }
)
vim.keymap.set("n", "<Leader>Fm", "<cmd>set foldmethod=manual<CR>", { desc = "Create folds manually with zf" })
vim.keymap.set("n", "<Leader>Fs", "<cmd>set foldmethod=syntax<CR>", { desc = "Fold from syntax highlighting" })
-- }}}

-- Scrolling
vim.keymap.set("n", "<C-d>", "5<C-d>")
vim.keymap.set("n", "<C-u>", "5<C-u>")

-- Command line {{{
-- See:
--   :h mapmode-c
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-b>", "<Left>")
vim.keymap.set("c", "<C-d>", "<Del>")
vim.keymap.set("c", "<C-f>", "<Right>")
-- }}}

-- Terminal {{{
-- See:
--   :h mapmode-t
vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h", { desc = "Move focus to left window" })
vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j", { desc = "Move focus to lower window" })
vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k", { desc = "Move focus to upper window" })
vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l", { desc = "Move focus to right window" })
-- }}}

-- Insert {{{
-- See:
--   :h mapmode-i
vim.keymap.set("i", "<C-a>", "<Home>")
vim.keymap.set("i", "<C-b>", "<Left>")
vim.keymap.set("i", "<C-d>", "<Del>")
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-f>", "<Right>")
-- }}}
