---
title: DateTimePicker 时间选择器
description: 纯滚轮选择日期/时间，选中值通过 onChange 回调。
spline: base
isComponent: true
---

## 代码演示

{{ flutter-example-group date-time-picker }}

{{ flutter-api date-time-picker }}

## FAQ

### 通过 TPickerPopup 展示时，关闭后会销毁内容吗？

使用 `TPickerPopup.show()` 展示日期时间选择器时，`destroyOnClose` 默认为 `false`，关闭后保留内容 State。替换会话的资源复用注意事项见 [Popup FAQ](/flutter/components/popup?tab=api#popup-session-reuse)。独立使用 `TDateTimePicker` 面板时，不涉及该弹层保留规则。
