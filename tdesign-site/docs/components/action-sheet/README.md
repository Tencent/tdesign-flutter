---
title: ActionSheet 动作面板
description: 在当前场景下向用户呈现一组可选操作。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 使用场景

ActionSheet 通过 `TActionSheet.showList`、`showGrid` 和 `showGroup` 命令式打开。选择项目后会自动关闭面板，并通过 `onChanged` 返回被选中的项目。

```dart
TActionSheet.showList(
  context,
  cancelText: 'cancel',
  subtitle: 'Email Settings',
  items: [
    TActionSheetItem(label: 'Move', icon: const Icon(TIcons.folder)),
    TActionSheetItem(label: 'Add to Tasks', icon: const Icon(TIcons.cloud_upload)),
  ],
  onChanged: (item, index) {
    // 执行业务操作
  },
);
```

## 宫格与状态

`icon` 是完整的 Widget 插槽。普通 `Icon` 会继承 ActionSheet 的默认字号和颜色；渠道图标、品牌图标或带背景的工具图标由调用方直接构造完整 Widget，组件不会强制缩放。

```dart
TActionSheet.showGrid(
  context,
  items: List.generate(
    16,
    (index) => TActionSheetItem(
      label: '标题文字',
      icon: const Icon(TIcons.image),
    ),
  ),
  showPagination: true,
  count: 8,
  rows: 2,
  onChanged: (item, index) {},
);

TActionSheet.showList(
  context,
  cancelText: 'cancel',
  items: [
    TActionSheetItem(
      label: 'Mark as important',
      textStyle: TextStyle(color: context.tTheme.brandNormalColor),
    ),
    TActionSheetItem(
      label: 'Unsubscribe',
      icon: const Icon(TIcons.delete),
      textStyle: TextStyle(color: context.tTheme.errorNormalColor),
    ),
    TActionSheetItem(label: 'Add to Tasks', disabled: true),
  ],
  onChanged: (item, index) {},
);
```

## API 摘要

- `TActionSheetItem`：`label`、`icon`、`subtitle`、`badge`、`disabled` 和 `group`。
- `icon` 是 Widget 插槽；背景、形状和显式尺寸由该 Widget 自己控制。
- `showList`：列表动作面板，支持副标题、取消按钮和禁用项。
- `showGrid`：宫格动作面板，支持分页、滚动、行数和每页数量。
- `showGroup`：按 `group` 分组并横向滚动展示动作。
- 三种入口均返回 `TPopupHandle`，可设置 `showOverlay`、`closeOnOverlayClick`、`useSafeArea`、`onCancel` 和 `onClosed`。

`TActionSheetThemeData` 提供 `iconSize`、`gridIconExtent` 和 `iconColor` 等视觉默认值。解析优先级为自定义 Widget 显式样式 > ThemeExtension > TDesign token；ThemeExtension 缺失时组件直接使用 token。

示例源码：[t_action_sheet_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_action_sheet_page.dart)
