# AGENTS.md

这是一个 Vue 3 + NestJS 项目的 AI Coding 指令示例。仓库假设采用 `web/` 前端、`server/` 后端、`user-guide/` 用户手册、`scripts/` 启动脚本、`docs/design-docs/` 设计细节、`reference-projects/` 只读参考项目结构。根文件只保留 AI 不知道就容易写错代码的项目地图、硬规则、验证闭环和文档导航；长教程、接口细节和模块深潜都放在 `docs/`。

## 1. 项目概述

本项目示例模拟一个前后端分离应用：前端位于 `web/`，使用 Vue 3 + TypeScript + Vite + Vue Router + Pinia 承载页面、组件、路由和状态管理；后端位于 `server/`，使用 NestJS + TypeScript 提供 REST API、认证鉴权、DTO validation、业务服务和数据访问；`user-guide/` 存放面向用户的 Markdown 手册；`docs/` 存放架构、开发、接口和参考项目说明。

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

| 目的         | 命令                      |
| ------------ | ------------------------- |
| 安装依赖     | `pnpm install`            |
| 启动前端     | `scripts/start-web.sh`    |
| 启动后端     | `scripts/start-server.sh` |
| 依赖边界检查 | `scripts/lint-deps.sh`    |
| 架构检查     | `make lint-arch`          |
| 格式化检查   | `make lint-format`        |
| 自动格式化   | `make format`             |
| 构建         | `make build`              |
| 测试         | `make test`               |
| 全量检查     | `make check`              |

环境变量示例位置见 `docs/development.md`。如果真实项目使用 `~/.<project>_env`、`.env.local`、`server/.env.local` 或 `web/.env.local`，必须在 `docs/development.md` 写清楚加载优先级。不要提交 token、cookie、私钥、生产数据库连接串或个人本地路径。

## 3. 后端架构

后端示例采用 NestJS 分层架构。真实项目以 `server/` 源码为准，不要为了贴合本文档而移动目录。

```text
server/src/
  main.ts                 # NestJS 启动入口
  app.module.ts           # 根模块
  common/                 # 通用 filter、guard、interceptor、pipe、异常和响应处理
  config/                 # 配置加载、环境变量、外部服务配置
  modules/                # 业务模块
    users/
      users.module.ts     # 模块边界
      users.controller.ts # REST Controller，只处理 HTTP 边界
      users.service.ts    # 业务规则、事务和外部服务编排
      dto/                # Request/Response DTO
      repositories/       # 数据访问
```

核心子系统：

- API 层：Controller 负责路由、参数、DTO、状态码和调用 Service，不写业务规则。
- 业务层：Service 负责业务规则、事务边界和外部服务编排。
- 数据层：Repository/DAO 负责数据库访问，不向前端暴露未脱敏实体。
- 鉴权层：guard/filter/interceptor/pipe 统一处理认证、权限、异常和响应包装。
- 契约层：DTO、错误码和响应结构必须和前端 API client、用户手册同步。

详见 `docs/architecture-server.md` 和 `docs/design-docs/api-design.md`。

## 4. 前端架构

前端示例采用 Vue 3 + TypeScript + Vite + Vue Router + Pinia。路由、API client、组件库和状态管理必须以当前 `web/` 源码为准。

```text
web/src/
  api/          # 后端请求封装、错误归一化、schema 校验
  assets/       # 样式、图片、静态资源
  components/   # 通用组件和业务组件
  composables/  # 可复用组合式逻辑
  router/       # 路由定义和导航守卫
  stores/       # Pinia stores
  views/        # 路由级页面
```

约定摘要：

- Vue 组件使用 Composition API 和 `<script setup lang="ts">`。
- props 和 emits 必须 typed，父子通信优先 props down / events up。
- 页面不直接拼接后端 URL；所有请求必须经过 `web/src/api/*`。
- Pinia 只承载跨页面状态；页面局部 loading、弹窗开关和表单草稿留在组件或 composable。
- API 字段、错误码和响应格式以后端 DTO、共享类型或 schema 为准，禁止在组件里复制 DTO。

详见 `docs/architecture-web.md`。

## 5. 关键约定

