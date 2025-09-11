#!/bin/bash
# Homebrew installation and package management

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "--- Homebrew Setup ---"

# Install Homebrew if not present
if [ -z "$(command -v brew)" ]; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Homebrew maintenance
if which /opt/homebrew/bin/brew >/dev/null 2>&1; then
    echo "Running brew doctor..."
    brew doctor

    echo "Updating Homebrew..."
    brew update --verbose

    echo "Upgrading packages..."
    brew upgrade --verbose
fi

# Install packages from Brewfile
echo "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile" --verbose

# Cleanup
echo "Cleaning up Homebrew..."
brew cleanup --verbose

echo "✓ Homebrew setup completed"
