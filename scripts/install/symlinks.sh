#!/bin/bash
# Create all symbolic links

set -euo pipefail

# Load common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Initialize directories
get_directories

echo "--- Symbolic Links Setup ---"

# Configuration files
echo "Creating config file links..."
create_symlink "$DOTFILES_DIR/config/vim/.vimrc" ~/.vimrc ".vimrc"
create_symlink "$DOTFILES_DIR/config/zsh/.zshrc" ~/.zshrc ".zshrc"
create_symlink "$DOTFILES_DIR/mise/.tool-versions" ~/.tool-versions ".tool-versions"
create_symlink "$DOTFILES_DIR/atcoder/.atcodertools.toml" ~/.atcodertools.toml ".atcodertools.toml"
create_symlink "$DOTFILES_DIR/config/git/.gitconfig" ~/.gitconfig ".gitconfig"

# Git ignore
ensure_directory ~/.config/git
create_symlink "$DOTFILES_DIR/config/git/ignore" ~/.config/git/ignore "git ignore"

# Note: AI tools configuration moved to ai-tools.sh

# Utilities
echo "Creating utility links..."
if [ -f "$DOTFILES_DIR/scripts/utils/pair_or_unpair_device.sh" ]; then
    sudo ln -sf "$DOTFILES_DIR/scripts/utils/pair_or_unpair_device.sh" /usr/local/bin/pair_or_unpair_device
    sudo chmod 755 /usr/local/bin/pair_or_unpair_device
    echo "  ✅ pair_or_unpair_device utility installed"
fi

echo "✓ Symbolic links created"
