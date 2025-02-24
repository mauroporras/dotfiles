# DotFiles

Settings for a development environment using Neovim and Zsh.

## Clone the repository

```bash
git clone git@github.com:mauroporras/dotfiles.git ~/dotfiles
```

## Install Homebrew

### Step 1:

[https://brew.sh](https://brew.sh)

### Step 2:

```bash
brew bundle --file ~/dotfiles/Brewfile
```

## Install the Nix package manager

[https://nixos.org/download](https://nixos.org/download)

## Neovim

If you are new to Neovim: `:h nvim`

If you're transitioning from Vim: `:h nvim-from-vim`

To optimize Neovim: `:checkhealth`

### Add Python support to Neovim

```bash
pip3 install --user --upgrade neovim
```

### Install LSP configs

```bash
npm add -g bash-language-server diagnostic-languageserver dockerfile-language-server-nodejs neovim prettier stylelint-lsp svelte-language-server @tailwindcss/language-server typescript typescript-language-server vscode-langservers-extracted yaml-language-server
```

## Finally, bootstrap DotFiles

```bash
~/dotfiles/bootstrap
~/dotfiles/git-config
```

## FAQ

[FAQ.md](FAQ.md)
