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

ActionSheet 通过 `TActionSheet.showList` 和 `TActionSheet.showGrid`
命令式打开。选择项目后会自动关闭面板，并通过
`onSelected` 返回带有稳定 `value` 的完整项目。

```dart
TActionSheet.showList(
  context,
  cancelText: 'cancel',
  subtitle: 'Email Settings',
  items: [
    TActionSheetItem(
      value: 'move',
      label: 'Move',
      icon: const Icon(TIcons.folder),
    ),
    TActionSheetItem(
      value: 'add-to-tasks',
      label: 'Add to Tasks',
      icon: const Icon(TIcons.cloud_upload),
    ),
  ],
  onSelected: (item) {
    // 使用 item.value 执行业务操作
  },
);
```

## 宫格与状态

`icon` 是完整的 Widget 插槽。普通 `Icon` 会继承 ActionSheet 的默认字号和颜色；渠道图标、品牌图标或带背景的工具图标由调用方直接构造完整 Widget，组件不会强制缩放。

宫格中 `count` 表示一个可视面板期望容纳的项目数量，`rows` 表示行数，
`items.length` 表示全部数据数量。`count` 必须能被 `rows` 整除；例如
`count: 10, rows: 2` 表示每个可视面板两行五列。分页模式按 `count`
切页，滚动模式保持相同密度并横向展示剩余项目。
`itemMinWidth` 只属于滚动布局；设置后可扩大项目并减少视口内实际可见数量。

```dart
TActionSheet.showGrid(
  context,
  items: List.generate(
    16,
    (index) => TActionSheetItem(
      value: index,
      label: '标题文字',
      icon: const Icon(TIcons.image),
    ),
  ),
  layout: const TActionSheetGridLayout.paged(count: 8, rows: 2),
  onSelected: (item) {},
);

TActionSheet.showGrid(
  context,
  items: List.generate(
    24,
    (index) => TActionSheetItem(
      value: index,
      label: '操作 $index',
      icon: const Icon(TIcons.image),
    ),
  ),
  layout: const TActionSheetGridLayout.scroll(
    count: 10,
    rows: 2,
    itemMinWidth: 80,
  ),
  onSelected: (item) {},
);

TActionSheet.showList(
  context,
  cancelText: 'cancel',
  items: [
    TActionSheetItem(
      value: 'important',
      label: 'Mark as important',
      icon: Icon(
        TIcons.notification,
        color: context.tTheme.brandNormalColor,
      ),
      textStyle: TextStyle(color: context.tTheme.brandNormalColor),
    ),
    TActionSheetItem(
      value: 'unsubscribe',
      label: 'Unsubscribe',
      icon: Icon(TIcons.delete, color: context.tTheme.errorNormalColor),
      textStyle: TextStyle(color: context.tTheme.errorNormalColor),
    ),
    TActionSheetItem(
      value: 'add-to-tasks',
      label: 'Add to Tasks',
      disabled: true,
    ),
  ],
  onSelected: (item) {},
);
```

## API 摘要

- `TActionSheetItem<T>`：必填稳定 `value`，并支持 `label`、`icon`、`subtitle`、`badge` 和 `disabled`；`badge` 是任意 Widget 槽位。
- `icon` 是 Widget 插槽；背景、形状和显式尺寸由该 Widget 自己控制。
- `textStyle` 只控制标题样式，不会隐式改变图标颜色；图标可显式设置样式，或继承 ActionSheet Theme。
- `showList`：列表动作面板，支持副标题、取消按钮和禁用项。
- `showGrid`：宫格动作面板，通过 `TActionSheetGridLayout.fixed`、
  `paged` 或 `scroll` 明确选择一种互斥布局；宫格 Item 和副标题居中展示。
- 面板与 Item 的 `subtitle` 为 null 或空字符串时均按无描述处理。
- 两种入口均返回 `TPopupHandle`，可设置 `showOverlay`、`closeOnOverlayClick`、`useSafeArea`、`onCancel` 和 `onClosed`。

`TActionSheetThemeData` 提供 `gridItemHeight`、`iconSize`、`gridIconExtent` 和
`iconColor` 等视觉默认值；`gridItemHeight` 只影响宫格项。解析优先级为
自定义 Widget 显式样式 > ThemeExtension > TDesign token；ThemeExtension
缺失时组件直接使用 token。

## 不兼容升级说明

- `onChanged(item, index)` 改为 `onSelected(item)`；请使用必填的 `item.value`
  识别业务动作，不再依赖可变的视图索引。
- `count`、`rows`、`showPagination`、`scrollable` 和 `itemMinWidth`
  收敛到 `layout`，不同布局的专属参数不会相互冲突。
- 删除无设计依据的 `showGroup`、`TActionSheetGroup` 和
  `TActionSheetItem.group`。
- `TActionSheetThemeData` 只保留视觉配置；布局行为应在每次调用的
  `layout` 中明确声明。
- 删除 `showGrid.align`；宫格 Item 和副标题固定居中。
- `TActionSheetThemeData.itemHeight` 改名为 `gridItemHeight`。
- `textStyle.color` 不再隐式覆盖图标颜色；需要同色时请同时设置 `Icon.color`。

示例源码：[t_action_sheet_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_action_sheet_page.dart)
