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
    3. gitignore 対象で worktree に存在しないファイルをメイン checkout からコピーする。**対象は PJ の構成ごとに違うため決め打ちにせず、`.gitignore` とメイン checkout 側の実ファイル（絶対パスで `ls`。worktree 内から `git -C` は使えない）を突き合わせて特定する**
       - 環境変数・秘密情報: 配置が PJ ごとに異なる（ルートの `.env`、`env/.env.*`、`env/secrets/.env.secrets.*`、`*.pem` 等）。ローカル起動・`cdk diff`・動作確認に必要なものを漏れなく揃える
       - AI 成果物: `docs/ai-output/plan/<issue番号>-*.md`（計画書。`mkdir -p docs/ai-output/plan docs/ai-output/review` してから）
    4. gitignore 対象の生成物があれば生成コマンドを実行する。`package.json` の scripts を見て判断する（e.g. Prisma PJ は `pnpm prisma:generate` で `prisma/client/` を生成。生成物がコミット済みの PJ では不要）
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
