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

### 1.0.0 → 1.0.1 升级需要适配什么？

- 自定义 `implements TNoticeBar` 须补 `onTargetTap` getter，返回原 `onPressed`，否则无法编译。
- 已有子类若存在同名业务成员，需核对类型和语义；冲突时重命名，或按新契约适配。
- 自定义 `prefix`/`operation` 仅通知单指主按钮短按，不再通知拖动、长按、多指和鼠标按键组合；需要其他手势时在自定义内容中自行处理。内置区域手势不变。
