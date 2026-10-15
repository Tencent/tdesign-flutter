# PR 交付拆分

发布准备 PR 只交付文档、Demo、组件修复、依赖调整及发布盘点。测试、Golden、测试辅助脚本和测试工作流分别交付：

1. PR1164 `fix/test-snapshot-determinism`：既有日期 fixture、Search 定位和失败图片收集修复，已合并 develop。
2. PR1165 `fix/demo-test-module-visibility`：Debug 内部区块策略、公开回归隔离、48张既有 PNG，已合并 develop。
3. PR1163 `chore/release-1-0-preparation`：发布准备，指向 develop，最终差异不包含测试或快照。
4. PR1166 `test/release-1-0-verification`：新增 Token、迁移、主题和文档验证，指向 develop，依赖 PR1163 的功能和文档源码。

剩余按1163、1166顺序合并。1163合并前，1166与develop的比较包含未合并的前置内容；先核对其相对1163的验证增量，前置合并后再核对最终差异和CI。全部验证合并且最终CI通过前，不宣称1.0发布已验收。

Spec059/060 等历史取证保留真实执行记录，相关执行代码由新增验证 PR 提供；历史记录中的“本 PR 已添加测试”不再描述拆分后的发布准备范围。迁移文档生成使用 `tool/fixtures/token_migration/lib/migration_027_to_100_examples.dart`，不依赖测试目录。
