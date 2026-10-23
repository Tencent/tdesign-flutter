---
title: 快速开始
description: 安装 TDesign Flutter 并在已有页面中使用组件。
spline: explain
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

`^1.0.0` 允许兼容的1.x更新。应用应提交依赖锁文件，升级后回归关键业务页面。

安装依赖：

```bash
flutter pub get
```

### 最小导入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

TD 入口导出 Flutter Material 组件，可通过同一个入口使用 `MaterialApp`、`Scaffold`、`Text` 和 TDesign 组件。

### 最小使用

将按钮放入已有页面的 Widget 树中：

```dart
const TButton(child: Text('按钮'))
```

无需额外初始化或主题配置。不传 `onPressed` 时，按钮处于禁用状态。

## 下一步

- [自定义主题](./custom-theme.md)
- [明暗主题切换](./custom-theme.md#明暗模式)
- [国际化](./internationalization.md)
- [组件概览](./overview.md)
- [常见问题](./faq.md)

## 自定义主题

主题JSON、主题生成器和局部覆盖统一见[自定义主题](./custom-theme.md)。本节保留旧快速开始的章节入口。
