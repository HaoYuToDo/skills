# agents-md-maintainer

一个用于维护 `AGENTS.md` 项目指令文件的 Codex Skill。

它帮助 AI Coding Agent 为仓库创建、审查、规范化和拆分 `AGENTS.md`，让项目指令保持“地图式”而不是“手册式”：根文件只保留 AI 理解项目和避免写错代码所必需的信息，详细说明则链接到源码或拆分到专题文档。

## 适用场景

- 为新项目创建根目录 `AGENTS.md`。
- 检查已有 `AGENTS.md` 是否清晰、真实、可维护。
- 将过长、像教程的 Agent 指令拆分到 `docs/`。
- 从 `CLAUDE.md`、`.cursorrules`、Copilot/Gemini/Cline 等工具指令中整理统一规则。
- 为项目补充真实的构建、启动、测试、质量检查和验证命令。
- 根据 AI 写错代码的 bad case 反推应该补充的规则或文档入口。

## 核心理念

`AGENTS.md` 应该是项目地图，而不是完整开发手册。

根目录 `AGENTS.md` 只应该保留两类内容：

- AI 不知道就会写错代码的项目心智模型，例如技术栈、目录结构、核心模块和架构边界。
- 违反后会直接导致问题的硬性规则，例如命名约定、禁止项、关键验证流程。

教程、长示例、模块深度说明和实现细节应优先放入已有文档，或拆分到 `docs/`，再从根 `AGENTS.md` 链接过去。

## 文件读者边界

团队中不是所有人都用 AI 工具。推广 `AGENTS.md` 时，建议明确标注每类文件的目标读者，降低理解成本。

| 文件 | 读者 | 说明 |
| --- | --- | --- |
| `README.md` | 人 | 项目介绍、快速开始，给人类看的入口 |
| `AGENTS.md` | AI 为主，人可浏览 | AI 工具自动读取的项目指令 |
| `docs/*.md` | AI 为主，人可参考 | 各模块的开发手册 |
| `scripts/*.sh` | 人和 AI 都用 | 构建、启动、部署脚本 |
| `setup-repos.sh` | 人执行 | 一键环境搭建 |

`README.md` 和 `AGENTS.md` 是互补的：`README.md` 是给人类看的项目说明，聚焦快速开始和贡献指南；`AGENTS.md` 是给 AI 看的项目指令，聚焦构建命令、编码规范和验证流程。两者的内容可能有少量重叠，例如项目概述，但侧重点不同，不需要合并。

一句话总结：脚本是人和 AI 共用的，`AGENTS.md` 和 `docs/` 下的文档主要是给 AI 的上下文，人不需要刻意阅读但可以参考。

## 推荐产物结构

常见输出包括：

- `AGENTS.md`：仓库级 AI 指令入口。
- `docs/architecture-server.md`：后端分层架构、依赖规则和领域模型。
- `docs/architecture-web.md`：前端分层架构、依赖规则、状态管理和 API 边界。
- `docs/development.md`：开发环境、依赖安装、本地启动和常用命令。
- `docs/server.md` 或 `docs/server/*.md`：后端目录、服务边界和核心子系统。
- `docs/web.md` 或 `docs/web/*.md`：前端路由、API 层、组件和状态管理约定。
- `docs/validation.md`：本地验证、curl、浏览器检查和日志排查流程。
- `docs/conventions.md`：编码约定、组件模式和长示例。
- `docs/design-docs/ref-*.md` 或 `docs/references/*.md`：参考项目、私有组件或相邻系统导航。
- `docs/design-docs/*-patterns.md` 或 `docs/patterns/*.md`：组件使用模式和场景化示例。

单篇、仓库级、长期稳定的主题平铺在 `docs/`；会形成系列文档、需要按来源/模块/模式扩展，或文件名天然需要 `ref-*.md`、`*-patterns.md` 这类通配符表达时，多建一层专题目录。

是否拆分取决于项目规模。小项目通常只需要一个简洁的根 `AGENTS.md`。

## AGENTS.md 通用模板

根 `AGENTS.md` 建议包含：

1. 项目概述：一段话说清楚项目是什么、技术栈、仓库结构，前 10 行必须让 AI 建立项目心智模型。
2. 快速命令：构建、启动、格式化、质量检查的命令速查表，以及 env 文件位置、启动脚本是否自动 source。
3. 后端架构：ASCII 包结构树、每个包的用途、核心子系统摘要、详细文档链接、前后端术语映射。
4. 前端架构：技术栈、路由方案、API 层约定、组件库规范和详细文档链接。
5. 关键约定：5-10 条违反后会直接导致问题的硬性编码规则，并附详细文档链接。
6. 本地开发及验证流程：「改 → 构建 → 启动 → 验证」闭环、curl 验证模板、Token 获取、日志路径。
7. 质量检查：lint、format、build、test 命令矩阵。
8. 参考项目约定：参考项目列表和优先级规则。
9. 文档导航：所有详细文档的索引表。

