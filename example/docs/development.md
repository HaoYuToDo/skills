# 本地开发

这个文档给 AI Agent 和新加入的开发者解决的问题：如何在本机准备环境、安装依赖、启动 Vue 3 前端和 NestJS 后端、初始化数据库，并进入可调试的开发状态。

应该维护在这里的内容：环境要求、命令来源、依赖安装、构建运行、env 配置、数据库初始化、测试数据和常见验证方式。

不应该维护在这里的内容：生产密钥、个人本地路径、一次性排查日志、没有在 `Makefile`、`package.json`、脚本或 CI 中验证过的命令。

## 技术栈

当前项目按前后端分离结构组织：

- 前端：Vue 3 + TypeScript + Vite + Vue Router + Pinia，目录为 `web/`。
- 后端：NestJS + TypeScript，目录为 `server/`。
- 包管理：pnpm。
- 质量入口：根目录 `Makefile` 和 `scripts/*.sh`。
- 数据库：真实项目以 `server/` 配置、迁移脚本和 Docker Compose 为准；如果没有明确配置，默认按 PostgreSQL 本地开发流程补齐。

## 环境要求

真实项目必须以 `.nvmrc`、`packageManager`、Dockerfile、CI workflow、README 和部署配置为准。当前示例目录没有真实 manifest，下面是 Vue 3 + NestJS 项目的推荐基线：

| 工具 | 推荐版本 | 用途 |
| --- | --- | --- |
| Git | `>=2.30` | 拉取代码和 submodule |
| Node.js | `>=20` | 前端 Vite、后端 NestJS、本地脚本 |
| pnpm | `>=9` | 安装和运行 workspace 依赖 |
| TypeScript | 由 `package.json` 锁定 | 前后端类型检查和构建 |
| PostgreSQL | `>=15` | 本地关系型数据库，真实项目可替换 |
| Redis | 按项目需要 | 缓存、队列、会话或限流，未使用时不要启动 |

版本检查：

```bash
git --version
node --version
pnpm --version
psql --version
```

## 命令来源

AI 或开发者新增、修改、执行命令前，必须先从这些文件确认真实命令：

- `Makefile`
- `package.json`
- `pnpm-workspace.yaml`
- `server/package.json`
- `web/package.json`
- `scripts/*.sh`
- `.github/workflows/*`
- Docker Compose、Dockerfile 或部署脚本

不要凭经验编造 `pnpm build:web`、`pnpm start:api`、`pnpm lint:fix` 等命令。只有在仓库文件中存在，才写入 `AGENTS.md`、开发文档或最终回复。

## 首次初始化

从干净机器开始时，按这个顺序执行：

1. 克隆仓库。
2. 初始化参考项目或 submodule。
3. 安装 Node/pnpm 依赖。
4. 准备 env 文件。
5. 初始化数据库。
6. 启动后端。
7. 启动前端。
8. 执行健康检查和浏览器 smoke check。

### 克隆和 submodule

如果仓库使用 submodule 或 `reference-projects/`，首次拉取后执行：

```bash
git submodule update --init --recursive
```

如果当前仓库没有 submodule，这条命令应当无副作用。`reference-projects/` 只作为只读参考，不要被运行时代码 import。

### 安装依赖

根目录安装：

```bash
pnpm install
```

如果真实项目不是 pnpm workspace，而是前后端分别维护依赖，则按实际 `package.json` 执行：

```bash
pnpm --dir server install
pnpm --dir web install
```

不要混用 npm、yarn 和 pnpm；锁文件以项目实际提交的包管理器为准。

## env 配置

常见 env 文件约定：

```text
.env.example          # 可提交，列出必需变量和示例值
.env.local            # 本地私有，不提交
server/.env.local     # 后端本地变量
web/.env.local        # 前端本地变量
```

后端常见变量：

```text
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://app:app_password@localhost:5432/app_dev
JWT_SECRET=replace-with-local-secret
```

前端常见变量：

```text
VITE_API_BASE_URL=http://localhost:3000/api
```

规则：

- `.env.example` 只能放示例值，不放真实 token、cookie、私钥、数据库密码或生产地址。
- `web/.env.local` 只能放可公开的浏览器变量，例如 API base URL、feature flag。
- 后端密钥、数据库连接串、第三方服务密钥只放服务端 env。
- 修改 env 变量时，同步更新 `.env.example`、启动脚本和本文档。

## 数据库

真实项目的数据库以 `server/` 配置、迁移目录、ORM 配置和 Docker Compose 为准。当前示例没有真实迁移脚本，下面给出 NestJS 项目的标准本地约定。

### 创建本地库

默认本地库：

