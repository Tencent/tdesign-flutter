---
title: 深色模式
description: 使用 TThemeBuilder 和 Flutter ThemeMode 配置浅色、深色及跟随系统的主题。
spline: explain
---

## 配置主题

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

`ThemeMode.system` 跟随系统外观；`ThemeMode.light` 和 `ThemeMode.dark` 固定使用对应模式。应用可以自行保存用户选择，在启动时恢复。

## 加载自定义配色

将主题 JSON 注册到应用的 `pubspec.yaml` assets 中，再加载浅色和深色配置：

```dart
final json = await rootBundle.loadString('assets/theme.json');
final tokens = TThemeData.fromJson(
  'green',
  json,
  darkName: 'greenDark',
) ?? TThemeData.defaultData();
```

此处需要引入 `package:flutter/services.dart`。JSON 中的 `green` 和 `greenDark` 应与实际主题名称一致。用上面的 `tokens` 替换示例中的 `_tokens`，再分别通过 `TThemeBuilder.light(tokens)` 和 `TThemeBuilder.dark(tokens)` 构建主题。

组件通过 `context.tTheme` 读取当前子树的 Token。全局配色由 `TThemeData` 管理，组件局部样式通过对应的 `T*ThemeData` 配置。

完整示例见 [深色模式示例源码](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/component_test/dark_test.dart)，配色配置见 [自定义主题](https://tdesign.tencent.com/flutter/getting-started#自定义主题)。
