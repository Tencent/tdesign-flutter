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

[t_dialog_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_dialog_page.dart)

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

## 行为说明

- Dialog 默认不允许点击蒙层关闭；通过 `barrierDismissible: true` 开启。
- 一到两个 action 横向排列，三个及以上 action 纵向排列。
- `TDialogActionRole` 提供次要、主要和危险操作的默认按钮语义。
- `closeOnPressed` 控制 action 点击后是否自动关闭；关闭结果来自 `result`。
- 内容区只有一个滚动视口，超长文字和自定义 Widget 使用同一套高度约束。
- Popup 负责蒙层、动画、安全区、局部 Theme 捕获、焦点闭环和路由生命周期。

## 主题

解析顺序为：实例参数 > `TDialogThemeData` > Flutter `DialogThemeData` > TDesign token。

`TDialogThemeData` 支持背景色、shape、elevation、标题/内容文字样式、内容内边距、最大高度、action 按钮样式和宽度。蒙层样式由共享的 `TPopupThemeData` 控制，也可在 `TDialog.show` 中显式传入 `barrierColor`。

## API

### TDialog

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | Widget? | - | 标题槽位。 |
| content | Widget? | - | 内容槽位。 |
| actions | List&lt;TDialogAction&gt; | const [] | 操作列表。 |
| actionsWidget | Widget? | - | 完全自定义操作区，与 actions 互斥。 |
| showCloseButton | bool | false | 是否显示右上角关闭按钮。 |
| semanticLabel | String? | - | 对话框语义标签。 |
| backgroundColor | Color? | - | 面板背景色。 |
| shape | ShapeBorder? | - | 面板形状。 |
| elevation | double? | - | 阴影高度。 |
| width | double? | - | 面板宽度。 |
| maxHeight | double? | - | 面板最大高度。 |
| contentPadding | EdgeInsetsGeometry? | - | 标题和内容区域内边距。 |
| actionsPadding | EdgeInsetsGeometry | EdgeInsets.fromLTRB(24, 24, 24, 24) | 操作区内边距。 |
| actionSpacing | double | 12 | 操作间距。 |

### TDialog.show

返回 `Future<T?>`。支持 `barrierDismissible`、`barrierColor`、`useRootNavigator` 和 `useSafeArea`。

### TDialogAction

通过 `child` 定义内容，`result` 定义关闭结果，`role` 定义默认视觉；可使用 `onPressed`、`closeOnPressed`、`disabled`、`variant`、`colorScheme` 和 `style` 控制行为与外观。

### TConfirmDialog

单操作便捷层，支持字符串标题、字符串或 Widget 内容、按钮文字/回调/结果，以及 `TDialog` 的主要视觉与布局参数。

v1 不提供历史专用 Dialog 类型或旧按钮配置对象的兼容别名。