- 不要编造命令。新增或修改命令前先查 `Makefile`、`package.json`、`scripts/`、CI 和 README。
- 不要把根 `AGENTS.md` 写成教程；长示例、curl 集合、模块细节放入 `docs/` 后在根文件链接。
- 前端页面不直接请求后端；所有 HTTP 调用必须经过 `web/src/api/*`，详见 `docs/architecture-web.md`。
- Vue 组件使用 Composition API 和 `<script setup lang="ts">`；props/emits 必须 typed，复杂逻辑抽到 composable。
- Pinia store 只承载跨页面状态；页面局部状态不要提升到全局。
- NestJS Controller 只处理路由、参数、DTO 和响应码；业务规则放 Service，数据库访问放 Repository/DAO，详见 `docs/architecture-server.md`。
- NestJS 禁止在 Controller 写业务逻辑，禁止绕过 DTO validation，禁止直接返回未脱敏实体。
- 修改 API 字段、错误码、枚举、权限点时，必须检查 `server/`、`web/`、`docs/design-docs/api-design.md` 和 `user-guide/`。
- 安全相关改动必须检查鉴权、权限、日志脱敏和前端敏感信息暴露。
- `reference-projects/*` 是只读参考源码，不要把参考项目里的命令或约定直接写成当前项目事实。

## 6. 本地开发及验证流程

最小闭环：改动后先运行与改动相关的依赖边界检查、类型检查、lint、测试或构建，再启动对应服务做 smoke test。

```bash
scripts/lint-deps.sh
make lint-arch
make lint-format
make test
make build
```

后端接口改动至少补充一个 curl 或 API client 验证：

```bash
curl -i \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  http://localhost:3000/api/health
```

前端交互改动至少做浏览器 smoke check。启动脚本、Token 获取、日志路径和质量检查说明见 `docs/development.md`；API 约定见 `docs/design-docs/api-design.md`。

## 7. 质量检查

| 检查       | 命令                   | 什么时候跑                               |
| ---------- | ---------------------- | ---------------------------------------- |
| 依赖边界   | `scripts/lint-deps.sh` | 修改 `server/`、`web/` 或共享类型依赖时  |
| 架构边界   | `make lint-arch`       | 修改跨模块依赖、API client、后端分层时   |
| 格式检查   | `make lint-format`     | 提交前或修改 TS、Vue、样式后             |
| 自动格式化 | `make format`          | 格式检查失败且可自动修复时               |
| 构建       | `make build`           | 修改构建配置、公共类型、后端或前端入口后 |
| 测试       | `make test`            | 修改业务逻辑、API、组件行为或权限后      |
| 全量检查   | `make check`           | 交付前或改动影响面不确定时               |

命令失败时不要静默跳过；最终回复必须说明失败命令、关键错误和未覆盖风险。

## 8. 参考项目约定

参考优先级：当前源码和测试 > 当前仓库文档 > `docs/design-docs/ref-*.md` > `reference-projects/*` > 历史经验。

| 参考项目                                     | 用途                                                        | 导航                                             |
| -------------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------ |
| `reference-projects/pro-components/`         | 私域 Vue 组件库、表单、表格、弹窗模式                       | `docs/design-docs/ref-pro-components.md`         |
| `reference-projects/other-product-server/` | 相邻产品 NestJS 模块划分、DTO、错误码和权限点               | `docs/design-docs/other-product-server.md`    |
| `reference-projects/other-product-web/`       | 相邻产品 Vue 3 页面组织、API client、Pinia store 和组件模式 | `docs/design-docs/other-product-web.md`          |

参考项目只读，作为模式参考，不作为当前项目事实。引用参考项目时先读对应 `ref-*.md`，再看源码。

## 9. 文档导航

| 文档                                         | 什么时候读                                  |
| -------------------------------------------- | ------------------------------------------- |
| `docs/architecture-server.md`               | 修改 NestJS 分层、依赖边界、DTO/VO、Entity 和领域模型 |
| `docs/architecture-web.md`                  | 修改 Vue 页面、组件、composable、store、API client |
| `docs/development.md`                        | 安装、启动、数据库、env、命令来源和本地环境 |
| `docs/design-docs/api-design.md`             | 修改 REST API、响应格式、错误码和端点       |
| `docs/design-docs/ref-*.md`                  | 查看参考项目用途、优先级和注意事项          |
