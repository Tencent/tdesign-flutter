# PR 交付拆分

发布准备 PR 只交付文档、Demo、组件修复、依赖调整及发布盘点。测试、Golden、测试辅助脚本和测试工作流分别交付：

1. `fix/test-snapshot-determinism`：既有日期 fixture、Search 定位和失败图片收集修复，基于 develop。
2. `fix/demo-test-module-visibility`：Debug 内部区块策略、公开回归隔离、48张既有 PNG，基于第一项。
3. `chore/release-1-0-preparation`：发布准备，基于第二项，最终差异不包含测试或快照。
4. `test/release-1-0-verification`：新增 Token、迁移、主题和文档验证，基于发布准备。

按以上顺序审查、合并。前置 PR 合并后更新后续目标分支为 develop，并核对最终差异。全部验证合并且最终 CI 通过前，不宣称1.0发布已验收。

Spec059/060 等历史取证保留真实执行记录，相关执行代码由新增验证 PR 提供；历史记录中的“本 PR 已添加测试”不再描述拆分后的发布准备范围。迁移文档生成使用 `tool/fixtures/token_migration/lib/migration_027_examples.dart`，不依赖测试目录。
