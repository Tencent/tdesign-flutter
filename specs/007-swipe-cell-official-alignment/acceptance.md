# TSwipeCell 官方对齐修复 - 验收记录

## 验证环境

- 分支：`rss1102/cnb-issue-82/fix/swipe-cell-official-alignment`
- 提交：待补
- Flutter/Dart：本地无 `flutter` / `dart` 环境，编译与 lint 由 CI（`.cnb.yml` 的 `flutter analyze --fatal-infos` + apk/web 双版本构建）兜底验证。

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze --fatal-infos` | 待 CI | 本地无环境，由 CI 在 flutter 3.32.0 / latest 执行 |
| `flutter test` | 待 CI | 本地无环境，依赖后续验证 |
| `flutter build apk` / `flutter build web` | 待 CI | 双版本构建兜底 |

## 人工验收

- [ ] 打开/关闭阈值按面板宽度 30% 触发，滑动手感与官方一致
- [ ] 展开/收起动画 600ms，节奏与官方一致
- [ ] 面板展开后点击本格 / 外部自动关闭；`closeOnTapOutside: false` 时不关闭
- [ ] 操作项图标 20px、间距 8px、左右内边距 16px，视觉与官方一致
- [ ] 站点文档含 `closeOnScroll` / `closeOnTapOutside`；示例无调试输出

## 未覆盖项与后续工作

- 面板宽度“内容自适应”模型（官方内容撑开 vs Flutter `extentRatio` 固定比例）未纳入，属框架形态差异，工程量大且含 breaking，另行评估。
