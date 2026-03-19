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
if [ ! -f ~/.gitconfig.local ]; then
    default_name="jion_kozono"
    default_email="zeon66190329@gmail.com"
    echo "  Git ユーザー設定 (~/.gitconfig.local):"
    echo "  デフォルト値を使う場合はそのままEnterを押してください"
    printf "    user.name (default: $default_name): " && read git_name
    printf "    user.email (default: $default_email): " && read git_email
    git config --file ~/.gitconfig.local user.name "${git_name:-$default_name}"
    git config --file ~/.gitconfig.local user.email "${git_email:-$default_email}"
    echo "  ✅ ~/.gitconfig.local を作成しました"
fi
create_symlink "$DOTFILES_DIR/config/git/.gitconfig" ~/.gitconfig ".gitconfig"

# Git ignore
ensure_directory ~/.config/git
create_symlink "$DOTFILES_DIR/config/git/ignore" ~/.config/git/ignore "git ignore"

# Ghostty
ensure_directory ~/.config/ghostty
create_symlink "$DOTFILES_DIR/config/ghostty/config" ~/.config/ghostty/config "ghostty config"

# Zed
ensure_directory ~/.config/zed
create_symlink "$DOTFILES_DIR/config/zed/settings.json" ~/.config/zed/settings.json "zed settings.json"
create_symlink "$DOTFILES_DIR/config/zed/keymap.json" ~/.config/zed/keymap.json "zed keymap.json"

# Note: AI tools configuration moved to ai-tools.sh

# Utilities
echo "Creating utility links..."
if [ -f "$DOTFILES_DIR/scripts/utils/pair_or_unpair_device.sh" ]; then
    sudo ln -sf "$DOTFILES_DIR/scripts/utils/pair_or_unpair_device.sh" /usr/local/bin/pair_or_unpair_device
    sudo chmod 755 /usr/local/bin/pair_or_unpair_device
    echo "  ✅ pair_or_unpair_device utility installed"
fi

echo "✓ Symbolic links created"
