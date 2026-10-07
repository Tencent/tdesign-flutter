---
title: Popover 弹出气泡
description: 用于文字提示的气泡框。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

通过统一入口引入 TDesign Flutter 组件：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

{{ flutter-example-group popover }}

## 从旧版 API 迁移

- 文本内容由 `content: '提示内容'` 改为 `content: const Text('提示内容')`。
- 自定义内容由 `contentWidget: widget` 改为 `content: widget`，不再需要为了首帧定位强制指定 `width` 和 `height`。
- `onTap`、`onLongTap` 改为无参数回调；内容已由调用方持有，无需从回调重复获取。
- `placement` 可省略，默认使用 `TPopoverPlacement.top`。
- `TPopoverWidget` 不再作为公开入口；统一通过 `TPopover.showPopover` 管理 Overlay 和生命周期。

{{ flutter-api popover }}
