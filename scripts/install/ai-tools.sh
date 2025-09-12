#!/bin/bash
# AI tools installation and configuration update script
# This script combines the functionality of the former update-ai-configs.sh

set -euo pipefail

# Load common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Initialize directories
get_directories

echo "--- AI Tools Setup ---"

# Install AI CLI tools
echo "Installing AI CLI tools..."

# Claude Code
install_npm_package "@anthropic-ai/claude-code" "claude" "Claude Code"

# Gemini CLI
install_npm_package "@google/gemini-cli" "gemini" "Gemini CLI"

# ccmanager
install_npm_package "ccmanager" "ccmanager" "ccmanager"

# AI tools configuration
echo "Setting up AI tools configuration..."
setup_ai_tool "claude"
setup_ai_tool "gemini"

# ccmanager configuration
setup_ccmanager "$DOTFILES_DIR/.ccmanager"

# claudecodeui (optional)
setup_claudecodeui "$HOME/projects"

echo ""
echo "--- AI Tools Setup Completed ---"
echo "🔗 Symbolic links:"
echo "   ~/.claude/CLAUDE.md → ~/dotfiles/common/development-rules.md"
echo "   ~/.gemini/GEMINI.md → ~/dotfiles/common/development-rules.md"
echo "   ~/.claude/settings.json → ~/dotfiles/.claude/settings.json"
echo "   ~/.gemini/settings.json → ~/dotfiles/.gemini/settings.json"
echo "   ~/.config/ccmanager/config.json → ~/dotfiles/.ccmanager/config.json"
if [ -f "$DOTFILES_DIR/.ccmanager/config.json" ]; then
    echo "   ✅ ccmanager config file path: $DOTFILES_DIR/.ccmanager/config.json"
fi
echo ""
echo "✏️  To edit common rules:"
echo "   code $DOTFILES_DIR/common/development-rules.md"