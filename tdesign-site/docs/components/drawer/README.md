---
title: Drawer 抽屉
description: 用于从屏幕侧边展示导航菜单或自定义内容。
spline: base
isComponent: true
---

## 代码演示

{{ flutter-example-group drawer }}

{{ flutter-api drawer }}

## FAQ

### 1.0.0 → 1.0.1 升级需要适配什么？

- 自定义 `implements TDrawer` 须补 `onItemTap` getter，返回原 `onItemClick`，否则无法编译。
- 已有子类若存在同名业务成员，需核对类型和语义；冲突时重命名，或按新契约适配。
- 自定义菜单文字开始继承菜单默认字体；保留旧外观请显式设置所需样式。
