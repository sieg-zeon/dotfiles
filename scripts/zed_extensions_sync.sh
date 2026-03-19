#!/bin/bash
# Zed Extensions の同期スクリプト
#
# dump: インストール済み拡張を extensions.txt に書き出し
# list: extensions.txt の内容を表示（未インストール拡張のインストール用）

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
EXTENSIONS_FILE="$DOTFILES_DIR/config/zed/extensions.txt"
INSTALLED_DIR="$HOME/Library/Application Support/Zed/extensions/installed"

case "${1:-dump}" in
  dump)
    if [ ! -d "$INSTALLED_DIR" ]; then
      echo "Zed extensions directory not found: $INSTALLED_DIR"
      exit 1
    fi
    ls "$INSTALLED_DIR" | sed 's/\///' | sort > "$EXTENSIONS_FILE"
    echo "Dumped $(wc -l < "$EXTENSIONS_FILE" | tr -d ' ') extensions to $EXTENSIONS_FILE"
    ;;
  list)
    if [ ! -f "$EXTENSIONS_FILE" ]; then
      echo "Extensions file not found: $EXTENSIONS_FILE"
      exit 1
    fi
    echo "--- Zed Extensions (dotfiles) ---"
    cat "$EXTENSIONS_FILE"
    echo ""
    if [ -d "$INSTALLED_DIR" ]; then
      TMPFILE_A=$(mktemp)
      TMPFILE_B=$(mktemp)
      sort "$EXTENSIONS_FILE" > "$TMPFILE_A"
      ls "$INSTALLED_DIR" | sed 's/\///' | sort > "$TMPFILE_B"
      diff "$TMPFILE_A" "$TMPFILE_B" | grep "^[<>]" | sed 's/^< /  未インストール: /; s/^> /  未管理: /' || echo "  全て同期済み"
      rm -f "$TMPFILE_A" "$TMPFILE_B"
    fi
    ;;
  *)
    echo "Usage: $0 [dump|list]"
    echo "  dump  - インストール済み拡張を extensions.txt に書き出し"
    echo "  list  - extensions.txt と現在の状態を比較"
    ;;
esac
