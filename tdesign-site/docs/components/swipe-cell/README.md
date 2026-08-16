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

`start` 和 `end` 是逻辑方向：横向滑动时分别对应左侧和右侧，纵向滑动时分别对应上方和下方。需要多个单元格互斥展开时，为它们设置相同的 `groupTag` 并开启 `closeWhenOpened`。

## API

### TSwipeCell

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 必填，接受任意内容 Widget。 |
| enabled | bool | true | 是否允许滑动。 |
| start | TSwipeCellPanel? | - | 起始侧操作面板。 |
| end | TSwipeCellPanel? | - | 结束侧操作面板。 |
| onOpenChanged | TSwipeCellChanged? | - | 面板展开或关闭时回调。 |
| controller | SlidableController? | - | 外部滑动控制器。 |
| direction | Axis | Axis.horizontal | 滑动轴。 |
| initialOpenSide | TSwipeCellSide? | - | 首次展示时打开的逻辑侧。 |
| groupTag | Object? | - | 互斥分组标识。 |
| closeWhenOpened | bool | false | 展开时关闭同组其他项。 |
| closeOnScroll | bool | true | 祖先滚动容器滚动时关闭已展开面板。 |
| closeOnTapOutside | bool? | true | 面板展开后点击本格或外部区域自动关闭。 |
| dragStartBehavior | DragStartBehavior | DragStartBehavior.start | 拖动起始行为。 |

### TSwipeCellPanel

操作面板。通过 `children` 提供 `TSwipeCellAction`，并可通过 `extentRatio` 指定面板占比、通过 `confirms` 为指定 action 提供二次确认内容。

### TSwipeCellAction

单个操作项。使用 `label`、`icon`、`backgroundColor` 定义外观，`onPressed` 处理点击；复杂内容可使用 `builder`。

### TSwipeCellSide 与 TSwipeCellChanged

`TSwipeCellSide` 仅包含 `start` 和 `end`。`TSwipeCellChanged` 的签名为：

```dart
typedef TSwipeCellChanged = void Function(TSwipeCellSide side, bool isOpen);
```

### 静态方法

`TSwipeCell.close(groupTag, current: controller)` 可关闭一个分组中除 `current` 外的所有单元格；`TSwipeCell.of(context)` 返回最近的 `SlidableController`。

v1 不提供旧命名的兼容别名；请只使用本页列出的 API。
