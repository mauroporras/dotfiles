# DotFiles

Configs for setting up a development environment using Neovim and Zsh on Kitty.

## Packages and dependencies

### Install the Nix package manager

[https://nixos.org/download](https://nixos.org/download)

### Install Homebrew

#### Step 1:

[https://brew.sh](https://brew.sh)

#### Step 2:

```bash
brew bundle
```

### Install Oh My Zsh

#### Step 1:

```bash
nix-shell --command zsh -p curl
```

#### Step 2:

[https://ohmyz.sh/#install](https://ohmyz.sh/#install)

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
pnpm add -g bash-language-server diagnostic-languageserver dockerfile-language-server-nodejs neovim prettier stylelint-lsp svelte-language-server @tailwindcss/language-server typescript typescript-language-server vscode-langservers-extracted yaml-language-server
```

## Finally, bootstrap DotFiles

```bash
git clone https://github.com/mauroporras/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap
~/dotfiles/git-config
```

---

## Optional

[Spaceship Zsh prompt](https://github.com/spaceship-prompt/spaceship-prompt#installing)

[https://ctags.io](https://ctags.io)

[https://formulae.brew.sh/formula/coreutils](https://formulae.brew.sh/formula/coreutils)

## Quick links

[https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg](https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg)
