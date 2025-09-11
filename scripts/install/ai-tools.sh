#!/bin/bash
# AI tools configuration (simplified version)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "--- AI Tools Setup ---"

# Create directories
mkdir -p ~/.claude
mkdir -p ~/.gemini
mkdir -p ~/.config/ccmanager

# Install AI CLI tools
echo "Installing AI CLI tools..."

# Claude Code
if ! command -v claude >/dev/null 2>&1; then
    echo "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code 2>/dev/null || true
fi

# Gemini CLI
if ! command -v gemini >/dev/null 2>&1; then
    echo "Installing Gemini CLI..."
    npm install -g @google/gemini-cli 2>/dev/null || true
fi

# ccmanager
if ! command -v ccmanager >/dev/null 2>&1; then
    echo "Installing ccmanager..."
    npm install -g ccmanager 2>/dev/null || true
fi

# claudecodeui (optional)
CLAUDECODEUI_DIR="$HOME/projects/claudecodeui"
if [ ! -d "$CLAUDECODEUI_DIR" ]; then
    echo "Installing claudecodeui..."
    mkdir -p "$HOME/projects"
    git clone https://github.com/siteboon/claudecodeui.git "$CLAUDECODEUI_DIR"
    cd "$CLAUDECODEUI_DIR"
    npm install
    cp .env.example .env
    cd - >/dev/null
fi

echo "✓ AI tools setup completed"