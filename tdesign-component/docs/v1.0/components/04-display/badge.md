# TBadge

> **状态**：已实现 | **控制类**：A | **Sprint**：S2

**源码路径**：`lib/src/components/badge`

## 架构

`TBadge` 是 Material `Badge` 的薄包装。数量、形态、显隐和交互全部由构造器控制；组件不缓存业务状态。

- `count` 使用 `int`，不接受字符串或动态值。
- `maxCount` 只负责最终文案截断，不修改调用方数据。
- `onTap == null` 时不创建点击行为。
- `TBadgeThemeData` 仅补充 Material `BadgeThemeData` 未覆盖的边框颜色和宽度。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `count` | `int` | `0` | 当前数量，必须大于等于 0 |
| `maxCount` | `int` | `99` | 最大显示数量，必须大于 0 |
| `variant` | `TBadgeVariant` | `normal` | `normal`、`small` 或 `dot` |
| `border` | `bool` | `false` | 是否显示对比色描边 |
| `showZero` | `bool` | `true` | 数量为 0 时是否显示 |
| `child` | `Widget?` | `null` | 被标记内容；为空时独立展示 |
| `onTap` | `GestureTapCallback?` | `null` | 点击回调 |

## Theme

优先使用 Material `BadgeThemeData` 配置背景色、文字色、尺寸、位置和 padding。`TBadgeThemeData` 仅包含：

| 字段 | 类型 | 说明 |
|---|---|---|
| `borderColor` | `Color?` | 描边颜色 |
| `borderWidth` | `double?` | 描边宽度 |

## Export

公开导出 `TBadge`、`TBadgeVariant`、`TBadgeThemeData`。绘制和 resolved 类型均保持内部可见。

## 验收

- 三种 variant 均有行为测试。
- `showZero`、`maxCount`、`child`、`onTap` 和边框 Theme 均有测试。
- Badge 源码逐文件覆盖率为 100%。
