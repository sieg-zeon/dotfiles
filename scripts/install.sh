#!/bin/sh
# Legacy install script - redirects to new modular setup

set -eu

echo "========================================="
echo "This script has been updated to use a modular structure."
echo "Redirecting to the new setup script..."
echo "========================================="
echo ""

# Check if new setup script exists
if [ -f ~/dotfiles/scripts/install/setup.sh ]; then
    exec bash ~/dotfiles/scripts/install/setup.sh "$@"
else
    echo "Error: New setup script not found at ~/dotfiles/scripts/install/setup.sh"
    echo "Please ensure your dotfiles repository is up to date."
    exit 1
fi