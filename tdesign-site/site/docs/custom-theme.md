---
title: 自定义主题
description: 配置全局主题、组件样式和明暗模式。
spline: explain
flutterExample: custom-theme
---

## 主题的作用范围

全局颜色、字体和间距等 Token 通过 `TThemeData` 配置；`TThemeBuilder` 把 Token 转为 Flutter `ThemeData`。组件局部外观使用对应 `T*ThemeData`，单个组件可用的实例配置以组件 API 为准。

使用 `context.tTheme` 读取当前子树主题。`TThemeData.defaultData()` 返回默认配置，不能代替当前上下文的主题。TD 内置视觉不隐式继承 Material 组件主题；自定义内容仍可使用 Flutter 的主题机制。

本文代码由[可运行示例源码](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/documentation_examples.dart)同步生成；右侧 Flutter 示例按章节展示对应效果，并直接复用这些函数。预览使用本文的品牌色配置；初始外观跟随外层预览，点击示例中的模式按钮后整页同步切换。示例文件引入：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## JSON 配置

以下示例分别配置浅色和深色品牌色：

<!-- documentation-example:theme-json:start -->
```dart
TThemeData documentationThemeTokens() {
  const json = '''
{
  "ocean": {"color": {"brandColor": "#0052D9"}},
  "oceanDark": {"color": {"brandColor": "#699EF5"}}
}
''';
  return TThemeData.fromJson('ocean', json, darkName: 'oceanDark') ??
      TThemeData.defaultData();
}
```
<!-- documentation-example:theme-json:end -->

运行效果：浅色品牌色 #0052D9、深色品牌色 #699EF5 应用于按钮和标签。右侧同时列出两套配置的品牌色、页面背景、容器背景和主要文字色，并标注 JSON 覆盖或默认继承；下方切换明暗模式时整页同步更新，并标识当前生效的一列。

[单独打开运行示例](/flutter/example/#custom-theme-json)

JSON 中未覆盖的 Token 按所属模式继承默认浅色或深色配置，背景和文字也会随模式切换。JSON 使用命名主题对象；`ocean`、`oceanDark` 必须与调用中的名称一致。`fromJson` 返回可空结果，加载失败时可回退默认主题。完整字段见[主题 API](/flutter/components/theme?tab=api)，默认 Token 定义见[默认主题源码](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/lib/src/theme/t_default_theme.dart)。

配置来自资源文件时，先在应用 `pubspec.yaml` 的 `flutter.assets` 注册文件，再通过 `rootBundle.loadString` 读取；这需要导入 `package:flutter/services.dart`。读取完成后再构建或更新应用主题，不在 Widget 的每次 build 中重复加载。

## 组件局部样式

通过 `mergeExtension` 合并指定类型的主题扩展，保留子树中的其他扩展：

<!-- documentation-example:theme-local:start -->
```dart
Widget documentationLocalTheme(BuildContext context, Widget child) {
  return Theme(
    data: Theme.of(
      context,
    ).mergeExtension(const TTagThemeData(squareBorderRadius: 6)),
    child: child,
  );
}
```
<!-- documentation-example:theme-local:end -->

运行效果：对比默认标签与圆角为 6 的局部主题标签。

[单独打开运行示例](/flutter/example/#custom-theme-local)

传入组件必须处于这个 `Theme` 子树内；需要读取更新后主题时，在子树的 `Builder` 或独立 Widget 中取得 context。

## 明暗模式

浅色、深色和跟随系统由 `MaterialApp.themeMode` 决定：

<!-- documentation-example:theme-mode:start -->
```dart
Widget documentationThemeApp(ThemeMode mode, Widget home) {
  final tokens = documentationThemeTokens();
  return MaterialApp(
    theme: TThemeBuilder.light(tokens),
    darkTheme: TThemeBuilder.dark(tokens),
    themeMode: mode,
    home: home,
  );
}
```
<!-- documentation-example:theme-mode:end -->

运行效果：点击浅色、深色或跟随系统，观察品牌色、组件与背景变化。

[单独打开运行示例](/flutter/example/#custom-theme-mode)

`tokens` 同时包含浅色配置 `ocean` 与深色配置 `oceanDark`。`TThemeBuilder.light(tokens)` 使用浅色配置，`TThemeBuilder.dark(tokens)` 使用深色配置；两者传入同一个对象，并不表示使用同一套配色。

- `ThemeMode.light`：固定浅色。
- `ThemeMode.dark`：固定深色。
- `ThemeMode.system`：跟随系统外观。

业务保存用户的外观选择，在切换时重建 `MaterialApp` 并传入新的 `mode`；不需要重新注册资源代理。自定义深色配色必须提供相应的深色主题配置，不能只把浅色颜色整体变暗。

## 主题工具与色板预览

[Theme 主题](/flutter/components/theme)展示功能色、文字与图标颜色、中性色板，并提供主题 API 查询。页面中的色板会根据当前上下文重新读取主题。

官网主题工具的 CSS 转换使用仓库内[css2token](https://github.com/Tencent/tdesign-flutter/tree/develop/packages/css2token)和[Web 主题接收适配](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/util/web_theme_message.dart)。它们负责 CSS Token 转换与默认值合并，不是组件包中的公开 CSS 导入 API。业务接入优先使用上面的 JSON 配置；不要把旧颜色转换脚本当作能处理所有字体、间距和阴影的通用转换器。
