#!/bin/bash
# Common functions for installation scripts

# Get script and dotfiles directories
get_directories() {
    export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
    export DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
}

# Create a symbolic link with proper messaging
create_symlink() {
    local source="$1"
    local target="$2"
    local description="${3:-symbolic link}"

    if [ -L "$target" ]; then
        # Check if existing symlink points to the correct location
        local current_link=$(readlink "$target")
        if [ "$current_link" = "$source" ]; then
            echo "  ✓ $description already exists"
            return 0
        else
            # Remove incorrect symlink
            rm -f "$target"
        fi
    elif [ -e "$target" ]; then
        echo "  ⚠️  $target exists but is not a symbolic link, skipping"
        return 1
    fi

    ln -sf "$source" "$target"
    echo "  ✅ Created: $description"
    return 0
}

# Create directory if it doesn't exist
ensure_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi
}

# Install or update npm package globally
install_npm_package() {
    local package="$1"
    local command="${2:-$(echo $package | sed 's/@.*\///' | sed 's/@.*//')}"
    local description="${3:-$package}"

    echo "Installing/updating $description..."

    # Always install/update to ensure latest version
    if npm install -g "$package@latest" 2>/dev/null; then
        echo "  ✅ $description installed/updated successfully"
    else
        echo "  ⚠️  $description installation/update failed (might need permissions)"
        return 1
    fi
    return 0
}

# Setup AI tool configuration
setup_ai_tool() {
    local tool_name="$1"  # claude or gemini
    local tool_dir_var="${2:-$(echo $tool_name | tr '[:lower:]' '[:upper:]')_DIR}"
    local tool_dir="${!tool_dir_var:-$DOTFILES_DIR/.$tool_name}"

    echo "Setting up $tool_name configuration..."

    # Create home directory
    ensure_directory "$HOME/.$tool_name"

    # Link settings.json
    create_symlink \
        "$tool_dir/settings.json" \
        "$HOME/.$tool_name/settings.json" \
        "$tool_name settings.json"

    # Link to common development rules
    local md_file="$(echo $tool_name | tr '[:lower:]' '[:upper:]').md"
    create_symlink \
        "$DOTFILES_DIR/common/development-rules.md" \
        "$HOME/.$tool_name/$md_file" \
        "$tool_name $md_file → common/development-rules.md"
}

# Setup ccmanager
setup_ccmanager() {
    local ccmanager_dir="${1:-$DOTFILES_DIR/.ccmanager}"

    echo "Setting up ccmanager configuration..."

    # Create directory
    ensure_directory "$HOME/.config/ccmanager"

    # Link config.json
    create_symlink \
        "$ccmanager_dir/config.json" \
        "$HOME/.config/ccmanager/config.json" \
        "ccmanager config.json"

    # Link all shell scripts
    for script in "$ccmanager_dir"/*.sh; do
        if [ -f "$script" ]; then
            local script_name=$(basename "$script")
            create_symlink \
                "$script" \
                "$HOME/.config/ccmanager/$script_name" \
                "ccmanager $script_name"
        fi
    done
}

# Setup claudecodeui (optional)
setup_claudecodeui() {
    local projects_dir="${1:-$HOME/projects}"
    local claudecodeui_dir="$projects_dir/claudecodeui"

    if [ ! -d "$claudecodeui_dir" ]; then
        echo "Installing claudecodeui..."
        ensure_directory "$projects_dir"

        if git clone https://github.com/siteboon/claudecodeui.git "$claudecodeui_dir"; then
            cd "$claudecodeui_dir"
            npm install
            cp .env.example .env
            cd - >/dev/null
            echo "  ✅ claudecodeui installed at $claudecodeui_dir"
        else
            echo "  ⚠️  claudecodeui installation failed"
            return 1
        fi
    else
        echo "  ✓ claudecodeui already installed at $claudecodeui_dir"
    fi
    return 0
}
