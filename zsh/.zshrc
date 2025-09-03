# あたらしくインストールされたコマンドを即認識させる
zstyle ":completion:*:commands" rehash 1
# Options
setopt print_eight_bit      # 日本語ファイル名を表示可能にする
setopt no_flow_control      # フローコントロールを無効にする
setopt interactive_comments # '#' 以降をコメントとして扱う
setopt auto_cd              # ディレクトリ名だけでcdする
setopt share_history        # 同時に起動したzshの間でヒストリを共有する
setopt hist_ignore_all_dups # 同じコマンドをヒストリに残さない
setopt hist_ignore_space    # スペースから始まるコマンド行はヒストリに残さない
setopt hist_reduce_blanks   # ヒストリに保存するときに余分なスペースを削除する
setopt nonomatch            # curl などで ? や & をエスケープなしで使いたい
setopt IGNOREEOF            # Ctrl+Dでログアウトしてしまうことを防ぐ

ZLE_REMOVE_SUFFIX_CHARS=$'' # ファイル名を補完した後に挿入されたスペースが消えてしまう

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

autoload -Uz compinit && compinit # 補完機能を有効にする

autoload -Uz colors && colors # プロンプトへ色を付ける
export LSCOLORS=cxfxcxdxbxegedabagacad

export LANG=ja_JP.UTF-8 # 日本語を使用

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $(brew --prefix)/opt/zsh-git-prompt/zshrc.sh
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fi

# check_update_dotfiles
source ~/dotfiles/zsh/.zshrc.check_update_dotfiles

# 環境変数
typeset -U path PATH
path=(
    /opt/homebrew/bin
    /opt/homebrew/sbin
    /usr/local/bin
    /usr/local/sbin
    /usr/bin
    /usr/sbin
    /bin
    /sbin
    /Library/Apple/usr/bin
)

# Git リポジトリ以外では $(git_super_status) を表示させたくない場合
git_prompt() {
    if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = true ]; then
        PROMPT='%F{cyan}%W%f %F{cyan}%*%f:%F{yellow}%m%f:%F{magenta}%n%f: %F{green}%~%f %F{red}$(git_super_status)%f '
    else
        PROMPT='%F{cyan}%W%f %F{cyan}%*%f:%F{yellow}%m%f:%F{magenta}%n%f: %F{green}%~%f '
    fi
}

# コマンド実行結果のあとに空行を挿入する
add_newline() {
    if [[ -z $PS1_NEWLINE_LOGIN ]]; then
        PS1_NEWLINE_LOGIN=true
    else
        printf '\n'
    fi
}

precmd() {
    git_prompt
    add_newline
}

typeset -A ZSH_HIGHLIGHT_STYLES
# エイリアスコマンドのハイライト
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
# 存在するパスのハイライト
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
# グロブ
ZSH_HIGHLIGHT_STYLES[globbing]='none'

# エイリアス
alias python='python3'
alias gac='git add . && git ci -m'
alias gp='git push'
alias gpl='git pull'
alias co='git checkout'
alias brd='git branch | grep -v -e "main" -e "\*" | xargs git branch -d'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -lGF'
alias ls='ls -GF'
alias ac-test="chmod 755 main.py && atcoder-tools test"
alias ac="atcoder-tools"
alias pn="pnpm"
alias pud="pair_or_unpair_device"
alias cc='claude'
alias ccd='claude --dangerously-skip-permissions'
alias dotfiles="code ~/dotfiles"
alias ccm='ccmanager'

# 仕事用などで使うエイリアス
if [ -f ~/dotfiles/alias.sh ]; then
    source ~/dotfiles/alias.sh
fi

########################################
# OS 別の設定
case ${OSTYPE} in
darwin*)
    #Mac用の設定
    git_prompt='%F{green}%~%f %F{red}$(__git_ps1 "%s" )%f'
    git_prompt='%F{green}%~%f %F{red}$(__git_ps1 "%s" )%f'
    export CLICOLOR=1
    alias ls='ls -G -F'
    ;;
linux*)
    #Linux用の設定
    alias ls='ls -F --color=auto'
    ;;
esac

# エディタ
export EDITOR=vscode
# postgres
export PATH=$PATH:/opt/homebrew/Cellar/postgresql@14/10.22_4/bin
# direnv
eval "$(direnv hook zsh)"
# mise
eval "$(/opt/homebrew/bin/mise activate zsh)"
# bun completions
[ -s "/Users/jion_kozono/.bun/_bun" ] && source "/Users/jion_kozono/.bun/_bun"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1
# android emulator
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# mysql
export PATH=$PATH:/opt/homebrew/opt/mysql@8.0/bin

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/xiaoyuanzhiwang/.sdkman"
[[ -s "/Users/xiaoyuanzhiwang/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/xiaoyuanzhiwang/.sdkman/bin/sdkman-init.sh"
# Flutter
export PATH="$PATH:/Users/xiaoyuanzhiwang/development/flutter/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"

# github cli
eval "$(gh completion -s zsh)"

# tiup: https://docs.pingcap.com/ja/tidb/stable/tiup-overview#install-tiup
export PATH=$HOME/.tiup/bin:$PATH
# ↑ Remove the same path of the above line
