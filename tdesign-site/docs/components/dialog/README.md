---
title: Dialog 对话框
description: 用于显示重要提示或请求用户完成关键操作的居中模态视图。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

{{ flutter-example-group dialog }}

## 基本使用

`TDialog` 负责标题、内容和操作区，打开时复用 `TPopup` 的居中模态路由。操作结果通过 `Future<T?>` 返回。

```dart
final confirmed = await TDialog.show<bool>(
  context,
  dialog: const TDialog(
    title: Text('提交修改？'),
    content: Text('提交后将立即同步给团队成员。'),
    actions: [
      TDialogAction(child: Text('取消'), result: false),
      TDialogAction(
        child: Text('确认'),
        result: true,
        role: TDialogActionRole.primary,
      ),
    ],
  ),
);
```

单操作场景可使用 `TConfirmDialog`：

```dart
await TDialog.show<bool>(
  context,
  dialog: const TConfirmDialog(
    title: '提示',
    content: '操作已完成。',
  ),
);
```

长内容通过 `maxHeight` 限制内容视口，标题和操作区保持固定：

```dart
await TDialog.show<void>(
  context,
  dialog: TDialog(
    title: const Text('服务说明'),
    maxHeight: 320,
    content: Column(
      children: List.generate(
        18,
        (index) => Text('${index + 1}. 需要滚动阅读的说明内容'),
      ),
    ),
    actions: const [
      TDialogAction(child: Text('知道了'), role: TDialogActionRole.primary),
    ],
  ),
);
```

## 行为说明

- Dialog 默认不允许点击蒙层关闭；通过 `barrierDismissible: true` 开启。
- 非关键提示可以允许点击蒙层关闭：

  ```dart
  TDialog.show<void>(
    context,
    barrierDismissible: true,
    dialog: const TDialog(
      title: Text('提示'),
      content: Text('点击对话框外部区域即可关闭。'),
    ),
  );
  ```
- 一到两个 action 横向排列，三个及以上 action 纵向排列。
- `TDialogActionRole` 提供次要、主要和危险操作的默认按钮语义。
- `closeOnPressed` 控制 action 点击后是否自动关闭；关闭结果来自 `result`。
- 内容区只有一个滚动视口，超长文字和自定义 Widget 使用同一套高度约束。
- Popup 负责蒙层、动画、安全区、局部 Theme 捕获、焦点闭环和路由生命周期。

## 主题

解析顺序为：实例参数 > `TDialogThemeData` > Flutter `DialogThemeData` > TDesign token。

`TDialogThemeData` 支持背景色、shape、elevation、标题/内容文字样式、内容内边距、最大高度、action 按钮样式和宽度。蒙层样式由共享的 `TPopupThemeData` 控制，也可在 `TDialog.show` 中显式传入 `barrierColor`。

{{ flutter-api dialog }}
