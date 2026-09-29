# 验收记录

## 验证环境

- 分支：`rss1102/refactor/miniprogram-tokens`
- Flutter 基线：`develop`（实施前状态见 Git 历史）
- 小程序基线：`develop@1a1c5ca135b0e9bf19abc43a59870c4908a28ad5`
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0

## 最新圆角口径

用户提供的全局 Radius 规范优先于先前引用的 Figma 变量页：small/default/large/extraLarge/round 为 3/6/9/12/999dp。Flutter 全局主题与小程序 216 个键同名，不再有 `radiusMedium`；头像方角读取 `radiusDefault`，Tag 方角默认读取 `radiusSmall`。下文按日期记录的 2/3/6dp 与 `radiusMedium` 是历史检查点，不代表最新源码。CSS `radiusCircle: 50%` 与 Flutter 固定半径 `9999dp` 仍是已记录的平台表达差异。

2026-09-29 合并 #1146/#1147 后，Tag 同时保留组件 Theme 的 `dangerColor`、`successColor`、`successLightColor` 和 `squareBorderRadius`；后者未显式指定时继续回退 `radiusSmall = 3dp`，未恢复旧 4dp。Flutter 3.32.0 Tag/SelectTag 聚焦测试 75/75 通过；固定 Linux 3.32.0 对四张公开 Tag Demo 图先无更新比对，确认差异包含已裁定的 3dp 方角和新增的第三种圆弧实例后，只更新这四张，在同环境无更新严格复跑通过。此结果不代表字体宽度或整页 Figma 像素差已裁定；完整视觉调度器仍须以合并后的最终源码运行。

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| Token 清单与映射审计 | PASS（静态，最新） | 小程序与 Flutter 各 216 个全局键，全部同名、无独有键；浅色 6 个、暗色 1 个已批准原始值差；未批准值差、引用链差异及缺失同名 getter 均为 0。804 个组件变量已提取明暗默认表达；Flutter 最终消费值未逐项证明。 |
| 暗色透明色、圆角聚焦测试 | PASS | Flutter 3.32.0 为 148 项，Flutter 3.47.0 为 148 项；BackTop 半圆形使用 `radiusRound`，圆形保留 `radiusCircle`。 |
| `flutter analyze --fatal-infos` | 全包 PASS（当前工作区） | Flutter 3.32.0 与 3.47.0 均为 `No issues found`；之前出现的 41 条弃用提示属于较早检查点，不再代表本次源码。 |
| 完整组件回归及覆盖率 | PASS | 两个 Flutter 版本的 57 个组件套件均通过。 |
| BackTop、Indexes、TabBar Demo 非视觉测试 | PASS | Flutter 3.32.0 Linux 与 3.47.0 macOS 均为 15 项。 |
| 视觉调度器自检 | PASS | Flutter 3.32.0；源码注释已避开共享字体未收录的 3 个字形，未修改字体或字形清单。 |
| Base、Navigation、TabBar 组件 Golden | PASS | Flutter 3.32.0 Linux：3 张经逐像素归因后更新；立即无更新严格复跑，16/16 通过。 |
| 完整视觉调度器无更新比对 | FAIL | Flutter 3.32.0 Linux：84 个调度条目中 71 个有失败；554 次像素不一致、6 次图片尺寸不一致，共 560 次 Golden 失败，对应 534 张去重图片。其余组件和 Demo 旧基线尚未逐项裁定，未批量更新。 |

## 本次增量核验

