# TInput label 对齐设计稿并补齐 H5 组件能力 —— 任务清单

## TODO

- [ ] 本地/CI 跑通 `flutter analyze`（0 error / 0 warning / 0 info）与组件测试

## DOING

- 无

## DONE

- [x] 分析 H5（tdesign-mobile-vue）`src/input` props / type / demos，确认目标行为与组件层差距
- [x] 创建并更新 Spec `specs/006-input-label-left-fixed`
- [x] 新增 `required`、`layout` 参数并重构 `label` 为左侧固定标签（`t_input.dart`）
- [x] 新增组件层能力：`status`（`TInputStatus`）、`tips`、`align`（`TInputAlign`）、`clearable`、`clearTrigger`（`TInputClearTrigger`）、`maxcharacter`、`borderless`、`allowInputOverMax`
- [x] 调整 `t_input_resolve.dart` 移除 label → `labelText` 映射
- [x] 更新示例页 `t_input_page.dart`，分组/文案/示例完全对齐 H5（tdesign-mobile-vue）`src/input/demos`，并改用组件层新 API（status/tips/align/maxcharacter/borderless）
- [x] 更新 dartdoc 注释与 API 文档（input_api.md）
- [x] 更新测试 `t_input_test.dart`，覆盖新增能力
