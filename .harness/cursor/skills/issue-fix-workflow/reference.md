# Issue 修复参考

## 贡献指南关注点

### 4. 开发规范

- 组件命名规范与 API 命名应遵循 TDesign 现有约定。
- 样式属性如色值、圆角、字体字号等应沉淀到主题中。
- 对系统原有组件应做能力扩展，而不是删减既有能力。
- 固定文案应抽离到 `TResourceDelegate`。
- 组件 API 和 demo 写法参考 `tdesign-component/demo_tool/README.md`。

### 5.2 代码 Review 自检

- 尽量使用 TD 已有组件而不是系统组件。
- 检查空值与边界条件。
- 是否补了验收用例，且需要的示例放在 `ExamplePage.test`。
- 是否提供了文档。

### 5.3 文档自检

- 检查 `tdesign-component/demo_tool/all_build.sh` 中是否已有对应组件 API 生成配置。
- 检查组件属性注释是否完整。
- 若组件有系统对应组件，检查是否遗漏系统组件已有能力。
- `all_build.sh` 中的名称与 `tdesign-component/example/lib/config.dart` 保持一致。

## issue #924 示例

已沉淀的示例材料：

- `requirements/issue-924-fab-on-long-press/TaskContract.md`
- `requirements/issue-924-fab-on-long-press/test-cases.md`
- `requirements/issue-924-fab-on-long-press/code-review-report.md`
- `requirements/issue-924-fab-on-long-press/acceptance-report.md`

可复用模式：

1. 先写任务契约与测试用例
2. 再实现代码和测试
3. 最后补 Review、验收与 PR 摘要
