---
title: Empty 空状态
description: 用于空状态时的占位提示。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

### 图标空状态

```dart
const TEmpty(emptyText: '描述文字');
```

### 自定义图片空状态

```dart
TEmpty(
  image: const TImage(
    src: 'assets/img/empty.png',
    fit: BoxFit.contain,
  ),
  emptyText: '描述文字',
);
```

### 带操作空状态

```dart
TEmpty(
  emptyText: '描述文字',
  operation: TButton(
    onPressed: () {},
    child: const Text('操作按钮'),
  ),
);
```

## API

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| icon | IconData? | `TIcons.info_circle_filled` | 默认图标；`image` 非空时不显示 |
| image | Widget? | - | 自定义图片或插画；优先于 `icon` |
| emptyText | String? | - | 描述文字 |
| operation | Widget? | - | 描述下方的操作内容 |
| key | Key? | - | 组件标识 |
