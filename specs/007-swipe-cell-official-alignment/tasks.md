# TSwipeCell 官方对齐修复 - 任务清单

## TODO

- [x] 本地验证 `flutter analyze` 无告警（0 error / 0 warning / 0 info）
- [x] 本地验证新增测试通过（28/28）+ 行覆盖率 95.13%
- [x] 提交 PR 并核对模板、Changelog（breaking 加 `⚠️`）

## DOING

- [x] 创建 Spec `007-swipe-cell-official-alignment`
- [x] `t_swipe_cell_panel.dart`：默认阈值 50%→30%
- [x] `t_swipe_cell.dart`：默认动画 200ms→600ms；新增 `closeOnTapOutside`
- [x] `t_swipe_cell_theme_data.dart`：新增 `actionPadding`
- [x] `t_swipe_cell_action.dart`：图标 20 / 间距 8 / 内边距 16；`flex` 注释
- [x] 示例清理 `print` + 同步生成代码 txt
- [x] 站点 README 补 `closeOnScroll` / `closeOnTapOutside`
- [x] 补充测试（阈值、时长、点击关闭、视觉默认值、Theme `actionPadding`）

## DONE

- （待验证后更新）
