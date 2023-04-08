
#!/bin/sh

set -e

DOTFILE_REPO=https://github.com/jion-kozono/dotfiles.git

if [ ! -e ~/dotfiles ]; then
    cd ~
    git clone ${DOTFILE_REPO}
fi

# brew がインストールされていなければインストール
if [ -z "$(command -v brew)" ]; then
    echo "--- Install Homebrew is Start! ---"

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew bundle

    echo "--- Install Homebrew is Done!  ---"
fi

# vim-plugをインストール
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "--- Link dotfiles is Start! ---"

mkdir -p ~/.config

# vim
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc

# zsh
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc

# asdf
ln -sf ~/dotfiles/asdf/.asdfrc ~/.asdfrc
ln -sf ~/dotfiles/asdf/.tool-versions ~/.tool-versions
asdf install

# git
mkdir -p ~/.config/git
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/git/ignore ~/.config/git/ignore
ln -sf ~/dotfiles/git/office ~/.config/git/office

# dotfiles
mkdir -p ~/ghq
ln -sf ~/dotfiles ~/ghq/dotfiles