- 2026-09-29 按用户提供的全局 Radius 规范撤销此前另一套 Figma 档位：small/default/large/extraLarge/round 为 3/6/9/12/999dp，删除尚未合并的 `radiusMedium`，Avatar 方角回退改为 `radiusDefault`，Tag 方角默认改为 `radiusSmall = 3dp`。冻结小程序基线审计为 216/216 个同名全局键、两端独有 0、未批准值差 0、引用差 0、缺失 getter 0；浅色 6 项及暗色 1 项批准的原始值差保留，其中 `radiusCircle` 为 CSS 50% 与 Flutter 9999dp 的平台表达差异。Flutter 3.32.0 和 3.47.0 的主题及 Avatar/Tag/Button/Skeleton/TabBar 聚焦测试各 285/285 通过，双版本完整组件包 `flutter analyze --no-pub --fatal-infos` 零诊断，3.32.0 的 Example 完整分析也零诊断。普通组件回归初跑 2658/2659，唯一失败是 Button 测试仍断言旧中性灰 `#E7E7E7`；改为已裁定的 `#E8E8E8` 后，3.32.0 无 Golden 的普通组件全量复跑 2659/2659 通过，Button 聚焦测试在两个版本各 9/9 通过。Linux 3.32.0 的四张 Tag Demo Golden 无更新复跑仍为 0/4；未更新快照。macOS 上混入 Golden 的完整组件测试不作为 Linux Golden 判据。
- 2026-09-29 按已裁定设计值完成四处消费修正：Avatar 默认背景 `brandColorLightActive`、方角 `radiusMedium`；Slider 正常态未选中轨道及刻度 `componentBorder`，胶囊/区间胶囊外轨复用解析后颜色，禁用态外轨保留原有 `bgColorComponent`；Tag 方角 extraLarge 用 `radiusMedium`、small/medium/large 用 `radiusDefault`；Cell Demo 页面底色 `bgColorSecondaryContainer`，不改 Cell 组件。组件 Theme 与显式 Material SliderTheme 的优先级保持。Flutter 3.32.0 与 3.47.0 的 Avatar/Slider/Tag/SelectTag 聚焦测试各 134/134 通过；3.47.0 覆盖率 Avatar 170/173（98.27%）、Slider 358/360（99.44%）、Tag 192/199（96.48%）。两版本组件包完整 `flutter analyze --no-pub --fatal-infos` 均零诊断；Example 包完整分析、Cell Demo 非视觉结构断言、示例代码生成 `--check` 在前一检查点通过，本批最后的 Slider 禁用态调整不涉及 Example。
- 同批在临时副本用 Linux amd64 Flutter 3.32.0、锁定图标包 0.0.6 无更新比对：Slider 组件 Golden 通过；Avatar、Cell、Tag、Slider 的 Demo 旧基线仍有差异（本次组合运行 3 通过、22 失败）。例如 Avatar 深色页 3867px、Slider 浅色页 13635px、Cell 单行页 3590px、Tag 浅色选中 4426px。旧基线还包含先前 Token 与 Demo 变动，未把这些差异一概归于本批，也未更新快照；完整视觉调度器未在本批最终源码上重跑。上表的全量回归成绩属于先前检查点，不代表本批已完成全量视觉门禁。
- 2026-09-29 按用户确认的 Figma 圆角变量修改 `radiusSmall = 2dp`、`radiusDefault = 3dp`、新增 `radiusMedium = 6dp`；`radiusLarge/ExtraLarge/Round/Circle` 不变。冻结小程序基线重新审计：216 个同名键 + 1 个已批准 Flutter 专属键；浅色 8 个、暗色 3 个已批准值差，未批准值差、未批准独有键及缺失 getter 均为 0。Flutter 3.32.0 下主题聚焦测试 45/45、15 个受影响组件测试文件 648/648 通过；Flutter 3.47.0 下主题与 5 个关键消费者测试文件 312/312、同一批 15 个组件测试文件 648/648 通过。两个版本的 `flutter analyze --fatal-infos` 全包检查均为 `No issues found`。原先 7 个组件断言写死旧 6dp，AvatarGroup 内圆角断言写死旧 4dp，已按真实新默认值修正；组件本身仍从全局 Token 读取，未把旧 6dp 偷换为 `radiusMedium`。`radiusSmall/default` 是已发布默认行为变化，应按 breaking change 处理。

### 2026-09-29 Linux Golden 像素归因

使用 Flutter 3.32.0 Linux 隔离副本，`PUB_HOSTED_URL=https://pub.dev` 保持依赖锁定的 `tdesign_flutter_icons 0.0.6`，不带 `--update-goldens` 运行 Base、Navigation 和 TabBar 三组测试。当前源码 16 张中 13 张通过；失败项如下。最初使用镜像默认腾讯 Pub 源会解析到图标包 `0.0.7`，该次结果已废弃，以下数值均为修正依赖源后的重测。

