# DotFiles

Configs for Neovim, tmux and Git, on Zsh.

## Install Zsh and Oh My Zsh

[https://github.com/robbyrussell/oh-my-zsh/blob/master/README.md](https://github.com/robbyrussell/oh-my-zsh/blob/master/README.md)

## Install Neovim

[https://github.com/neovim/neovim/wiki/Installing-Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)

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

## Install tmux and Git

For tmux support: [https://github.com/tmux/tmux/wiki/FAQ](https://github.com/tmux/tmux/wiki/FAQ)

Use `pnpm root -g` to display the root directory where global packages are installed.

### macOS (Using Homebrew)

```bash
brew install tmux git
```

### Ubuntu

```bash
sudo apt install -y tmux git
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

[https://github.com/tony/tmuxp](https://github.com/tony/tmuxp)

[https://github.com/direnv/direnv](https://github.com/direnv/direnv)

[https://ctags.io](https://ctags.io)

[https://formulae.brew.sh/formula/coreutils](https://formulae.brew.sh/formula/coreutils)

### How to patch the Input Mono Narrow font

1. Setup the font patcher: https://github.com/ryanoasis/nerd-fonts#font-patcher

2. Download the font archive: [http://input.fontbureau.com](http://input.fontbureau.com)

3. Extract the font archive into the patcher's dir.

4. From the patcher's dir, run these commands:

```bash
fontforge -script font-patcher -c --name postscript ./Input-Font/Bold.ttf
fontforge -script font-patcher -c --name postscript ./Input-Font/BoldItalic.ttf
fontforge -script font-patcher -c --name postscript ./Input-Font/Italic.ttf
fontforge -script font-patcher -c --name postscript ./Input-Font/Regular.ttf
```

## Quick links

[https://man.openbsd.org/tmux.1#DEFAULT_KEY_BINDINGS](https://man.openbsd.org/tmux.1#DEFAULT_KEY_BINDINGS)

[https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg](https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg)
