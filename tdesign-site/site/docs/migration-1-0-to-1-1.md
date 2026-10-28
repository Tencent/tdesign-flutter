---
title: 从 1.0 升级到 1.1
description: 从 1.0.0 升级到计划中的 1.1.0 的接口与行为注意事项。
spline: explain
docClass: migration-guide
tocLevel: [2]
---

# 从 1.0 升级到 1.1

## 升级注意事项

以下内容基于开发分支中计划的 1.1.0，最终范围和行为以正式更新日志为准。

### 1.0.0 → 1.1.0 事件与主题配置

1.1.0 候选保留旧回调入口，但新增公开 getter 会影响自定义 `implements` 的业务。使用下表中旧 getter 的实现需补齐对应新 getter；普通构造调用可继续使用旧参数，旧入口会产生弃用提示。新旧参数同时传入时，以非空新参数为准。

- `TCheckboxGroup`：`onMaxSelected` → `onSelectionLimitExceeded`。
- `TDrawer`：`onItemClick` → `onItemTap`。
- `TNoticeBar`：`onPressed` → `onTargetTap`。
- `TPopoverAnchor`、`TPopoverWidget`：`onLongTap` → `onLongPress`。
- `TSteps`、`TStepsHorizontal`、`TStepsVertical`：`onChange` → `onStepTapped`。
- `TTabBarItemConfig`：`allowMultipleTaps` → `notifyOnReselect`。
- `TTabBarPopUpBtnConfig`：`onChanged` → `onSelected`。

例如，旧 `TTabBarItemConfig` 实现可将 `notifyOnReselect` 转发到原有 `allowMultipleTaps`。如业务已有同名成员，还需确认其类型和语义与新契约一致。旧入口计划在 2.0.0 删除，迁移后仍需检查回调时机、受控值和交互。

部分组件 ThemeData 新增配置或解析成员；自行 `implements` 组件 ThemeData 的业务需对照目标版本 API 检查编译和实际主题行为，不应将 Drawer、TabBar 的兼容修复外推到其他类型。

### 已有文字槽遗漏修复

Avatar、Calendar 副标题、Collapse、Divider、Link、Progress、Table 及内部操作文字槽为 TText 补齐既有组件默认值；Drawer 标题继续保留已有 TD 段落设置。未设置样式的 TText 外观可能随组件字体或状态色修正；显式字段及内容内部更近的主题仍优先。原生 Text 的段落 reset/merge 边界不改变。

<a id="自定义文字槽默认值统一（patch）"></a>
### 自定义文字槽默认值统一

Popover 内容、Drawer 菜单 content、Toast customWidget、Picker itemBuilder、Steps customTitle/customContent、TabBar 弹出菜单 itemWidget 开始接入所属组件的默认字体和状态色。Row、Padding、Builder 不会切断文字槽样式。TText 全局仍与外部 Material 默认文字隔离，不增加开关或配置。

- 显式 TextStyle 字段优先；未指定字段仍采用组件默认值。要保持旧外观，明确指定需保留的字号、颜色、字重、行高、字距等，或在内容内部设置局部文字主题。TText 使用更近的 TTextThemeData，原生 Text 可用 DefaultTextStyle。
- Popover 和 Toast 的未着色文案会适配气泡背景；原来自定义菜单的字距、行高及尺寸可能变化。
- Drawer 菜单正文不自动加单行限制；自定义内容继续自行设置换行和省略。
- Picker 自定义选项随选中/禁用状态使用内置默认值；选中项可能从 14/w400 变为 16/w600，需检查滚轮排版。
- Steps 自定义标题/说明随方向、状态采用内置默认值，需检查字号、状态色、粗体和换行。
- TabBar 自定义菜单默认文字从正文样式调整为菜单样式，自动行高按真实内容适配；显式 popUpItemHeight 保持原约束。Column/Expanded 等依赖确定高度的内容继续显式给定该现有高度配置。

升级时检查明暗主题、字体缩放、长内容和背景对比度，并留意换行、省略、弹层尺寸与点击范围。要保留旧外观，应明确设置所需文字字段；仅设置颜色不能保留旧字号或字重。原生 Text 的段落语义不变，不向自定义内容强加内置标签的 maxLines/overflow。

### Popup 配置与关闭生命周期

开发分支中面向 1.1.0 的 Popup 调整涉及蒙层配置继承与关闭后的资源保留，兼容性调整仍在准备中。使用过旧配置的 `extends/implements`、mock 或依赖关闭即销毁的业务，需要单独核对 [Popup API 与升级说明](https://tdesign.tencent.com/flutter/components/popup?tab=api)，并验证关闭、重新打开和页面卸载。最终行为以正式版本和更新日志为准；该版本说明不表示 1.1.0 已发布。
