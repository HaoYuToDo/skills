# skills

这个仓库用于维护个人 Codex Skills 和跨项目复用的全局 Agent 指令。目前主要包含一个 skill：`agents-md-maintainer`，用于帮助其他项目创建、审查、规范化和拆分 `AGENTS.md`；以及 `global/AGENTS.md`，用于同步到多个项目作为通用协作规则。

`AGENTS.md` 的核心原则是渐进式披露：它是一张项目地图，不是一本开发手册。根文件只放 AI 理解项目全貌所必需的信息，以及违反后会直接导致问题的硬性规则；更细的教程、模块说明和长示例应拆到详细文档里，再从根文件链接过去。

## 目录结构

```text
skills/                  # GitHub 仓库根目录；本地 checkout 名称可以不同
  README.md
  global/
    AGENTS.md            # 跨项目复用的全局 Agent 指令
  skills/
    agents-md-maintainer/
      SKILL.md              # 可独立导入其他项目或 Codex skills 目录的 skill
  example/
    AGENTS.md               # 期望产物示例
    docs/                   # 拆分后的详细文档示例
    reference-projects/     # 只读参考项目示例
```

## agents-md-maintainer

`skills/agents-md-maintainer/SKILL.md` 是这个仓库的主要产物。它定义了 Codex 在维护 `AGENTS.md` 时应该遵循的流程、模板、拆分规则和检查清单。

适用场景：

- 为项目补一个新的 `AGENTS.md`。
- 检查现有 `AGENTS.md` 是否太长、太像手册或不够真实。
- 把根 `AGENTS.md` 中的教程、长示例和模块细节拆到 `docs/`。
- 为项目补充真实的构建、启动、测试、质量检查和验证命令。
- 根据 AI 写错代码的 bad case 反推应该新增的硬规则或文档入口。

## 使用方式

把 `skills/agents-md-maintainer/` 作为独立 skill 导入到目标环境即可。这个 skill 不依赖本仓库的 `example/` 目录。

如果使用默认 Codex skills 目录，可以复制到：

```bash
cp -R skills/agents-md-maintainer ~/.codex/skills/
```

之后在其他项目中直接提出类似请求：

```text
用 agents-md-maintainer 帮这个项目补一个 AGENTS.md
```

```text
检查这个 AGENTS.md 有没有太像手册，帮我拆到 docs/
```

## 示例

`example/` 是一个完整的示例项目骨架，用来展示这个 skill 期望生成或整理出的形态：

- `example/AGENTS.md` 展示根文件如何保持地图式、短小、可扫描。
- `example/docs/` 展示架构、开发、API 和参考项目说明如何承接详细内容。
- `example/reference-projects/` 展示只读参考项目如何被导航，而不是被当作当前项目事实。

示例只用于理解产物形态，不是 skill 运行时依赖。把 skill 导入其他项目时，只需要 `skills/agents-md-maintainer/`。

## 全局 AGENTS.md

`global/AGENTS.md` 是跨项目复用的通用 Agent 指令，适合复制或同步到其他仓库根目录作为默认 `AGENTS.md`。它只放通用沟通、编码、验证、前后端偏好和 Git 交付规则，不包含某个具体项目的技术栈、命令或目录结构。

同步到目标项目时，可以复制为目标仓库根目录的 `AGENTS.md`：

```bash
cp global/AGENTS.md /path/to/project/AGENTS.md
```

## 维护说明

- 修改 skill 行为时，优先改 `skills/agents-md-maintainer/SKILL.md`。
- 修改跨项目通用规则时，优先改 `global/AGENTS.md`，再同步到需要使用它的项目。
- 修改期望产物形态时，同步更新 `example/AGENTS.md` 和相关 `example/docs/`。
- README 只说明这个仓库是什么、包含什么、怎么使用；具体维护规则不要在 README 和 `SKILL.md` 之间重复维护。
