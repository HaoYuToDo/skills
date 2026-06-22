# agents-md-maintainer

一个用于维护 `AGENTS.md` 项目指令文件的 Codex Skill。

它帮助 AI Coding Agent 为仓库创建、审查、规范化和拆分 `AGENTS.md`，让项目指令保持“地图式”而不是“手册式”：根文件只保留 AI 理解项目和避免写错代码所必需的信息，详细说明则链接到源码或拆分到专题文档。

## 适用场景

- 为新项目创建根目录 `AGENTS.md`。
- 检查已有 `AGENTS.md` 是否清晰、真实、可维护。
- 将过长、像教程的 Agent 指令拆分到 `docs/agents/`。
- 从 `CLAUDE.md`、`.cursorrules`、Copilot/Gemini/Cline 等工具指令中整理统一规则。
- 为项目补充真实的构建、启动、测试、质量检查和验证命令。
- 根据 AI 写错代码的 bad case 反推应该补充的规则或文档入口。

## 核心理念

`AGENTS.md` 应该是项目地图，而不是完整开发手册。

根目录 `AGENTS.md` 只应该保留两类内容：

- AI 不知道就会写错代码的项目心智模型，例如技术栈、目录结构、核心模块和架构边界。
- 违反后会直接导致问题的硬性规则，例如命名约定、禁止项、关键验证流程。

教程、长示例、模块深度说明和实现细节应优先放入已有文档，或拆分到 `docs/agents/`，再从根 `AGENTS.md` 链接过去。

## 推荐产物结构

常见输出包括：

- `AGENTS.md`：仓库级 AI 指令入口。
- `docs/agents/architecture.md`：总体架构和模块关系。
- `docs/agents/backend.md`：后端目录、服务边界和核心子系统。
- `docs/agents/frontend.md`：前端路由、API 层、组件和状态管理约定。
- `docs/agents/commands.md`：环境、启动和常用命令说明。
- `docs/agents/validation.md`：本地验证、curl、浏览器检查和日志排查流程。
- `docs/agents/conventions.md`：编码约定、组件模式和长示例。
- `docs/agents/references.md`：参考项目、私有组件或相邻系统导航。

是否拆分取决于项目规模。小项目通常只需要一个简洁的根 `AGENTS.md`。

## 使用方式

把本目录作为 Codex Skill 安装后，当用户要求创建、检查、重写、拆分或统一 `AGENTS.md` 相关指令时，Codex 会使用该 skill。

典型请求示例：

```text
帮这个项目补一个 AGENTS.md
```

```text
检查现有 AGENTS.md 有没有过长或不真实的地方
```

```text
把 CLAUDE.md 和 .cursorrules 整理成统一的 AGENTS.md
```

```text
这个 AGENTS.md 太像教程了，帮我拆到 docs/agents/
```

## 维护建议

- 优先从真实文件提取事实，例如 `package.json`、`Makefile`、CI workflow、`pyproject.toml`、`go.mod`、`Cargo.toml` 等。
- 不要编造项目命令；无法确认的命令宁可不写。
- 根 `AGENTS.md` 建议控制在 200 行以内，超过时拆分。
- 每次 AI 犯错后，先判断应该补全的是全局规则、模块文档、组件说明、参考源码，还是自动化检查。
- 其他工具专属指令文件应尽量指向 `AGENTS.md`，或至少避免写出冲突规则。

## 文件说明

- `SKILL.md`：Skill 的完整行为定义、工作流程、推荐结构、拆分规则和检查清单。
- `README.md`：面向仓库维护者的人类说明。
