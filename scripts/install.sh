#!/bin/sh

set -eu

DOTFILE_REPO=https://github.com/jion-kozono/dotfiles.git

if [ ! -e ~/dotfiles ]; then
    cd ~
    git clone ${DOTFILE_REPO}
fi

# git
mkdir -p ~/.config/git
ln -sf ~/dotfiles/git/ignore ~/.config/git/ignore

# 共通で持ちたくないalias用のファイル作成
touch ~/dotfiles/git/alias.sh

# シンボリックリンクの作成
echo "--- Create symbolic link is Start! ---"
# vim
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/mise/.tool-versions ~/.tool-versions
ln -sf ~/dotfiles/atcoder/.atcodertools.toml ~/.atcodertools.toml
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig # configを分ける場合は、unlink ~/.gitconfig

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
brew bundle --file=~/dotfiles/Brewfile --verbose

which brew >/dev/null 2>&1 && echo "Execute brew cleanup..." && brew cleanup --verbose

# vim-plug
echo "--- Install vim-plug is Start! ---"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "--- Install Xcode Command Line Tools is Start! ---"
which xcode-select >/dev/null 2>&1 || xcode-select --install
sudo xcodebuild -license accept

# mise
echo "--- Install mise install is Start! ---"
chmod u+x mise/_mise.sh
mise/_mise.sh
echo "--- Install mise install is Done! ---"

# Volta install
echo "--- Install Volta is Start! ---"
volta install node
volta install yarn
volta install pnpm
echo "--- Install Volta is Done! ---"

# npm install
echo "--- Install npm package is Start! ---"
npm i -g @antfu/ni
echo "--- Install npm package is Done! ---"

# tiup: https://docs.pingcap.com/ja/tidb/stable/tiup-overview#install-tiup
curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh

# pair_or_unpair_deviceのシンボリックリンク
sudo ln -s ~/dotfiles/scripts/pair_or_unpair_device.sh /usr/local/bin/pair_or_unpair_device
chmod 755 /usr/local/bin/pair_or_unpair_device

# gh setup
gh config set editor "code --wait"

# AI configuration files update
echo "--- Update AI configuration files is Start! ---"
chmod +x ~/dotfiles/scripts/update-ai-configs.sh
~/dotfiles/scripts/update-ai-configs.sh
echo "--- Update AI configuration files is Done! ---"

# source zsh
source ~/.zshrc

echo "All Done!"
