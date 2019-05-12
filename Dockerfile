FROM ubuntu

ENV TERM xterm-256color

WORKDIR /root/

RUN apt-get -qq update && \
    apt-get -qq install -y apt-utils cmake curl direnv git python-dev python-pip python3-dev python3-pip ranger software-properties-common silversearcher-ag tmux zsh

# Install NeoVim.
RUN add-apt-repository ppa:neovim-ppa/stable

RUN apt-get -qq update && \
    apt-get -qq install -y neovim

RUN pip3 install --user --upgrade neovim tmuxp

# Install Oh My Zsh.
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install utilities.
RUN git clone --depth=1 --quiet https://github.com/junegunn/fzf.git && \
    ./fzf/install

# Bootstrap dotfiles repo.
RUN git clone --depth=1 --quiet https://github.com/mauroporras/dotfiles.git && \
    ./dotfiles/bootstrap

CMD ["zsh"]
