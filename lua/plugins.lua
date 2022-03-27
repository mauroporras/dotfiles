-- Runs whenever this file is updated.
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Install "packer.nvim" if not present.
-- See:
-- https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then

  packer_bootstrap = fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path
  })

  print('Packer has been installed into "'..install_path..'". Restart Neovim and run `:PackerSync`.')
end

return require('packer').startup(function(use)
  -- Packer can manage itself.
  use 'wbthomason/packer.nvim'

  -- Fzf.
  use {
   'junegunn/fzf',
   run = ':call fzf#install()'
  }
  use 'junegunn/fzf.vim'

  -- Misc.
  use 'andrewradev/inline_edit.vim'
  use 'antonk52/vim-browserslist'
  use 'editorconfig/editorconfig-vim'
  use 'euclidianAce/BetterLua.vim'
  use 'honza/vim-snippets'
  use 'jiangmiao/auto-pairs'
  use 'justinmk/vim-sneak'
  use 'kevinhwang91/rnvimr'
  use 'kevinoid/vim-jsonc'
  use {
    'liuchengxu/vim-which-key',
    cmd = { 'WhichKey', 'WhichKey!' }
  }
  use 'mattn/emmet-vim'
  use 'neovim/nvim-lspconfig'
  use {
   'nvim-treesitter/nvim-treesitter',
   run = ':TSUpdate'
  }
  use 'rakr/vim-one'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'unblevable/quick-scope'

  -- Automatically set up your configuration after cloning packer.nvim.
  -- Put this at the end after all plugins.
  if packer_bootstrap then
    require('packer').sync()
  end
end)
