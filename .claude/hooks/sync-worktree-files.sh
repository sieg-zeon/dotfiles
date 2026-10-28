#!/usr/bin/env bash
# PostToolUse hook: worktree（<repo>/.claude/worktrees/<name>/）の、許可したディレクトリ直下のファイルを、
# メイン checkout（<repo>/<同じディレクトリ>/）へコピーする。
# worktree に入ったセッションはメイン checkout へ書き込めないため、hook 側で同期する。
#
# - 許可するディレクトリは、このスクリプトと同じ場所の sync-worktree-files.json の allow に、リポジトリルートからの相対パスで書く
# - メイン checkout 側にそのディレクトリがある時だけコピーする（ディレクトリは作らない）
# - Write / Edit: 書き換えたファイルが、worktree の許可したディレクトリ直下にあれば、そのファイルをコピーする
# - Bash: 作業ディレクトリが worktree の中なら、許可したディレクトリ直下のファイルのうち、メイン側より新しいものをコピーする
set -euo pipefail

config="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/sync-worktree-files.json"
[[ -f "$config" ]] || exit 0

input="$(cat)"
tool_name="$(jq -r '.tool_name // empty' <<<"$input")"
file_path="$(jq -r '.tool_input.file_path // empty' <<<"$input")"
cwd="$(jq -r '.cwd // empty' <<<"$input")"

# NOTE: パスから <repo> と <repo>/.claude/worktrees/<name> を取り出す
worktree_roots_of() {
  [[ "$1" =~ ^(.+)/\.claude/worktrees/([^/]+)(/|$) ]] || return 1
  repo_root="${BASH_REMATCH[1]}"
  worktree_root="${BASH_REMATCH[1]}/.claude/worktrees/${BASH_REMATCH[2]}"
}

copy_if_newer() {
  local src="$1" dest_dir="$2"
  local dest="$dest_dir/$(basename "$src")"
  [[ -f "$src" && -d "$dest_dir" ]] || return 0
  if [[ ! -e "$dest" || "$src" -nt "$dest" ]]; then
    cp -p "$src" "$dest"
  fi
}

allowed_dirs=()
while IFS= read -r dir; do
  [[ -n "$dir" ]] && allowed_dirs+=("${dir%/}")
done < <(jq -r '.allow[]? // empty' "$config")
[[ ${#allowed_dirs[@]} -gt 0 ]] || exit 0

case "$tool_name" in
  Write | Edit)
    worktree_roots_of "$file_path" || exit 0
    relative_dir="$(dirname "${file_path#"$worktree_root"/}")"
    for dir in "${allowed_dirs[@]}"; do
      [[ "$relative_dir" == "$dir" ]] || continue
      copy_if_newer "$file_path" "$repo_root/$dir"
    done
    ;;
  Bash)
    [[ -n "$cwd" ]] || exit 0
    worktree_roots_of "$cwd" || exit 0
    shopt -s nullglob
    for dir in "${allowed_dirs[@]}"; do
      for file in "$worktree_root/$dir"/*; do
        copy_if_newer "$file" "$repo_root/$dir"
      done
    done
    ;;
esac
