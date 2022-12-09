# DotFiles

Configs for Neovim, tmux and Git, on Zsh.

## 1. Install Zsh and Oh My Zsh

[https://github.com/robbyrussell/oh-my-zsh/blob/master/README.md](https://github.com/robbyrussell/oh-my-zsh/blob/master/README.md)

## 2. Install Neovim

[https://github.com/neovim/neovim/wiki/Installing-Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)

If you are new: `:h nvim`

If you're transitioning from Vim: `:h nvim-from-vim`

To optimize Neovim: `:checkhealth`

## 3. Add Python support to Neovim

```bash
pip3 install --user --upgrade neovim
```

## 4. Install tmux and Git

For tmux support: [https://github.com/tmux/tmux/wiki/FAQ](https://github.com/tmux/tmux/wiki/FAQ)

## 5. Install LSP configs

```bash
pnpm add -g bash-language-server diagnostic-languageserver dockerfile-language-server-nodejs neovim prettier stylelint-lsp svelte-language-server tailwindcss-language-server typescript typescript-language-server vscode-langservers-extracted yaml-language-server
```

Use `pnpm root -g` to display the root directory where global packages are installed.

### macOS (Using MacPorts)

```bash
sudo port install tmux git
```

### Ubuntu

```bash
sudo apt install -y tmux git
```

## 5. Install required utilities

[https://github.com/cli/cli#installation](https://github.com/cli/cli#installation)
(required for the aliases).

[https://github.com/BurntSushi/ripgrep#installation](https://github.com/BurntSushi/ripgrep#installation)

[https://github.com/junegunn/fzf#installation](https://github.com/junegunn/fzf#installation)

[https://github.com/kevinhwang91/rnvimr#installation](https://github.com/kevinhwang91/rnvimr#installation)

## 6. Finally, bootstrap DotFiles

```bash
git clone https://github.com/mauroporras/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap
~/dotfiles/git-config
```

---

## Optional

[Spaceship Zsh prompt](https://github.com/spaceship-prompt/spaceship-prompt#installing)

[https://github.com/jwilm/alacritty](https://github.com/jwilm/alacritty)

[https://github.com/tony/tmuxp](https://github.com/tony/tmuxp)

[https://github.com/direnv/direnv](https://github.com/direnv/direnv)

[http://input.fontbureau.com](http://input.fontbureau.com)

[https://ctags.io](https://ctags.io)

[https://formulae.brew.sh/formula/coreutils](https://formulae.brew.sh/formula/coreutils)

## Quick links

[https://man.openbsd.org/tmux.1#DEFAULT_KEY_BINDINGS](https://man.openbsd.org/tmux.1#DEFAULT_KEY_BINDINGS)

[https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg](https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg)
