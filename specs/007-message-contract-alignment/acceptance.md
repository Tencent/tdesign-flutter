# 验收记录

## 验证环境

- 分支：`rss1102/cnb-issue-71/feat/message-contract-alignment`
- 提交：`f5ec47d3`
- Flutter/Dart：3.32.0 (Dart 3.8.0) / 3.47.0 (Dart 3.13.0)

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze --fatal-infos`（3.32.0） | ✅ 0 error / 0 warning | lib + test + example |
| `flutter analyze --fatal-infos`（3.47.0） | ✅ 0 error / 0 warning | lib + test + example |
| `flutter test test/components/message/t_message_test.dart`（3.32.0） | ✅ 25/25 通过 | |
| `flutter test test/components/message/t_message_test.dart`（3.47.0） | ✅ 25/25 通过 | |
| LCOV 覆盖率（`lib/src/components/message/`） | ✅ 98.22% | LH=221, LF=225 |
| `dart run tool/generate_example_code.dart --check` | ✅ 通过 | 生成片段与示例页一致 |

## 人工验收

- [x] 小程序公开 Demo 的两个分组与十个触发实例已按顺序收敛。
- [x] `example/assets/code/message.*.txt` 已与两个公开示例容器同步，旧的单实例与关闭所有片段已删除。
- [x] 站点 `README.md` 已对齐现网 API（`TMessage.show` / `TMessageVariant` / `TMessageLink` / `TMessageMarquee` / `showIcon` / `showCloseButton` / `onCloseButtonPressed` / `onLinkPressed`）。
- [x] 图标-文本间距对齐官方 `@spacer` = 8px，同步 marquee 宽度计算。
- [x] Mobile Vue / Flutter 扩展的“关闭所有通知”不再作为小程序公开 Demo 基线；底层 dismiss 能力保留。
- [x] 未新增 / 未删除 / 未重命名任何公共 API。
- [x] 已使用微信开发者工具截取小程序实际页，并与 Flutter 3.32.0 Linux 明暗整页 Golden 比对。

## 未覆盖项与后续工作

- 像素级 Review 中以下项目标记为"未验证/阻塞"，需真机截图 / 测量确认，此 PR 未改动：
  - 默认定位（距顶 80px 居中卡片 vs 官方贴顶全宽条带）——视觉 breaking change，需维护者另行拍板；
  - 阴影（Material elevation 6 vs 官方 `@shadow-1`/`@shadow-4`）；
  - 图标尺寸（Flutter 约束 20×22 vs 官方 44rpx=22px）。
- `align` / `gap` / `single` / 自定义 content Widget / `marquee` 的 `speed`/`loop` 语义等官方能力，现有公开 API 未覆盖，属潜在增强，未纳入本次最小实现。

## 2026-08-31 develop 同步复验

- 已合并 `origin/develop@fb26b8d5`，保留 Message 回归登记并采用 develop 的共享测试基建。
- CI 同款 Flutter 3.32.0 Linux：页面 light/dark 与点击“带关闭的通知”后的 Overlay light/dark Golden 共 4 项，更新后不带 `--update-goldens` 复跑通过。
- Flutter 3.32.0 与 3.47.0：25 个组件测试、Demo 功能测试和 `flutter analyze --fatal-infos --no-pub` 均通过。
- API 收敛复核：未新增、删除或重命名公共 API；仅将图标到文本的内部间距由 10 调为 8，并同步宽度计算。
