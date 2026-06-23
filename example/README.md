# AGENTS.md Maintainer 项目全景示例

这是 `agents-md-maintainer` skill 的文档产物示例，模拟一个 Vue 3 + NestJS 项目整理 AI Coding Agent 指令后，可能形成的“项目全景图”结构。

这个目录不是可运行项目，只展示文档、目录职责、质量检查入口、启动脚本入口和参考项目导航。所有 `pnpm`、`vite`、`nest`、`vitest`、`playwright` 命令都是“目标项目示例命令”，用于演示真实项目中应该如何记录命令和验证流程。

## 如何阅读

1. 先读 `AGENTS.md`：它是 AI Agent 的入口，只保留项目地图、硬规则、真实命令摘要和文档导航。
2. 需要理解后端架构时，读 `docs/architecture-server.md`；需要理解前端架构时，读 `docs/architecture-web.md`。
3. 需要安装、启动、构建和配置环境时，读 `docs/development.md`。
4. 需要修改接口或后端 Controller 约定时，读 `docs/design-docs/api-design.md` 和 `docs/architecture-server.md`。
5. 需要查看只读参考项目时，读 `reference-projects/` 和 `docs/design-docs/ref-*.md`。

## 文件读者

| 文件 | 主要读者 | 作用 |
| --- | --- | --- |
| `README.md` | 人 | 说明这个示例如何使用，不承载项目规则 |
| `AGENTS.md` | AI 为主，人可浏览 | AI Coding 的根入口，保持地图式 |
| `Makefile` | 人和 AI | 质量检查统一入口示例 |
| `scripts/*.sh` | 人和 AI | 启动、健康检查和依赖检查脚本示例 |
| `server/` | AI | NestJS 后端目录占位和职责说明 |
| `web/` | AI | Vue 3 前端目录占位和职责说明 |
| `user-guide/` | 人为主，AI 可生成 | 用户手册目录示例 |
| `docs/*.md` | AI 为主，人可参考 | 架构、开发、设计细节和参考导航 |
| `reference-projects/*` | AI 只读 | 参考项目源码占位，不作为当前项目事实 |
| `CLAUDE.md` / `.cursorrules` / `.github/copilot-instructions.md` | 对应工具 | 桥接到 `AGENTS.md`，避免重复维护 |

## 示例项目假设

- 前端：Vue 3、TypeScript、Vite、Vue Router、Pinia。
- 后端：NestJS、TypeScript、REST API、DTO validation。
- 共享契约：由后端 DTO、前端 API client、共享 schema 或生成类型共同维护，真实项目应按源码结构补充。
- 包管理：pnpm。
- 目标：展示 AI Agent 如何从项目事实中创建、审查、拆分和维护 `AGENTS.md`。

## 当前示例目录

```text
example/
  AGENTS.md
  README.md
  Makefile
  CLAUDE.md
  .cursorrules
  .github/
    copilot-instructions.md
  server/
  web/
  user-guide/
  scripts/
    start-server.sh
    start-web.sh
  docs/
    architecture-server.md
    architecture-web.md
    development.md
    design-docs/
      api-design.md
      ref-pro-components.md
      other-product-server.md
      other-product-web.md
  reference-projects/
    pro-components/
    other-product-server/
    other-product-web/
```

## 使用方式

把本目录当作模板库，而不是直接复制到真实项目。真实项目使用时应：

- 删除不存在的目录、命令、参考项目和技术栈说明。
- 用 `package.json`、`Makefile`、CI、脚本和源码中的真实事实替换示例内容。
- 只保留违反后会写错代码的硬规则。
- 把教程、长示例和模块深潜放入 `docs/`，根 `AGENTS.md` 只保留链接。
