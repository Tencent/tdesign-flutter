# TSwipeCell 组件 Review 修复 - 任务清单

## TODO

- [ ] 在 CI 上运行 `flutter analyze` 确认无告警
- [ ] 在 CI 上运行 `flutter test test/components/swipe_cell/` 与 `test/acceptance/theme_acceptance_test.dart`
- [ ] 确认 `flutter@3.32.0` 与 `flutter@latest` 双版本构建通过

## DOING

- [x] 补齐 `TSwipeCellThemeData` 视觉字段与 `copyWith` / `merge` / `lerp`
- [x] `TSwipeCellAction` 实现 P0 > P1 > P4 优先级解析与布局对称
- [x] 新增 `TSwipeCellAction.id` 并接入 `actionClick`
- [x] 补充 `groupTag` / `closeOnScroll` / `confirms` 文档
- [x] 补充单元测试与主题验收测试
- [x] 创建 Spec `004-swipe-cell-theme-review-fixes`

## DONE

- （提交 PR 后更新）
