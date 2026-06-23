#!/usr/bin/env bash
set -euo pipefail

# 示例脚本：真实项目可以在这里接入 dependency-cruiser、eslint import rules、
# madge、ts-prune 或自研检查，保证 web/server/reference-projects 边界不被打破。

echo "Checking dependency boundaries example..."
echo "- web/ must not import server/ internals"
echo "- server/ must not import web/ components or browser-only code"
echo "- reference-projects/ is read-only and must not be imported by runtime code"

