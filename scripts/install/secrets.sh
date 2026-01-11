#!/bin/bash
# 機密情報の設定スクリプト

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$SCRIPT_DIR/../.." && pwd)}"

ZSHRC_LOCAL="$HOME/.zshrc.local"
TEMPLATE="$DOTFILES_DIR/templates/.zshrc.local.template"

echo "=== Setting up secrets ==="

if [ -f "$ZSHRC_LOCAL" ]; then
    echo "~/.zshrc.local already exists. Skipping..."
else
    echo "Creating ~/.zshrc.local from template..."
    cp "$TEMPLATE" "$ZSHRC_LOCAL"
    echo ""
    echo "=========================================="
    echo "  ~/.zshrc.local を作成しました"
    echo "=========================================="
    echo ""
    echo "以下の手順でPATを設定してください:"
    echo ""
    echo "1. GitHub Fine-grained PATを作成/再生成:"
    echo "   既存: https://github.com/settings/personal-access-tokens"
    echo "     対象トークンを選択 → 'Regenerate token' をクリック"
    echo ""
    echo "2. ~/.zshrc.local を編集してPATを貼り付け:"
    echo "   vim ~/.zshrc.local"
    echo ""
    echo "3. シェルを再読み込み:"
    echo "   source ~/.zshrc"
    echo ""
    echo "4. 確認:"
    echo "   echo \$GITHUB_PERSONAL_ACCESS_TOKEN"
    echo ""
fi
