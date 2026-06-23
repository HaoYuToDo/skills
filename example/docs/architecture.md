# 架构说明

这个文档给 AI Agent 解决的问题：理解 Vue 3 + NestJS 项目的整体结构、职责边界、依赖规则和领域模型，避免在错误层级写代码。

应该维护在这里的内容：长期稳定的架构事实、目录职责、模块边界、跨端数据流、参考项目优先级。

不应该维护在这里的内容：接口字段全集、组件长示例、Controller 细节、一次性排查日志。这些内容应放在 `docs/design-docs/`、源码、schema 或测试中。

## 项目结构

```text
project-root/
  AGENTS.md
  README.md
  Makefile
  server/               # NestJS 后端
  web/                  # Vue 3 前端
  user-guide/           # 用户手册
  scripts/              # 启动和检查脚本
  docs/
    architecture.md
    development.md
    design-docs/
  reference-projects/   # 只读参考项目
```

## 职责边界

`web/` 负责浏览器端体验：

- 页面组合、路由、用户交互、表单校验、loading/error/empty 状态。
- 通过 `web/src/api/*` 调用后端，不直接依赖 NestJS 模块。
- 只保存前端展示状态和会话状态，不承载后端业务规则。

`server/` 负责服务端业务：

- REST API、认证鉴权、DTO validation、业务规则、数据库访问、审计日志。
- 通过 NestJS module 边界组织业务能力。
- 对外返回稳定 DTO，不直接返回未脱敏数据库实体。

`user-guide/` 负责面向用户的 Markdown 手册：

- AI 可以基于已验证功能和接口生成用户说明。
- 用户手册不得记录内部 token、数据库字段、私有部署细节。
- API 或 UI 文案变更时，检查手册是否需要同步。

`reference-projects/` 是只读参考源码：

- 只用于查模式、命名、集成方式和相邻系统行为。
- 不把参考项目命令、目录或技术栈当成当前项目事实。
- 引用参考项目时，先读 `docs/design-docs/ref-*.md` 中的说明。

## 数据流

```text
Vue View
  -> composable/store
  -> web/src/api client
  -> HTTP REST endpoint
  -> NestJS Controller
  -> DTO validation pipe
  -> Service
  -> Repository/DAO
  -> database or external service
```

返回链路：

```text
Repository entity
  -> Service result
  -> response DTO
  -> global response/error filter
  -> API client normalization
  -> composable/store state
  -> Vue component render
```

## 依赖规则

- `web/` 可以依赖前端工具、UI 组件、API client 和共享类型。
- `server/` 可以依赖 NestJS、数据库 client、服务端 SDK 和共享类型。
- `web/` 不导入 `server/` 内部文件。
- `server/` 不导入 `web/` 组件、store 或浏览器代码。
- 共享类型如果存在，应保持无运行时环境依赖，不能依赖浏览器、NestJS provider 或数据库 client。

## 领域模型

领域模型以服务端业务和 API 契约为准：

- 数据库实体是持久化模型，不等同于响应 DTO。
- DTO 是前后端契约，不应暴露密码、token、内部状态。
- 前端 view model 可以为展示派生字段，但不能改写后端业务语义。
- 错误码、枚举、权限点应有稳定命名，并在 API 文档中同步。

## AGENTS.md 与本文档边界

根 `AGENTS.md` 保留架构摘要、硬规则和文档链接。本文档保留目录职责、数据流、依赖边界和领域模型说明。具体 API、Controller、前端架构和参考项目说明放在 `docs/design-docs/`。

