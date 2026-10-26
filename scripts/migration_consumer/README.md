# 迁移消费验证

这是仓库级开发工具，不属于组件运行代码，也不会发布为组件能力。

在仓库根目录执行：

```bash
bash scripts/run-tooling-checks.sh migration
```

脚本将项目复制到临时目录，通过组件公开入口执行依赖解析、严格静态分析和测试。GitHub/CNB 使用同一入口，在最低支持版和当前稳定版 Flutter 下验证。

## 内容与验证边界

| 文件 | 用途 | 如何验证 |
| --- | --- | --- |
| `lib/guide_examples.dart` | 迁移指南代码片段的唯一来源 | 静态分析；`guide_examples_test.dart` 验证片段的交互组合 |
| `lib/public_api_examples.dart` | 公开构造参数、Theme 和类型替代示例 | 静态分析，不为列表长度或简单属性读取重复运行测试 |
| `test/public_api_usage_test.dart` | Theme 返回类型链、TabBar 与 Theme 组合、Popover/Popup 公开调用 | 少量必要的运行时验证 |

Text、Avatar、Tag 的通用样式解析和 SwipeCell 的参数互斥规则由现有组件测试负责（[Text](../../tdesign-component/test/components/text/t_text_style_scope_test.dart)、[Avatar](../../tdesign-component/test/components/avatar/t_avatar_test.dart)、[Tag](../../tdesign-component/test/components/tag/t_tag_test.dart)、[SwipeCell](../../tdesign-component/test/components/swipe_cell/t_swipe_cell_test.dart)）；这里不再维护第二套相同断言。只挂载并检查“未抛异常”的示例，已有静态分析及组件/Demo 测试覆盖时不另设用例。

维护文档片段后运行 `node scripts/sync-readme.mjs`，由同一份源码更新指南和包内副本。只有文档自身的行为组合或独立消费边界需要新的运行时测试，组件内部行为与 Golden 继续归组件测试。
