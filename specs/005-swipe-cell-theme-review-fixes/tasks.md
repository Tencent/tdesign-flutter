> 2026-10-15 发布前核销：当前自动检查与历史阶段记录分开；证据和保留待办见 [Spec 057](../057-release-readiness-audit/acceptance.md)。

# TSwipeCell 组件 Review 修复 - 任务清单

## TODO

- [x] 当前基线双版本严格 analyze 已通过，历史“本地无环境”待办已核销；见 Spec 057。
- [x] 当前基线 SwipeCell 与主题验收测试已由组件回归入口执行并通过；见 Spec 057。

## DOING

- [x] 补齐 `TSwipeCellThemeData` 视觉字段与 `copyWith` / `merge` / `lerp`
- [x] `TSwipeCellAction` 实现 P0 > P1 > P4 优先级解析与布局对称
- [x] 新增 `TSwipeCellAction.id` 并接入 `actionClick`
- [x] 补充 `groupTag` / `closeOnScroll` / `confirms` 文档
- [x] 补充单元测试与主题验收测试
- [x] 创建 Spec `005-swipe-cell-theme-review-fixes`
- [x] 创建 PR #38，CI（flutter 3.32.0 / latest 的 apk + web 构建）通过

## DONE

- 自动测试待办已核销。上方实现条目保留原阶段记录；最终公开 API 以当前源码及后续 Spec 048 为准。
