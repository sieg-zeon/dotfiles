# peco を使ったインタラクティブユーティリティ関数集
# 依存: peco

# ヒストリ検索 (Ctrl+R)
function peco_select_history() {
    local selected=$(history -n 1 | tail -r | peco --query "$LBUFFER")
    if [ -n "$selected" ]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
    fi
    zle clear-screen
}
zle -N peco_select_history
bindkey '^r' peco_select_history

# gitブランチ切り替え
function peco_co() {
    local branch=$(git branch -a | peco | tr -d ' ' | sed 's|remotes/origin/||')
    if [ -n "$branch" ]; then
        git checkout "$branch"
    fi
}

# ディレクトリ移動（cd履歴から）
# cdr を有効化
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
function peco_cdr() {
    local dir=$(cdr -l | sed 's/^[^ ]*  *//' | peco)
    if [ -n "$dir" ]; then
        cd "$dir"
    fi
}

# プロセスキル
function peco_kill() {
    local pid=$(ps aux | peco | awk '{print $2}')
    if [ -n "$pid" ]; then
        echo "kill $pid"
        kill "$pid"
    fi
}

# docker コンテナにexec
function peco_docker_exec() {
    local cid=$(docker ps --format "{{.ID}} {{.Names}} {{.Image}}" | peco | awk '{print $1}')
    if [ -n "$cid" ]; then
        docker exec -it "$cid" /bin/bash
    fi
}
