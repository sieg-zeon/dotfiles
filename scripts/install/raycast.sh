#!/bin/bash
# 自作の Raycast 拡張を Raycast に取り込む
#
# ストア未公開の拡張は .rayconfig に含まれないため、マシンごとにソースから取り込む。
# `ray develop` は監視を続けて終了しないので、ビルド完了を待ってから止める。
# 一度取り込めば dev プロセスを止めても拡張は残る。

set -euo pipefail

# Load common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Initialize directories
get_directories

echo "--- Raycast Extensions Setup ---"

# 取り込む拡張（raycast/ 配下のディレクトリ名）
RAYCAST_EXTENSIONS=(orca-open)
# ビルド完了を待つ最大秒数
RAYCAST_DEV_TIMEOUT=120

import_raycast_extension() {
    local name="$1"
    local dir="$DOTFILES_DIR/raycast/$name"
    local log
    log="$(mktemp)"

    echo "Importing $name..."
    (cd "$dir" && npm ci --silent)

    (cd "$dir" && exec npx ray develop --non-interactive) >"$log" 2>&1 &
    local pid=$!

    local result="timeout"
    for _ in $(seq 1 "$RAYCAST_DEV_TIMEOUT"); do
        if grep -q "built extension successfully" "$log"; then
            result="ok"
            break
        fi
        if grep -q -i "error" "$log" || ! kill -0 "$pid" 2>/dev/null; then
            result="error"
            break
        fi
        sleep 1
    done

    # npx 配下の ray develop ごと止める
    pkill -P "$pid" 2>/dev/null || true
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true

    case "$result" in
    ok) echo "  ✅ $name imported" ;;
    *)
        echo "  ⚠️  $name の取り込みに失敗しました ($result)。ログ:"
        sed 's/^/    /' "$log"
        ;;
    esac
    rm -f "$log"
}

if [ ! -d /Applications/Raycast.app ]; then
    echo "  ⚠️  Raycast がインストールされていないためスキップします"
else
    # 取り込み先の Raycast を起動しておく
    open -a Raycast
    for ext in "${RAYCAST_EXTENSIONS[@]}"; do
        import_raycast_extension "$ext"
    done
fi

echo "✓ Raycast extensions setup completed"
