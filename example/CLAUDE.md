# Claude 指令桥接

本文件用于演示如何让 Claude 专属指令与统一的 AI Agent 规则保持一致。

请先阅读并遵守 `AGENTS.md`。本文件不重复维护项目架构、命令、编码约定或验证流程，避免与 `AGENTS.md` 漂移。

Claude 执行任务时的补充要求：

- 如果 `AGENTS.md` 与本文件冲突，以 `AGENTS.md` 为准。
- 如果进入 `web/`、`server/`、`scripts/` 或 `docs/design-docs/`，继续阅读该目录 README 或对应专题文档。
- 不要根据本示例编造真实项目命令；真实项目命令必须来自 manifest、脚本或 CI。
- 输出审查结论时先列风险和文件位置，再给简短总结。
