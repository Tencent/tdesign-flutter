---
title: NoticeBar 公告栏
description: 在导航栏下方，用于给用户显示提示消息。
spline: base
isComponent: true
---

## 代码演示

{{ flutter-example-group noticeBar }}

{{ flutter-api notice-bar }}

## FAQ

### 1.0.0 → 1.0.1 升级后，自定义区域点击通知有何变化？

自定义 `prefix`/`operation` 仅通知单指主按钮短按，不再通知拖动、长按、多指和鼠标按键组合；需要其他手势时在自定义内容中自行处理。内置区域手势不变。
