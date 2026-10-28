## Development Environment

### Tech Stack

- **Language**: TypeScript/JavaScript (Node.js)
- **Package Manager**: pnpm, yarn (managed by mise)
- **Database**: MySQL with Prisma, TiDB, AWS Aurora, Supabase
- **Backend**: NestJS, GraphQL
- **Frontend**: Next.js
- **Testing**: Vitest
- **Code Style**: ESLint, Prettier

### Tools & Utilities

- **Version Control**: Git
- **Container**: Docker
- **Cloud**: AWS, TiDB, GCP
- **CI/CD**: GitHub Actions, GitLab CI
- **IDE**: VS Code
- **Terminal**: Zsh with custom dotfiles
- **Git Worktree Management**: Claude Code 標準の EnterWorktree ツールを使う（ccmanager は使わない。ユーザーへの作成依頼も不要）
  - 派生元は issue の `branch::` ラベル（対応表: staging / release / pre-main、ラベルなしは main）に従う
  - EnterWorktree は既定で `origin/<default branch>` から切るため、派生元を選ぶにはプロジェクトの `.claude/settings.local.json`（gitignore 対象）に `"worktree": { "baseRef": "head" }` を入れ、メイン checkout を派生元ブランチに切り替えて `git pull --ff-only` してから `EnterWorktree({ name })` を呼ぶ
  - 作成後のセットアップは worktree 内で次を行う
    1. ブランチ名は `worktree-<name>` になるので `git branch -m worktree-<name> <name>` で規約名（`<issue番号>-<prefix>-<short-name>`）に改名する
    2. `pnpm install --frozen-lockfile`
    3. gitignore 対象ファイルをメイン checkout からコピーする: `.env`、`docs/ai-output/plan/<issue番号>-*.md`（計画書。`mkdir -p docs/ai-output/plan docs/ai-output/review` してから）
    4. `pnpm prisma:generate`（`prisma/client/` は gitignore 対象で worktree には無い）
  - worktree 内の Bash は隔離チェックが厳しく、`git -C` や `cd` でメイン側を触る操作に加え、コマンド文字列に「git」を含むだけの heredoc / printf も拒否される。ファイル編集は Edit / Write ツールを使い、メイン側の設定ファイルを読むだけなら絶対パスで参照してよい
  - 終了は ExitWorktree。`EnterWorktree({ path })` で入った既存 worktree は `remove` できないため、その場合は `keep` で抜けてからメイン checkout で `git worktree remove` する

## Project Standards

### Code Style

- Ensure type safety with TypeScript
- Adopt DDD architecture patterns
- Prioritize functional programming (side-effect-free code)
- Follow [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)

### ORM

- Prisma
  - Implement proper repository patterns
  - Use Prisma query builder for complex queries
- TypeORM
  - Proper separation of entities and repositories
  - Implement transaction management

### API Development

- GraphQL schema-first approach
  - Code-first for NestJS
- Implement proper input validation
- Data transfer via DTOs
- Apply security best practices

### Frontend Development

- Utilize Next.js App Router
- Proper use of Server/Client Components
- Type-safe component development with TypeScript
- Use functional components and Hooks

## Development Guidelines

### Language & Communication

- **AI Instructions**: Japanese
- **AI Responses**: Japanese
- **Comments**: Japanese (following international standards)
- **Test Cases**: Japanese (following international standards)
- **Variable/Function Names**: English

### Issue / MR コメント

人に判断を依頼するコメントは、読み手が読んで判断できることを最優先にする。下書きしたら投稿前に全体を通読し、以下を満たしているか確認する。

- **結論を先頭に置く**。何を判断してほしいのかを冒頭で明示する
- **短くする**。判断に不要な経緯・補足・余談は削る。文章量そのものがコミュニケーションコストになる
  - 返信は 1〜3 文を目安にする。表・箇条書きは、求められたときか、文章だと読みにくいときだけ使う
  - 聞かれたことにだけ答える。ついでに気づいたことは、必要になってから別に出す
  - 検証結果・SQL ログ・長い補足は `<details>` で畳む。本文には結論だけ残す
