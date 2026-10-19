#!/bin/bash
# Orca の設定を dotfiles と同期する
#
# Orca の設定は SQLite（profile-state.db）内の JSON に保存されており、
# シンボリックリンクでは管理できないため export / import で同期する。
#
# 使い方:
#   settings.sh export  … 現在の設定を config/orca/settings.json に書き出す（Orca 起動中でも可）
#   settings.sh diff    … dotfiles と現在の設定の差分を表示する
#   settings.sh import  … config/orca/settings.json を現在の設定にマージする（Orca 終了中のみ）
#
# マシン固有・機密の項目は EXCLUDE_KEYS で除外し、import 時も上書きしない。

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../install/common.sh"
get_directories

ORCA_DATA_DIR="${ORCA_DATA_DIR:-$HOME/Library/Application Support/orca}"
SETTINGS_FILE="${ORCA_SETTINGS_FILE:-$DOTFILES_DIR/config/orca/settings.json}"

# マシン固有・アカウント・機密の項目
EXCLUDE_KEYS='[
  "workspaceDir", "workspaceDirHistory", "floatingTerminalCwd", "floatingTerminalTrustedCwds",
  "opencodeSessionCookie", "opencodeWorkspaceId", "minimaxGroupId",
  "codexManagedAccounts", "activeCodexManagedAccountId", "activeCodexManagedAccountIdsByRuntime",
  "claudeManagedAccounts", "activeClaudeManagedAccountId",
  "machineName", "androidSdkPath", "mobileEmulatorDefaultDeviceUdid",
  "mobilePairingCustomAddress", "mobilePairingCustomAddresses",
  "activeRuntimeEnvironmentId", "devPluginPaths", "pluginConsents",
  "githubProjects", "defaultRepoSelection", "defaultLinearTeamSelection",
  "httpProxyUrl", "httpProxyBypassRules", "telemetry", "voice"
]'

profile_db() {
    local profile_id
    profile_id="$(jq -r '.activeProfileId' "$ORCA_DATA_DIR/orca-profile-index.json")"
    echo "$ORCA_DATA_DIR/profiles/$profile_id/profile-state.db"
}

current_settings() {
    sqlite3 -readonly "$(profile_db)" "SELECT payload FROM profile_state_documents WHERE domain = 'settings';"
}

shareable_settings() {
    current_settings | jq -S --argjson ex "$EXCLUDE_KEYS" 'with_entries(select(.key as $k | $ex | index($k) | not))'
}

cmd_export() {
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    shareable_settings >"$SETTINGS_FILE"
    echo "✅ Exported: $SETTINGS_FILE"
}

cmd_diff() {
    diff -u --label "dotfiles" --label "current" "$SETTINGS_FILE" <(shareable_settings) && echo "差分なし"
}

cmd_import() {
    local db
    db="$(profile_db)"

    [ -f "$SETTINGS_FILE" ] || { echo "❌ $SETTINGS_FILE がありません" >&2; exit 1; }
    if lsof "$db" >/dev/null 2>&1; then
        echo "❌ Orca が DB を使用中です。Orca を終了してから再実行してください" >&2
        exit 1
    fi

    # 現在値に dotfiles の値を上書きマージ（除外キーは現在値を維持）
    local merged hash backup
    merged="$(jq -c -n --argjson ex "$EXCLUDE_KEYS" \
        --argjson cur "$(current_settings)" --slurpfile src "$SETTINGS_FILE" \
        '$cur * ($src[0] | with_entries(select(.key as $k | $ex | index($k) | not)))')"
    # content_hash は payload の SHA-256
    hash="$(printf '%s' "$merged" | shasum -a 256 | cut -d' ' -f1)"

    backup="$db.dotfiles-backup.$(date +%Y%m%d%H%M%S)"
    sqlite3 "$db" ".backup '$backup'"

    # payload は SQL に埋め込まず一時ファイル経由で渡す
    local tmp
    tmp="$(mktemp)"
    printf '%s' "$merged" >"$tmp"
    sqlite3 "$db" "UPDATE profile_state_documents
        SET payload = CAST(readfile('$tmp') AS TEXT), content_hash = '$hash',
            revision = revision + 1, updated_at = $(($(date +%s) * 1000))
        WHERE domain = 'settings';"
    rm -f "$tmp"

    echo "✅ Imported: $SETTINGS_FILE"
    echo "   Backup:   $backup"
}

case "${1:-}" in
export) cmd_export ;;
diff) cmd_diff ;;
import) cmd_import ;;
*)
    echo "usage: $(basename "$0") {export|diff|import}" >&2
    exit 1
    ;;
esac
