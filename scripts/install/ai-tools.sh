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

# Claude Code (native installer)
if command -v claude &> /dev/null; then
    echo "Updating Claude Code..."
    claude update 2>/dev/null && echo "  ✅ Claude Code updated" || echo "  ⚠️  Claude Code update failed"
else
    echo "Installing Claude Code (native installer)..."
    curl -fsSL https://claude.ai/install.sh | bash && echo "  ✅ Claude Code installed" || echo "  ⚠️  Claude Code installation failed"
fi

# Gemini CLI
install_npm_package "@google/gemini-cli" "gemini" "Gemini CLI"

# ccmanager
install_npm_package "ccmanager" "ccmanager" "ccmanager"

# AI tools configuration
echo "Setting up AI tools configuration..."
setup_ai_tool "claude"
setup_ai_tool "gemini"

# Claude Code MCP servers (global)
# 環境変数はシェルから継承されるため、envに直接値を保存しない
echo "Setting up Claude Code MCP servers..."
if command -v claude &> /dev/null; then
    claude mcp add playwright -s user -- npx @playwright/mcp@latest 2>/dev/null || true
    claude mcp add chrome-devtools npx chrome-devtools-mcp@latest 2>/dev/null || true
    claude mcp add context7 -s user -- npx @upstash/context7-mcp 2>/dev/null || true
    claude mcp add youtube -s user -- npx @anaisbetts/mcp-youtube 2>/dev/null || true
    # github MCPは環境変数が必要（~/.zshrc.localで設定）
    # - GITHUB_PERSONAL_ACCESS_TOKEN: アクセストークン
    # - GITHUB_OWNER: デフォルトのリポジトリオーナー名
    if [ -n "${GITHUB_PERSONAL_ACCESS_TOKEN:-}" ]; then
        claude mcp add github -s user -e GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_PERSONAL_ACCESS_TOKEN" -e GITHUB_OWNER="${GITHUB_OWNER:-}" -- npx -y @modelcontextprotocol/server-github 2>/dev/null || true
    else
        echo "  ⚠️  GITHUB_PERSONAL_ACCESS_TOKEN not set, skipping GitHub MCP setup"
    fi
    # Notion MCP (OAuth認証が必要、Claude Code内で /mcp から認証)
    claude mcp add Notion -s user -t http https://mcp.notion.com/mcp 2>/dev/null || true
    echo "✅ MCP servers registered (playwright, context7, youtube, github, Notion)"
    echo "   ※ Notion MCPは /mcp コマンドで認証が必要です"
else
    echo "⚠️  Claude Code not installed, skipping MCP setup"
fi

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
echo "   zed $DOTFILES_DIR/common/development-rules.md"
