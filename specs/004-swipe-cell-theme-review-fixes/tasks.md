# TSwipeCell 组件 Review 修复 - 任务清单

## TODO

- [ ] 确认 `flutter analyze` 无告警（本地无环境，依赖后续人工/CI 确认）
- [ ] 确认新增单元测试与主题验收测试通过（本地无环境，依赖后续验证）

## DOING

- [x] 补齐 `TSwipeCellThemeData` 视觉字段与 `copyWith` / `merge` / `lerp`
- [x] `TSwipeCellAction` 实现 P0 > P1 > P4 优先级解析与布局对称
- [x] 新增 `TSwipeCellAction.id` 并接入 `actionClick`
- [x] 补充 `groupTag` / `closeOnScroll` / `confirms` 文档
- [x] 补充单元测试与主题验收测试
- [x] 创建 Spec `004-swipe-cell-theme-review-fixes`
- [x] 创建 PR #38，CI（flutter 3.32.0 / latest 的 apk + web 构建）通过

## DONE

- （待人工验证测试后更新）
