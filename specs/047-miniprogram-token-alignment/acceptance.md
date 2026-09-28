# 验收记录

## 验证环境

- 分支：`rss1102/refactor/miniprogram-tokens`
- Flutter 基线：`develop`（实施前状态见 Git 历史）
- 小程序基线：`develop@1a1c5ca135b0e9bf19abc43a59870c4908a28ad5`
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| Token 清单与映射审计 | PASS（静态） | 216 个全局键同名；浅/暗模式各有 1 个已批准原始值差（仅 `radiusCircle` 的 CSS `50%` / Flutter `9999dp`），未批准值差、未比较键、引用链差异、Flutter 独有键及缺失 getter 均为 0。804 个组件变量已提取明暗默认表达；Flutter 最终消费值未逐项证明。 |
| 暗色透明色、圆角聚焦测试 | PASS | Flutter 3.32.0 为 148 项，Flutter 3.47.0 为 148 项；BackTop 半圆形使用 `radiusRound`，圆形保留 `radiusCircle`。 |
| `flutter analyze --fatal-infos` | 定向 PASS；全包待清理 | Flutter 3.32.0 和 3.47.0 对本轮 7 个改动的 Dart 文件均零诊断；此前全包检查曾通过，但后续全包运行出现 41 条范围外 `RegExp` 弃用提示，不能据旧结果声称当前全包零告警。 |
| 完整组件回归及覆盖率 | PASS | 两个 Flutter 版本的 57 个组件套件均通过。 |
| BackTop、Indexes、TabBar Demo 非视觉测试 | PASS | Flutter 3.32.0 Linux 与 3.47.0 macOS 均为 15 项。 |
| 视觉调度器自检 | PASS | Flutter 3.32.0；源码注释已避开共享字体未收录的 3 个字形，未修改字体或字形清单。 |
| 受影响 Golden 无更新比对 | FAIL | Flutter 3.32.0 Linux：组件文件 1 通过 / 15 差异，三个 Demo 文件 11 通过 / 20 差异；总计 12 通过 / 35 差异。原先 10 通过 / 37 差异；恢复 `radiusCircle` 固定半径后 BackTop 浅色两张通过。字体方块已修复，旧基线仍混有正确 Token 色值与阴影、既有 TabBar/Demo 布局变更；未更新基线。 |

## 本次增量核验

