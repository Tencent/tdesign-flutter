# TDesign Flutter 文档站点开发

组件使用方法见[快速开始](site/docs/getting-started.md)，开发贡献规则见[仓库贡献指南](../CONTRIBUTING.md)。本文件只维护站点运行方式。

## 安装

先按[贡献指南](../CONTRIBUTING.md#本地开发)安装Flutter并解析组件及示例依赖，再在本目录执行：

```bash
pnpm install --frozen-lockfile
```

## 开发与构建

- `pnpm dev`：同时运行站点（19000）和右侧Flutter Web预览（19001）。
- `pnpm dev:site`：只运行站点。
- `pnpm site`：运行主题和文档契约测试，再构建生产站点。
- `pnpm test:example-code`：检查所有组件页面、生成资产及文档同步契约。

## 文档来源

用户指南直接维护在 `site/docs/`。贡献页直接读取根 `CONTRIBUTING.md`，不维护站点副本。根README只负责项目入口，站点快速开始不再由README覆盖生成。

组件页面位于 `docs/components/`，保留生成示例和API入口；修改API应改dartdoc，修改示例应改Example源码。生成和检查方式见[API工具说明](../tdesign-component/demo_tool/README.md)。

每个组件使用组指令展示全部已生成示例：

```markdown
{{ flutter-example-group table }}

{{ flutter-api table }}
```

`pnpm test:example-code` 验证全部57份组件文档及对应资产；组件页禁止手写代码块、API参数表和迁移正文。迁移摘要的后续接入见[设计方案](site/docs/migration-0.2.7-to-1.0.md)。

主题与国际化示例维护在 `tdesign-component/example/lib/documentation_examples.dart`，指南中的标记片段从该源码提取；修改代码后由现有Theme功能测试验证。迁移示例继续来自独立消费夹具。

包内README和迁移副本统一执行 `node ../scripts/sync-readme.mjs` 生成，或加 `--check` 只读检查。`script/copy-readme.js` 仅保留兼容入口。

更新日志保留现有发布工具入口，不在文档构建时生成或覆盖；版本发布步骤见[PUBLISH.md](../PUBLISH.md)。
