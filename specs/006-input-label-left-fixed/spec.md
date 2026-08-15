# TInput label 对齐设计稿（左侧固定标签）

## 背景

Issue #54：TInput 的 label 实现没对齐设计稿。

设计稿与 H5（tdesign-mobile-vue）端要求：输入框的 label 是**输入框左侧的固定标签**（横向一行排列），必填项在标签后带红色 `*`（如「标签文字*」），下方输入区占位为「请输入文字」。

当前 `TInput` 的 `label` 直接映射到 Material `TextField` 的 `labelText`，表现为**浮动标签**（聚焦时上浮到输入框上方、失焦且为空时作为占位显示在框内）。这与设计稿的左侧固定标签形态完全不同，因此“没对齐”。

## 目标

- 将 `TInput` 的 `label` 由 Material 浮动标签改为**输入框左侧的固定标签**（默认横向布局），与设计稿及 H5 对齐。
- 新增 `required` 能力：必填时在标签后展示红色 `*`（如「标签文字*」）。
- 新增 `layout` 能力：支持 `horizontal`（label 在左，默认）与 `vertical`（label 在上）。
- 保持占位 `hintText` 独立于 label，仅显示在输入区内。

## 非目标

- 不实现 H5 的 `align`（输入内容左/中/右对齐）能力（超出本 Issue 范围，可后续单独处理）。
- 不改动 `TInput.multiline` 的多行输入行为，仅同步 label 布局形态。
- 不改变控制器、回调、校验、清除按钮、格式化等既有能力。

## 范围

### 涉及

- `tdesign-component/lib/src/components/input/t_input.dart`
- `tdesign-component/lib/src/components/input/t_input_theme_data.dart`（如需要补充 label 样式主题）
- `tdesign-component/lib/src/components/input/t_input_resolve.dart`
- `tdesign-component/example/lib/page/t_input_page.dart`（示例）
- `tdesign-component/test/components/input/t_input_test.dart`（测试）
- `tdesign-site/docs/components/input/README.md`（站点文档，如与实现不一致需同步）

### 不涉及

- `TTextarea`（未在本仓库发现独立实现，若后续存在另行处理）。
- 表单联动（`TForm` / `TFormItem`）逻辑。

## 行为契约

1. **`label` 语义变更（breaking change）**：传入 `label` 时，在输入框左侧渲染固定标签文本（横向布局），不再使用 Material 浮动标签。未传 `label` 时行为与现状一致（纯输入框）。
2. **`required`（新增，bool，默认 false）**：为 `true` 且存在 `label` 时，在标签文本后渲染红色 `*`（`context.tTheme.errorColor6`，即 #D54941）。
3. **`layout`（新增，`TInputLayout`，默认 `horizontal`）**：
   - `horizontal`：`label` 在输入框左侧，同一行排列。
   - `vertical`：`label` 在输入框上方，换行排列。
4. **`hintText`** 仍为输入区占位文本，独立于 label，不因 label 存在与否而变化。
5. **label 样式**：默认使用 body 字号、主题主文本色；`vertical` 时 label 下方与输入区保留间距。label 与输入区之间保留固定间距。
6. **兼容性**：多行输入框（`TInput.multiline`）同样遵循上述 label 布局。

## 验收标准

- [ ] `TInput(label: '标签文字')` 在输入框左侧渲染固定标签文本，而非 Material 浮动标签（聚焦不浮起、为空时不作为占位）。
- [ ] `TInput(label: '标签文字', required: true)` 在标签后渲染红色 `*`。
- [ ] `TInput(label: '标签文字', layout: vertical)` 将 label 渲染在输入框上方。
- [ ] 未传 `label` 的纯输入框行为与改动前一致。
- [ ] 占位 `hintText` 独立显示，不受 label 影响。
- [ ] `flutter analyze` 通过（0 error / 0 warning）。
- [ ] 示例页、dartdoc 注释随实现同步更新。
