# 本地开发

这个文档给 AI Agent 解决的问题：知道如何发现真实命令、安装依赖、启动 Vue 3 前端和 NestJS 后端、管理 env，并避免把示例命令误写成当前仓库事实。

应该维护在这里的内容：环境要求、命令来源、启动流程、env 文件位置、质量检查入口。

不应该维护在这里的内容：生产密钥、个人本地路径、一次性调试命令、没有在 manifest 或 CI 中验证过的命令。

## 命令来源

真实项目中，AI 必须优先从这些文件确认命令：

- `Makefile`
- `package.json`
- `server/package.json`
- `web/package.json`
- `scripts/*.sh`
- `.github/workflows/*`
- Docker Compose 或部署脚本

不要凭经验编造 `pnpm build:web`、`pnpm start:api`、`pnpm lint:fix` 等命令。只有文件中存在时才写入 `AGENTS.md` 或最终回复。

## 示例环境要求

这些是目标项目示例要求，真实项目以 README、Dockerfile、CI、`.nvmrc` 和 `packageManager` 字段为准。

| 工具 | 示例版本 |
| --- | --- |
| Node.js | `>=20` |
| pnpm | `>=9` |
| TypeScript | 由 `package.json` 管理 |
| 数据库 | PostgreSQL 或项目实际数据库 |

## 质量检查入口

`Makefile` 是统一入口示例：

```bash
make lint-arch
make lint-format
make format
make build
make test
make check
```

脚本入口示例：

```bash
scripts/start-server.sh
scripts/start-web.sh
scripts/lint-deps.sh
```

## 本地启动顺序

1. `pnpm install`
2. 复制 `.env.example` 到本地 env 文件。
3. 启动数据库、Redis 或其他依赖服务。
4. 运行 `scripts/start-server.sh` 启动 NestJS 后端。
5. 运行 `scripts/start-web.sh` 启动 Vue 3 前端。
6. 调用 `/api/health` 或项目健康检查接口。
7. 打开前端页面做浏览器 smoke check。

## env 文件

常见约定：

```text
.env.example          # 可提交，列出必需变量和示例值
.env.local            # 本地私有，不提交
server/.env.local     # 后端本地变量
web/.env.local        # 前端本地变量
```

规则：

- 前端变量只放可公开值，例如 API base URL、feature flag。
- 后端密钥只放在服务端 env。
- `.env.example` 不包含真实 token、cookie、私钥、数据库密码。
- 文档可以说明变量用途，但不要写入真实敏感值。

## AI 开发行为

- 修改前先确认目标目录、已有模式和相关测试。
- 新增依赖前先检查根、`server/`、`web/` 是否已有同类依赖。
- 命令失败时记录失败命令和关键错误，不要静默跳过。
- 无法运行服务或测试时，在最终回复中说明原因和未覆盖风险。