| 截图 | 当前相对旧基线 | 隔离副本逐项消融结果 | 归因 |
| --- | --- | --- | --- |
| Base 浅色 | 5782px（2.68%） | 仅将 `grayColor3 #E8 → #E7` 后剩 2099px；再将 `TText` 默认 `bodyMedium 14/22 → bodyLarge 16/24` 后剩 723px；其中 Button 圆角 212px、Fab 区域 511px | `grayColor3` 改动净贡献 3683px；文字默认字号 1376px；圆角 212px；Fab 投影 511px。旧基线各项可逐像素解释，不是 Demo 补样式。 |
| Base 深色 | 6771px（3.13%） | 仅将 `fontWhite1` alpha `E6 → E5` 后剩 4582px；再将 `TText` 默认字号还原后剩 3207px；将暗色 `shadow2` 还原到 develop 值后剩 870px；将 `textColorAnti` 从 `fontWhite1` 还原为纯白后剩 205px；最后还原圆角后通过 | alpha 净贡献 2189px；文字 1375px；暗色 Fab 投影 2337px；反色文字/图标 665px；Button 圆角 205px。当前暗色 `shadow2` 与冻结小程序 `_dark.less` 的三层阴影一致；旧值不是当前目标。 |
| Navigation 浅色 | 376px（0.08%） | 单独还原圆角后仍差 376px；单独还原 `grayColor3 #E8 → #E7` 后通过 | 差异仅在 Steps 的 Next 指示器；其背景消费 `bgColorComponent → grayColor3`，不是圆角或布局位移。 |

消融仅修改隔离副本；工作区源码与 Golden 均未因实验回退或更新。按旧值组合恢复 Base 明暗旧截图并不证明旧设计更正确，也会使原本通过的 Navigation 深色和 TabBar 快照产生新差异。此表确认差异来源，不替代 Figma 最终观感判断或完整视觉调度器门禁。

逐项归因后仅更新 `base_components_light.png`、`base_components_dark.png`、`navigation_components_light.png`。Navigation 浅色的工作区旧文件在本次运行前已含 1086px 高的未提交布局变化；此次新图同为 1086px，保留原有布局，仅替换 Steps Next 的 376 个像素。Linux 3.32.0 同一隔离副本更新后立即不带更新参数严格复跑 Base、Navigation、TabBar，16/16 通过；整个 Golden 目录与隔离副本逐文件一致。其余 13 张没有变化。

随后运行完整 `dart run tool/run_visual_regression.dart`，在当时源码和 Golden 下有 84 个调度条目，其中 71 个失败；重新按 Flutter 异常块解析换行内容后，准确计为 554 次像素不一致、6 次图片尺寸不一致，共 560 次 Golden 失败，对应 534 张去重图片。先前 `rg` 单行统计的 547 次漏掉跨行像素信息且未识别尺寸不一致，现已作废。Steps 的四张为 375×3089→375×3101，Theme 的浅/深两张分别为 375×2991→375×2837、375×2925→375×2837。Base、Navigation、TabBar 组件条目在完整入口中未重新失败。Avatar、Tag、Slider、Theme 等 Demo 均仍有差异：Avatar 的图标背景色与方角可在组件的 `brandColorFocus` / `radiusDefault` 读取路径找到；Slider 灰轨读取 `bgColorComponent`；当时 Tag 方角仍固定 4dp，与 Figma 3px 不一致；Theme 页同时展示了全局 Token 色块、命名和示例布局变化。原始尺寸查看 Tag 截图，其中文文字完整；缩小预览造成的漏笔画不是组件裁切。上述只确认消费路径和快照现状，不把 560 次差异一概判为设计正确，也不以全量更新掩盖未审查的组件或 Demo 问题。

随后已按 Tag 设计稿的 3px 独立修正方角路径：`TTagThemeData.squareBorderRadius` 显式值优先，否则读取全局 `radiusDefault`（出厂 3dp），原先固定 4dp 的小程序组件默认值作为设计例外记录。Flutter 3.32.0 Linux 与 3.47.0 macOS 的 Tag 组件测试各 67/67 通过；两个版本的全组件包 `flutter analyze --fatal-infos` 均为 `No issues found`。四张 Tag Demo Golden 无更新重跑，按浅色页面、深色页面、浅色选中、深色选中顺序，差异像素由 5894/12480/5752/12138 降为 4452/10986/4270/10604，分别减少 1442/1494/1482/1534；四张仍失败，剩余颜色/文字/其他视觉变化不能算作圆角已修复的证据，尚未更新 Tag Golden。此项在上面的完整调度器运行**之后**实施，560 次失败数是修正前检查点；Tag 四张重测后仍失败，因此失败断言数量未变，但完整调度器没有以新源码重跑，不能冒充最新全量数值。

