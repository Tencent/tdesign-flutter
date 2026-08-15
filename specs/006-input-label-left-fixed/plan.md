# TInput label 对齐设计稿 —— 技术方案

## 现状

`TInput` 是 Material `TextField` 的薄封装。`label` 通过 `TInputResolve.resolveDecoration` 映射到 `InputDecoration.labelText`，表现为 Material 浮动标签。

## 方案

将 `TInput` 从“纯 TextField 封装”改为“自绘布局 + 内部 TextField”：

1. 外层用 `Column` / `Row` 承载 label 与输入区：
   - `horizontal`（默认）：`Row[ label区, Expanded(输入区) ]`
   - `vertical`：`Column[ label区, 输入区 ]`
2. label 区：渲染 label 文本；`required` 为 true 时追加红色 `*`（`errorColor6` #D54941）。横向时 label 右/下保留间距并垂直居中；纵向时 label 下保留间距。
3. 输入区：保留现有 `TextField` 及全部既有能力（控制器、回调、清除、格式化、校验等）。由于 label 不再走 `labelText`，`TInputResolve` 中 label 相关映射需移除/调整。

## API 变化

新增参数：

- `required`（bool，默认 false）：是否展示必填 `*`。
- `layout`（`TInputLayout?`，默认 `horizontal`）：label 与输入区的排布。

变更语义（breaking change）：

- `label`：由 Material 浮动标签改为左侧固定标签。

## 风险

- **breaking change**：现有使用 `label` 作为浮动标签的调用方视觉会变化。通过示例与 dartdoc 同步说明。
- 布局需自行处理 label 与输入区对齐（横向垂直居中）、间距、`vertical` 排布，需在测试中覆盖。
- Flutter 3.32.0 与 latest 均使用标准 `Row`/`Column`/`Text`，无版本差异。

## 验证

- 更新 `t_input_test.dart`：覆盖 label 固定渲染、required `*`、layout 两种排布、无 label 时行为不变。
- `flutter analyze` 零告警。
