---
title: Table 表格
description: 用于展示同类结构化数据，支持受控排序、选择、固定列、表体滚动和加载状态。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[t_table_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_table_page.dart)

示例页中的 `@ExampleCode(group: 'table')` 是本页代码片段的唯一来源，覆盖排序、选择、固定列、表体滚动、加载、边框和斑马纹。

## API

### TTable

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| columns | List<TTableColumn<T>> | - | 列配置，不能为空 |
| data | List<T> | - | 行数据 |
| selectionMode | TTableSelectionMode | none | 行选择模式 |
| selectedRows | Set<T> | const {} | 当前受控选中行 |
| onSelectionChanged | ValueChanged<Set<T>>? | - | 请求更新选中行集合 |
| rowSelectable | bool Function(T row, int index)? | - | 判断行是否可选 |
| sort | TTableSort? | - | 当前受控排序值 |
| onSortChanged | ValueChanged<TTableSort?>? | - | 请求更新排序值；同一可排序列依次回调升序、降序、`null`（未排序） |
| loading | bool | false | 在表体显示加载遮罩；表头和 footer 保持可见 |
| loadingWidget | Widget? | - | 自定义加载内容 |
| empty | Widget? | - | 自定义空数据内容；未设置时使用本地化的 TEmpty |
| footer | Widget? | - | 表格底部内容 |
| showHeader | bool | true | 是否显示表头 |
| maxHeight | double? | - | 表体最大可视高度；超过时表体垂直滚动 |
| onCellTap | TTableCellTap<T>? | - | 单元格点击回调 |
| onScroll | ValueChanged<ScrollNotification>? | - | 表体垂直滚动通知 |

### TTableColumn

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| id | String | - | 列唯一标识，用于排序 |
| header | Widget | - | 表头内容 |
| cellBuilder | TTableCellBuilder<T> | - | 单元格构建器 |
| width | double | 120 | 列宽 |
| fixed | TTableColumnFixed | none | 固定在左侧、右侧或随中间区域横向滚动 |
| align | TTableColumnAlign | left | 单元格内容对齐方式 |
| comparator | Comparator<T>? | - | 排序比较器；为空时该列不可排序 |

排序是受控状态：父级将回调结果回传给 `sort`。同一列的点击顺序固定为“升序 → 降序 → 未排序”；未排序时 `onSortChanged` 返回 `null`，表格按传入 `data` 的原始顺序展示。组件只基于副本执行本地比较，不会修改传入列表。

### TTableThemeData

通过局部 `Theme.of(context).mergeExtension(...)` 设置表格视觉默认值：`bordered`、`stripe`、`rowHeight`、`headerHeight`、`width`、`backgroundColor`、`headerColor`、`stripeColor`、`borderColor`、`cellPadding`。默认显示横向分割线；`bordered: true` 额外显示纵向分割线与外框。

`maxHeight` 是单个表格的布局约束，不属于 ThemeExtension。

默认空态的文案来自 `context.resource.emptyData`。应用可通过 `setTResourceBuilder` 注入对应语言的 `TResourceDelegate`；传入 `empty` 时由调用方内容覆盖默认 `TEmpty`。
