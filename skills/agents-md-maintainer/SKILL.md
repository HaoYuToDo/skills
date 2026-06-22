---
name: agents-md-maintainer
description: Create, review, normalize, and split AGENTS.md project instruction files for AI Coding Agents. Use when the user asks in Chinese or English to create AGENTS.md, check whether an existing AGENTS.md follows best practices, rewrite it into a concise map-not-manual style, split oversized instructions into docs/agents, add project build/test/validation guidance, or align Claude/Cursor/Copilot/Gemini style agent instruction files with AGENTS.md.
---

# AGENTS.md Maintainer

## 输出语言

默认使用中文输出，包括最终回复、审查结论、新建或整理后的 `AGENTS.md`、拆分到 `docs/agents/` 的文档内容。只有在用户明确要求英文，或项目现有文档明显全英文且用户要求保持一致时，才改用英文。

保留命令、路径、包名、API 名称、代码标识符的原文，不要为了中文化而翻译这些技术字面量。

## 核心原则

把 `AGENTS.md` 当成地图，而不是手册。只保留两类内容：AI Agent 理解项目全貌的必要信息，例如技术栈、仓库结构、核心模块、分层架构；以及违反后会直接导致问题的硬性规则，例如编码规约、命名约定、禁止项。教程、长示例、实现细节、模块深度说明都应拆到链接文档或指向源码。

判断标准：如果 AI 不知道这条信息就会写出错误代码，放进根 `AGENTS.md`；如果只是会写出不够好的代码，放进详细文档，根 `AGENTS.md` 只保留链接。

使用本 Skill 为仓库创建、检查、规范化或拆分 `AGENTS.md`。

## 工作流程

1. 写之前先检查项目。阅读文件列表、manifest、构建文件、包管理器文件、CI 配置、现有文档，以及已有 Agent 指令文件，例如 `AGENTS.md`、`CLAUDE.md`、`.cursorrules`、`.cursor/rules`、`.github/copilot-instructions.md`、`GEMINI.md`、`.clinerules`、`AGENT.md`。
2. 从真实来源发现命令，例如 `package.json`、`Makefile`、`pnpm-workspace.yaml`、`turbo.json`、`pom.xml`、`gradlew`、`pyproject.toml`、`Cargo.toml`、`go.mod`、Docker Compose 文件或 CI workflow。不要编造命令。
3. 如果缺少 `AGENTS.md`，在仓库根目录创建。如果已经存在，保留正确的项目专属规则，只重写能提升清晰度、真实性和可维护性的部分。
4. 如果根目录 `AGENTS.md` 过长或像手册，把详细内容拆到 `docs/agents/`，根文件只留下简短摘要和链接。
5. 对 monorepo 或明显不同的子系统，只有在子目录存在特殊规则时才新增嵌套 `AGENTS.md`。嵌套文件应短小，并只描述当前目录规则。
6. 如果用户是在改进已有 AI 规则，根据 bad case 反推规则位置：全局硬规则写入 `AGENTS.md`，模块细节写入 `docs/agents/` 或已有专题文档，组件用法写入组件模式文档，参考项目结构写入 `ref-*` 文档。
7. 编辑后，用下面的检查清单复核最终文档，并在安全可行时运行相关项目验证命令。

## 实践提炼

- 以 `AGENTS.md` 作为 AI 规则核心入口。其他工具专属文件应尽量软链接、引用或保持与 `AGENTS.md` 一致，避免多处复制同一规则。
- 保持读者边界：`README.md` 面向人类快速开始，`AGENTS.md` 面向 AI 建立项目地图，`docs/agents/` 面向 AI 和人类补充模块细节，`scripts/` 或 `Makefile` 面向人和 AI 共同执行。
- 把复杂操作封装成稳定命令。优先记录一键启动、健康检查、质量检查、验证脚本等入口；环境变量位置和优先级必须写清楚，敏感本地配置不应建议提交进仓库。
- 用 bad case 驱动维护。每次 AI 犯错后，判断是缺全局规则、缺模块文档、缺组件说明、缺参考源码，还是缺自动化检查，再补到对应位置。
- 规则要有执行力。关键硬规则优先配套 lint、test、typecheck、依赖扫描、架构检查或脚本验证；自定义检查失败信息应说明 WHAT、WHY、HOW。
- 验证不止于编译。后端优先给出 bash、curl 或测试命令；前端或 UI 变更应补充浏览器验证、截图检查或人工可复现路径；功能变更应尽量形成“改 -> 检 -> 启动 -> 验证 -> 修复”的闭环。
- 对闭源组件、内部框架、相邻系统或训练数据覆盖不到的项目，优先链接权威源码、类型定义、schema 或 `reference-projects/`，并配套短小的 `ref-*` 导航文档说明什么时候看哪个参考。
- 如果有 `/init`、项目脚手架或其他工具生成的初稿，可以作为起点，但必须用仓库真实文件、CI 和源码校正；不要把自动生成内容当成事实。

