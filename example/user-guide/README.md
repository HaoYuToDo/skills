# 用户手册

这个目录示例代表面向用户的 Markdown 手册。

AI 可以基于已验证的源码、接口和产品行为生成手册，但必须遵守：

- 不记录内部 token、cookie、数据库连接、私有部署路径。
- 不把未发布功能写成已上线能力。
- UI 文案、接口字段或权限变化后，检查对应用户说明是否需要同步。
- 面向用户描述操作结果，不暴露内部实现。

建议真实项目内容：

```text
user-guide/
  getting-started.md
  account-and-permissions.md
  troubleshooting.md
```

