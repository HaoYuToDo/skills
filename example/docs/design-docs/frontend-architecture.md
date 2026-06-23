# 前端架构

这个文档给 AI Agent 解决的问题：修改 `web/` 中 Vue 3 页面、组件、store 和 API client 时，保持数据流和组件边界清晰。

应该维护在这里的内容：Vue 组件模式、路由、状态管理、API client、组件库和表单约定。

不应该维护在这里的内容：每个组件的完整源码、后端 DTO 字段全集、UI 视觉稿细节。

## 技术栈

- Vue 3 + Composition API。
- TypeScript。
- Vite。
- Vue Router。
- Pinia。

## 推荐目录

```text
web/src/
  api/          # 后端请求封装、错误归一化、schema 校验
  assets/       # 样式、图片、静态资源
  components/   # 通用组件和业务组件
  composables/  # 可复用组合式逻辑
  router/       # 路由定义和导航守卫
  stores/       # Pinia stores
  views/        # 路由级页面
```

## 组件规则

- 使用 `<script setup lang="ts">`。
- props 和 emits 必须 typed。
- 父子通信优先 props down / events up。
- 路由级 view 负责组装，不承载大量业务逻辑。
- 复杂状态和副作用抽到 composable。
- 不在 template 中写复杂过滤、排序、聚合逻辑；用 `computed`。

## API client

前端请求必须经过 `web/src/api/*`：

- 统一 base URL、headers、认证信息、超时、错误归一化。
- 统一处理 401、403、422、500 等状态。
- 组件和 store 不直接调用 `fetch('/api/...')` 或散落拼 URL。

典型链路：

```text
views/UserListView.vue
  -> composables/useUsers.ts
  -> api/users.ts
  -> server REST API
```

## Pinia 使用边界

适合放 Pinia：

- 登录用户、权限、主题、跨页面缓存、长生命周期业务状态。

不适合放 Pinia：

- 单个弹窗开关。
- 单个表单草稿。
- 页面局部 loading。
- 可以从 props 或 API response 直接派生的值。

