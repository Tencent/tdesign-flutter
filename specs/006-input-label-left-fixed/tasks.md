# TInput label 对齐设计稿 —— 任务清单

## TODO

- [ ] `flutter analyze` 通过（CI 兜底）

## DOING

- 无

## DONE

- [x] 分析 H5 demos 源码与设计稿，确认目标行为
- [x] 创建 Spec `specs/006-input-label-left-fixed`
- [x] 新增 `required`、`layout` 参数并重构 `label` 为左侧固定标签（`t_input.dart`）
- [x] 调整 `t_input_resolve.dart` 移除 label → `labelText` 映射
- [x] 同步更新 `TTextarea`（继承新 label 语义）及其注释
- [x] 更新示例页 `t_input_page.dart`，分组/文案/示例完全对齐 H5（tdesign-mobile-vue）`src/input/demos`（01 组件类型 / 02 组件状态 / 03 组件样式），新增 maxcharacter 自定义 formatter、error 状态、align 内容位置、非通栏/标签外置/自定义样式等示例
- [x] 更新 dartdoc 注释与 API 文档（input_api.md / textarea_api.md）
- [x] 更新测试 `t_input_test.dart` 与 `t_textarea_test.dart`
