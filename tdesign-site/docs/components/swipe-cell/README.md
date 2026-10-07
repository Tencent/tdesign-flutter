---
title: SwipeCell 滑动操作
description: 为任意列表项内容提供起始侧和结束侧的滑动操作面板。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

{{ flutter-example-group SwipeCell }}

## 使用说明

`TSwipeCell` 是独立的交互容器，`child` 可以是任意 `Widget`；`TCell` 只是列表场景中常见的 child，不是组件依赖。

```dart
TSwipeCell(
  child: const TCell(title: Text('消息标题')),
  end: TSwipeCellPanel(
    children: [
      TSwipeCellAction(label: '删除', onPressed: (_) {}),
    ],
  ),
  onOpenChanged: (side, isOpen) {
    // side: TSwipeCellSide.start / TSwipeCellSide.end
  },
)
```

`start` 和 `end` 是逻辑方向，会随 `TextDirection` 自动适配。操作项宽度由图标、文字、间距和内边距的实际布局结果决定；自定义 `builder` 也无需另传宽度。任意一个单元格展开时，其他已展开单元格会自动关闭。

{{ flutter-api swipe-cell }}
