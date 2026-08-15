# TInput label 对齐设计稿并补齐 H5 组件能力

## 背景

Issue #54：TInput 的 label 实现没对齐设计稿。

设计稿与 H5（tdesign-mobile-vue）端要求：输入框的 label 是**输入框左侧的固定标签**（横向一行排列），必填项在标签后带红色 `*`（如「标签文字*」），下方输入区占位为「请输入文字」。

当前 `TInput` 的 `label` 直接映射到 Material `TextField` 的 `labelText`，表现为**浮动标签**（聚焦时上浮到输入框上方、失焦且为空时作为占位显示在框内）。这与设计稿的左侧固定标签形态完全不同，因此“没对齐”。

此外，逐项对照 H5（tdesign-mobile-vue）`src/input` 的 `props.ts` / `type.ts` 与 demos，`TInput` 组件层还缺少一批 H5 已有能力（状态 `status`、提示 `tips`、内容对齐 `align`、可清空 `clearable` / 触发方式 `clearTrigger`、字符数 `maxcharacter`、无边框 `borderless`、超长可继续输入 `allowInputOverMax`），需在本 PR 一并补齐到组件层（此前这些仅在示例页用现有能力临时呈现）。

## 目标

- 将 `TInput` 的 `label` 由 Material 浮动标签改为**输入框左侧的固定标签**（默认横向布局），与设计稿及 H5 对齐。
- 新增 `required` 能力：必填时在标签后展示红色 `*`（如「标签文字*」）。
- 新增 `layout` 能力：支持 `horizontal`（label 在左，默认）与 `vertical`（label 在上）。
- 新增 H5 对齐的组件能力：`status`、`tips`、`align`、`clearable`、`clearTrigger`、`maxcharacter`、`borderless`、`allowInputOverMax`。
- 保持占位 `hintText` 独立于 label，仅显示在输入区内。

## 非目标

- 不改动 `TInput.multiline` 的多行输入行为，仅同步 label 布局形态与上述新能力。
- 不实现 H5 的 `format`（展示值格式化）、`autocomplete` / `enterkeyhint` / `spellCheck` / `name` 等 HTML 原生透传属性（超出组件视觉与交互范围，可后续单独处理）。
- 不改变控制器、回调、校验、既有格式化等能力的语义。

## 范围

### 涉及

- `tdesign-component/lib/src/components/input/t_input.dart`
- `tdesign-component/lib/src/components/input/t_input_theme_data.dart`（如需要补充 label / 状态样式主题）
- `tdesign-component/lib/src/components/input/t_input_resolve.dart`
- `tdesign-component/example/lib/page/t_input_page.dart`（示例）
- `tdesign-component/test/components/input/t_input_test.dart`（测试）
- `tdesign-component/example/assets/api/input_api.md`（API 文档，如与实现不一致需同步）

### 不涉及

- `TTextarea`（未在本仓库发现独立实现，若后续存在另行处理）。
- 表单联动（`TForm` / `TFormItem`）逻辑。

## 行为契约

1. **`label` 语义变更（breaking change）**：传入 `label` 时，在输入框左侧渲染固定标签文本（横向布局），不再使用 Material 浮动标签。未传 `label` 时行为与现状一致（纯输入框）。
2. **`required`（新增，bool，默认 false）**：为 `true` 且存在 `label` 时，在标签文本后渲染红色 `*`（`context.tTheme.errorColor6`，即 #D54941）。
3. **`layout`（新增，`TInputLayout`，默认 `horizontal`）**：
   - `horizontal`：`label` 在输入框左侧，同一行排列。
   - `vertical`：`label` 在输入框上方，换行排列。
4. **`status`（新增，`TInputStatus`，默认 `normal`）**：`success` / `warning` / `error` 分别影响输入区边框/下划线颜色与 `tips` 文本颜色（`successNormalColor` / `warningNormalColor` / `errorNormalColor`）；`normal` 保持默认。
5. **`tips`（新增，String?，默认 null）**：在输入区下方渲染辅助提示文本，颜色随 `status`（默认 `textColorPlaceholder`，`success`/`warning`/`error` 分别用对应色）。
6. **`align`（新增，`TInputAlign?`，默认 null）**：`left` / `center` / `right` 映射到输入内容对齐方式；未传时回退到现有 `textAlign`。
7. **`clearable`（新增，bool?，默认 null）**：为 `false` 时关闭内置清除按钮；为 `null`/`true` 时按既有规则（有值且无 `suffix`）显示。
8. **`clearTrigger`（新增，`TInputClearTrigger`，默认 `always`）**：`focus` 时仅在输入框聚焦且有值时显示清除按钮；`always` 时有值即显示。
9. **`maxcharacter`（新增，int?，默认 null）**：限制最大字符数，一个汉字计 2 个字符长度；与 `maxlength` 二选一使用（`maxcharacter` 优先）。
10. **`borderless`（新增，bool，默认 false）**：为 `true` 时使用无边框模式（各状态边框均为 `InputBorder.none`）。
11. **`allowInputOverMax`（新增，bool，默认 false）**：为 `true` 且设置了 `maxlength` / `maxcharacter` 时，允许输入超过上限（不做硬性截断）；默认 `false` 则超限截断。
12. **`hintText`** 仍为输入区占位文本，独立于 label，不因 label 存在与否而变化。
13. **label 样式**：默认使用 body 字号、主题主文本色；`vertical` 时 label 下方与输入区保留间距。label 与输入区之间保留固定间距。
14. **兼容性**：多行输入框（`TInput.multiline`）同样遵循上述 label 布局与新增能力。

## 验收标准

- [ ] `TInput(label: '标签文字')` 在输入框左侧渲染固定标签文本，而非 Material 浮动标签（聚焦不浮起、为空时不作为占位）。
- [ ] `TInput(label: '标签文字', required: true)` 在标签后渲染红色 `*`。
- [ ] `TInput(label: '标签文字', layout: vertical)` 将 label 渲染在输入框上方。
- [ ] `TInput(status: TInputStatus.error, tips: '辅助说明')` 渲染错误态边框与对应颜色提示文本。
- [ ] `TInput(align: TInputAlign.right, label: '价格')` 将输入内容居右对齐。
- [ ] `TInput(clearable: false)` 不显示内置清除按钮；`clearTrigger: focus` 时仅聚焦显示。
- [ ] `TInput(maxcharacter: 10)` 输入 11 个字符（含汉字）时按“汉字算 2”规则截断。
- [ ] `TInput(borderless: true)` 无边框；`allowInputOverMax: true` 时超限不截断。
- [ ] 未传 `label` 的纯输入框行为与改动前一致。
- [ ] 占位 `hintText` 独立显示，不受 label 影响。
- [ ] `flutter analyze` 通过（0 error / 0 warning / 0 info）。
- [ ] 示例页、dartdoc 注释、API 文档随实现同步更新。
