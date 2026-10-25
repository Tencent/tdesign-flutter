---
title: TabBar 标签栏
description: 用于在不同功能模块之间进行快速切换，位于页面底部。
spline: base
isComponent: true
---

## 代码演示

{{ flutter-example-group tabBar }}

{{ flutter-api tab-bar }}

## FAQ

### 1.0.0 → 1.0.1 升级需要适配什么？

- 自定义 `implements TTabBarItemConfig` 须补 `notifyOnReselect` getter，返回原 `allowMultipleTaps`；`implements TTabBarPopUpBtnConfig` 须补 `onSelected` getter，返回原 `onChanged`。否则无法编译；getter 不执行回调。
- 已有子类若存在同名业务成员，需核对类型和语义；冲突时重命名，或按新契约适配。
- 自定义菜单项开始继承默认字体并适配实际行高；保留旧外观请显式定制，检查溢出和定位。
