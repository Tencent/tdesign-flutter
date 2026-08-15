# TInput label 对齐设计稿并补齐 H5 组件能力 —— 验收记录

## 执行环境

- 当前工作环境未安装 Flutter/Dart，无法本地执行 `flutter analyze` / `flutter test`。
- 由 CI（`.cnb.yml` 中 `flutter analyze --fatal-infos`）作为 lint 兜底；组件测试由 CI 的 test 步骤执行。

## 已完成的改动

- `t_input.dart`：
  - 新增 `TInputLayout`（horizontal/vertical）、`TInputStatus`（normal/success/warning/error）、`TInputAlign`（left/center/right）、`TInputClearTrigger`（always/focus）枚举。
  - 新增参数 `required`、`layout`、`status`、`tips`、`align`、`clearable`、`clearTrigger`、`maxcharacter`、`borderless`、`allowInputOverMax`。
  - `label` 由 Material 浮动标签改为输入框左侧固定标签（横向默认 / `vertical` 换行在上）；`required` 时在标签后渲染红色 `*`（`errorColor6` #D54941）。
- `t_input_resolve.dart`：移除 `label` 到 `labelText` 的映射。
- 示例页 `t_input_page.dart`、API 文档（`input_api.md`）同步更新。
- 测试：更新 `t_input_test.dart` 断言，并新增 label 布局、required、layout、status/tips、align、clearable/clearTrigger、maxcharacter、borderless、allowInputOverMax 用例。
- 示例页 `t_input_page.dart` 重构为**完全对齐 H5（tdesign-mobile-vue）`src/input/demos`**：分组 01 组件类型 / 02 组件状态 / 03 组件样式，desc 文案与 H5 逐一对应，全部改用组件层新 API（不再使用示例层私有 formatter / decoration 临时方案）。

## 待人工/CI 验证

- [ ] `flutter analyze`：0 error / 0 warning / 0 info。
- [ ] `flutter test tdesign-component/test/components/input/` 全部通过。
- [ ] 视觉验收：`TInput(label: '标签文字', required: true)` 呈现左侧固定标签 + 红色 `*`；`TInput(status: TInputStatus.error, tips: '辅助说明')` 呈现错误态边框与提示；`TInput(align: TInputAlign.right, label: '价格')` 内容右对齐；`TInput(maxcharacter: 10)` 汉字算 2；`TInput(borderless: true)` 无边框。