建议控制在 200 行以下。超过这个范围，考虑将细节拆分到 `docs/` 下的专题文档。

### 章节结构摘要示例

下面是管控系统项目 `AGENTS.md` 的章节结构摘要，供参考。使用时必须替换为当前仓库真实技术栈、命令、路径和规则。

```markdown
# AGENTS.md

## 1. 项目概述

一段话：项目定位、技术栈（NestJS + Vue 3）、monorepo 结构。

## 2. 快速命令

构建、启动、格式化、质量检查命令速查表。

环境变量配置：`~/.<project>_env` 优先级说明。

## 3. 后端架构

包结构树（ASCII）+ 每个包的用途注释。

核心子系统简要说明。

→ 详见 `docs/architecture-server.md`

## 4. 前端架构

技术栈、路由方案、API 层约定、组件库规范。

→ 详见 `docs/architecture-web.md`

## 5. 关键约定

- 异常统一用 `BusinessException`，禁止直接抛 `RuntimeException`。
- 响应体由框架统一包装，禁止手动构造。
- 分层架构禁止跨层依赖（`make lint-arch` 自动检查）。
- 代码风格：Spotless + Google Java Format。
- 安全：无状态 JWT。

→ 每条规则附详细文档链接。

## 6. 本地开发及验证流程

「改 → 构建 → 启动 → 验证」完整闭环。

curl 验证模板、Token 获取、日志路径。

→ 详见 `docs/design-docs/api-verification.md`

## 7. 质量检查

`make lint-arch` / `make lint-format` / `make format` / `make build` / `make test`

## 8. 参考项目约定

参考项目列表 + 优先级规则。

## 9. 文档导航

所有详细文档的索引表（`architecture` / `design-docs` / `ref-*`）。
```

## 项目全景图示例

下面把前面的实践汇总成一张全景图，方便对照参考。使用时必须按当前仓库真实目录裁剪，不要为了凑结构而创建空目录或空文档。

```text
project-root/
  AGENTS.md                         # AI Coding 项目指令（核心入口）
  README.md                         # 给人看的项目说明
  Makefile                          # 质量检查统一入口（lint-arch/format/build/test）

  server/                           # 后端（NestJS）
  web/                              # 前端（Vue 3 + TypeScript）
  user-guide/                       # 用户手册（Markdown，AI 基于代码生成）

  scripts/
    start-server.sh                 # 后端一键启动（构建+启动+健康检查）
    start-web.sh                    # 前端一键启动
    lint-deps.sh                    # 分层依赖检查脚本

  docs/
    architecture-server.md          # 后端分层架构、依赖规则、领域模型
    architecture-web.md             # 前端分层架构、依赖规则、状态管理
    development.md                  # 环境要求、构建运行、数据库
    design-docs/
      api-design.md                 # 响应格式、错误码、端点详情
      gateway-integration.md        # 网关对接详细文档
      ref-higress.md                # 参考：Higress 网关内核
      ref-nacos.md                  # 参考：Nacos 注册配置中心
      ref-pro-components.md         # 参考：私域组件库
      ef-other-product-server.md    # 参考：其他产品后端
      other-product-web.md          # 参考：其他产品前端
      ref-himarket.md               # 参考：HiMarket AI 开放平台

  reference-projects/               # 参考项目（git submodule，只读）
    higress/                        # 开源 Higress 网关内核源码
    nacos/                          # 开源 Nacos 源码
    pro-components/                 # 私域组件库源码
    ef-other-product-server/        # 其他产品后端
    other-product-web/              # 其他产品前端
    himarket/                       # 开源 HiMarket AI 开放平台
```

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
这个 AGENTS.md 太像教程了，帮我拆到 docs/
```

## 维护建议

- 优先从真实文件提取事实，例如 `package.json`、`Makefile`、CI workflow、`pyproject.toml`、`go.mod`、`Cargo.toml` 等。
- 不要编造项目命令；无法确认的命令宁可不写。
- 根 `AGENTS.md` 建议控制在 200 行以内，超过时拆分。
- 不要试图一次写完 `AGENTS.md`；它需要随着项目演进持续调整。
- 每次 AI 犯错后，先复盘错误，例如用了错误的命名风格、在错误的层级引入了依赖；再判断“多写哪条规则能避免复发”；最后决定写到哪里：全局规则写入 `AGENTS.md`，模块细节写入对应的 `docs/`。
- 其他工具专属指令文件应尽量指向 `AGENTS.md`，或至少避免写出冲突规则。

## 文件说明

- `SKILL.md`：Skill 的完整行为定义、工作流程、推荐结构、拆分规则和检查清单。
- `README.md`：面向仓库维护者的人类说明。
