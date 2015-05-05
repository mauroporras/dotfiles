# DotVim

Awesome configuration and plugins for Vim (Neovim) and Tmux.


## Install Neovim

[https://github.com/neovim/neovim/wiki/Installing-Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)


## Install Tmux


### In Ubuntu

````
sudo apt-get install -y tmux
````


### In Macintosh

````
brew install tmux
````


## Bootstrap DotVim

````
cd; rm -rf ~/.tmux.conf ~/.nvimrc ~/.nvim ~/.vimrc ~/.vim
git clone https://github.com/mporras/dotvim.git ~/.vim
~/.vim/bootstrap
````


## To update all plugins

Run `:PluginUpdate` inside Vim.