- 2026-09-28 按 Figma 已裁定的浅色 `grayColor3 = #E8E8E8` 修改 Flutter 默认值和 getter 回退，并重算冻结小程序基线审计：浅色 6 个已批准的原始值差为 `radiusCircle`、`grayColor3` 和后者的 4 个引用项，暗色仅 `radiusCircle`；未批准值差为 0。`t_colors_test.dart` 与 `t_tag_test.dart` 合计 72 项通过，改动的 3 个 Dart 文件定向 `flutter analyze --fatal-infos` 零诊断。随后在当前工作区复跑这两个聚焦测试，仍为 72/72 通过；此批次未运行 Linux Golden，旧快照与新颜色的差异不能据此判为组件错误。
- 同日以临时 Widget 探针测量无图标 medium `TTag('Tag')`：Roboto 的文字 20.5078125dp、外宽 36.5078125dp；Arial 的文字 20.09765625dp、外宽 36.09765625dp。设计稿实例外宽 38px、左右各 8px，反推文字约 22px；Roboto 与反推值相差约 1.49dp，但该 22px 不是直接字形测量。探针文件已移除，未用 38px 固定宽度或额外 Padding 修正组件。Tag 当前内部 `TextStyle` 未设置字体族；缺少同字体直接测量，不能断定差额全由字体导致。
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

2026-09-29 Tag 复核：按用户裁定，方形圆角的组件专属 `squareBorderRadius` 只在显式设置时覆盖，默认回退全局 `radiusSmall`（当前 2dp）；小程序 `@radius-small` 为 6rpx≈3dp，独立 `--td-tag-square-border-radius` 旧默认 8rpx≈4dp，三者不可混称同值。组件双版本各 73 项测试通过，Demo 非 Golden 5 项通过，双版本全包 `flutter analyze --fatal-infos` 零诊断。固定 Linux 3.32.0 无更新运行 Tag 四张 Golden 仍失败，浅色整页旧基线 1310×375 与当前同尺寸、像素差 1847（0.38%）；未更新基线。另将当前图去除 64px 导航后与已归档 Figma 整页参考同尺寸比较，阈值为 RGB 任一通道差 >28，旧当前 43435/467250，现当前 43330/467250（减少 105px），这不是完全像素一致。

为核对上下留白，曾在隔离验证中把四档外高试改为另一张 Figma“Style 组件样式”页的 16/20/24/36px，字号仍 10/12/14/14，当前页高度从 1310 变成 1266；相同整页比较反而升至 51118/467250。该试验已撤回，公开 Demo 保留 20/24/28/40dp 和对应字体行高。两个 Figma 来源的尺寸契约存在冲突，不能通过改 Golden 消除；当前未裁定默认 Tag 应采用哪一套高度。`Tag` 文字样例的剩余宽度约 1.49dp 差仍缺少同字体直接测量，不补固定宽度或 Demo 侧偏移。

- [x] Tag `danger → errorColor` 按小程序原命名保留，不新增全局 `dangerColor`。
- [ ] 字体、阴影、组件局部间距等平台表达仍需逐组件设计与像素裁定。
- [ ] Figma View seat 工具调用配额已耗尽，当前无法获取高分辨率设计节点；不把旧 Spec 或低分辨率截图当作新像素验收。

## 未覆盖项与后续工作

- 全局 Token 的静态名称和结构值除 `radiusCircle` 固定半径例外外已对齐，但字体/阴影跨平台表达尚未验证与设计稿像素等价；组件 804 项有来源和小程序明暗默认值，尚无 Flutter 最终值的逐项验证，未宣称运行或视觉一致。
- BackTop 的旧 Figma 规格与小程序默认宽度、图标和深色边框存在冲突，需在可读取设计图时裁定；未因 Golden 失败而覆盖旧基线。
