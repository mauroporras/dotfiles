# DotFiles

Configs for Neovim, tmux and Git, on Zsh.

[https://hub.docker.com/r/mauroporras/dotfiles](https://hub.docker.com/r/mauroporras/dotfiles)

## 1. Install Zsh and Oh My Zsh

https://github.com/robbyrussell/oh-my-zsh/blob/master/README.md

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

[https://github.com/ggreer/the_silver_searcher#installing](https://github.com/ggreer/the_silver_searcher#installing)

[https://github.com/junegunn/fzf#installation](https://github.com/junegunn/fzf#installation)

[https://github.com/ranger/ranger#installing](https://github.com/ranger/ranger#installing)

## 6. Finally, bootstrap DotFiles

```bash
git clone https://github.com/mauroporras/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap
~/dotfiles/git-config
~/dotfiles/install-terms
```

---

## Optional

[https://ctags.io](https://ctags.io)

[https://github.com/jwilm/alacritty](https://github.com/jwilm/alacritty)

[https://formulae.brew.sh/formula/coreutils](https://formulae.brew.sh/formula/coreutils)

[https://github.com/tony/tmuxp](https://github.com/tony/tmuxp)

[http://input.fontbureau.com](http://input.fontbureau.com)

[https://github.com/direnv/direnv](https://github.com/direnv/direnv)

[https://github.com/denysdovhan/spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt)

## Quick links

[https://man.openbsd.org/tmux.1#DEFAULT_KEY_BINDINGS](https://man.openbsd.org/tmux.1#DEFAULT_KEY_BINDINGS)

[https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg](https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg)
