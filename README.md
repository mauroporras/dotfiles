# DotFiles

Cool configs for Neovim, tmux and Git, on Zsh.

[https://hub.docker.com/r/mporras/dotfiles](https://hub.docker.com/r/mporras/dotfiles)

## 1. Install Zsh and Oh My Zsh

https://github.com/robbyrussell/oh-my-zsh/blob/master/README.md


## 2. Install Neovim

[https://github.com/neovim/neovim/wiki/Installing-Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)

If you're transitioning from Vim: `:h nvim-from-vim`


## 3. Add Python support to Neovim

``` bash
pip3 install --user --upgrade neovim
```


## 4. Install tmux and Git


### macOS (Using MacPorts)

``` bash
sudo port install tmux git
```


### Ubuntu

``` bash
sudo apt install -y tmux git
```


## 5. Install utilities for browsing & searching

[https://ctags.io](https://ctags.io)

[https://ranger.github.io](https://ranger.github.io)

[https://github.com/junegunn/fzf#installation](https://github.com/junegunn/fzf#installation)

[https://github.com/ggreer/the_silver_searcher#installing](https://github.com/ggreer/the_silver_searcher#installing)


## 6. Finally, bootstrap DotFiles

``` bash
git clone https://github.com/mauroporras/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap
~/dotfiles/git-config
```


______


## Optional

[https://formulae.brew.sh/formula/coreutils](https://formulae.brew.sh/formula/coreutils)

[https://github.com/tony/tmuxp](https://github.com/tony/tmuxp)

[https://github.com/editorconfig/editorconfig-vim](https://github.com/editorconfig/editorconfig-vim)

[http://input.fontbureau.com](http://input.fontbureau.com)

[https://github.com/chriskempson/base16-shell](https://github.com/chriskempson/base16-shell)

[https://github.com/direnv/direnv](https://github.com/direnv/direnv)

[https://github.com/denysdovhan/spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt)


## Quick links

[https://man.openbsd.org/tmux.1#DEFAULT_KEY_BINDING](https://man.openbsd.org/tmux.1#DEFAULT_KEY_BINDING)
[https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg](https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg)
