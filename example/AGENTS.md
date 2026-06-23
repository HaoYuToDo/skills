# AGENTS.md

这是一个 Vue 3 + NestJS 项目的 AI Coding 指令示例。仓库假设采用 `web/` 前端、`server/` 后端、`user-guide/` 用户手册、`scripts/` 启动脚本、`docs/design-docs/` 设计细节、`reference-projects/` 只读参考项目结构。根文件只保留 AI 不知道就容易写错代码的项目地图、硬规则、验证闭环和文档导航；长教程、接口细节和模块深潜都放在 `docs/`。

> 注意：本目录是 `agents-md-maintainer` skill 的文档示例，不是可运行项目。以下命令均为目标项目示例命令，真实项目必须从 `Makefile`、`package.json`、CI、脚本和源码中核对后再写入。

## 1. 项目概述

- 前端：`web/`，Vue 3 + TypeScript + Vite + Vue Router + Pinia。
- 后端：`server/`，NestJS + TypeScript + REST API + DTO validation。
- 用户手册：`user-guide/`，Markdown 文档，AI 可基于源码、接口和产品说明生成。
- 脚本入口：`scripts/`，提供后端启动、前端启动和依赖边界检查。
- 详细架构见 `docs/architecture.md`，本地开发见 `docs/development.md`，接口和前后端专题见 `docs/design-docs/`。

```text
project-root/
  AGENTS.md             # AI Coding 项目指令核心入口
  README.md             # 给人看的项目说明
  Makefile              # 质量检查统一入口
  server/               # NestJS 后端
  web/                  # Vue 3 前端
  user-guide/           # 用户手册
  scripts/              # 启动和检查脚本
  docs/                 # 架构、开发、设计细节
  reference-projects/   # 只读参考项目
```

## 2. 快速命令

这些是目标项目示例命令。真实项目必须以 `Makefile`、`package.json`、脚本和 CI 为准。

| 目的 | 命令 |
| --- | --- |
| 安装依赖 | `pnpm install` |
| 启动前端 | `scripts/start-web.sh` |
| 启动后端 | `scripts/start-server.sh` |
| 依赖边界检查 | `scripts/lint-deps.sh` |
| 架构检查 | `make lint-arch` |
| 格式化检查 | `make lint-format` |
| 自动格式化 | `make format` |
| 构建 | `make build` |
| 测试 | `make test` |
| 全量检查 | `make check` |

环境变量示例位置见 `docs/development.md`。不要提交 `.env.local`、token、cookie、私钥或生产连接串。

## 3. 架构边界

- 前端页面不直接拼接后端 URL；所有请求必须经过 `web/src/api/*`，详见 `docs/design-docs/frontend-architecture.md`。
- API 字段、错误码和响应格式以 `docs/design-docs/api-design.md`、后端 DTO 和共享类型为准，禁止在组件里复制 DTO。
- NestJS Controller 只处理路由、参数、DTO 和响应码；业务规则放 Service，数据库访问放 Repository/DAO，详见 `docs/design-docs/controller-conventions.md`。
- `reference-projects/*` 是只读参考源码，不要把参考项目里的命令或约定直接写成当前项目事实。
- API 契约变更必须同步更新后端 DTO、前端 API client、用户手册和测试。

## 4. 关键硬规则

- 不要编造命令。新增或修改命令前先查 `Makefile`、`package.json`、`scripts/`、CI 和 README。
- 不要把根 `AGENTS.md` 写成教程；长示例、curl 集合、模块细节放入 `docs/` 后在根文件链接。
- 修改 API 字段、错误码、枚举、权限点时，必须检查 `server/`、`web/`、`docs/design-docs/api-design.md` 和 `user-guide/`。
- Vue 组件使用 Composition API 和 `<script setup lang="ts">`；props/emits 必须 typed，复杂逻辑抽到 composable。
- Pinia store 只承载跨页面状态；页面局部状态不要提升到全局。
- NestJS 禁止在 Controller 写业务逻辑，禁止绕过 DTO validation，禁止直接返回未脱敏实体。
- 安全相关改动必须检查鉴权、权限、日志脱敏和前端敏感信息暴露。
- 完成代码改动后按 `Makefile` 或 `docs/development.md` 中的质量检查入口执行最小验证闭环，并在回复里说明运行了什么。

## 5. 本地验证闭环

最小闭环：改动后先运行与改动相关的依赖边界检查、类型检查、lint、测试或构建，再启动对应服务做 smoke test。常用路径：

```bash
scripts/lint-deps.sh
make lint-arch
make lint-format
make test
make build
make check
```

后端接口改动至少补充一个 curl 或 API client 验证；前端交互改动至少做浏览器 smoke check。启动脚本和质量检查说明见 `docs/development.md`。

## 6. 文档导航

| 文档 | 什么时候读 |
| --- | --- |
| `docs/architecture.md` | 理解整体结构、依赖边界、领域模型和数据流 |
| `docs/development.md` | 安装、启动、数据库、env、命令来源和本地环境 |
| `docs/design-docs/api-design.md` | 修改 REST API、响应格式、错误码和端点 |
| `docs/design-docs/controller-conventions.md` | 修改 NestJS Controller、DTO 和响应约定 |
| `docs/design-docs/frontend-architecture.md` | 修改 Vue 页面、组件、store、API client |
| `docs/design-docs/ref-*.md` | 查看参考项目用途、优先级和注意事项 |

## 7. 参考项目和优先级

优先级为：当前源码和测试 > 当前仓库文档 > `docs/design-docs/ref-*.md` > `reference-projects/*` > 历史经验。参考项目只读，作为模式参考，不作为当前项目事实。

