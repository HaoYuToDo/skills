# 后端架构

这个文档给 AI Agent 解决的问题：修改 `server/` 中 NestJS 代码时，知道代码应该写在哪一层、对象应该如何流转、哪些依赖绝对不能出现。

应该维护在这里的内容：后端分层架构、模块职责、依赖规则、DTO/VO/Entity 边界、领域模型和事务边界。

不应该维护在这里的内容：每个接口字段全集、完整 OpenAPI 输出、数据库 DDL 全量清单、一次性排查日志。这些内容应放在 API 文档、schema、迁移文件、测试或模块设计文档中。

## 目标架构

后端采用 NestJS 分层架构。真实项目目录以 `server/` 源码为准，新增功能时优先沿用已有模块命名和目录风格。

推荐结构：

```text
server/src/
  main.ts
  app.module.ts
  common/                 # 全局 filter、guard、interceptor、pipe、exception、response
  config/                 # env、配置加载、外部服务配置
  modules/
    orders/
      orders.module.ts
      orders.controller.ts
      orders.service.ts
      dto/
        create-order.dto.ts
        order-query.dto.ts
        order.vo.ts
      entities/
        order.entity.ts
      repositories/
        orders.repository.ts
```

## 分层职责

### Controller 层

Controller 是 HTTP 边界，只负责协议相关工作：

- 声明路由、HTTP method、状态码和 API 文档元数据。
- 接收 `params`、`query`、`body`、headers 和当前用户上下文。
- 使用 DTO、pipe 和 class-validator 做输入校验。
- 调用 Service，并返回 Response DTO/VO。

Controller 禁止：

- 编写业务规则、流程编排或事务逻辑。
- 直接调用 Repository、ORM client、数据库、缓存或第三方 SDK。
- 返回未脱敏 Entity、ORM Model 或数据库原始行。
- 拼接 SQL、拼接外部服务请求或吞掉业务异常。

### Service 层

Service 是业务用例层，负责表达系统能做什么：

- 编排一个业务用例，例如创建订单、查询订单、取消订单。
- 承载业务规则、权限后的业务校验、事务边界和幂等逻辑。
- 调用 Repository、其他领域 Service、外部服务网关或消息发布器。
- 将 Entity 或领域结果转换成对外 DTO/VO。

Service 禁止：

- 直接依赖 Controller、HTTP request/response 或 Vue 前端类型。
- 把 Entity 原样传给 Controller 作为响应。
- 把数据库查询细节泄漏给上层，例如返回 query builder。
- 为了复用而跨模块调用对方 Repository；跨领域协作应通过对方公开 Service 或应用服务。

### Repository/DAO 层

Repository/DAO 是数据访问层，只负责持久化：

- 封装 ORM、SQL、缓存读写和数据源适配。
- 返回 Entity、持久化模型或明确的内部查询结果。
- 隐藏数据库表结构、索引细节和查询优化实现。

Repository 禁止：

- 处理 HTTP DTO、VO、分页响应包装或前端展示字段。
- 编写跨业务流程、权限规则或用户可见错误文案。
- 被 Controller 直接调用。

### DTO/VO 层

DTO/VO 是 API 契约，不是数据库模型：

- Request DTO 描述输入字段、校验规则、默认值和可选性。
- Response DTO/VO 描述前端可见字段、脱敏结果和稳定枚举。
- DTO/VO 命名要表达方向，例如 `CreateOrderDto`、`OrderQueryDto`、`OrderVO`。

硬规则：

- Service 层绝对不能把 Entity 直接流转到前端，必须转换成 DTO/VO。
- Response DTO/VO 不包含密码、token、内部状态、软删除标记、数据库审计字段或第三方密钥。
- DTO 改动必须同步前端 API client、相关页面、测试和 `docs/design-docs/api-design.md`。

## 依赖规则

允许的依赖方向：

```text
Controller -> Service -> Repository -> database/external data source
                  |
                  v
             domain model / DTO mapper
```

具体规则：

- `modules/*/*.controller.ts` 可以依赖本模块 DTO、VO、Service 和通用鉴权装饰器。
- `modules/*/*.service.ts` 可以依赖本模块 Repository、Entity、DTO/VO mapper、领域服务和公共基础设施。
- `modules/*/repositories/*` 可以依赖 ORM/database client、Entity 和基础设施配置。
- `common/` 可以提供跨模块的异常、响应、权限、日志、pipe、filter、interceptor，但不能依赖具体业务模块。
- 跨模块调用优先通过被调用模块导出的 Service；禁止跨模块直接 import 对方 Repository 或 Entity 后修改持久化状态。
- `server/` 禁止导入 `web/` 内的任何文件。
- `reference-projects/` 只读参考，运行时代码禁止 import。

## 领域模型

领域模型以后端业务语义为准，前端展示模型和数据库表结构都不能替代领域模型。

### Entity

Entity 表示可持久化的核心业务对象：

```ts
class OrderEntity {
  id: string
  userId: string
  status: OrderStatus
  totalAmount: number
  createdAt: Date
  updatedAt: Date
}
```

Entity 规则：

- Entity 可以表达领域状态和持久化字段，但不能作为 API 响应直接返回。
- Entity 字段名优先反映业务语义，不为单个页面展示需求改名。
- 需要暴露给前端的派生字段，通过 Service mapper 生成 VO。

### 关系描述

用文字或伪代码维护稳定的核心关系，避免 AI 新增功能时误判边界：

```text
User 1 -- n Order
Order 1 -- n OrderItem
Order n -- 1 Payment
```

真实项目应把当前核心实体补在这里，至少说明：

- 实体名称和主键。
- 一对一、一对多、多对多关系。
- 聚合根或主要业务入口。
- 状态枚举和状态流转规则。
- 哪些字段不能对前端暴露。

### 模型风格

本项目默认采用偏贫血模型：

- Entity 主要承载状态和少量不依赖基础设施的领域判断。
- Service 承载业务流程、事务、权限后的业务校验和外部依赖编排。
- 复杂领域规则如果反复出现，可以抽到独立 domain service 或 policy，避免散落在多个 Service。

## AI 新增功能规则

新增一个后端业务能力时，按这个顺序落文件：

1. 在对应模块新增或复用 Request DTO、Response VO。
2. 在 Controller 增加路由、参数校验、权限声明和 Service 调用。
3. 在 Service 实现业务规则、事务和 Entity 到 VO 的转换。
4. 在 Repository 增加必要查询或持久化方法。
5. 同步 API 文档、前端 API client、测试和用户手册。

例如“订单查询接口”应拆成：

```text
orders.controller.ts  # GET /api/orders/:id
orders.service.ts     # getOrderDetail
orders.repository.ts  # findById
dto/order.vo.ts       # 前端可见响应
```

禁止为了省事把 Controller、Service、Repository 和 VO 混在一个文件里。
