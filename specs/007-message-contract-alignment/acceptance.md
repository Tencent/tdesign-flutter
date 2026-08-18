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
| LCOV 覆盖率（`lib/src/components/message/`） | ✅ 98.21% | LH=220, LF=224 |
| `dart run tool/generate_example_code.dart --check` | ✅ 通过 | 生成片段与示例页一致 |

## 人工验收

- [x] 官方 Demo 矩阵（小程序 / Mobile Vue / Flutter）已一一对应补齐。
- [x] `example/assets/code/message.*.txt` 已与示例页同步（删除 `message._marquee.txt`，新增 12 个 Demo 片段）。
- [x] 站点 `README.md` 已对齐现网 API（`TMessage.show` / `TMessageVariant` / `TMessageLink` / `TMessageMarquee` / `showIcon` / `showCloseButton` / `onCloseButtonPressed` / `onLinkPressed`）。
- [x] 图标-文本间距对齐官方 `@spacer` = 8px，同步 marquee 宽度计算。
- [x] 多消息使用不同垂直偏移展示且保持可见，关闭全部通知可定向移除所有句柄。
- [x] 未新增 / 未删除 / 未重命名任何公共 API。

## 未覆盖项与后续工作

- 像素级 Review 中以下项目标记为"未验证/阻塞"，需真机截图 / 测量确认，此 PR 未改动：
  - 默认定位（距顶 80px 居中卡片 vs 官方贴顶全宽条带）——视觉 breaking change，需维护者另行拍板；
  - 阴影（Material elevation 6 vs 官方 `@shadow-1`/`@shadow-4`）；
  - 图标尺寸（Flutter 约束 20×22 vs 官方 44rpx=22px）。
- `align` / `gap` / `single` / 自定义 content Widget / `marquee` 的 `speed`/`loop` 语义等官方能力，现有公开 API 未覆盖，属潜在增强，未纳入本次最小实现。
