# reference-projects

这个目录示例代表只读参考项目集合。

真实项目中，这些目录通常是 git submodule、只读源码快照或内部参考仓库。AI Agent 可以用它们理解相邻系统、组件库和集成模式，但不能把参考项目里的命令、目录、依赖或部署方式直接当成当前项目事实。

优先级：

1. 当前项目源码和测试。
2. 当前项目 `AGENTS.md` 和 `docs/`。
3. `docs/design-docs/ref-*.md`。
4. `reference-projects/*` 源码。
5. 通用经验。