- 2026-09-27 重新按冻结小程序源码审计全局 Token：浅/暗各 216 个均同名，原始值差各 1 个且均仅为 `radiusCircle`，未批准值差、未解析值、引用链差异、缺失 getter 均为 0。Flutter 的 `radiusCircle` 已恢复固定 `9999dp` 的原有 API 语义，背景与边框共用 `RoundedRectangleBorder`；未把组件圆角差异伪装为 Token 同值。
- 对旧 Golden 做逐项像素消融：恢复 `radiusCircle` 固定半径使 BackTop 两张浅色图恢复通过；非 Apple 平台默认字体栈使用 Flutter 可用主字体后，TabBar 的数字由方块恢复正常，单张浅色纯文字图差异由 2310 降至 1667 像素。47 张受影响截图整体由 37 张差异降至 35 张，相对旧基线的不一致像素总数由 354655 降至 333868（减少 20787）。这是对旧 Golden 的变化量，**不是**对小程序或 Figma 的像素差。
- Flutter 3.32.0 与 3.47.0 的主题、文字解析、BackTop 聚焦测试各 82 项通过；两个版本对本轮 7 个改动的 Dart 文件运行定向 `flutter analyze --fatal-infos` 均为 0 诊断。Linux 3.32.0 在临时副本无更新复跑 3 个组件和 3 个 Demo Golden 文件，12 通过 / 35 差异；没有修改工作区 Golden。暗色 BackTop/Indexes Demo 差异的主色对多为 `#e9e9e9 → #eaeaea` 等 1 级灰度变化，符合 `fontWhite1` alpha 修正；TabBar 图标/文字旧基线还包含 Spec 028 的布局变更，胶囊还包含按小程序修正为 `shadow3` 的阴影。不能仅凭旧基线认定这些为当前组件缺陷，设计稿像素验收仍未完成。
- 重新比较全局颜色的引用链和类型化读取入口，发现此前默认值审计遗漏浅色 `bgColorContainer`、明暗 `textColorAnti`、明暗 `textColorBrand/textColorLink` 的引用差异及 3 个缺失 getter；已对齐小程序并将两项检查纳入审计脚本。重新扫描 216 个全局键：名称缺少/多出 0、明暗未批准静态值差 0、明暗引用链差 0、缺失 getter 0；只有 `radiusCircle` 为有记录的值例外。用户已接受以 375dp 宽的 `2rpx = 1dp` 作为全局尺寸数值通过标准；不宣称其他屏宽严格响应式等价。
- 新增浅色/暗色上游颜色联动、下游直接覆盖优先级和 3 个 getter 的测试；Flutter 3.32.0 与 3.47.0 下 `t_colors_test.dart` + `t_theme_test.dart` 各 35 项通过。Button 的实际前景色跟随 `fontWhite1` 的 Widget 测试已补，两个 Flutter 版本的 `t_button_test.dart` 各 102 项通过。两个版本对改动的主题定义、getter 和测试文件定向 `flutter analyze --fatal-infos` 均零诊断。3.47.0 初次 `--no-pub` 复跑误用 3.32.0 的本地包配置导致 SDK 混用编译失败，重新解析依赖后的正式复跑通过；该错误非源码缺陷。
- 本批次没有改变内置默认色值，故未更新 Golden；之前全局主题迁移造成的 Linux 旧基线差异仍待归因，不能以本批次的 Widget 测试宣称视觉门禁已通过。
- 从官方小程序仓库将冻结提交 `1a1c5ca135b0e9bf19abc43a59870c4908a28ad5` 获取到独立临时检出，未使用机器上其他版本的小程序工作区。重新运行 `tool/audit_miniprogram_tokens.mjs`：216 个全局键全部同名，明暗模式各仅有 `radiusCircle` 1 个批准的原始值差，未批准值差及未比较键 0；组件变量 804 项，并生成明暗默认表达、冲突候选及 460 个 Flutter Theme 字段清单。组件侧有 784 项默认表达已展开、14 项仍含 `calc()`、2 项有多套回退、1 项暗色值未解析、3 项无回退；后四类均未被算作“值对齐”。Flutter 组件最终值仍待逐项核对。
- Tag 组件消费测试在亮/暗主题将 `warningColor1` / `errorColor1` / `successColor1` 与各自的 `*ColorLight` 别名故意设为不同值，确认浅色 Tag 读取小程序组件变量指定的色阶 1，而不是值恰好相同的别名。普通 outline 背景/默认描边、square 4dp 圆角、关闭图标占位文字色及四档尺寸的边框盒也已按冻结小程序源码核对并做最终 Widget 断言。Flutter 3.32.0 与 3.47.0 的 `t_tag_test.dart` 各 66 项通过，改动文件严格 analyze 零告警；Linux 四张旧 Tag Golden 仍差异，未更新。此结果不推广为 804 项组件变量均已验证。
- 复核旧 `spacer4` 的 4dp 消费说明时，发现 Button 公开 Theme 字段 `iconTextSpacing` 的 dartdoc 仍误称“全局 `spacer4`（4dp）”；实现实际使用组件内置 4dp，已更正注释，未改变运行时布局。

## 人工验收

- [x] Tag `danger → errorColor` 按小程序原命名保留，不新增全局 `dangerColor`。
- [ ] 字体、阴影、组件局部间距等平台表达仍需逐组件设计与像素裁定。
- [ ] Figma View seat 工具调用配额已耗尽，当前无法获取高分辨率设计节点；不把旧 Spec 或低分辨率截图当作新像素验收。

## 未覆盖项与后续工作

- 全局 Token 的静态名称和结构值除 `radiusCircle` 固定半径例外外已对齐，但字体/阴影跨平台表达尚未验证与设计稿像素等价；组件 804 项有来源和小程序明暗默认值，尚无 Flutter 最终值的逐项验证，未宣称运行或视觉一致。
- BackTop 的旧 Figma 规格与小程序默认宽度、图标和深色边框存在冲突，需在可读取设计图时裁定；未因 Golden 失败而覆盖旧基线。
