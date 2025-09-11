# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-09-11

### 🏗️ Changed

- **Breaking**: ディレクトリ構造を大幅に再編成
  - 設定ファイルを`config/`ディレクトリに集約
  - `zsh/`, `git/`, `vim/` → `config/zsh/`, `config/git/`, `config/vim/`へ移動
- AI ツール設定をシンボリックリンク方式に変更
  - `~/.claude/CLAUDE.md`と`~/.gemini/GEMINI.md`が直接`common/development-rules.md`を参照
  - dotfiles 内の中間シンボリックリンクを削除
- `install.sh`を機能別に 5 つのスクリプトに分割
  - `setup.sh`: メインエントリーポイント
  - `brew.sh`: Homebrew 管理
  - `symlinks.sh`: シンボリックリンク作成
  - `dev-tools.sh`: 開発ツールインストール
  - `ai-tools.sh`: AI ツール設定
- `update-ai-configs.sh`を簡素化（152 行 → 約 90 行）
  - ファイル生成機能を削除
  - シンボリックリンク管理に特化

### 🐛 Fixed

- Brewfile の`gh`コマンド重複定義を修正
- `vscode_extentions_install_batch.sh`のファイル名タイポを修正 → `vscode_extensions_install_batch.sh`

### ✨ Added

- 詳細なタスク別ドキュメント（`refactoring-tasks/`ディレクトリ）
  - task-01-backup-and-prepare.md
  - task-02-symbolic-links.md
  - task-03-split-scripts.md
  - task-04-organize-configs.md
  - task-05-cleanup-code.md
  - task-06-update-documentation.md
- `MIGRATION.md`: v2.0.0 への移行ガイド
- `CHANGELOG.md`: 変更履歴（このファイル）
- レガシー対応のための`install.sh`リダイレクト機能

### 🗑️ Removed

- dotfiles 内の不要なシンボリックリンク
  - `.claude/CLAUDE.md`
  - `.gemini/GEMINI.md`
- `update-ai-configs.sh`のファイル自動生成機能
- 空のディレクトリ: `zsh/`, `git/`, `vim/`

### 📝 Documentation

- README.md を全面的に改訂
  - 日本語化
  - ディレクトリ構造図を更新
  - セットアップ手順を明確化
  - トラブルシューティングセクションを追加
- 各スクリプトにコメントを追加

## [1.1.0] - 2024-09-10

### Added

- Claude Code 設定のサポート
- Gemini CLI 設定のサポート
- ccmanager 統合
- claudecodeui（オプション）のインストールスクリプト

### Changed

- AI ツール設定の自動更新機能を追加

## [1.0.0] - 2024-03-14

### Initial Release

- 基本的な dotfiles 管理機能
- macOS 環境用の自動セットアップ
- Homebrew、Volta、mise 統合
- Zsh、Git、Vim 設定管理
- 自動更新チェック機能（`.zshrc.check_update_dotfiles`）

---

## バージョニングポリシー

このプロジェクトは[セマンティック バージョニング](https://semver.org/lang/ja/)に従います：

- **メジャー（X.0.0）**: 後方互換性のない変更
- **マイナー（0.X.0）**: 後方互換性のある機能追加
- **パッチ（0.0.X）**: 後方互換性のあるバグ修正

## 貢献

変更を加える際は、この CHANGELOG を更新してください。形式は以下の通りです：

- **Added**: 新機能
- **Changed**: 既存機能の変更
- **Deprecated**: 今後削除される機能
- **Removed**: 削除された機能
- **Fixed**: バグ修正
- **Security**: 脆弱性の修正
