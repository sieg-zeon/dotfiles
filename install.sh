
#!/bin/sh

set -e

# if [ "$(dscl . -read ~/ UserShell)" = "UserShell: /bin/bash" ]; then
#     chsh -s /bin/zsh
#     chmod -R 755 /usr/local/share/zsh
#     chown -R root:staff zsh
# fi

if [ ! -f /opt/homebrew/bin/brew ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -d ~/dotfiles ]; then
    cd ~
    git clone https://github.com/jion-kozono/dotfiles.git
fi

# brew bundle -v --file "$CLONE_PATH"/tutorials/dotfiles/Brewfile


# if [ ! -d ~/.config ]; then
#     mkdir ~/.config/
# fi

# stow -v -d "$CLONE_PATH"/tutorials/dotfiles/packages -t $HOME zsh starship
