---
title: Checkbox 多选框
description: 用于预设的一组选项中执行多项选择，并呈现选择结果。
spline: base
isComponent: true
---

## 代码演示

{{ flutter-example-group checkbox }}

{{ flutter-api checkbox }}

## FAQ

### 1.0.0 → 1.0.1 升级需要适配什么？

- 自定义 `implements TCheckboxGroup` 须补 `onSelectionLimitExceeded` getter，返回原 `onMaxSelected`，否则无法编译。
- 已有子类若存在同名业务成员，需核对类型和语义；冲突时重命名，或按新契约适配。
