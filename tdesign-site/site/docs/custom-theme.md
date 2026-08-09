---
title: 自定义主题
description: 如何使用 TThemeData 自定义 Flutter 主题
spline: explain
---

TDesign Flutter 使用 `TThemeData` 和 Flutter `ThemeData` 描述主题。应用应通过 `TTheme` 注入主题数据，不使用 CSS Variables 或小程序 `page` 样式。

## 全局自定义

将全局主题放在应用根部，组件会按“实例参数 > 组件 ThemeData > Flutter 子树主题 > TDesign token”的优先级解析颜色、字号和状态样式。

```dart
TTheme(
  data: TThemeData.defaultData(),
  child: MaterialApp(home: const MyHomePage()),
)
```

可用的 token 和默认值见 [t_default_theme.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/lib/src/theme/t_default_theme.dart)。

## 局部自定义

可以通过局部 `TTheme` 或 Flutter 的 `Theme` 在子树中覆盖主题；需要覆盖单个组件时，优先使用对应的 `T*ThemeData`，而不是修改全局主题。

```dart
TTheme(
  data: TTheme.of(context).copyWith(
    // 在此提供局部主题覆盖。
  ),
  child: const RatingSection(),
)
```

## Flutter 原生主题

未被组件 ThemeData 显式覆盖的文字、图标和 Material 控件会继承 Flutter 子树主题。需要保持 TDesign 默认视觉时，使用 `TTheme.of(context)` 获取局部主题；不要通过外层 `DefaultTextStyle` 或颜色包裹器修改组件内部状态层级。
