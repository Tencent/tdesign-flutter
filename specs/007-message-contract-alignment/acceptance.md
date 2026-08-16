# 验收记录

## 验证环境

- 分支：`rss1102/cnb-issue-71/feat/message-contract-alignment`（待创建）
- 提交：（待 PR 后回填）
- Flutter/Dart：目标 `flutter@3.32.0` 与 `flutter@latest`（本 CNB 沙箱无法本地安装 Flutter，验证依赖 CI）

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze --fatal-infos` | 待 CI | CNB `.cnb.yml` 已含 analyze（3.32.0 & latest） |
| `flutter test test/components/message/` | 待 CI | 依赖 CI / GitHub workflow |
| LCOV 覆盖率（`lib/src/components/message/`） | 待 CI | 目标 ≥95%，需真机/CI 生成 |
| codegen `--check` | 待 CI | `.txt` 已按 codegen 提取逻辑手动生成 |
| `node scripts/check-flutter-component-contracts.mjs` | 待 CI | 站点/组件契约 |

## 人工验收

- [x] 官方 Demo 矩阵（小程序 / Mobile Vue / Flutter）已一一对应补齐。
- [x] `example/assets/code/message.*.txt` 已与示例页同步（删除 `message._marquee.txt`，新增 12 个 Demo 片段）。
- [x] 站点 `README.md` 已对齐现网 API（`TMessage.show` / `TMessageVariant` / `TMessageLink` / `TMessageMarquee` / `showIcon` / `showCloseButton` / `onCloseButtonPressed` / `onLinkPressed`）。
- [x] 图标-文本间距对齐官方 `@spacer` = 8px，同步 marquee 宽度计算。
- [x] 未新增 / 未删除 / 未重命名任何公共 API。

## 未覆盖项与后续工作

- 本沙箱无 Flutter / Dart 运行环境，`flutter analyze`、`flutter test`、LCOV 覆盖率无法本地实测，需由 CI / GitHub workflow 兜底；覆盖率数值与"未验证/阻塞"的像素项在 Issue 汇报中明确标注，不声称已对齐。
- 像素级 Review 中以下项目标记为"未验证/阻塞"，需真机截图 / 测量确认，此 PR 未改动：
  - 默认定位（距顶 80px 居中卡片 vs 官方贴顶全宽条带）——视觉 breaking change，需维护者另行拍板；
  - 阴影（Material elevation 6 vs 官方 `@shadow-1`/`@shadow-4`）；
  - 图标尺寸（Flutter 约束 20×22 vs 官方 44rpx=22px）。
- `align` / `gap` / `single` / 自定义 content Widget / `marquee` 的 `speed`/`loop` 语义等官方能力，现有公开 API 未覆盖，属潜在增强，未纳入本次最小实现。
