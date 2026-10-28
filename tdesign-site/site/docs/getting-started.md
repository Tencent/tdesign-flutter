---
title: 快速开始
description: 安装 TDesign Flutter 并在已有页面中使用组件。
spline: explain
flutterExample: getting-started
---

## 快速体验

选择对应平台体验官方 Demo：

| 体验方式 | 入口 |
| --- | --- |
| Android 真机体验 | [下载官方 Demo APK](https://tdesign.gtimg.com/flutter/tdesign_flutter_example.apk)，或扫码下载。<br /><img src="/assets/qrcode/t_apk_qrcode.png" alt="官方 Android Demo APK 下载二维码" width="160" /> |
| iOS 体验 | 从[版本发布页](https://github.com/Tencent/tdesign-flutter/releases)下载对应源码，运行其中的 `tdesign-component/example` 工程。 |

## 接入

从 0.2.7 升级时，请先阅读 [1.0 迁移指南](./migration-0.2.7-to-1.0.md)。1.0 包含不兼容的接口与默认行为变化，不能只替换组件前缀。

要求 Flutter ≥ 3.32.0、Dart ≥ 3.8.0。

### 添加依赖

在应用的 `pubspec.yaml` 中添加：

```yaml
dependencies:
  flutter:
    sdk: flutter
  tdesign_flutter: ^1.0.0
```

`^1.0.0` 允许兼容的 1.x 更新。应用应提交依赖锁文件，升级后回归关键业务页面。

安装依赖：

```bash
flutter pub get
```

### 最小导入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

TD 入口导出 Flutter Material 组件，可通过同一个入口使用 `MaterialApp`、`Scaffold`、`Text` 和 TDesign 组件。

### 运行第一个应用

将 `lib/main.dart` 替换为以下内容，执行 `flutter run`。点击按钮，计数会随之增加，无需提前配置主题。

<!-- documentation-example:quick-start:start -->
```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() => runApp(const MaterialApp(home: CounterPage()));

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const TNavBar(title: Text('TDesign Flutter')),
    body: Center(
      child: TButton(
        colorPreset: TButtonColorPreset.primary,
        onPressed: () => setState(() => _count += 1),
        child: Text('点击次数：$_count'),
      ),
    ),
  );
}
```
<!-- documentation-example:quick-start:end -->

如果应用已有 `MaterialApp` 和页面，只复制按钮及其业务状态即可。`onPressed: null` 会禁用按钮；需要操作的按钮必须传入回调。

<span id="自定义主题" aria-hidden="true"></span>

## 下一步

- [自定义主题](./custom-theme.md)
- [明暗主题切换](./custom-theme.md#明暗模式)
- [国际化](./internationalization.md)
- [组件概览](./overview.md)
- [常见问题](./faq.md)
