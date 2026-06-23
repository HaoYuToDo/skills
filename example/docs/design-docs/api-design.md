# API 设计

这个文档给 AI Agent 解决的问题：修改 NestJS REST API 时，知道响应格式、错误码、端点命名和前后端契约同步规则。

应该维护在这里的内容：稳定 API 风格、响应结构、错误码约定、端点设计原则、兼容策略。

不应该维护在这里的内容：每个接口的完整 OpenAPI 输出、临时调试 curl、数据库表结构全集。

## 响应格式

示例成功响应：

```json
{
  "data": {
    "id": "usr_123",
    "name": "Ada"
  },
  "requestId": "req_abc"
}
```

示例错误响应：

```json
{
  "code": "USER_NOT_FOUND",
  "message": "用户不存在",
  "details": {},
  "requestId": "req_abc"
}
```

规则：

- 前端业务分支依赖稳定 `code`，不依赖 `message` 文案。
- `message` 是用户或客服可理解的信息，不暴露 stack、SQL、内部服务地址。
- `requestId` 用于前后端联动排查。

## 端点命名

- 使用名词复数资源：`/api/users`、`/api/orders`。
- 使用 HTTP method 表达动作：`GET` 查询、`POST` 创建、`PATCH` 部分更新、`DELETE` 删除。
- 非 CRUD 动作必须有清晰语义，例如 `POST /api/orders/:id/cancel`。
- 列表接口必须明确分页、排序和过滤参数。

## 兼容策略

- 新增响应字段通常兼容，但前端不应立即假设所有环境都有该字段。
- 删除、改名、类型变化属于破坏性变更，必须同步更新 `server/`、`web/`、用户手册和测试。
- 错误码一旦被前端或用户手册依赖，不应随意改名。

## 修改 API 的检查清单

- 后端 DTO 和 validation 是否更新。
- 前端 API client 是否更新。
- 相关 Vue 页面是否处理 loading/error/empty。
- 用户手册是否需要同步。
- curl 或集成测试是否覆盖成功和失败路径。