- **返信は必要なときだけ**。了解・お礼だけの返信は書かず、リアクションで済ませる
  - 返信するのは、質問に答える・修正を報告する・判断を仰ぐとき
  - 相手の発言を言い換えて返さない（「承知しました。〜します」の列挙など）
  - リアクションは glab / gh で付け外しできる（自分が付けたものだけ外せる）。返信の代わりに使う
- **メンションの後は空行を入れる**。`@user` の行で改行し、本文は次の段落から書く
  - 例: `@user` の行、空行、本文の順
- **答える箇所を引用する**。相手の発言を `>` でそのまま引用し、その下に回答を書く
  - 引用は該当する一文に絞る。言い換えず原文のまま引く
  - 例: `> xxxx ではないか？` の下に `〜なので xxx ですね。`
- **硬くなりすぎない**。文末に `!` や `:bow:` を適度に添える
  - 全部の文に付けるとくどい。依頼・お礼・報告の締めだけにする
  - 質問・確認の文は `？` で終える。
- **識別子は略さずフルネームで書く**（`stu_corr` ではなく `stu_corr_scoringdate_idx`）
- **読み手と共有できているか不明な用語を使わない**。「covering」のような一般語で指さず、具体名（どの index か）で書く
- **数値には前提と出所を添える**
  - どのクエリを・どの条件で・どの環境で測ったか。実ワークロードに沿った条件か
  - 比率は分母の定義を書く（「93/300」なら 300 が何の母数か）
  - 似た指標を並べない。並べるなら違いを説明する
  - 計測結果は読み取り行数だけでなく返却行数も載せる
- **因果関係を安易に結ばない**。「A なので B」と書く前に A が B の原因か確認する。推測は推測と明示するか、書かない
- **本文の説明と表・図の内容が対応しているか確認する**
- **AI 特有の言い回しを避ける**
  - 比喩（「1つ後ろの列車」「covering を手放す」「index を引く」）
  - 曖昧な動詞（「落とせる」「寄せる」）
  - 技術的に不正確な言い換え（PK ルックアップを「行取得」と呼ぶなど）
  - 1 文への詰め込み（「〜で、〜し、〜しています」）。1 文には 1 つのことだけ書く
  - 関係する識別子の網羅。話に必要なものだけ出す
  - 確信の度合いをぼかすこと。自信がないときは「たぶん」「自信がない」とそのまま書く
  - 定型の締め（「以上です」「〜となります」）の反復

### Task Management

- Use TodoWrite tool for complex multi-step tasks
- Break large features into manageable steps
- Track progress systematically
- Mark todos complete immediately after finishing

### Code Quality

- Follow defensive security practices
- Never expose sensitive data or secrets
- Proper logging implementation without sensitive info
- Use established patterns in codebase

## Development Workflow

### Git Workflow

- Work on feature branches
- Use conventional commit messages
- Create pull requests for code review
- Maintain clean commit history

### Testing

- Unit & integration tests with Vitest
- Create test cases for business logic
- Run integration tests for API endpoints
- Test frontend components
- Ensure critical path test coverage
- Use proper mocks and stubs for external dependencies

### Documentation

- Update README.md for important changes (or docs/ if using VitePress)
- Document API changes in appropriate files
- Maintain inline comments for complex logic
- Keep documentation concise and practical

## DDD Principles

### Architecture

- Clear separation of entities and value objects
- Business logic aggregation through domain services
- Data access abstraction via repository pattern
- UseCase implementation through application services

### Functional Programming

- Prioritize pure functions without side effects
- Use immutable data structures
- Function composition and pipeline patterns
- Use map, filter, reduce over imperative loops

## Performance Considerations

### Database Optimization

- Use single database connection per operation
- Implement proper transaction boundaries
- Optimize queries for performance
- Monitor connection pool usage

### Frontend Optimization

- Properly utilize Next.js SSR and SSG
- Image optimization and Core Web Vitals improvement
- Bundle size optimization
- Implement proper caching strategies

### Code Optimization

- Minimize output tokens in responses
- Use efficient algorithms and data structures
- Monitor and optimize memory usage

## Security Guidelines

### Data Protection

- Never log sensitive information
- Implement proper input validation
- Use parameterized queries to prevent SQL injection
- Apply proper authentication and authorization

### Code Security

- Follow secure coding practices
- Regular dependency updates
- Use security linters and scanners
- Proper error handling without information leakage
