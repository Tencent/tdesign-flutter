---
title: NavBar 导航栏
description: 用于不同页面之间切换或者跳转，位于内容区的上方，系统状态栏的下方。
spline: base
isComponent: true
---

## 引入

通过统一入口引入 TDesign Flutter 组件：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

{{ flutter-example-group navbar }}

## API

### TNavBar

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | Widget? | - | 标题内容 |
| leading | List\<TNavBarItem\>? | - | 左侧操作项 |
| actions | List\<TNavBarItem\>? | - | 右侧操作项 |
| centerTitle | bool | true | 标题是否居中 |
| useDefaultBack | bool | false | 是否显示默认返回按钮 |
| onBack | VoidCallback? | - | 默认返回按钮回调，仅在 `useDefaultBack` 为 true 时生效 |
| belowTitleWidget | Widget? | - | 标题区域下方内容，占用 `height` 内部空间 |
| flexibleSpace | Widget? | - | 位于导航栏内容下层的背景 Widget |
| titleColor | Color? | - | 标题默认颜色；标题自身显式颜色优先 |
| backIconColor | Color? | - | 默认返回图标颜色 |
| backgroundColor | Color? | - | 背景颜色 |
| height | double | 48 | 内容高度及 `preferredSize.height` |
| padding | EdgeInsetsGeometry? | - | 内部填充 |
| titleMargin | double? | - | 标题与两侧内容的间距 |
| opacity | double? | - | 背景颜色透明度，未配置时为 1 |
| useBorderStyle | bool | false | 是否启用操作项边框结构 |
| border | TNavBarBorder? | - | 操作项边框配置，仅在边框模式下生效 |
| boxShadow | List\<BoxShadow\>? | - | 底部阴影 |
| useSafeArea | bool | false | 是否在实际渲染高度中加入顶部安全区 |

### TNavBarItem

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| icon | IconData? | - | 图标 |
| iconColor | Color? | - | 图标颜色 |
| onTap | VoidCallback? | - | 点击回调；null 表示禁用 |
| iconSize | double? | 24 | 图标尺寸；null 时由 `IconTheme` 决定 |
| padding | EdgeInsetsGeometry? | - | 操作项内部填充 |
| customWidget | Widget? | - | 自定义内容，优先级高于 `icon` |

### TNavBarBorder

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double | 1 | 边框及分隔线宽度 |
| radius | double | 22 | 边框圆角 |
| color | Color? | - | 边框颜色；未配置时使用 TDesign Token |
| padding | EdgeInsetsGeometry? | - | 边框内部填充 |

### TNavBarThemeData

可配置 `titleColor`、`backIconColor`、`backgroundColor`、`padding`、
`titleMargin`、`opacity`、`border` 和 `boxShadow`。构造器同名参数优先于
Theme；Theme 不保存高度、边框模式或业务状态。
