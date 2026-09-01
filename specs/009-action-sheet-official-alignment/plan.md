# 实施方案

## 技术方案

不增加公开 API。保留现有 13 个 Example 入口，并统一宫格布局契约：`count`
表示可视面板期望容量，`rows` 表示行数，列数由 `count ~/ rows` 推导。
默认、分页和滚动模式共享该密度；滚动模式按 `count` 分段后在段内按行优先排列。
未显式设置 `itemMinWidth` 时按可用宽度和列数计算项目宽度，显式实例参数或
Theme 值作为最小宽度覆盖。
常规宫格和多行滚动宫格继续共用 `TActionSheetItemWidget`，Example 的可比较
入口改为复用同一组 8 项应用数据，不新增、删除或隐藏 Demo。
默认、分页和横向滚动宫格统一通过私有索引换算方法计算回调索引，避免不同
布局路径各自维护面板偏移公式。
同步扩充 ActionSheet Golden 专用 CJK 字符子集，并只在 Flutter 3.32.0 Linux
重新生成受新增字形影响的页面、常规宫格和滚动宫格明暗基线。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `t_action_sheet.dart`, `t_action_sheet_grid.dart` | 可见尺寸、容量与滚动顺序对齐 |
| 测试 | `test/components/action_sheet/` | 保护样式契约 |
| 示例 | `example/lib/page/t_action_sheet_page.dart` | 官方 Demo 矩阵 |
| 文档 | `example/assets/code/action_sheet.*.txt` | 代码查看器片段 |

## API 与兼容性变化

- 公开参数签名不变。
- 未显式设置 `itemMinWidth` 的多行滚动宫格默认宽度由固定 80dp 改为按
  `count / rows` 自适应，属于用户可感知的默认行为变化，按 breaking change 处理。
- 非法 `count` / `rows` 组合新增断言约束。

## 风险与取舍

- 84 高度会增加带描述列表的垂直空间，这是为了匹配官方视觉规范。
- Flutter Demo 使用本地 TDesign 图标表达小程序的远程社交平台图片，避免把网络可用性变成组件验收前提。
- 显式 `itemMinWidth` 大于自适应宽度时优先保证最小宽度，因此实际同时可见数量
  可以少于 `count`；这是调用方明确选择的滚动密度覆盖。

## 验证策略

- 单元测试：ActionSheet 全部 Widget 测试。
- 集成或 Widget 测试：验证描述项高度、颜色 token、分页点、`8 / 2` 与
  `10 / 2` 跨模式密度、滚动项目顺序及非法参数组合。
- 静态检查：Flutter 3.32.0 与 latest 严格 analyze。
- 人工验收：实机打开 13 个入口，重点检查多行滚动宫格的可视容量、顺序与滑动。
