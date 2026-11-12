---
title: ActionSheet 动作面板
description: 在当前场景下向用户呈现一组可选操作。
spline: base
isComponent: true
---

## 代码演示

{{ flutter-example-group action_sheet }}

{{ flutter-api action-sheet }}

## FAQ

### 关闭动作面板后会销毁内容吗？

`TActionSheet.showList()`、`showGrid()` 和 `showGridSections()` 使用 Popup 默认保留策略，关闭后保留内容 State，可通过返回句柄的 `open()` 重开；所属 Navigator 卸载时释放。

这些入口没有 `destroyOnClose` 参数，不能直接配置关闭销毁。资源复用风险见 [Popup FAQ](/flutter/components/popup?tab=api#popup-session-reuse)；其中设置 `destroyOnClose: true` 的方式不适用于这些入口。
