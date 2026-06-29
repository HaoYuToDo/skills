# Git 规范模板

## 提交信息规范

提交信息使用简洁的中文，格式为：

`类型: 简短说明`

常用类型：

- `feat`: 新功能
- `fix`: 修复问题
- `refactor`: 重构
- `style`: 样式或格式调整
- `test`: 测试相关
- `docs`: 文档相关
- `chore`: 构建、依赖、配置等杂项

示例：

- `feat: 添加用户筛选功能`
- `fix: 修复登录状态丢失问题`
- `refactor: 简化订单状态计算逻辑`

不要使用笼统提交信息，例如：

- `update`
- `fix bug`
- `修改代码`

## Git 改动保护

本仓库可能同时存在多个并发任务，不要假设工作区已有改动是你做的。

只修改当前任务需要的文件，不要对其他文件做任何操作。

禁止使用以下会丢失未提交改动的命令：

- `git reset --hard`
- `git checkout -- .`
- `git checkout -- <file>`
- `git restore .`
- `git restore <file>`
- `git clean -fd`
- `git clean -xdf`

任务结束时运行 `git status --short`，并在最终回复中声明：

1. **本任务实际修改的文件**（附简要说明改了什么）
2. **工作区中其他未提交改动的文件**（非本任务所为，请人工确认）
