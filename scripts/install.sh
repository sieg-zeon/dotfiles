#!/bin/sh

set -eu

DOTFILE_REPO=https://github.com/jion-kozono/dotfiles.git

if [ ! -e ~/dotfiles ]; then
    cd ~
    git clone ${DOTFILE_REPO}
fi

# Homebrew
if [ -z "$(command -v brew)" ]; then
    echo "--- Install Homebrew is Start! ---"

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo "--- Install Homebrew is Done!  ---"
fi


which /opt/homebrew/bin/brew >/dev/null 2>&1 && echo "Execute brew doctor..." && brew doctor


which /opt/homebrew/bin/brew >/dev/null 2>&1 && echo "Execute brew update..." && brew update --verbose

which /opt/homebrew/bin/brew >/dev/null 2>&1 && echo "Execute brew upgrade..." && brew upgrade --verbose

echo "Execute brew bundle in Brewfile..."
brew bundle --file ./Brewfile --verbose

which brew >/dev/null 2>&1 && echo "Execute brew cleanup..." && brew cleanup --verbose

# vim-plug
echo "--- Install vim-plug is Start! ---"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "--- Install Xcode Command Line Tools is Start! ---"
which xcode-select >/dev/null 2>&1 || xcode-select --install

# mise
echo "--- Install mise install is Start! ---"
chmod u+x mise/_mise.sh
mise/_mise.sh

# Volta install
echo "--- Install Volta is Start! ---"
volta install node
volta install yarn
volta install pnpm

# git
mkdir -p ~/.config/git
ln -sf ~/dotfiles/git/ignore ~/.config/git/ignore

# シンボリックリンクの作成
echo "--- Create symbolic link is Start! ---"
# vim
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/mise/.tool-versions ~/.tool-versions
ln -sf ~/dotfiles/atcoder/.atcodertools.toml ~/.atcodertools.toml
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig

echo "--- Create symbolic link is Done! ---"
echo "All Done!"
