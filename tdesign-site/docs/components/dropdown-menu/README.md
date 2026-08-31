---
title: DropdownMenu 下拉筛选菜单
description: 用于移动端页面内容的排序和多维筛选。
spline: data
isComponent: true
toc: false
---

## 何时使用

DropdownMenu 是页面级筛选栏，适用于商品列表等内容的排序、单选筛选和多选筛选。

- 表单中的单项选择请使用 Picker。
- 按钮触发的操作列表请使用 Popover 或 ActionSheet。
- 多选面板中的选择只保存在草稿中，点击“确定”后才提交；遮罩、返回键和切换筛选项不会提交草稿。

## 代码演示

示例代码以 `t_dropdown_menu_page.dart` 中的 `@ExampleCode` 为唯一来源，并生成到 Example 的 `assets/code/dropdown_menu.*.txt`。

Example 页面按公开矩阵覆盖组件类型（单选下拉菜单、分栏下拉菜单）、组件状态（禁用状态），并补充 Flutter 组合能力（自定义价格区间、向上展开与自定义图标、横向滚动与禁用项、局部主题与自动方向）。代码查看器直接读取生成后的片段，不在 README 维护第二份示例源码。

## API

### TDropdownMenu

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| items | `List<TDropdownMenuItem>` | 必填 | 筛选触发项 |
| controller | `TDropdownMenuController?` | - | 类型安全的打开、关闭控制器 |
| placement | `TDropdownMenuPlacement` | `auto` | 自动、向下或向上展开 |
| scrollable | `bool` | `false` | 触发栏是否横向滚动 |
| showOverlay | `bool` | `true` | 是否显示遮罩颜色 |
| closeOnOverlayTap | `bool` | `true` | 点击遮罩是否关闭 |
| useRootOverlay | `bool` | `false` | 是否使用根 Overlay |
| animationDuration | `Duration` | `200ms` | 展开和收起动画时长 |
| onOpened | `ValueChanged<int>?` | - | 展开动画完成回调 |
| onClosed | `TDropdownMenuClosedCallback?` | - | 收起动画完成回调，包含索引和关闭原因 |

### TDropdownMenuItem

默认构造接收 `label`、`panelBuilder`、`enabled`、`flex` 和可滚动模式下的 `width`。

`TDropdownMenuItem.custom` 使用 `triggerBuilder` 完全自定义触发内容。Builder 可读取 `index`、`isOpen`、`enabled` 并调用 `toggle()`。

### TDropdownMenuController

| 成员 | 说明 |
| --- | --- |
| `open(index)` | 打开指定筛选项 |
| `close()` | 以 `controller` 原因关闭 |
| `toggle(index)` | 切换指定筛选项 |
| `openIndex` | 当前打开项索引 |
| `isOpen` | 是否存在打开面板 |

外部创建的 Controller 由调用方负责释放；省略时由组件内部创建和释放。

### TDropdownSingleSelectPanel&lt;T&gt;

受控单选面板。通过 `value` 指定当前值，选择有效选项后调用 `onChanged` 并以 `selection` 原因关闭。

### TDropdownMultiSelectPanel&lt;T&gt;

通过 `values` 初始化本次打开的草稿。选择和重置只修改草稿；点击确定后通过 `onConfirm` 返回不可变 `Set<T>`。

### TDropdownMenuOption&lt;T&gt;

仅保存 `value`、`label`、`disabled` 和可选 `group`。分组顺序与选项首次出现的顺序一致。

### TDropdownMenuPlacement

`auto`、`below`、`above`。

### TDropdownMenuCloseReason

`selection`、`confirm`、`cancel`、`overlay`、`back`、`trigger`、`controller`、`switchItem`。

### TDropdownThemeData

组件主题只保存视觉和布局默认值：

| 分类 | 字段 |
| --- | --- |
| 筛选栏 | `barHeight`、`barBackgroundColor`、`dividerColor` |
| 文本 | `textStyle`、`activeTextStyle`、`disabledTextStyle` |
| 图标 | `iconColor`、`activeIconColor`、`disabledIconColor`、`iconSize` |
| 弹层 | `panelBackgroundColor`、`overlayColor`、`animationDuration` |
| 选项 | `optionHeight`、`optionPadding`、`optionTextStyle`、`selectedOptionTextStyle`、`disabledOptionTextStyle` |
| 选项块 | `optionColor`、`selectedOptionColor`、`disabledOptionColor`、`optionBorderRadius` |
| 操作区 | `actionAreaPadding`、`actionGap` |

解析优先级为：

```text
实例结构参数或自定义内容
> TDropdownThemeData
> Flutter DefaultTextStyle / IconTheme / ColorScheme / DividerTheme
> TDesign token
```
