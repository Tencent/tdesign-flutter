---
title: Picker 选择器
description: 纯滚轮选择器组件，支持多列独立和联动两种模式
spline: base
isComponent: true
---

## 代码演示

{{ flutter-example-group picker }}

{{ flutter-api picker }}

## FAQ

### 使用 TPickerPopup 时，关闭后会销毁内容吗？

`TPickerPopup.show()` 的 `destroyOnClose` 默认为 `false`，关闭后保留内容 State；原句柄可通过 `open()` 重开。替换会话的资源复用注意事项见 [Popup FAQ](/flutter/components/popup?tab=api#popup-session-reuse)。此规则不改变独立 `TPicker` 面板的生命周期。
