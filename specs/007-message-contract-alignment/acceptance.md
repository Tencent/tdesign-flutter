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
- [x] 站点 `README.md` 已对齐现网 API（`TMessage.show` / `TMessageStatus` / `TMessageMarquee` / `action` / `showIcon` / `showCloseButton` / `onCloseButtonPressed`）。
- [x] 图标-文本间距对齐官方 `@spacer` = 8px，同步 marquee 宽度计算。
- [x] Mobile Vue / Flutter 扩展的“关闭所有通知”不再作为小程序公开 Demo 基线；底层 dismiss 能力保留。
- [x] 操作 API 已收敛为 `Widget? action`，移除 `TMessageLink` / `link` / `onLinkPressed` 的拆分状态。
- [x] 已使用微信开发者工具截取小程序实际页，并与 Flutter 3.32.0 Linux 明暗整页 Golden 比对。

## 未覆盖项与后续工作

- `align` / `gap` / 自定义 content Widget / `marquee` 的 `speed`/`loop` 语义等官方能力，现有公开 API 未覆盖，属潜在增强，未纳入本次最小实现。
- `TMessageVariant/variant` 已迁移为 `TMessageStatus/status`，不再保留语义不准确的别名。

## 2026-08-31 develop 同步复验

- 已合并 `origin/develop@fb26b8d5`，保留 Message 回归登记并采用 develop 的共享测试基建。
- CI 同款 Flutter 3.32.0 Linux：页面 light/dark 与点击“带关闭的通知”后的 Overlay light/dark Golden 共 4 项，更新后不带 `--update-goldens` 复跑通过。
- Flutter 3.32.0 与 3.47.0：25 个组件测试、Demo 功能测试和 `flutter analyze --fatal-infos --no-pub` 均通过。
- 当时的 API 收敛复核未改公共 API；后续的完整收敛与销毁闭环见下方 2026-09-01 记录。

## 2026-08-31 默认契约对齐（待最终复验）

- [x] 已以小程序实际触发态与源码默认值为可见基线；跨端永久展示按行为映射为 Flutter `duration: null`，不复制数值哨兵。
- [x] 声明式 `visible` 默认改为 false；`show()` 显式展示，默认 3 秒后动画关闭并移除 Overlay。
- [x] 默认几何改为安全区与导航栏后的可视全宽条带；默认字体、图标和阴影改为 `bodyMedium`、22px 和 `shadowsBase`。
- [x] 未传 offset 的连续触发只保留当前消息；显式不同 offset 继续允许多消息，未新增 `single` 或 Theme 同义状态。
- [x] Flutter 3.32.0 Message 组件测试 29/29 通过；严格 analyze 0 error / 0 warning。
- [x] `lib/src/components/message/` 覆盖率 96.76%（LH=239，LF=247）。
- [x] Flutter 3.32.0 Linux 明暗页面与点击后 Overlay Golden 共 4 项更新后无参数复跑通过；实际变更为点击后的 light / dark 两张 Overlay 基线。
- [x] Message Demo 功能测试与示例 codegen `--check` 通过。
- [ ] Android 真机已在改动前成功安装启动，但验证时设备断开；重连后补充点击、3 秒关闭和常驻消息截图。

## 2026-08-31 操作与时长 API 收敛（待复验）

- [x] `TMessageLink`、`link` 与 `onLinkPressed` 已替换为 `Widget? action`，操作组件完整持有外观和行为。
- [x] `duration: null` 是唯一永久展示表达；非 null 时长必须为正数。
- [x] 更新 Message 组件测试、Demo 功能测试、API 生成文档及明暗页面 / 触发态 Golden。
- [x] Flutter 3.32.0 Linux 容器中 Message 页面与带关闭通知展开态 Golden 更新后复跑 4/4 通过。
- [x] Message Demo 结构与操作点击测试 2/2 通过，`generate_example_code.dart --check` 与组件契约检查通过。
- [ ] Flutter latest 双版本分析与 Android 真机更新后点击验收，待后续 CI / 设备可用时补验。

## 2026-09-01 API 与资源销毁闭环复验

- [x] `TMessageHandle.dismiss()`、默认消息替换、关闭动画与 Overlay 卸载复用同一幂等销毁入口；释放 entry listener、handle 闭包和 Expando slot，`onDismissed` 最多回调一次。
- [x] 覆盖重复 dismiss、自动关闭后再 dismiss、Overlay 根节点销毁、首帧前连续 show 与替换回调重入 show。
- [x] `visible=false` 时更新 duration / marquee 不创建有效 Timer 或启动 AnimationController；切换隐藏会取消所有计时和动画。
- [x] 跑马灯使用 `Expanded` 真实约束，不再按 action 最大宽度重复预估。
- [x] `TMessageVariant/variant` 迁移为独立 types 边界的 `TMessageStatus/status`；删除 `TMessageThemeData.defaultOffset`，位置只由实例 `offset` 控制。
- [x] Flutter 3.32.0：Message 组件 36/36、Demo 功能 2/2、严格 analyze 0 问题，生产源码覆盖率 254/258 = 98.45%，回归登记自测 11/11。
- [x] Flutter 3.47.0：clean 后 Message 组件 36/36、Demo 功能 2/2、严格 analyze 0 问题。
- [x] 示例 codegen `--check`、Message API 源码生成与组件站点契约检查通过。
- [x] Flutter 3.32.0 Linux Golden 已在 CI 同款镜像中更新并无参数复跑 22/22 通过，未使用 macOS 结果覆盖 Linux 基线。

## 2026-09-01 十入口触发态 Golden 完备复验

- [x] 小程序公开 Demo 的十个入口均通过真实滚动与点击触发目标状态；初始隐藏页不替代触发态证据。
- [x] 每个入口均保存 Flutter 3.32.0 Linux light / dark Overlay Golden；加上明暗初始页面共 22 项，更新后无参数复跑 22/22 通过。
- [x] 循环跑马灯在点击后固定 400ms 保存快照，不使用无法收敛的 `pumpAndSettle`，连续两次 Linux 测试结果一致。
- [x] Demo 功能测试覆盖十个入口的展示与生命周期，并真实点击关闭按钮、声明式隐藏及“按钮”/“链接”操作，13/13 通过。
- [x] Flutter 3.32.0 / 3.47.0：Message 组件测试 36/36、Demo 功能测试 13/13、严格 analyze 0 问题。
- [x] Message 生产源码覆盖率维持 254/258 = 98.45%，组件与视觉回归登记自测 6/6 通过。
