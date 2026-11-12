# Cell 验证范围与结论

## 2026-10-23 高度约束与兼容性修复

代码候选：`33eba3b67803f52d2e5f2f35a4ee02b2e5d386ef`；基于 develop `071efaba0111d868efe0b6a7ce55f6f784069a62`。本次新增的 Spec 文档不在该代码候选中；文档整理没有重新运行测试，也不改变原验证范围。源码、测试和日志指纹见 [证据摘要](./evidence/scrollable-validation.json)。

环境：macOS arm64；Flutter 3.32.0 / 3.47.7。两版本依次独立解析依赖并运行，未宣称并行或使用独立目录。

| 检查 | 3.32.0 | 3.47.7 |
| --- | --- | --- |
| Cell 组件测试 | 39 项通过 | 39 项通过 |
| 严格 analyze | 零诊断 | 零诊断 |
| Cell 生产覆盖率 | 229/232，98.71% | 229/232，98.71% |

执行入口（在 tdesign-component 内，分别使用对应 SDK）：

```text
flutter pub get --offline
flutter test --no-pub --coverage test/components/cell/t_cell_test.dart --reporter expanded
flutter analyze --no-pub --fatal-infos
dart run tool/check_component_coverage.dart cell
```

## 修复前后对照

修复前实现为合并 develop 后的 `e526fd82bcca2551f2a83c00e7484479da279ffd`，另加入同一组新增回归场景。在 Flutter 3.47.7 上运行：37 项通过、2 项失败；失败项是空组与自定义 builder 的 IntrinsicHeight 布局。修复后两项均通过，有界内部拖动及无界外层拖动场景在前后均通过。该结果不代表普通 TCell 子树普遍支持固有尺寸。

## 证据边界

原始日志位于本地工作区外层 `review-artifacts/pr1162-fix/`，不随仓库提交；本目录保存可随代码追溯的结果和指纹摘要。未执行公开 Demo 测试、设备人工走查或 Golden；未检查最终远端 CI。上述结果仅证明指定候选的自动化布局/交互、静态分析及生产行覆盖率，不代表全部视觉或发布门禁通过。后续事项集中在 tasks.md。
