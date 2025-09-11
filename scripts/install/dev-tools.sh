#!/bin/bash
# Development tools installation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "--- Development Tools Setup ---"

# Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    sudo xcodebuild -license accept
fi

# vim-plug
echo "Installing vim-plug..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# mise
echo "Installing mise languages..."
if [ -f "$DOTFILES_DIR/mise/_mise.sh" ]; then
    chmod u+x "$DOTFILES_DIR/mise/_mise.sh"
    "$DOTFILES_DIR/mise/_mise.sh"
fi

# Volta
if command -v volta >/dev/null 2>&1; then
    echo "Setting up Volta..."
    volta install node
    volta install yarn
    volta install pnpm
fi

# npm global packages
if command -v npm >/dev/null 2>&1; then
    echo "Installing npm global packages..."
    npm i -g @antfu/ni
fi

# TiUP (TiDB)
if ! command -v tiup >/dev/null 2>&1; then
    echo "Installing TiUP..."
    curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh
fi

# gh CLI configuration
if command -v gh >/dev/null 2>&1; then
    echo "Configuring GitHub CLI..."
    gh config set editor "code --wait"
fi

echo "✓ Development tools setup completed"
