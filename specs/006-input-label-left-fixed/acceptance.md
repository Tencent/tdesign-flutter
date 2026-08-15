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

## 待人工/CI 验证

- [ ] `flutter analyze`：0 error / 0 warning。
- [ ] `flutter test tdesign-component/test/components/input/` 与 `.../textarea/` 全部通过。
- [ ] 视觉验收：`TInput(label: '标签文字', required: true)` 呈现左侧固定标签 + 红色 `*`，与设计稿一致。
