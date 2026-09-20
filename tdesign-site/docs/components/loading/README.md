---
title: Loading 加载
description: 用于表示页面或操作的加载状态，给予用户反馈的同时减缓等待的焦虑感，由一个或一组反馈动效组成。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

通过统一入口引入 TDesign Flutter 组件：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

{{ flutter-example-group loading }}

## API
### TLoading
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| customIcon | Widget? | - | 自定义加载图标，优先于 icon，并按当前 Loading 动画时长持续旋转。 |
| icon | TLoadingIcon? | TLoadingIcon.circle | 预设图标，支持圆形、点状、菊花状；为 null 时不显示预设图标。customIcon 不为 null 时仍优先显示自定义图标。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| refreshWidget | Widget? | - | 文案后的自定义操作内容 |
| size | double | 20 | 加载指示器的外部尺寸，单位为逻辑像素，默认为 20。 |
| text | String? | - | 文案 |

### TLoadingThemeData

Loading 的视觉配置通过 `TLoadingThemeData` 注入到子树（`Theme.of(context).mergeExtension(...)`），字段均为可选，未指定时使用默认值。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| axis | Axis | Axis.horizontal | 文案和图标相对方向。默认 horizontal（图标在左、文字在右），对齐官方 `layout`；可显式指定 `Axis.vertical` 实现竖向布局。 |
| duration | int | 800 | 一次刷新的时间（毫秒），控制动画速度。默认 `800`ms，对齐官方 `duration`。 |
| iconColor | Color? | - | 图标颜色 |
| textColor | Color? | - | 文案颜色 |

### TLoadingIcon
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形 |
| point | 点状 |
| activity | 菊花状 |
