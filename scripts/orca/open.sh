#!/bin/bash
# リポジトリ名（部分一致可）またはパスを指定して Orca で開く
#
# 使い方:
#   open.sh <query|path> [terminal|claude|codex|...]
#     - 既に端末が開いていればそのタブに切り替える
#     - 無ければ main worktree に端末（第2引数がエージェント名ならそのエージェント）を作って表示する
#     - Orca 未登録のリポジトリは自動で `orca repo add` する
#   open.sh --list
#     - 候補を "<name>\t<path>" で出力する（Raycast 拡張の一覧用）
#
# 探索ルートは ORCA_OPEN_ROOTS（スペース区切り）で上書きできる

set -euo pipefail

# Raycast などから起動すると PATH が最小限（/usr/bin も無い）なので補う
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"

ORCA_BIN="${ORCA_BIN:-/Applications/Orca.app/Contents/Resources/bin/orca}"
ROOTS="${ORCA_OPEN_ROOTS:-$HOME/projects $HOME/orca/projects $HOME/dotfiles}"

query="${1:-}"
mode="${2:-terminal}"

if [ -z "$query" ]; then
    echo "usage: $(basename "$0") <repo-name|path> [terminal|<agent>] | --list" >&2
    exit 1
fi

for cmd in jq "$ORCA_BIN"; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "$cmd が見つかりません" >&2; exit 1; }
done

orca() { "$ORCA_BIN" "$@"; }

# 候補一覧: "<name>\t<path>"（Orca 登録済み + 探索ルート直下の git リポジトリ）
# Orca 未起動でも一覧は出せるよう、repo list の失敗は無視する
list_candidates() {
    { orca repo list --json 2>/dev/null || echo '{}'; } |
        jq -r '.result.repos[]? | "\(.path | split("/") | last)\t\(.path)"'
    for root in $ROOTS; do
        [ -d "$root" ] || continue
        if [ -e "$root/.git" ]; then
            printf '%s\t%s\n' "$(basename "$root")" "$root"
            continue
        fi
        for dir in "$root"/*/; do
            dir="${dir%/}"
            [ -e "$dir/.git" ] && printf '%s\t%s\n' "$(basename "$dir")" "$dir"
        done
    done
}

if [ "$query" = "--list" ]; then
    list_candidates | awk -F'\t' '!seen[$2]++'
    exit 0
fi

# 完全一致 → 前方一致 → 部分一致 の順で最初に見つかった階層を採用
resolve_query() {
    local candidates q tier matches=""
    candidates="$(list_candidates | awk -F'\t' '!seen[$2]++')"
    q="$(printf '%s' "$query" | tr '[:upper:]' '[:lower:]')"

    for tier in exact prefix substr; do
        matches="$(printf '%s\n' "$candidates" | awk -F'\t' -v q="$q" -v tier="$tier" '
            { n = tolower($1) }
            tier == "exact"  && n == q          { print; next }
            tier == "prefix" && index(n, q) == 1 { print; next }
            tier == "substr" && index(n, q) > 0  { print }
        ')"
        [ -n "$matches" ] && break
    done

    if [ -z "$matches" ]; then
        echo "「${query}」に一致するリポジトリがありません" >&2
        exit 1
    fi
    if [ "$(printf '%s\n' "$matches" | wc -l | tr -d ' ')" -gt 1 ]; then
        echo "「${query}」が複数に一致しました:" >&2
        printf '%s\n' "$matches" | cut -f1 | sed 's/^/  - /' >&2
        exit 1
    fi
    printf '%s' "$matches" | cut -f2
}

if [ -d "$query" ]; then
    repo_path="$(cd "$query" && pwd)"
else
    repo_path="$(resolve_query)"
fi
name="$(basename "$repo_path")"

# Orca 起動（起動済みなら即 return）
orca open >/dev/null

# 未登録なら Orca に追加
if ! orca repo list --json | jq -e --arg p "$repo_path" '.result.repos[] | select(.path == $p)' >/dev/null; then
    orca repo add --path "$repo_path" >/dev/null
fi

# 既存の端末があれば最後に出力があったタブへ切り替える
handle="$(orca terminal list --json | jq -r --arg p "$repo_path" '
    [.result.terminals[] | select(.worktreePath == $p and .connected)]
    | sort_by(.lastOutputAt) | last | .handle // empty')"

if [ -n "$handle" ]; then
    orca terminal switch --terminal "$handle" >/dev/null
elif [ "$mode" = "terminal" ]; then
    orca terminal create --worktree "path:$repo_path" --focus >/dev/null
else
    orca agent launch --agent "$mode" --worktree "path:$repo_path" --focus >/dev/null
fi

open -a Orca
echo "Opened $name in Orca"
