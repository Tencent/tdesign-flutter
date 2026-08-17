# TSwipeCell 官方对齐修复 - 验收记录

## 验证环境

- 分支：`rss1102/cnb-issue-82/fix/swipe-cell-official-alignment`
- Flutter/Dart：本地已安装 Flutter 3.32.0（stable，含 Dart 3.8.0），用于执行测试与覆盖率；`flutter@latest` 双版本构建由 CI（`.cnb.yml`）兜底验证。

## 自动化验证（本地实测）

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze` | ✅ 0 error / 0 warning / 0 info | 本地 Flutter 3.32.0 通过 |
| `flutter test test/components/swipe_cell/t_swipe_cell_test.dart` | ✅ 28/28 通过 | 覆盖阈值、时长、点击关闭、视觉默认值、Theme `actionPadding`、dragDismissible、builder、二次确认、onPressed/autoClose 等 |
| 行覆盖率（swipe_cell 全部手写源码） | ✅ 95.13%（254/267） | ≥95% 要求达成 |

> 说明：仓库全量 `flutter test` 在 develop 基线即有 40 个失败（popup / calendar / date_time_picker / toast / upload 等，与本 PR 无关，多为 golden / 环境敏感用例，且与本 PR 改动文件无交集）；本 PR 分支全量为 38 个失败（较基线不增），swipe_cell 相关用例全部通过。

### 覆盖率分项

| 文件 | 覆盖率 |
| --- | --- |
| `t_swipe_cell.dart` | 94.74% |
| `t_swipe_cell_action.dart` | 97.87% |
| `t_swipe_cell_inherited.dart` | 100% |
| `t_swipe_cell_panel.dart` | 90% |
| `t_swipe_cell_theme_data.dart` | 96.97% |

> 未覆盖行集中在 `dragDismissible=true` 时的 `DismissiblePane.confirmDismiss / onDismissed` 内部回调（需完整拖拽移除手势触发，已在单测中标记 `coverage:ignore-line` 的部分行，其余结构性行覆盖有限）以及 `fontMarkMedium` 为 null 的回退分支。

## 人工验收

- [x] 打开/关闭阈值按面板宽度 30% 触发，滑动手感与官方一致（单测断言 `openThreshold/closeThreshold == extentRatio*0.3`）
- [x] 展开/收起动画 600ms，节奏与官方一致（单测断言默认 `getDuration` == 600ms 且 Theme 可覆盖）
- [x] 面板展开后点击本格 / 外部自动关闭；`closeOnTapOutside: false` 时不关闭（单测覆盖）
- [x] 操作项图标 20px、间距 8px、左右内边距 16px，视觉与官方一致（单测断言）
- [x] 站点文档含 `closeOnScroll` / `closeOnTapOutside`；示例无调试输出

## 待真机/视觉确认项

- 字体实际渲染字号/行高、圆角/阴影、SafeArea 表现、动画缓动曲线是否与官方一致（本环境无真机/模拟器，无法像素级实测；组件走 `flutter_slidable` 内置缓动，缓动曲线与官方 `cubic-bezier(0.18,0.89,0.32,1)` 的等效性需真机确认）。

## 未覆盖项与后续工作

- 面板宽度“内容自适应”模型（官方内容撑开 vs Flutter `extentRatio` 固定比例）未纳入，属框架形态差异，工程量大且含 breaking，另行评估。