```text
database: app_dev
user: app
encoding: UTF8
```

PostgreSQL 示例：

```bash
createdb app_dev
psql app_dev -c "CREATE USER app WITH PASSWORD 'app_password';"
psql app_dev -c "GRANT ALL PRIVILEGES ON DATABASE app_dev TO app;"
```

如果项目使用 Docker Compose，应优先使用仓库里的 compose 文件启动数据库，不要手动创建一套不同配置。

### 初始化表结构

按项目实际迁移工具选择一种方式：

- Flyway/Liquibase：运行后端启动或专用迁移命令自动迁移。
- Prisma/TypeORM/Knex：运行 `server/package.json` 中定义的 migration 命令。
- SQL 脚本：导入 `docs/sql/`、`server/sql/` 或迁移目录下的初始化脚本。

示例 SQL 导入方式：

```bash
psql "$DATABASE_URL" -f docs/sql/init.sql
```

只有当仓库里真实存在 `docs/sql/init.sql` 时才执行上述命令。

### 测试数据

本地测试数据应满足：

- 可重复执行，重复执行不制造脏数据。
- 不包含真实用户手机号、邮箱、token、订单号或生产数据。
- 能覆盖至少一组正常数据、一组空状态数据、一组权限不足或异常数据。
- 造数脚本路径和运行方式写入 `server/package.json`、`scripts/` 或本文档。

## 构建和运行

当前示例仓库提供了统一入口：

```bash
make lint-arch
make lint-format
make format
make build
make test
make check
```

脚本入口：

```bash
scripts/start-server.sh
scripts/start-web.sh
scripts/lint-deps.sh
```

### 启动后端

推荐通过脚本启动：

```bash
scripts/start-server.sh
```

当前示例脚本提示的 NestJS 开发命令是：

```bash
pnpm --dir server start:dev
```

启动后做健康检查：

```bash
curl -f http://localhost:3000/api/health
```

如果真实项目的端口、base path 或健康检查路径不同，必须以 `server/` 配置和启动脚本为准。

### 启动前端

推荐通过脚本启动：

```bash
scripts/start-web.sh
```

当前示例脚本提示的 Vite 开发命令是：

```bash
pnpm --dir web dev
```

默认访问：

```text
http://localhost:5173
```

前端启动前确认 `web/.env.local` 中的 `VITE_API_BASE_URL` 指向本地后端。

### 构建

统一构建入口：

```bash
make build
```

当前示例 `Makefile` 会调用：

```bash
pnpm build
```

真实项目如果拆分前后端构建，应在根 `package.json` 或 `Makefile` 中明确，例如后端 build、前端 build、全量 build 的区别。

## 验证流程

改动后至少执行和影响范围相关的验证：

| 改动范围 | 最小验证 |
| --- | --- |
| 后端 Controller、Service、DTO、Repository | `make test`，必要时 curl 成功和失败路径 |
| 前端页面、组件、composable、store、API client | `make lint-format`，启动前端做浏览器 smoke check |
| API 字段、错误码、权限点 | 后端测试、前端 API client、相关页面、`docs/design-docs/api-design.md` |
| 依赖边界、跨模块 import | `scripts/lint-deps.sh` 或 `make lint-arch` |
| 构建配置、入口文件、公共类型 | `make build` |

全量交付前执行：

```bash
make check
```

命令失败时不要静默跳过；最终回复必须说明失败命令、关键错误和未覆盖风险。

## 常见问题

### 前端能启动但接口报错

检查：

- `web/.env.local` 的 `VITE_API_BASE_URL` 是否指向本地后端。
- 后端是否已启动并通过 `/api/health`。
- 浏览器 Network 面板中的请求路径、状态码和 CORS 错误。
- 后端日志中的 requestId 或错误码。

### 后端启动失败

检查：

- `server/.env.local` 是否存在必需变量。
- 数据库是否启动，`DATABASE_URL` 是否可连接。
- 迁移是否已执行。
- 端口 `3000` 是否被占用。

### 依赖安装失败

检查：

- Node.js 和 pnpm 版本是否满足本文档要求。
- 是否混用了 npm/yarn/pnpm 导致 lockfile 冲突。
- 是否需要先初始化 submodule。
- 私有 registry 或 token 是否配置在本机，不要写入仓库。

## AI 开发行为

- 修改前先确认目标目录、已有模式、真实命令和相关测试。
- 新增依赖前先检查根、`server/`、`web/` 是否已有同类依赖。
- 运行服务前先确认 env 和数据库状态。
- 命令失败时记录失败命令和关键错误，不要用未经验证的替代命令糊过去。
- 无法运行服务或测试时，在最终回复中说明原因和未覆盖风险。
