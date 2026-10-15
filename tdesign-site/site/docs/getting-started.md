---
title: 快速开始
description: 安装 TDesign Flutter 并在已有页面中使用组件。
spline: explain
---

## 接入


从 0.2.7 升级时，请先阅读 [1.0 迁移指南](./migration-0.2.7-to-1.0.md)。1.0 包含不兼容的接口与默认行为变化，不能只替换组件前缀。

要求 Flutter ≥ 3.32.0、Dart ≥ 3.8.0。

### 添加依赖

当前单入口功能尚未发布到 pub.dev。发布前，在 `pubspec.yaml` 中添加以下锁定提交的源码依赖：

```yaml
dependencies:
  flutter:
    sdk: flutter
  tdesign_flutter:
    git:
      url: https://github.com/Tencent/tdesign-flutter.git
      ref: 86c37e563039c57cf6c3f9b52fead418fd3c03bd
      path: tdesign-component
```

包含上述能力的 `1.0.0` 稳定版发布后，可将源码依赖替换为 `tdesign_flutter: ^1.0.0`，允许兼容的 1.x 更新，无需每次发布都修改版本号；`1.0.0` 不带 `^` 则只允许该精确版本。发布前请使用上面的源码配置。

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
- [深色模式](./dark-mode.md)
- [国际化](./internationalization.md)
- [组件概览](./overview.md)
- [常见问题](./faq.md)

## 自定义主题

主题JSON、主题生成器和局部覆盖统一见[自定义主题](./custom-theme.md)。本节保留旧快速开始的章节入口。
