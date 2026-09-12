---
title: Footer 页脚
description: 用于展示App的版权声明、联系信息、重要页面链接和其他相关内容等信息。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

### 基础页脚

```dart
const TFooter(
  text: 'Copyright © 2021-2031 TD.All Rights Reserved.',
);
```

### 链接页脚

```dart
TFooter(
  links: [
    TLink(
      child: const Text('底部链接'),
      onPressed: () {},
    ),
  ],
  text: 'Copyright © 2021-2031 TD.All Rights Reserved.',
);
```

### 品牌页脚

```dart
const TFooter(
  logo: TImage(
    src: 'assets/img/t_brand.png',
    width: 104,
    height: 24,
    fit: BoxFit.contain,
  ),
);
```

## API

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| logo | Widget? | - | 品牌内容；非空时优先展示，不再展示 `links` 和 `text` |
| links | List<Widget> | `const []` | 链接内容；多个链接之间自动绘制分隔线 |
| text | String | `''` | 版权或其他文字 |
| key | Key? | - | 组件标识 |
