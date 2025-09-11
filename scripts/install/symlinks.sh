#!/bin/bash
# Create all symbolic links

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "--- Symbolic Links Setup ---"

# Configuration files
echo "Creating config file links..."
ln -sf "$DOTFILES_DIR/config/vim/.vimrc" ~/.vimrc
ln -sf "$DOTFILES_DIR/config/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/mise/.tool-versions" ~/.tool-versions
ln -sf "$DOTFILES_DIR/atcoder/.atcodertools.toml" ~/.atcodertools.toml
ln -sf "$DOTFILES_DIR/config/git/.gitconfig" ~/.gitconfig

# Git ignore
mkdir -p ~/.config/git
ln -sf "$DOTFILES_DIR/config/git/ignore" ~/.config/git/ignore

# AI tools configuration
echo "Creating AI tools links..."

# Claude
mkdir -p ~/.claude
ln -sf "$DOTFILES_DIR/.claude/settings.json" ~/.claude/settings.json
ln -sf "$DOTFILES_DIR/common/development-rules.md" ~/.claude/CLAUDE.md

# Gemini
mkdir -p ~/.gemini
ln -sf "$DOTFILES_DIR/.gemini/settings.json" ~/.gemini/settings.json
ln -sf "$DOTFILES_DIR/common/development-rules.md" ~/.gemini/GEMINI.md

# ccmanager
mkdir -p ~/.config/ccmanager
ln -sf "$DOTFILES_DIR/.ccmanager/config.json" ~/.config/ccmanager/config.json
for script in "$DOTFILES_DIR/.ccmanager"/*.sh; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script")
        ln -sf "$script" ~/.config/ccmanager/"$script_name"
    fi
done

# Utilities
echo "Creating utility links..."
sudo ln -sf "$DOTFILES_DIR/scripts/utils/pair_or_unpair_device.sh" /usr/local/bin/pair_or_unpair_device
sudo chmod 755 /usr/local/bin/pair_or_unpair_device

echo "✓ Symbolic links created"