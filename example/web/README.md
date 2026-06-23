# web

这个目录示例代表 Vue 3 前端。

AI Agent 在这里工作时应遵守：

- 使用 Vue 3 Composition API 和 `<script setup lang="ts">`。
- 页面组件负责组合，复杂逻辑抽到 composable。
- API 请求必须经过 `src/api/*`，不要在组件中散落拼接 URL。
- Pinia 只保存跨页面状态；页面局部状态留在组件或 composable。
- props/emits 必须 typed，父子通信优先 props down / events up。

建议真实项目目录：

```text
web/
  src/
    api/
    assets/
    components/
    composables/
    router/
    stores/
    views/
```

详细前端约定见 `../docs/architecture-web.md`。
