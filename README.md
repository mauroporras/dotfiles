# DotFiles

Configs for setting up a development environment using Neovim and Zsh on Kitty.

## Install Homebrew

[https://brew.sh](https://brew.sh)

## Install dependencies using Homebrew

```bash
brew bundle
```

## Install Oh My Zsh

[https://github.com/robbyrussell/oh-my-zsh/blob/master/README.md](https://github.com/robbyrussell/oh-my-zsh/blob/master/README.md)

## Considerations for Neovim

If you are new: `:h nvim`

If you're transitioning from Vim: `:h nvim-from-vim`

To optimize Neovim: `:checkhealth`

## Add Python support to Neovim

```bash
pip3 install --user --upgrade neovim
```

## Install LSP configs

```bash
pnpm add -g bash-language-server diagnostic-languageserver dockerfile-language-server-nodejs neovim prettier stylelint-lsp svelte-language-server @tailwindcss/language-server typescript typescript-language-server vscode-langservers-extracted yaml-language-server
```

## Install required utilities

[https://github.com/cli/cli#installation](https://github.com/cli/cli#installation)
(required for the aliases).

[https://github.com/BurntSushi/ripgrep#installation](https://github.com/BurntSushi/ripgrep#installation)

[https://github.com/junegunn/fzf#installation](https://github.com/junegunn/fzf#installation)

## Finally, bootstrap DotFiles

```bash
git clone https://github.com/mauroporras/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap
~/dotfiles/git-config
```

---

## Optional

[Spaceship Zsh prompt](https://github.com/spaceship-prompt/spaceship-prompt#installing)

[https://github.com/direnv/direnv](https://github.com/direnv/direnv)

[https://ctags.io](https://ctags.io)

[https://formulae.brew.sh/formula/coreutils](https://formulae.brew.sh/formula/coreutils)

## Quick links

[https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg](https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg)
