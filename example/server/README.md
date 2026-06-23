# server

这个目录示例代表 NestJS 后端。

AI Agent 在这里工作时应遵守：

- Controller 只处理路由、参数、DTO、状态码和调用 Service。
- Service 承载业务规则、事务边界和外部服务编排。
- Repository/DAO 负责数据库访问。
- DTO 是 API 边界，不直接返回未脱敏数据库实体。
- 鉴权、权限、异常过滤、响应包装优先使用 NestJS guard/filter/interceptor/pipe。

建议真实项目目录：

```text
server/
  src/
    main.ts
    app.module.ts
    common/
      filters/
      guards/
      interceptors/
      pipes/
    config/
    modules/
      users/
        users.module.ts
        users.controller.ts
        users.service.ts
        dto/
        repositories/
```

详细后端架构见 `../docs/architecture-backend.md`，Controller 约定见 `../docs/design-docs/controller-conventions.md`。
