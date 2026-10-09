# 组件文档正文只使用生成来源

用户要求全部组件页不保留手写示例。逐项复查 57 个组件页，将正文统一收敛为代码演示标题、一个 flutter-example-group 指令和一个 flutter-api 指令，保留标题、描述与分类元数据。

删除重复导入块、手写用法/Theme/API 说明、迁移章节、旧源码链接与静态覆盖率徽章。Example 源码和 dartdoc 是示例及 API 的唯一来源；本次不修改组件或 Example 的运行实现。

逐组件证据见 component-pages-audit.json：57 页分别展开对应 Example 分组和 API，360 个示例映射完整，手写代码块为零。

新增页面正文契约检查，并用原 Text 过期参数代码块、手写 API 表、迁移文案和 Dart 面板进行回归测试：即使生成映射正确，这些内容仍必须被拒绝。

验收：
- generate_example_code.dart --check 成功，生成资产与实际源码一致。
- 文档转换及正文契约 15 项测试通过；check-docs 校验 57 页、360 示例。
- 故障注入：在 Text 页追加旧 textColor 手写代码，真实 check-docs CLI 返回失败；恢复后通过。
- 生产站点构建通过；浏览器抽查 Text、Dialog、Rate 生成示例，Text API 标签中的生成配置表正常显示。
