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

[t_swipe_cell_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_swipe_cell_page.dart)

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

## API

### TSwipeCell

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 必填，接受任意内容 Widget。 |
| enabled | bool | true | 是否允许滑动。 |
| start | TSwipeCellPanel? | - | 起始侧操作面板。 |
| end | TSwipeCellPanel? | - | 结束侧操作面板。 |
| onOpenChanged | TSwipeCellChanged? | - | 面板展开或关闭时回调。 |
| controller | TSwipeCellController? | - | 通过 `open(side)` / `close()` 命令式控制。 |
| initialOpenSide | TSwipeCellSide? | - | 首次展示时打开的逻辑侧。 |
| closeOnScroll | bool | true | 祖先滚动容器滚动时关闭已展开面板。 |

### TSwipeCellPanel

操作面板，只需通过 `children` 提供 `TSwipeCellAction`。面板宽度是所有操作项真实布局宽度之和。

### TSwipeCellAction

单个操作项。使用 `label`、`icon`、`backgroundColor` 定义外观，`onPressed` 处理点击；复杂内容可使用 `builder`。点击操作项后面板会自动关闭。

### TSwipeCellSide 与 TSwipeCellChanged

`TSwipeCellSide` 仅包含 `start` 和 `end`。`TSwipeCellChanged` 的签名为：

```dart
typedef TSwipeCellChanged = void Function(TSwipeCellSide side, bool isOpen);
```

### TSwipeCellController

控制器只提供 `open(TSwipeCellSide side)` 和 `close()`。一个控制器同一时间只能绑定一个 `TSwipeCell`；普通拖动场景无需创建控制器。
