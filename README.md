# DotVim

Awesome configuration and plugins for Vim and Tmux.


## To install Vim and Tmux


### In Ubuntu, use GVim

````
sudo apt-get install -y vim-gnome tmux
````


### In Macintosh, use MacVim

[https://github.com/b4winckler/macvim/releases](https://github.com/b4winckler/macvim/releases)

Then, install Tmux:
````
brew install tmux
````


## To install DotVim

````
cd; rm -rf ~/.vim ~/.vimrc ~/.tmux.conf
git clone git@github.com:mporras/dotvim.git ~/.vim
~/.vim/bootstrap
````


## To update all plugins

Run `:PluginUpdate` inside Vim.
