#!/bin/bash

set -eu

DOTFILES_DIR="$HOME/dotfiles"
COMMON_FILE="$DOTFILES_DIR/common/development-rules.md"
CLAUDE_DIR="$DOTFILES_DIR/claude"
GEMINI_DIR="$DOTFILES_DIR/gemini"

# ディレクトリが存在しない場合は作成
mkdir -p "$CLAUDE_DIR"
mkdir -p "$GEMINI_DIR"

echo "--- Updating AI configuration files ---"

# AI CLIツールのインストール/更新
echo "Installing/updating AI CLI tools..."

echo "📦 Installing @anthropic-ai/claude-code..."
if npm install -g @anthropic-ai/claude-code 2>/dev/null; then
    echo "✅ Claude Code installed successfully"
else
    echo "⚠️  Claude Code installation failed (might already be installed or need permissions)"
fi

echo "📦 Installing @google/gemini-cli..."
if npm install -g @google/gemini-cli 2>/dev/null; then
    echo "✅ Gemini CLI installed successfully"
else
    echo "⚠️  Gemini CLI installation failed (might already be installed or need permissions)"
fi

echo ""

# mcp設定
claude mcp add playwright -s user npx @playwright/mcp@latest # https://github.com/microsoft/playwright-mcp
claude mcp add context7 -s user npx @upstash/context7-mcp    # https://github.com/upstash/context7
claude mcp add markitdown -s user uvx markitdown-mcp         # https://github.com/microsoft/markitdown/tree/main/packages/markitdown-mcp
claude mcp add youtube -s user npx @anaisbetts/mcp-youtube   # https://github.com/anaisbetts/mcp-youtube

# シンボリックリンクの確認と作成
echo "Checking symbolic links..."

# Claude用シンボリックリンクの確認
mkdir -p "$HOME/.claude"

# Claude settings.json
if [ ! -L "$HOME/.claude/settings.json" ]; then
    echo "Creating Claude settings.json symbolic link..."
    ln -sf "$CLAUDE_DIR/settings.json" "$HOME/.claude/settings.json"
    echo "✅ Claude settings.json symbolic link created: ~/.claude/settings.json"
else
    echo "✅ Claude settings.json symbolic link already exists"
fi

# Claude CLAUDE.md
if [ ! -L "$HOME/.claude/CLAUDE.md" ]; then
    echo "Creating Claude CLAUDE.md symbolic link..."
    ln -sf "$CLAUDE_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
    echo "✅ Claude CLAUDE.md symbolic link created: ~/.claude/CLAUDE.md"
else
    echo "✅ Claude CLAUDE.md symbolic link already exists"
fi

# Gemini settings.json
if [ ! -L "$HOME/.gemini/settings.json" ]; then
    echo "Creating Gemini settings.json symbolic link..."
    ln -sf "$GEMINI_DIR/settings.json" "$HOME/.gemini/settings.json"
    echo "✅ Gemini settings.json symbolic link created: ~/.gemini/settings.json"
else
    echo "✅ Gemini settings.json symbolic link already exists"
fi

# Gemini用シンボリックリンクの確認
if [ ! -L "$HOME/.gemini/GEMINI.md" ]; then
    echo "Creating Gemini symbolic link..."
    mkdir -p "$HOME/.gemini"
    ln -sf "$GEMINI_DIR/GEMINI.md" "$HOME/.gemini/GEMINI.md"
    echo "✅ Gemini symbolic link created: ~/.gemini/GEMINI.md"
else
    echo "✅ Gemini symbolic link already exists"
fi

echo ""

# Claude用ファイルの生成
echo "Generating CLAUDE.md..."
cat >"$CLAUDE_DIR/CLAUDE.md" <<'CLAUDE_EOF'
# Claude Code Configuration

This file defines the Claude Code settings and development policies common to all projects.

CLAUDE_EOF

# 共通ファイルの内容を追加
cat "$COMMON_FILE" >>"$CLAUDE_DIR/CLAUDE.md"

# Gemini用ファイルの生成
echo "Generating GEMINI.md..."
cat >"$GEMINI_DIR/GEMINI.md" <<'GEMINI_EOF'
# Gemini CLI Configuration

This file defines the Gemini CLI settings and development policies common to all projects.

GEMINI_EOF

# 共通ファイルの内容を追加
cat "$COMMON_FILE" >>"$GEMINI_DIR/GEMINI.md"

echo "--- AI configuration files updated successfully ---"
echo "📁 Source files:"
echo "   Common rules: $COMMON_FILE"
echo "   Claude config: $CLAUDE_DIR/CLAUDE.md"
echo "   Gemini config: $GEMINI_DIR/GEMINI.md"
echo ""
echo "🔗 Symbolic links:"
echo "   ~/.claude/settings.json → $CLAUDE_DIR/settings.json"
echo "   ~/.claude/CLAUDE.md     → $CLAUDE_DIR/CLAUDE.md"
echo "   ~/.gemini/settings.json → $GEMINI_DIR/settings.json"
echo "   ~/.gemini/GEMINI.md     → $GEMINI_DIR/GEMINI.md"
echo ""
echo "✏️  To edit common rules:"
echo "   code $COMMON_FILE"
echo "   Then run this script again to update both configs."
