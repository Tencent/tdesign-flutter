---
title: Message 消息通知
description: 用于轻量级反馈或提示，不会打断用户操作。
spline: base
isComponent: true
---

## 代码演示

{{ flutter-example-group message }}

### 跑马灯行为

配置 `TMessageMarquee` 后，只有文字超出实际可用宽度时才会滚动。系统禁用动画时，超出部分以省略号显示。非循环滚动到末尾后会返回起点；`duration` 表示单向滚动时间，返回时使用相同时间。重新满足滚动条件时重新等待 `delay`。

{{ flutter-api message }}
