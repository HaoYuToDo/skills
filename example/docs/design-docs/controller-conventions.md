# NestJS Controller 约定

这个文档给 AI Agent 解决的问题：修改 `server/` 中的 Controller、DTO 和响应处理时，避免把业务逻辑写错层。

应该维护在这里的内容：Controller 职责、DTO validation、状态码、异常处理、鉴权入口。

不应该维护在这里的内容：Service 业务算法长说明、数据库查询细节、前端组件逻辑。

## Controller 职责

Controller 只负责：

- 声明路由和 HTTP method。
- 接收 params、query、body。
- 使用 DTO 和 pipe 做输入校验。
- 声明认证、权限、状态码和 API 文档元数据。
- 调用 Service 并返回 DTO。

Controller 不负责：

- 编写复杂业务规则。
- 直接访问数据库。
- 拼接第三方服务请求。
- 返回未脱敏实体。

## DTO 规则

- Request DTO 字段必须明确 required / optional。
- 枚举、日期、数字、数组必须校验。
- Response DTO 不包含密码、token、内部状态、数据库审计字段。
- DTO 改动必须同步 `docs/design-docs/api-design.md` 和前端 API client。

## 错误处理

- 业务错误由 Service 抛出领域异常或业务异常。
- 全局 exception filter 统一转换响应结构。
- 认证失败返回 401，权限不足返回 403，参数错误返回 400 或 422。
- 服务器错误不要泄漏 stack trace 或 SQL。

## 示例骨架

```ts
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get(':id')
  async getUser(@Param('id') id: string): Promise<UserDto> {
    return this.usersService.getUser(id)
  }
}
```

真实项目应以现有 Controller 风格为准，不要只因为这个示例而重写架构。

