# 方案

在保留已确认 Demo 结构与视觉的基础上，重构 Collapse 的公开状态契约和 Header
扩展点：

1. `TCollapse` 以必传 `List<T> value` 和 nullable `onChanged` 统一 multiple /
   accordion；内部只读取列表，不修改调用方对象，回调返回新的不可修改列表。
2. `TCollapsePanel.value` 必传且在组内唯一；移除 `isExpanded`、
   `onExpansionChanged` 和 `expandIconTextBuilder`。
3. Header 使用 `leadingBuilder`、`headerBuilder`、`trailingBuilder` 与
   `expandIconBuilder` 分区。默认展开图标通过构造参数的非空默认 builder 提供，
   从而让省略参数、显式 null 和自定义 builder 分别表示默认、隐藏和替换。
4. `onChanged == null` 作为组级禁用入口，与 Panel `disabled` 合并为内部唯一的
   effective disabled；不公开 `TCollapse.disabled`。
5. 迁移公开 Demo、站点源码文档、API/代码生成产物和组件/Demo 测试。先跑功能、
   analyze、覆盖率及生成器检查；默认视觉应保持不变，最后以无更新参数 Golden
   严格比对，不用更新快照掩盖布局偏差。

## Breaking migration

- multiple：Panel `isExpanded` + `onExpansionChanged` → 组级 `value` +
  `onChanged`。
- accordion：单值 `T? value` / `ValueChanged<T?>` → 列表 `List<T>` /
  `ValueChanged<List<T>>`。
- `expandIconTextBuilder` → 返回 Widget 的 `trailingBuilder`。
- 每个 Panel 必须提供唯一 `value`；无回调的组件按禁用视觉与语义渲染。
