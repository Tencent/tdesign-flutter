# TProgress

> **状态**：已实现 | **控制类**：纯展示 | **Sprint**：S2

**源码路径**：`lib/src/components/progress`

## 架构

`TProgress` 在 Material `LinearProgressIndicator` / `CircularProgressIndicator` 之上补充 TDesign 的标签和视觉形态。组件没有点击行为，也不缓存外部业务值。

- `value` 为 `null` 时展示 indeterminate 进度。
- 非空 `value` 自动限制在 0 到 1。
- `label` 直接接受标准 `Widget`，不引入专用包装类型。
- `TProgressThemeData` 只承载视觉默认，不承载 Widget、回调或业务状态。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `variant` | `TProgressVariant` | 必填 | `linear`、`circular`、`micro` 或 `button` |
| `value` | `double?` | `null` | 确定进度，null 表示不确定进度 |
| `label` | `Widget?` | `null` | 自定义标签 |

`button` 仅表示按钮外观的进度条，不提供点击行为。需要交互时由调用方在组件外组织 Button。

## Theme

`TProgressThemeData` 包含粗细、颜色、背景色、圆角、半径、标签显隐和位置、标签布局及动画时长。所有字段都是视觉默认值。

## Export

公开导出 `TProgress`、`TProgressVariant`、`TProgressLabelPosition` 和 `TProgressThemeData`。内部 indicator 与 painter 不公开。

## 验收

- 四种 variant、确定/不确定进度、边界值、标签位置和更新生命周期均有测试。
- Progress 源码逐文件覆盖率均高于 99%。
