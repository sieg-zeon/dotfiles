import {
  Action,
  ActionPanel,
  closeMainWindow,
  Icon,
  Keyboard,
  List,
  showHUD,
  showToast,
  Toast,
} from "@raycast/api";
import { useExec, useFrecencySorting } from "@raycast/utils";
import { execFile } from "node:child_process";
import { homedir } from "node:os";
import { promisify } from "node:util";

// 一覧取得・起動処理は dotfiles のシェルスクリプトに集約している
const OPEN_SCRIPT = `${homedir()}/dotfiles/scripts/orca/open.sh`;

type Repo = { name: string; path: string };
type Mode = { value: string; title: string; icon: Icon };

const MODES: readonly Mode[] = [
  { value: "terminal", title: "Open Terminal", icon: Icon.Terminal },
  { value: "claude", title: "Open with Claude", icon: Icon.Stars },
  { value: "codex", title: "Open with Codex", icon: Icon.Code },
];

const parseRepos = (stdout: string): Repo[] =>
  stdout
    .split("\n")
    .filter((line) => line.includes("\t"))
    .map((line) => {
      const [name, path] = line.split("\t");
      return { name, path };
    });

const toDisplayPath = (path: string): string => path.replace(homedir(), "~");

const openRepo = async (repo: Repo, mode: Mode): Promise<void> => {
  const toast = await showToast({ style: Toast.Style.Animated, title: `Opening ${repo.name}…` });
  try {
    await promisify(execFile)(OPEN_SCRIPT, [repo.path, mode.value]);
    await closeMainWindow();
    await showHUD(`Opened ${repo.name} in Orca`);
  } catch (error) {
    toast.style = Toast.Style.Failure;
    toast.title = `Failed to open ${repo.name}`;
    toast.message = error instanceof Error ? error.message : String(error);
  }
};

export default function Command() {
  const { data, isLoading } = useExec(OPEN_SCRIPT, ["--list"], {
    // 独自パーサだと失敗が握りつぶされるため、エラー時は投げて Raycast のトーストに出す
    parseOutput: ({ stdout, stderr, exitCode, error }) => {
      if (error) throw error;
      if (exitCode !== 0) throw new Error(stderr || `open.sh exited with ${exitCode}`);
      return parseRepos(stdout);
    },
    keepPreviousData: true,
  });
  // よく開くリポジトリほど上に出す
  const { data: repos, visitItem } = useFrecencySorting(data ?? [], { key: (repo) => repo.path });

  return (
    <List isLoading={isLoading} searchBarPlaceholder="Search repositories">
      {repos.map((repo) => (
        <List.Item
          key={repo.path}
          title={repo.name}
          subtitle={toDisplayPath(repo.path)}
          icon={Icon.Folder}
          actions={
            <ActionPanel>
              {MODES.map((mode) => (
                <Action
                  key={mode.value}
                  title={mode.title}
                  icon={mode.icon}
                  onAction={async () => {
                    await visitItem(repo);
                    await openRepo(repo, mode);
                  }}
                />
              ))}
              <Action.ShowInFinder path={repo.path} shortcut={{ modifiers: ["cmd"], key: "f" }} />
              <Action.CopyToClipboard
                title="Copy Path"
                content={repo.path}
                shortcut={Keyboard.Shortcut.Common.Copy}
              />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
