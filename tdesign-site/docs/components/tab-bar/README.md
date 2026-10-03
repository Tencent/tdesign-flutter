---
title: TabBar 标签栏
description: 用于在不同功能模块之间进行快速切换，位于页面底部。
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

{{ flutter-example-group tabBar }}

## API
### TTabBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationCurve | Curve? | - | 动画曲线 |
| animationDuration | Duration? | - | 动画时长 |
| iconTextLayout | TTabBarIconTextLayout | TTabBarIconTextLayout.stacked | 图文项排列方式：上下排列间距 0px，左右排列间距 4px。仅在 `type: TTabBarType.iconText` 时生效。 |
| indicatorAnimation | TTabBarIndicatorAnimation | TTabBarIndicatorAnimation.none | 指示器动画类型 |
| itemStyle | TTabBarItemStyle | TTabBarItemStyle.label | 单个标签项的选中样式。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| navigationTabs | List<TTabBarItemConfig> | - | tabs配置 |
| needInkWell | bool | false | 是否需要水波纹效果 |
| onChanged | ValueChanged<int>? | - | 选中项变化；null 时整栏禁用 |
| split | bool | false | 是否使用竖线分隔；`itemStyle` 为 `TTabBarItemStyle.label` 时不显示。 |
| style | TTabBarStyle | TTabBarStyle.filled | 标签栏容器样式。 |
| type | TTabBarType | - | 标签栏内容类型。 |
| useSafeArea | bool | true | 是否使用标签栏背景色填充底部安全区域；普通标签栏始终绘制默认顶边线，胶囊样式不绘制。 |
| value | int | - | 选中的 index |


### TTabBarItemConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| allowMultipleTaps | bool | false | 是否允许重复点击当前选中项时再次调用 `onTap`，默认为 false。 该字段不影响点击未选中项，也不会让 `TTabBar.onChanged` 重复通知当前值。 |
| badge | TBadgeConfig? | - | 展示在标签内容右上角的徽标；为空时不显示。纯文本项使用文本徽标默认位置；纯图标项和上下排列图文项以图标为锚点，左右排列图文项以整组图文为锚点。`TBadgeConfig.offset` 可覆盖默认位置。 |
| onLongPress | GestureLongPressCallback? | - | 长按事件 |
| onTap | GestureTapCallback? | - | 标签项被选中时的附加点击回调。 点击未选中项时，在 `TTabBar.onChanged` 之前调用；重复点击当前选中项时， 仅当 `allowMultipleTaps` 为 true 才调用。整栏禁用时不会调用。 |
| popUpButtonConfig | TTabBarPopUpBtnConfig? | - | 弹窗配置 |
| selectedIcon | Widget? | - | 选中时图标；未显式指定尺寸时默认为 20px。 |
| selectTabTextStyle | TextStyle? | - | 选中时的文字样式，按字段覆盖继承主题与内置默认值。 |
| tabText | String? | - | tab 文本 |
| unselectedIcon | Widget? | - | 未选中时图标；尺寸规则与选中图标相同。 |
| unselectTabTextStyle | TextStyle? | - | 未选中时的文字样式，按字段覆盖继承主题与内置默认值。 |


### TTabBarPopUpBtnConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| items | List<TTabBarMenuItem> | - | 选项list |
| onChanged | ValueChanged<String> | - | 统一在 onChanged 中处理各item点击事件 |
| popUpDialogConfig | TTabBarPopUpShapeConfig? | - | 弹窗UI配置 |


### TTabBarPopUpShapeConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowHeight | double? | - | 箭头高度 默认8 |
| arrowWidth | double? | - | 箭头宽度 默认13.5 |
| backgroundColor | Color? | - | 弹窗背景颜色 |
| popUpItemHeight | double? | _kDefaultMenuItemHeight | 单个选项高度 所有选项等高 不设置则使用默认值 48 |
| popUpWidth | double? | - | 弹窗宽度。 不设置时使用 `max(107, 标签项宽度 - 20)`；显式设置时覆盖该默认值。 |
| radius | double? | - | 弹层面板圆角。 不设置时使用当前 TDesign 主题的 `radiusDefault`（默认 6px）； 显式设置时覆盖主题默认值。 |


### TTabBarMenuItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | AlignmentGeometry | AlignmentDirectional.center | 对齐方式 |
| itemWidget | Widget? | - | 选项widget |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| value | String | - | 选项值 |


### TTabBarThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 标签栏容器背景色；未设置时回退全局 `bgColorContainer`。 |
| barHeight | double? | - | 标签栏高度；未设置时为 56 逻辑像素。 |
| dividerColor | Color? | - | 竖向分割线颜色；未设置时回退全局 `grayColor3`。 |
| dividerHeight | double? | - | 竖向分割线高度；未设置时为 32 逻辑像素，仅在实例 `split` 生效时使用。 |
| dividerThickness | double? | - | 竖向分割线厚度；未设置时为 0.5 逻辑像素，仅在实例 `split` 生效时使用。 |
| selectedBgColor | Color? | - | Label 选中项背景色；未设置时回退全局 `brandColorLight`。 |
| unselectedBgColor | Color? | - | Label 未选中项背景色；未设置时不额外绘制背景。 |


### TTabBarType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| text | 纯文本标签栏。 |
| iconText | 图标加文本标签栏。 |
| icon | 纯图标标签栏。 |
| doubleLayer | 带弹出菜单的双层级文本标签栏。 |


### TTabBarItemStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 仅改变前景色。 |
| label | 使用浅色胶囊背景强调选中项。 |


### TTabBarIconTextLayout
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| stacked | 图标在上、文字在下；默认布局。 |
| inline | 图标在左、文字在右。 |


### TTabBarStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| filled | 铺满父容器。 |
| capsule | 带外边距、圆角和阴影的悬浮胶囊。 |


### TTabBarIndicatorAnimation
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| none | 无动画，瞬间切换 |
| linear | 线性滑动：指示器匀速从一个 tab 滑到另一个 |
| elastic | 弹性动画：指示器先拉伸后收缩 |
