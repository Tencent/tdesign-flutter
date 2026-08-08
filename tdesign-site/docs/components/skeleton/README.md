---
title: Skeleton 骨架屏
description: 当网络较慢时，在页面真实数据加载之前，给用户展示出页面的大致结构。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[t_skeleton_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_skeleton_page.dart)

示例页中的 `@ExampleCode(group: 'skeleton')` 是本页代码片段的唯一来源，覆盖预设形态、自定义布局和两种动画效果。

## API

### TSkeleton

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| variant | TSkeletonVariant | TSkeletonVariant.text | 预设骨架形态：avatar、image、text、paragraph |
| animation | TSkeletonAnimation? | null | 动画效果；null 为静态 |
| delay | Duration | Duration.zero | 延迟展示时间 |

### TSkeleton.custom

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| layout | TSkeletonLayout | 自定义骨架的行列布局 |
| animation | TSkeletonAnimation? | 动画效果；null 为静态 |
| delay | Duration | 延迟展示时间 |

### TSkeletonLayout

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- |
| rows | List<List<TSkeletonBlock>> | - | 每个内层列表表示一行骨架块 |
| rowSpacing | double? | null | 行间距；未设置时读取主题和 Token |

### TSkeletonBlock

`line`、`circle`、`rectangle` 与 `spacer` 分别创建文本行、圆形、直角矩形和透明间隔块。通用参数为 `width`、`height`、`flex`、`margin`、`style`；`flex` 为 null 时使用固定宽度。

### TSkeletonBlockStyle

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| color | Color? | null | 块颜色；优先于组件主题 |
| borderRadius | double? | null | 圆角；优先于 shape 和组件主题 |
| shape | TSkeletonBlockShape | rounded | rounded、circle 或 rectangle |

### TSkeletonThemeData

`blockColor`、`highlightColor`、`borderRadius`、`rowSpacing` 用于设置子树默认视觉与布局。优先级为：Block 显式值 > `TSkeletonThemeData` > TDesign token。
