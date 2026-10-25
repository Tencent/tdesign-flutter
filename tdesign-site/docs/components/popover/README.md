---
title: Popover 弹出气泡
description: 用于文字提示的气泡框。
spline: base
isComponent: true
---

## 代码演示

{{ flutter-example-group popover }}

{{ flutter-api popover }}

## FAQ

### 1.0.0 → 1.0.1 升级需要适配什么？

- 自定义 `implements TPopoverAnchor` / `TPopoverWidget` 须补 `onLongPress` getter，返回原 `onLongTap`，否则无法编译。
- 已有子类若存在同名业务成员，需核对类型和语义；冲突时重命名，或按新契约适配。
- 自定义内容开始继承气泡字体和颜色，尺寸按实际样式测量；保留旧外观请显式定制，并检查换行、尺寸和背景对比度。
