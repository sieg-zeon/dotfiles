# dotfiles

個人用の dotfiles 管理リポジトリ。macOS 環境用に最適化されています。

## 📁 ディレクトリ構造

```bash
dotfiles/
├── common/                     # 共通設定
│   └── development-rules.md    # AI開発ツール共通ルール
├── config/                     # 各種設定ファイル
│   ├── zsh/                   # Zsh設定
│   │   ├── .zshrc
│   │   └── .zshrc.check_update_dotfiles
│   ├── git/                   # Git設定
│   │   ├── .gitconfig
│   │   └── ignore
│   └── vim/                   # Vim設定
│       └── .vimrc
├── .claude/                   # Claude Code設定
│   └── settings.json
├── .ccmanager/                # ccmanager設定
│   └── config.json
├── scripts/                   # 各種スクリプト
│   ├── install/              # インストールスクリプト
│   │   ├── common.sh         # 共通関数
│   │   ├── setup.sh          # メインセットアップ
│   │   ├── brew.sh           # Homebrew管理
│   │   ├── symlinks.sh       # シンボリックリンク作成
│   │   ├── dev-tools.sh      # 開発ツール
│   │   ├── ai-tools.sh       # AIツール＆設定更新
│   │   └── raycast.sh        # 自作 Raycast 拡張の取り込み
│   └── utils/                # ユーティリティ
│       └── pair_or_unpair_device.sh
├── mise/                      # mise設定
├── atcoder/                   # AtCoder設定
└── Brewfile                   # Homebrew パッケージリスト
```

## 🚀 セットアップ

### 前提条件

- macOS (Apple Silicon/Intel)
- インターネット接続

### クイックスタート

```bash
# 1. リポジトリをホームディレクトリ直下にクローン
cd ~
git clone https://github.com/jion-kozono/dotfiles.git

# 2. セットアップスクリプトを実行
cd ~/dotfiles
bash scripts/install/setup.sh
```

### 個別セットアップ

特定の部分のみセットアップしたい場合：

```bash
# Homebrewパッケージのみ
bash ~/dotfiles/scripts/install/brew.sh

# シンボリックリンクのみ
bash ~/dotfiles/scripts/install/symlinks.sh

# 開発ツールのみ
bash ~/dotfiles/scripts/install/dev-tools.sh

# AIツール＆設定更新
bash ~/dotfiles/scripts/install/ai-tools.sh

# 自作 Raycast 拡張の取り込み
bash ~/dotfiles/scripts/install/raycast.sh
```

## ✨ 機能

### AI 開発ツール統合

- **Claude Code**: Anthropic 公式 CLI ツール
- **ccmanager**: Claude Code Manager
- **claudecodeui**: Claude Code UI (Web interface)
- **共通ルール管理**: `common/development-rules.md`を AI ツールで共有

### 自動チェック機能

起動時に dotfiles リポジトリの変更を検出し、コミットを促します。

[詳細](config/zsh/.zshrc.check_update_dotfiles)

```bash
=== DOTFILES IS DIRTY ===
The dotfiles have been changed.
Please update them with the following command.

cd ~/dotfiles
git add .
git commit -m "update: dotfiles"
git push origin main
=========================
```

### インストールツール

主要ツール:

- Homebrew & 各種 CLI
- mise (多言語バージョン管理)
- Docker Desktop
- VS Code
- iTerm2

詳細は[Brewfile](./Brewfile)を参照。

### Orca 連携

#### リポジトリ名で Orca を開く（Raycast）

```bash
# 単体でも使える。名前は 完全一致 → 前方一致 → 部分一致 の順で解決
~/dotfiles/scripts/orca/open.sh utanote          # 端末を開く（既存タブがあれば切り替え）
~/dotfiles/scripts/orca/open.sh utanote claude   # 新規なら Claude Code を起動
```

- 探索対象は Orca 登録済みリポジトリと `~/projects` `~/orca/projects` `~/dotfiles`（`ORCA_OPEN_ROOTS` で変更可）。未登録なら自動で `orca repo add` する
- Raycast 拡張（`raycast/orca-open`）でリポジトリ一覧を絞り込んで開ける。よく開くものほど上に並ぶ
  - インストール: `setup.sh` で自動的に取り込まれる。単体では `bash ~/dotfiles/scripts/install/raycast.sh`
  - Raycast の Settings → Extensions で「Open in Orca」にホットキーを割り当てる
  - Enter で端末、Action Panel（`⌘K`）から Claude / Codex 起動を選べる

#### Raycast 設定の同期

Raycast の設定は Raycast の Cloud Sync で同期する（正本）。

- 別マシン: 上記の Raycast 拡張を先に取り込んでから Raycast にログインし、Cloud Sync を有効にする（拡張に割り当てたホットキーも復元するため）
- バックアップ: Raycast v2 の Scheduled Backup（毎週）で `config/raycast/` に `.rayconfig` が保存される。git 管理外（`.gitignore`）なのでローカルにのみ残る

#### Orca 設定の同期

Orca の設定は SQLite 内に保存されるため、`config/orca/settings.json` と export / import で同期する。アカウント・パスなどマシン固有の項目は除外される。

```bash
bash ~/dotfiles/scripts/orca/settings.sh export   # 現在の設定を dotfiles に書き出す
bash ~/dotfiles/scripts/orca/settings.sh diff     # 差分確認
bash ~/dotfiles/scripts/orca/settings.sh import   # dotfiles の設定を反映（Orca 終了中のみ。DB をバックアップしてから更新）
```

## 🔧 カスタマイズ

### AI 開発ルールの編集

```bash
# 共通ルールを編集
code ~/dotfiles/common/development-rules.md

# 変更は自動的に全AIツールに反映されます
```

## 📝 メンテナンス

### アップデート

```bash
# Homebrewパッケージの更新
brew update && brew upgrade

# dotfiles自体の更新
cd ~/dotfiles
git pull origin main
bash scripts/install/setup.sh
```

### トラブルシューティング

シンボリックリンクの再作成:

```bash
bash ~/dotfiles/scripts/install/symlinks.sh
```

AI設定の更新:

```bash
bash ~/dotfiles/scripts/install/ai-tools.sh
```

Homebrew 関連の問題:

```bash
brew doctor
```

## 📄 ライセンス

MIT License

## 🤝 コントリビューション

Issue、Pull Request は歓迎です。
