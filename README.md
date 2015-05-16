# DotFiles

Awesome configuration and plugins for Vim (Neovim), Git and Tmux.


## Install Neovim

[https://github.com/neovim/neovim/wiki/Installing-Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)


## Install Git and Tmux


### In Ubuntu

````
sudo apt-get install -y git tmux
````


### In Macintosh

[http://git-scm.com/download/mac](http://git-scm.com/download/mac)

````
brew install tmux
````


## Bootstrap DotFiles

````
cd; rm -rf ~/.tmux.conf ~/.nvimrc ~/.nvim ~/.vimrc ~/.vim
git clone https://github.com/mporras/dotfiles.git ~/.vim
~/.vim/bootstrap
````


## To update all plugins

Run `:PluginUpdate` inside Vim.
