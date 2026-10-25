---
title: Steps 步骤条
description: 用于任务步骤展示或任务进度展示。
spline: navigation
isComponent: true
---

## 代码演示

{{ flutter-example-group steps }}

{{ flutter-api steps }}

## FAQ

### 1.0.0 → 1.0.1 升级需要适配什么？

- 自定义 `implements TSteps`、`TStepsHorizontal` 或 `TStepsVertical` 须补 `onStepTapped` getter，返回原 `onChange`，否则无法编译。
- 已有子类若存在同名业务成员，需核对类型和语义；冲突时重命名，或按新契约适配。
- 自定义标题/说明开始继承状态字体；保留旧外观需明确样式，仅设置颜色不会固定字号和字重。
