# 项目目录结构

```text
project-root/
  AGENTS.md                         # AI Coding 项目指令（核心入口）
  README.md                         # 给人看的项目说明
  Makefile                          # 质量检查统一入口（lint-arch/format/build/test）

  server/                           # 后端（Spring Boot）
  web/                              # 前端（React + TypeScript）
  user-guide/                       # 用户手册（Markdown，AI 基于代码生成）

  scripts/
    start-server.sh                 # 后端一键启动（构建+启动+健康检查）
    start-web.sh                    # 前端一键启动
    lint-deps.sh                    # 分层依赖检查脚本

  docs/
    architecture.md                 # 分层架构、依赖规则、领域模型
    development.md                  # 环境要求、构建运行、数据库
    design-docs/
      api-design.md                 # 响应格式、错误码、端点详情
      controller-conventions.md     # Controller 层编码规范
      gateway-integration.md        # 网关对接详细文档
      frontend-architecture.md      # 前端架构、组件库规范
      ref-higress.md                # 参考：Higress 网关内核
      ref-nacos.md                  # 参考：Nacos 注册配置中心
      ref-pro-components.md         # 参考：私域组件库
      ref-other-product-backend.md  # 参考：其他产品后端
      ref-other-product-frontend.md # 参考：其他产品前端
      ref-himarket.md               # 参考：HiMarket AI 开放平台

  reference-projects/               # 参考项目（git submodule，只读）
    higress/                        # 开源 Higress 网关内核源码
    nacos/                          # 开源 Nacos 源码
    pro-components/                 # 私域组件库源码
    other-product-backend/          # 其他产品后端
    other-product-frontend/         # 其他产品前端
    himarket/                       # 开源 HiMarket AI 开放平台
```
