# Migration Guide

## v2.0.0 への移行ガイド

このドキュメントは、dotfiles のリファクタリング後の新構造への移行手順を説明します。

### 📋 主な変更点

1. **ディレクトリ構造の整理**

   - 設定ファイルが`config/`ディレクトリに集約
   - `zsh/`, `git/`, `vim/` → `config/zsh/`, `config/git/`, `config/vim/`

2. **シンボリックリンク方式の変更**

   - AI ツール設定が共通ファイル`common/development-rules.md`を直接参照
   - dotfiles 内の`.claude/CLAUDE.md`は削除

3. **スクリプトの分割**

   - `install.sh`が機能別の 5 つのスクリプトに分割
   - `scripts/install/`ディレクトリに整理

4. **不要コードの削除**
   - `update-ai-configs.sh`からファイル生成機能を削除
   - Brewfile の重複定義を修正

### 🔄 移行手順

#### 1. 最新版を取得

```bash
cd ~/dotfiles
git pull origin main
```

#### 2. バックアップを作成（推奨）

```bash
# 重要なファイルのバックアップ
mkdir -p ~/dotfiles-backup-$(date +%Y%m%d)
cp -r ~/.claude ~/dotfiles-backup-$(date +%Y%m%d)/
cp ~/.zshrc ~/.gitconfig ~/.vimrc ~/dotfiles-backup-$(date +%Y%m%d)/
```

#### 3. 新しい構造への移行

```bash
# 新しいセットアップスクリプトを実行
cd ~/dotfiles
bash scripts/install/setup.sh
```

#### 4. 動作確認

```bash
# 設定ファイルの確認
ls -la ~/.zshrc ~/.gitconfig ~/.vimrc

# シンボリックリンクの確認
ls -la ~/.claude/CLAUDE.md

# Zsh設定の読み込み
source ~/.zshrc
```

### ⚠️ 注意事項

#### カスタム設定がある場合

1. **Git alias**: `git/alias.sh`を使用している場合

   ```bash
   # 新しい場所に移動
   mv ~/dotfiles/git/alias.sh ~/dotfiles/config/git/alias.sh
   ```

2. **カスタムスクリプト**: `scripts/`内に独自スクリプトがある場合
   - `scripts/utils/`に移動することを推奨

#### トラブルシューティング

**Q: シンボリックリンクが壊れている**

```bash
# シンボリックリンクを再作成
bash ~/dotfiles/scripts/install/symlinks.sh
```

**Q: 古いパスを参照してエラーが出る**

```bash
# 古いシンボリックリンクを削除して再作成
rm ~/.zshrc ~/.gitconfig ~/.vimrc
bash ~/dotfiles/scripts/install/symlinks.sh
```

**Q: AI ツールの設定が読み込まれない**

```bash
# 直接リンクを確認
ls -la ~/.claude/CLAUDE.md
# 出力例: ~/.claude/CLAUDE.md -> /Users/username/dotfiles/common/development-rules.md

# リンクが壊れている場合
rm ~/.claude/CLAUDE.md
ln -sf ~/dotfiles/common/development-rules.md ~/.claude/CLAUDE.md
```

### 📝 変更の詳細

#### ファイルの移動

| 旧パス                             | 新パス                                    |
| ---------------------------------- | ----------------------------------------- |
| `zsh/.zshrc`                       | `config/zsh/.zshrc`                       |
| `zsh/.zshrc.check_update_dotfiles` | `config/zsh/.zshrc.check_update_dotfiles` |
| `git/.gitconfig`                   | `config/git/.gitconfig`                   |
| `git/ignore`                       | `config/git/ignore`                       |
| `vim/.vimrc`                       | `config/vim/.vimrc`                       |
| `scripts/pair_or_unpair_device.sh` | `scripts/utils/pair_or_unpair_device.sh`  |

#### 削除されたファイル

- `.claude/CLAUDE.md` (シンボリックリンク)
- 空のディレクトリ: `zsh/`, `git/`, `vim/`

### ✅ 移行完了の確認

以下のコマンドで移行が完了したことを確認できます：

```bash
# ディレクトリ構造の確認
ls -la ~/dotfiles/config/

# シンボリックリンクの確認
readlink ~/.claude/CLAUDE.md
# 期待値: /Users/[username]/dotfiles/common/development-rules.md

# 新しいセットアップスクリプトの存在確認
ls ~/dotfiles/scripts/install/
# 期待値: setup.sh brew.sh symlinks.sh dev-tools.sh ai-tools.sh
```

### 🔙 ロールバック

問題が発生した場合、バックアップから復元できます：

```bash
# バックアップから復元
cp ~/dotfiles-backup-*/.*rc ~/ 2>/dev/null || true
cp -r ~/dotfiles-backup-*/.claude ~/.claude 2>/dev/null || true
```

### 📞 サポート

問題が解決しない場合は、GitHub の Issue で報告してください：
https://github.com/jion-kozono/dotfiles/issues
