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

## 文字默认值与组件文字槽

**普通位置用正文默认值，组件文字槽用组件默认值，自己明确设置的样式优先。**

| 使用位置 | 默认样式来源 | 如何定制 |
| --- | --- | --- |
| 普通位置的 `TText('说明')` | 最近的 `TTextThemeData`，未配置字段回退 TD 正文 Token | 子树文字主题或实例 `style` / `font` |
| `TButton` 的 `child` 文字 | 按钮尺寸、配色和当前状态的文案样式 | 按钮已有样式入口，或内容实例的显式文字样式 |
| `TNavBar` 的 `title` 文字 | 导航标题字体和标题色，默认单行省略 | `TNavBarThemeData`，或标题实例的显式文字样式 |

全局 `TTextThemeData` 仍可配置，但它表达通用默认，不强制所有场景使用相同字体。组件文字槽覆盖外层默认中的同名字段，其余字段继续保留；内容内部更近的 TD 文字主题可重新提供局部默认。文字实例的显式字段优先，`style` 同名字段又优先于 `font`。

未传 `style`、空 `TextStyle()`、只设置颜色，遵循同一规则：未设置字段继续采用所在位置默认。`TextStyle(inherit: false)` 是已有的整体替换行为。富文本的基础样式遵循相同规则，span 保留自己的显式样式。

全站字体族和各类字体规格通过 TD Token 配置；正文、按钮文案和导航标题分别使用各自的语义规格。调整正文默认字号，不等于强制修改所有按钮和标题。TText 的字体与颜色仍不自动读取外部 Material `TextTheme` 或 `DefaultTextStyle.style`；缩放、方向和已有段落环境行为不因此取消。

### Button / NavBar 旧用法迁移

Button、NavBar 的文字槽现在同时向原生 `Text` 和 `TText` 提供组件默认。这是默认行为变化：旧无样式或部分样式 TText 的字号、字重、颜色、自然宽度和省略位置可能改变，不会通过新增兼容配置切换。

希望使用组件默认时，直接传入 `TText('提交')` 或 `TText('首页')`。希望保留旧正文外观时，通过现有 `TText.style` / `font` 明确原来依赖的字段，或者在内容内部提供局部 `TTextThemeData`；不要再依赖组件外层通用文字主题强制统一外观。只显式指定红色时，红色会保留，其余字体字段仍采用组件默认；该红色也优先于按钮禁用前景色。

复合标题的主副文案都会接受标题默认；需要较小副标题时，在副标题上明确字号、行高或颜色。此规则仅描述已适配的文字槽，不代表所有自定义 Widget 区域都由组件接管。Button 图标、NavBar 操作项与整块自定义布局仍保持各自职责。

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
