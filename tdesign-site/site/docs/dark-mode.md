---
title: 深色模式
description: 使用 TThemeBuilder 和 Flutter ThemeMode 配置浅色、深色及跟随系统的主题。
spline: explain
---

## 切换浅色、深色与跟随系统

通过 `TThemeBuilder.light` 和 `TThemeBuilder.dark` 将 `TThemeData` 转换为 Flutter 主题，并在 `MaterialApp` 上设置 `themeMode`。

```dart
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() => runApp(const ThemeExample());

class ThemeExample extends StatefulWidget {
  const ThemeExample({super.key});

  @override
  State<ThemeExample> createState() => _ThemeExampleState();
}

class _ThemeExampleState extends State<ThemeExample> {
  final TThemeData _tokens = TThemeData.defaultData();
  ThemeMode _mode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: TThemeBuilder.light(_tokens),
      darkTheme: TThemeBuilder.dark(_tokens),
      themeMode: _mode,
      home: Scaffold(
        appBar: AppBar(title: const Text('主题设置')),
        body: Column(
          children: [
            for (final mode in ThemeMode.values)
              TextButton(
                onPressed: () => setState(() => _mode = mode),
                child: Text(switch (mode) {
                  ThemeMode.system => '跟随系统',
                  ThemeMode.light => '浅色模式',
                  ThemeMode.dark => '深色模式',
                }),
              ),
          ],
        ),
      ),
    );
  }
}
```

`ThemeMode.system` 跟随系统外观；`ThemeMode.light` 和 `ThemeMode.dark` 固定使用对应模式。

## 保存用户选择

将 `ThemeMode` 作为业务状态保存，并在启动时恢复；保存和读取可以采用业务已有的持久化方案。异步读取完成时，要避免覆盖用户在等待期间作出的新选择。

可参考示例应用的 [ThemeModeProvider](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/provider/theme_mode_provider.dart)。本页示例用 `setState` 演示切换，业务可以使用自己的状态管理方式。

## 使用自定义明暗配色

将已经加载好的自定义 Token 替换示例中的 `_tokens`，再分别传给 `TThemeBuilder.light` 和 `TThemeBuilder.dark`。JSON 结构、资产加载和暗色配置名称统一见[自定义主题](/flutter/custom-theme)。

自定义配色需要准备对应暗色 Token，详见[自定义暗色配色](/flutter/custom-theme#配置自定义暗色配色)。

完整示例见[深色模式示例源码](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/component_test/dark_test.dart)。
