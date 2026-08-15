# TInput label 对齐设计稿 —— 验收记录

## 执行环境

- 当前环境未安装 Flutter/Dart，无法本地执行 `flutter analyze` / `flutter test`。
- 由 CI（`.cnb.yml` 中 `flutter analyze`，`--fatal-infos`）作为 lint 兜底；组件测试由 CI 的 test 步骤执行。

## 已完成的改动

- `t_input.dart`：新增 `TInputLayout` 枚举与 `required`、`layout` 参数；`label` 由 Material 浮动标签改为输入框左侧固定标签（横向默认 / `vertical` 换行在上）；`required` 时在标签后渲染红色 `*`（`errorColor6` #D54941）。
- `t_input_resolve.dart`：移除 `label` 到 `labelText` 的映射。
- `t_textarea.dart`：继承新 label 语义，注释同步更新。
- 示例页 `t_input_page.dart`、API 文档（`input_api.md` / `textarea_api.md`）同步更新。
- 测试：更新 `t_input_test.dart` / `t_textarea_test.dart` 断言，并新增 label 布局、required、layout 用例。
- 按评审意见，示例页 `t_input_page.dart` 重构为**完全对齐 H5（tdesign-mobile-vue）`src/input/demos`**：分组 01 组件类型 / 02 组件状态 / 03 组件样式，desc 文案与 H5 逐一对应（基础输入框、带字数限制输入框、带操作输入框、带图标输入框、特定类型输入框、输入框状态、信息超长状态、内容位置、竖排样式、非通栏样式、标签外置样式、自定义样式输入框）；新增 `_MaxCharacterTextInputFormatter` 示例对齐 H5 `maxcharacter`（汉字算两个）、error 状态与 tips、`align` 内容位置、非通栏/标签外置/自定义样式等示例，全部用现有组件能力实现（未改组件层 API）。

## 待人工/CI 验证

- [ ] `flutter analyze`：0 error / 0 warning。
- [ ] `flutter test tdesign-component/test/components/input/` 与 `.../textarea/` 全部通过。
- [ ] 视觉验收：`TInput(label: '标签文字', required: true)` 呈现左侧固定标签 + 红色 `*`，与设计稿一致。
