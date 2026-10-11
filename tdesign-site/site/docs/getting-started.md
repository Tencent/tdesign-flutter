---
title: 快速开始
description: 安装并运行第一个 TDesign Flutter 应用，再按需求继续配置。
spline: explain
---

## 🔨 安装

### SDK 版本要求

Flutter `>=3.32.0`，Dart `>=3.8.0 <4.0.0`。下面示例对应 v1 预发布版本；预发布期间 API 和视觉细节仍可能调整，建议锁定依赖版本。旧版项目升级前请核对对应版本的变更说明。

### 添加依赖

在应用的 `pubspec.yaml` 中添加：

```yaml
dependencies:
  flutter:
    sdk: flutter
  tdesign_flutter: 1.0.0-alpha.1
```

然后在应用目录执行 `flutter pub get`。

## 📖 第一个应用

将下面完整示例放入 `lib/main.dart`，连接设备后执行 `flutter run`：

```dart
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final token = TThemeData.defaultData();
    return MaterialApp(
      theme: TThemeBuilder.light(token),
      darkTheme: TThemeBuilder.dark(token),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(title: const Text('TDesign Flutter')),
        body: Center(
          child: TButton(
            onPressed: () {},
            child: const TText('Hello TDesign'),
          ),
        ),
      ),
    );
  }
}
```

默认主题已配置，`ThemeMode.system` 会跟随系统明暗设置。运行后应能看到一个“Hello TDesign”按钮。

<a id="自定义主题"></a>
<a id="🎨-自定义主题"></a>

## 接下来你想做什么？

| 需求 | 阅读入口 | 你将完成什么 |
| --- | --- | --- |
| 找到并使用组件 | [组件概览](/flutter/overview) | 查看演示和公开参数 |
| 改整个应用的品牌色 | [自定义主题](/flutter/custom-theme) | 配置全局配色 |
| 改一类组件、某个页面或单个实例的样式 | [自定义主题](/flutter/custom-theme) | 选择合适的配置范围 |
| 手动切换明暗模式，或保存用户选择 | [深色模式](/flutter/dark-mode) | 管理浅色、深色与跟随系统 |
| 使用其他语言 | [国际化](/flutter/internationalization) | 配置业务语言与组件文案 |
| 从旧版本升级 | [发布记录](https://github.com/Tencent/tdesign-flutter/releases) | 核对目标版本及不兼容变化 |
