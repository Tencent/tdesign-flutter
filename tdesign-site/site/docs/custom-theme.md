---
title: 自定义主题
description: 使用 TThemeData 和组件 ThemeExtension 自定义 Flutter 主题。
spline: explain
---

## 全局主题

`TThemeData` 保存全局设计 Token；`TThemeBuilder` 将其转换为 Flutter 的 `ThemeData`。

```dart
final tokens = TThemeData.defaultData();
MaterialApp(
  theme: TThemeBuilder.light(tokens),
  darkTheme: TThemeBuilder.dark(tokens),
  themeMode: ThemeMode.system,
  home: const MyHomePage(),
);
```

通过 `context.tTheme` 读取当前子树的 Token。JSON 配置方式见 [快速开始](https://tdesign.tencent.com/flutter/getting-started#自定义主题)。

## 组件局部样式

通过组件的 `T*ThemeData` 覆盖局部样式。`mergeExtension` 保留其他主题扩展，仅替换指定类型的扩展。

```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TTagThemeData(squareBorderRadius: 6),
  ),
  child: const TTag('局部圆角'),
);
```

全局 Token 与组件 ThemeExtension 分别负责全局配色和组件样式；组件可用配置见各组件文档末尾的 Theme 表。
