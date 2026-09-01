# 实施方案

## 技术方案

保留现有 13 个 Example 入口，并统一宫格布局契约：`count`
表示可视面板期望容量，`rows` 表示行数，列数由 `count ~/ rows` 推导。
以 `TActionSheetGridLayout.fixed/paged/scroll` 三个互斥构造替换
`showPagination/scrollable/count/rows/itemMinWidth` 的扁平组合；默认、分页和滚动
模式共享容量语义，滚动模式按 `count` 分段后在段内按行优先排列。
未显式设置 `itemMinWidth` 时按可用宽度和列数计算项目宽度，显式实例参数或
滚动布局值作为最小宽度覆盖。
删除没有小程序公开设计与 Demo 证据的 `showGroup`、`TActionSheetGroup` 和
`TActionSheetItem.group`，不引入 Section 模型。`TActionSheetItem<T>` 新增必填
业务值 `value`，选择回调收敛为 `onSelected(item)`，不再回传布局相关索引。
`TActionSheetThemeData` 只保留视觉默认值，布局容量和模式完全由调用参数所有。
移除 `showGrid.align`：该参数无法改变宫格 Item 对齐，仅改变副标题会导致
调用方误判作用域；宫格 Item 与副标题统一居中。Theme 的
`itemHeight` 同步改名为 `gridItemHeight`，使名称与仅影响宫格的实际行为一致。
常规宫格和多行滚动宫格继续共用 `TActionSheetItemWidget`，Example 的可比较
入口改为复用同一组 8 项应用数据，不新增、删除或隐藏 Demo。
默认、分页和横向滚动宫格统一回传带稳定 `value` 的完整 Item，
布局路径不再对外维护或暴露面板偏移索引。
同步扩充 ActionSheet Golden 专用 CJK 字符子集，并只在 Flutter 3.32.0 Linux
重新生成受新增字形影响的页面、常规宫格和滚动宫格明暗基线。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `t_action_sheet.dart`, `t_action_sheet_grid.dart`, Item 与 Theme | 公开入口、布局与状态所有权收敛 |
| 测试 | `test/components/action_sheet/` | 保护样式契约 |
| 示例 | `example/lib/page/t_action_sheet_page.dart` | 官方 Demo 矩阵 |
| 文档 | `example/assets/code/action_sheet.*.txt` | 代码查看器片段 |

## API 与兼容性变化

- 删除 `showGroup`、`TActionSheetGroup`、`TActionSheetItem.group`、
  `showPagination`、`scrollable` 以及 Theme 中的布局行为字段。
- `TActionSheetItem` 改为带稳定业务值的泛型模型；`onChanged(item, index)` 改为
  `onSelected(item)`。
- `showGrid` 改为接收单一 `layout`，三种布局构造互斥。
- 删除不能控制宫格 Item 对齐的 `showGrid.align`；
  `TActionSheetThemeData.itemHeight` 改名为 `gridItemHeight`。
- 未显式设置 `itemMinWidth` 的多行滚动宫格默认宽度由固定 80dp 改为按
  `count / rows` 自适应，属于用户可感知的默认行为变化，按 breaking change 处理。
- 非法 `count` / `rows` 组合新增断言约束。

## 风险与取舍

- 84 高度会增加带描述列表的垂直空间，这是为了匹配官方视觉规范。
- Flutter Demo 使用本地 TDesign 图标表达小程序的远程社交平台图片，避免把网络可用性变成组件验收前提。
- 显式 `itemMinWidth` 大于自适应宽度时优先保证最小宽度，因此实际同时可见数量
  可以少于 `count`；这是调用方明确选择的滚动密度覆盖。
- 这是有意的 breaking API 重构，不提供旧签名兼容层，避免两个状态源长期并存。

## 验证策略

- 单元测试：ActionSheet 全部 Widget 测试。
- 集成或 Widget 测试：验证描述项高度、颜色 token、分页点、`8 / 2` 与
  `10 / 2` 跨模式密度、滚动项目顺序及非法参数组合。
- 静态检查：Flutter 3.32.0 与 latest 严格 analyze。
- 人工验收：实机打开 13 个入口，重点检查多行滚动宫格的可视容量、顺序与滑动。
