# TInput label 对齐设计稿并补齐 H5 组件能力 —— 技术方案

## 现状

`TInput` 是 Material `TextField` 的薄封装。`label` 通过 `TInputResolve.resolveDecoration` 映射到 `InputDecoration.labelText`，表现为 Material 浮动标签。对照 H5 `props.ts` / demos，组件层缺少 `status` / `tips` / `align` / `clearable` / `clearTrigger` / `maxcharacter` / `borderless` / `allowInputOverMax` 等能力。

## 方案

将 `TInput` 从“纯 TextField 封装”改为“自绘布局 + 内部 TextField”：

1. 外层用 `Column` / `Row` 承载 label 与输入区：
   - `horizontal`（默认）：`Row[ label区, Expanded(输入区) ]`
   - `vertical`：`Column[ label区, 输入区 ]`
2. label 区：渲染 label 文本；`required` 为 true 时追加红色 `*`（`errorColor6` #D54941）。横向时 label 右/下保留间距并垂直居中；纵向时 label 下保留间距。
3. 输入区：保留现有 `TextField` 及全部既有能力（控制器、回调、清除、格式化、校验等）。新增能力通过以下方式实现：
   - **`status` / `tips`**：`status` 决定边框/下划线颜色（`successNormalColor` / `warningNormalColor` / `errorNormalColor`）与 `tips` 文本颜色；`tips` 渲染到 `InputDecoration.helperText`（保留其样式），`status` 错误态走 `errorBorder`。
   - **`align`**：映射为 `TextField.textAlign`（`left→start` / `center→center` / `right→end`）。
   - **`clearable` / `clearTrigger`**：控制内置清除按钮的显示；`clearTrigger=focus` 时需结合焦点状态（`FocusNode` 监听）判断。
   - **`maxcharacter`**：内置“汉字算 2”的输入格式化器（内部类），与 `maxlength` 二选一。
   - **`borderless`**：所有状态边框置为 `InputBorder.none`。
   - **`allowInputOverMax`**：为 true 时不套用 Material 的硬性 `maxLength` 截断（改用软性校验 / 不自带长度限制）。

## API 变化

新增参数：

- `required`（bool，默认 false）：是否展示必填 `*`。
- `layout`（`TInputLayout?`，默认 `horizontal`）：label 与输入区的排布。
- `status`（`TInputStatus`，默认 `normal`）：`success` / `warning` / `error` 影响边框与 tips 颜色。
- `tips`（String?）：输入区下方提示文本。
- `align`（`TInputAlign?`）：输入内容位置（left/center/right）。
- `clearable`（bool?）：是否可清空。
- `clearTrigger`（`TInputClearTrigger`，默认 `always`）：清除按钮触发方式。
- `maxcharacter`（int?）：最大字符数（汉字算 2）。
- `borderless`（bool，默认 false）：无边框模式。
- `allowInputOverMax`（bool，默认 false）：允许超长继续输入。

新增枚举：`TInputStatus`、`TInputAlign`、`TInputClearTrigger`。

变更语义（breaking change）：

- `label`：由 Material 浮动标签改为左侧固定标签。

## 风险

- **breaking change**：现有使用 `label` 作为浮动标签的调用方视觉会变化。通过示例与 dartdoc 同步说明。
- 布局需自行处理 label 与输入区对齐（横向垂直居中）、间距、`vertical` 排布，需在测试中覆盖。
- `clearTrigger=focus` 依赖焦点状态，需监听 `FocusNode` 并处理失焦/聚焦刷新。
- `maxcharacter` 需自定义 formatter，需注意 IME 组合输入与光标位置。
- Flutter 3.32.0 与 latest 均使用标准 `Row`/`Column`/`Text`/`TextField`，无版本差异。

## 验证

- 更新 `t_input_test.dart`：覆盖 label 固定渲染、required `*`、layout 两种排布、status/tips、align、clearable/clearTrigger、maxcharacter、borderless、allowInputOverMax、无 label 时行为不变。
- `flutter analyze` 零告警。
