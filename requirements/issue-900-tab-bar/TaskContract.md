# TaskContract — issue #900 TabBar 图标选中不变色

## 基本信息

- issue: https://github.com/Tencent/tdesign-flutter/issues/900
- 组件：`TBottomTabBar`
- 分支：`fix/issue-900-tab-bar`
- 优先级：P2（功能缺陷，影响视觉反馈）

## 问题描述

`TBottomTabBarBasicType.iconText` 类型下，切换选中 tab 时：
- 文字颜色正确切换（选中：brandNormalColor，未选中：textColorPrimary）
- **图标颜色不切换**，始终保持同一颜色

## 根因分析

`_constructItem` 方法中：

- `text` 类型：通过 `_textItem` 内的 `textColor` 参数正确应用了选中/未选中颜色
- `icon` / `iconText` 类型：仅切换 `selectedIcon` / `unselectedIcon` widget，**未包裹 `IconTheme`**，图标颜色由 widget 自身决定，不受选中状态控制

## 修复方案

在 `icon` 和 `iconText` 分支中，用 `IconTheme` 包裹图标 widget，根据 `isSelected` 注入对应颜色：
- 选中：`TTheme.of(context).brandNormalColor`
- 未选中：`TTheme.of(context).textColorPrimary`

## 交付物清单

| 序号 | 交付物 | 负责角色 |
|------|--------|---------|
| 1 | `requirements/issue-900-tab-bar/test-cases.md` | tester |
| 2 | `tdesign-component/test/td_bottom_tab_bar_test.dart` | tester |
| 3 | `tdesign-component/lib/src/components/tabbar/td_bottom_tab_bar.dart`（修复） | developer |
| 4 | `requirements/issue-900-tab-bar/code-review-report.md` | reviewer |
| 5 | `requirements/issue-900-tab-bar/evaluation-report.md` | tester |
| 6 | PR to develop | ci |

## 确认点

1. 修复后 `icon` 类型也需同步修复（同样逻辑缺陷）
2. 如果用户自定义图标显式设置了 `color`，`IconTheme` 不应覆盖（Flutter 的 `Icon` widget 显式 color 优先级高于 IconTheme，无需额外处理）
3. 不改动任何公开 API