## 根 AGENTS.md 推荐结构

除非仓库明显适合另一种更简洁结构，否则优先使用这套通用模板。根文件建议控制在 200 行以下；超过这个范围时，把细节拆分到 `docs/agents/` 下的专题文档，根文件只保留摘要和链接。

```markdown
# AGENTS.md

## 1. 项目概述
一段话说清楚：项目是什么、技术栈、仓库结构。前 10 行必须帮助 AI 建立项目心智模型。

## 2. 快速命令
用速查表列出构建、启动、格式化、质量检查等真实命令。说明环境变量配置，例如 env 文件位置、启动脚本是否自动 source。

## 3. 后端架构
用 ASCII 包结构树说明后端目录和每个包的用途。简要说明核心子系统，并链接详细文档。前后端术语存在差异时，补充术语映射。

## 4. 前端架构
说明前端技术栈、路由方案、API 层约定、组件库规范，并链接详细文档。

## 5. 关键约定
列出 5-10 条硬性编码规则，只写违反后会直接导致问题的规则。每条规则尽量附详细文档或权威源码链接。

## 6. 本地开发及验证流程
说明“改 -> 构建 -> 启动 -> 验证”的完整闭环。项目支持时补充 curl 验证模板、Token 获取方式、日志路径。

## 7. 质量检查
用矩阵列出 lint、format、build、test 等命令，并说明适用场景或结束前最低检查要求。

## 8. 参考项目约定
列出参考项目、私有组件或相邻仓库，并说明优先级规则。

## 9. 文档导航
用索引表链接所有详细文档，尤其是拆分到 docs/agents/ 的专题文档。
```

## 检查清单

检查现有或新写的 `AGENTS.md` 是否满足：

- 定位清晰：快速说明项目是什么、技术栈是什么、重要目录在哪里。
- 命令真实：列出项目中实际存在的安装、构建、启动、测试、lint、format 和验证命令。
- 规则克制：只保留少量可执行硬规则，不写泛泛偏好。
- 验证闭环：说明改完代码后如何验证，而不是只停在“已修改文件”。
- 渐进披露：细节链接到文档或源码，根文件尽量控制在 200 行以内；超过时拆到 `docs/agents/`。
- 自动化意识：重要规则有自动检查，或建议补充自动检查。自定义检查的错误信息应说明 WHAT、WHY、HOW。
- 兼容一致：其他工具专属指令文件应指向 `AGENTS.md`，或至少不要写冲突规则。

## 拆分规则

当内容过长、只属于某个模块、像教程、包含大量示例，或只是让代码“写得更好”而不是“避免写错”时，应拆分，不要塞进根目录 `AGENTS.md`。

路径选择规则：

- 优先复用项目已有文档体系，例如已有 `docs/architecture.md`、`docs/development.md`、`docs/design-docs/` 时，在根 `AGENTS.md` 链接这些文件，不要强行迁移。
- 如果项目没有清晰的 AI 文档目录，默认拆到 `docs/agents/`。
- 根 `AGENTS.md` 每个链接只保留一句说明，必要时写明“什么时候该读这个文档”。

默认拆分位置：

| 内容类型 | 默认位置 | 根 `AGENTS.md` 中保留什么 |
| --- | --- | --- |
| 总体架构、模块关系、数据流 | `docs/agents/architecture.md` | 架构摘要和入口链接 |
| 后端包结构、服务边界、核心子系统 | `docs/agents/backend.md` | 后端目录树摘要和入口链接 |
| 前端路由、API 层、组件库、状态管理 | `docs/agents/frontend.md` | 前端技术栈摘要和入口链接 |
| 环境变量、启动脚本、常用命令说明 | `docs/agents/commands.md` | 命令速查表和环境入口 |
| curl、浏览器、日志、Token 获取等验证步骤 | `docs/agents/validation.md` | 最小验证闭环和入口链接 |
| 编码约定、组件模式、长示例 | `docs/agents/conventions.md` | 5-10 条硬规则和详细链接 |
| 参考项目、私有组件、外部源码地图 | `docs/agents/references.md` | 参考优先级和入口链接 |

这些内容应留在根目录 `AGENTS.md`：

- 仓库级心智模型。
- 真实命令表。
- 全局适用的硬规则。
- 指向拆分文档的链接。
- 任何遗漏后代价很高的提醒。

## 写作要求

- 直接、明确、可执行。写给已经在仓库里的 AI Agent。
- 避免“写干净代码”这类泛泛建议，除非项目里有具体定义和检查方式。
- 优先链接事实来源，而不是复制大段细节。源码、类型定义、schema、CI 配置通常比说明文更权威。
- 不要编造命令。推断但未确认的命令应标为候选，或先不写。
- 从已有工具指令文件复制规则时，如有冲突，优先采用更具体、更新、离当前仓库更近的规则。
- 用户要求自动整理时，完成检查后直接编辑；如果不确定性较高，在最终回复中列出假设。
