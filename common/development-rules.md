## Development Environment

### Tech Stack

- **Language**: TypeScript/JavaScript (Node.js)
- **Package Manager**: pnpm, yarn, volta
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

## Project-Specific Notes

### Current Project (aim-at-CMS-api)

- NestJS-based GraphQL API
- MySQL database with Prisma
- Microservice architecture patterns
- Heavy use of decorators (@Retry, @Transactional)
- Focus on transaction management and database connection optimization

### Common Patterns

- Controller → Service → Repository architecture
- UseCase pattern for complex business logic
- DTO factories for data transformation
- Comprehensive error handling with custom exceptions
- Retry mechanisms for database operations

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
