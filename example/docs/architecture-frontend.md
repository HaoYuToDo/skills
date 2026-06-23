# 前端架构

这个文档给 AI Agent 解决的问题：修改 `web/` 中 Vue 3 页面、组件、composable、API client 和 Pinia store 时，知道代码应该写在哪一层、状态应该放在哪里、模块之间如何依赖。

应该维护在这里的内容：前端分层架构、目录职责、依赖规则、API 契约、状态管理边界、前端领域视图模型。

不应该维护在这里的内容：每个组件完整源码、视觉稿细节、后端 DTO 字段全集、一次性调试记录。这些内容应放在源码、组件文档、API 文档或测试中。

## 技术栈

- Vue 3 + Composition API。
- TypeScript。
- Vite。
- Vue Router。
- Pinia。

## 目标结构

真实项目目录以 `web/` 源码为准，新增代码优先沿用现有模块结构。

推荐结构：

```text
web/src/
  api/                 # 后端请求封装、错误归一化、schema 校验
  assets/              # 样式、图片、静态资源
  components/          # 通用组件和业务组件
  composables/         # 可复用组合式逻辑和副作用编排
  router/              # 路由定义和导航守卫
  stores/              # Pinia stores
  views/               # 路由级页面
  types/               # 前端类型、API 类型或生成类型
```

## 分层职责

### View 层

`views/` 是路由级页面，负责页面组合：

- 读取 route params/query。
- 组合页面布局、业务组件和状态入口。
- 处理页面级 loading、error、empty 和权限展示。
- 调用 composable 或 store action，不直接写复杂业务流程。

View 禁止：

- 直接调用 `fetch`、`axios` 或拼接后端 URL。
- 直接复制后端 DTO 并在页面里改字段语义。
- 承载可复用业务逻辑、复杂过滤排序或跨页面状态。

### Component 层

`components/` 负责可复用 UI 和局部交互：

- 使用 `<script setup lang="ts">`。
- props、emits、slots 必须 typed。
- 父子通信优先 props down / events up。
- 展示派生值使用 `computed`，不要在 template 写复杂表达式。

Component 禁止：

- 为了展示方便直接请求后端。
- 引入不相关业务模块的组件形成横向耦合。
- 在通用组件里读取业务 store 或路由上下文。
- 把弹窗、表单、表格等组件写成依赖单一页面的隐式状态。

### Composable/Hooks 层

`composables/` 封装可复用状态和副作用：

- 组合 API client、局部状态、分页、筛选、轮询、表单提交等逻辑。
- 对外暴露稳定的响应式状态和方法，例如 `data`、`loading`、`error`、`refresh`。
- 管理组件生命周期相关副作用，例如请求取消、定时器清理。

Composable 禁止：

- 直接操作 DOM 来绕过 Vue 状态。
- 保存应该全局共享的登录用户、权限、主题等长生命周期状态。
- 隐式依赖某个页面组件的内部变量。

### Service/API 层

`api/` 是前端唯一的 HTTP 出口：

- 统一 base URL、headers、认证信息、超时和错误归一化。
- 统一处理 401、403、422、500 等状态。
- 将后端响应转换为前端可消费的数据结构。
- 维护 API 类型、schema 校验或生成类型的引用。

硬规则：

- 组件、view、store、composable 不直接调用 `fetch('/api/...')` 或散落拼 URL。
- API client 不读取组件状态，不弹 UI，不依赖 Pinia store 的具体业务模块。
- 后端响应结构变化时，先更新 API client，再向上调整 composable/store/view。

### Store 层

`stores/` 使用 Pinia 管理跨页面、长生命周期状态：

适合放入 Pinia：

- 登录用户、权限、租户、主题、语言。
- 多页面共享缓存。
- 会影响多个路由的业务状态。
- WebSocket 或长连接推送后的全局状态。

不适合放入 Pinia：

- 单个弹窗开关。
- 单个表单草稿。
- 页面局部 loading/error。
- 可以从 props、route 或 API response 直接派生的值。

## 依赖规则

允许的依赖方向：

```text
views
  -> components
  -> composables
  -> stores
  -> api
  -> types
```

实际写代码时按更具体的规则执行：

- `views/` 可以依赖业务组件、composable、store、router 和 API 类型。
- `components/` 可以依赖通用组件、局部 composable 和纯类型；通用组件不依赖业务 store。
- `composables/` 可以依赖 API client、Pinia store、Vue/VueUse 工具和纯类型。
- `stores/` 可以依赖 API client 和纯类型；不要依赖 view 或业务组件。
- `api/` 可以依赖请求基础设施、schema 和纯类型；不要依赖 Vue component、router view 或业务 store。
- `types/` 必须保持纯类型，不依赖浏览器副作用、Vue 组件、Pinia 实例或后端运行时代码。
- `web/` 禁止导入 `server/` 内部文件；共享契约应通过生成类型、schema 或独立共享包提供。
- 禁止前端组件跨模块循环依赖；发现循环时优先抽出纯组件、composable 或类型。

## 前端领域模型

前端领域模型是“面向展示和交互的模型”，不等同于后端 Entity。

### API DTO

API DTO 来自后端契约或生成类型：

```ts
interface OrderVO {
  id: string
  status: 'PENDING' | 'PAID' | 'CANCELLED'
  totalAmount: number
  createdAt: string
}
```

规则：

- DTO 字段语义以后端为准，前端不能擅自改写含义。
- 组件不要手写重复 DTO；优先从 `api/`、`types/` 或生成产物导入。
- DTO 只表达接口契约，不塞入组件临时状态。

### View Model

View Model 是为了展示派生出来的数据：

```ts
interface OrderListItemVM {
  id: string
  statusText: string
  totalAmountText: string
  createdAtText: string
}
```

规则：

- 金额、日期、状态文案等展示字段可以在 API adapter、composable 或 computed 中生成。
- View Model 不反向提交给后端，提交时必须转换回明确的 Request DTO。
- 派生规则如果多个页面复用，应抽到 composable 或 formatter，不散落在 template。

## 数据流

典型查询链路：

```text
views/OrderDetailView.vue
  -> composables/useOrderDetail.ts
  -> api/orders.ts
  -> server REST API
  -> OrderVO
  -> computed OrderDetailVM
  -> component render
```

典型提交链路：

```text
form component
  -> local form state
  -> validate
  -> composable submit method
  -> api request DTO
  -> refresh store or query state
```

## AI 新增功能规则

新增一个前端页面或业务能力时，按这个顺序落文件：

1. 在 `api/` 增加或复用请求方法和类型。
2. 在 `composables/` 封装请求状态、分页、筛选、提交和错误处理。
3. 在 `stores/` 放入确实跨页面共享的状态。
4. 在 `views/` 组装页面。
5. 在 `components/` 拆出可复用 UI。
6. 同步 loading、error、empty、权限不足和无数据状态。

例如“订单查询页面”应拆成：

```text
api/orders.ts                    # getOrderDetail
composables/useOrderDetail.ts    # loading/error/data/refresh
views/OrderDetailView.vue        # 路由级页面
components/orders/OrderSummary.vue
```

禁止把请求、状态、格式化、表单校验和大段模板全部塞进一个 `.vue` 文件。
