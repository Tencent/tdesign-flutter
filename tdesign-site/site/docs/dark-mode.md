---
title: 深色模式
description: 使用 TD 组件演示浅色、深色及跟随系统的主题切换。
spline: explain
flutterPreview: dark-mode
toc: false
---

## 切换浅色、深色与跟随系统

在预览中切换模式，观察页面、按钮与文字的变化。源码可在已安装依赖的应用中用 `runApp(const ThemeDarkModeExample())` 运行。

通过 `TThemeBuilder.light` 和 `TThemeBuilder.dark` 将 `TThemeData` 转换为 Flutter 主题，并在 `MaterialApp` 上设置 `themeMode`。

`ThemeMode.system` 跟随系统外观；`ThemeMode.light` 和 `ThemeMode.dark` 固定使用对应模式。

## 交互演示源码

{{ flutter-example theme.ThemeDarkModeExample }}

## 保存用户选择

将 `ThemeMode` 作为业务状态保存，并在启动时恢复；保存和读取可以采用业务已有的持久化方案。异步读取完成时，要避免覆盖用户在等待期间作出的新选择。

可参考示例应用的 [ThemeModeProvider](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/provider/theme_mode_provider.dart)。本页示例用 `setState` 演示切换，业务可以使用自己的状态管理方式。

## 使用自定义明暗配色

将已经加载好的自定义 Token 替换示例中的 `_tokens`，再分别传给 `TThemeBuilder.light` 和 `TThemeBuilder.dark`。自定义配色需要准备对应暗色 Token；JSON 结构、资产加载和暗色配置名称见[自定义主题](/flutter/custom-theme#配置自定义暗色配色)。

完整示例见[深色模式示例源码](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/page/theme/dark_mode_example.dart)。
