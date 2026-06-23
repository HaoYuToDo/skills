# 参考项目：Nacos

用途：参考服务发现、配置管理、命名空间、配置发布和订阅模型。

位置：`reference-projects/nacos/`

使用规则：

- 只读参考，不把 Nacos 构建命令写入当前项目。
- 当前项目如果只消费配置，不要引入 Nacos 服务端内部概念。
- 配置项命名和 env 优先以当前项目 `docs/development.md` 为准。

