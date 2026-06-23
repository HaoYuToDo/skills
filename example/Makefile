# 示例 Makefile：真实项目应替换为当前仓库实际命令。

.PHONY: lint-arch lint-format format build test check

lint-arch:
	@echo "示例：运行 scripts/lint-deps.sh 检查 server/web 依赖边界"
	@scripts/lint-deps.sh

lint-format:
	@echo "示例：运行 pnpm lint 和格式化检查"
	@pnpm lint
	@pnpm format:check

format:
	@echo "示例：自动格式化"
	@pnpm format

build:
	@echo "示例：构建 Vue 3 前端和 NestJS 后端"
	@pnpm build

test:
	@echo "示例：运行单元测试和集成测试"
	@pnpm test

check: lint-arch lint-format test build
	@echo "示例：全量质量检查完成"

