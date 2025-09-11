#!/bin/bash
# AI tools configuration

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

# claudecodeui (optional)
setup_claudecodeui "$HOME/projects"

echo "✓ AI tools setup completed"