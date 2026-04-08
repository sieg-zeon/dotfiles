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

# npm global packages
# TODO: Vite Plus (vp) が安定したら ni を削除する（vp が上位互換のため）
if command -v npm >/dev/null 2>&1; then
    echo "Installing npm global packages..."
    npm i -g @antfu/ni
fi

# Vite Plus (https://viteplus.dev)
if ! command -v vite-plus >/dev/null 2>&1; then
    echo "Installing Vite Plus..."
    curl -fsSL https://vite.plus | bash
fi

# TiUP (TiDB)
if ! command -v tiup >/dev/null 2>&1; then
    echo "Installing TiUP..."
    curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh
fi

# git-secrets
if command -v git-secrets >/dev/null 2>&1; then
    echo "Configuring git-secrets..."
    git secrets --install ~/.git-templates/git-secrets
    git config --global init.templateDir ~/.git-templates/git-secrets
    git secrets --register-aws --global
fi

# gh CLI configuration
if command -v gh >/dev/null 2>&1; then
    echo "Configuring GitHub CLI..."
    gh config set editor "zed --wait"
fi

echo "✓ Development tools setup completed"
