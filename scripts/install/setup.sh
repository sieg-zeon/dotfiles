#!/bin/bash
# Main setup script that orchestrates all installation steps

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "=== Starting dotfiles setup ==="
echo "Dotfiles directory: $DOTFILES_DIR"

# 1. Homebrew and packages
source "$SCRIPT_DIR/brew.sh"

# 2. Symbolic links
source "$SCRIPT_DIR/symlinks.sh"

# 3. Development tools
source "$SCRIPT_DIR/dev-tools.sh"

# 4. AI tools
source "$SCRIPT_DIR/ai-tools.sh"

echo "=== All setup completed successfully! ==="
echo "Please restart your terminal or run: source ~/.zshrc"
