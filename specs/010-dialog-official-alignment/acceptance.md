# 验收记录

## 验证环境

- 分支：`rss1102/fix/pr-1036-design-alignment`（基于 PR #1036 head 的本地修复分支）
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub test/components/dialog/t_dialog_test.dart --coverage` | PASS，22 tests；LH/LF `225/230 = 97.83%` | Flutter 3.32.0；Dialog 尺寸、内容、操作区、显式值优先级、token、主题和路由契约 |
| Popup 公共契约复核 | PASS，未新增或修改 Popup API | Dialog 使用独立标准模态路由，既有 Popup 240×240 默认契约保持不变 |
| `flutter test --no-pub test/dialog_page_test.dart` | PASS，9 tests | 22 个入口结构契约、真实点击打开/关闭及关键组合交互 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.32.0，0 issues |
| `dart run tool/generate_example_code.dart --check` | PASS | 生成代码片段与 Demo 源码同步 |
| Flutter 3.47.0 Dialog 组件测试 | PASS，18 tests | 三操作稳定排序与极小视口保护追加前的合并结果；本轮未重跑 latest |
| `flutter test --no-pub test/dialog_page_test.dart` | PASS，8 tests | Flutter 3.47.0 最终源码复验 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.47.0，0 issues |
| CNB 同款 Flutter 3.32.0 Linux `dialog_page_golden_test.dart` | PASS，12 tests | 更新 4 张过期基线后，不带 `--update-goldens` 复跑 12/12 通过 |
| 回归调度器工具测试 | PASS，11 tests | Dialog 组件、覆盖率、Demo 功能和视觉回归登记同步 |

## 人工验收

- [x] 22 个入口通过真实 Widget 操作逐项打开并关闭；输入、图片、按钮顺序和返回结果有独立断言。
- [x] 使用 375dp 视口完成小程序与 Flutter 页面、关键打开态截图对照，证据见 [visual-comparison.md](visual-comparison.md)。
- [x] 真实 Web Demo 手动完成输入与清除、图片渲染、文字 Footer、多按钮顺序和关闭按钮交互。

## 未覆盖项与后续工作

- 未执行移动真机触摸验收；本轮证据为 Flutter Widget 真实事件、Linux Golden 和桌面 Web 人工操作。

## 2026-08-31 develop 同步复验

- 已合并 `origin/develop@ab04f68b8bcb572111216170d19045dd16d7895b`，冲突按 develop 共享测试基建与本 PR Dialog 默认值改动并集解决。
- CI 同款 Flutter 3.32.0 Linux：页面 light/dark 与点击“带关闭按钮的对话框”后的 Overlay light/dark Golden 共 4 项，更新后不带 `--update-goldens` 复跑通过。
- Flutter 3.32.0 与 3.47.0：15 个组件测试、4 个 Demo 功能测试和 `flutter analyze --fatal-infos --no-pub` 均通过。
- API 收敛复核：`TDialog` 与 `TPopupOptions` API 均不变；Dialog 使用 Flutter 标准模态路由绕开 Popup 的 240×240 固定面板，不引入仅供 Dialog 使用的公共开关。
- Token 复核：默认圆角、内容留白、标题正文间距、关闭按钮偏移与操作区间距均从 TDesign token 解析，并有自定义 token Widget 回归；311dp 宽度、56dp Footer 高度和 0.5dp 分隔线没有等价语义 token，保留单一设计常量。
- 完整滚动 Web Demo 后发现并移除页尾内部“单元测试”模块；页面测试已增加公开页不出现该模块的断言。
- CI 同款 Flutter 3.32.0 Linux 已重建 375×1992 明暗整页 Golden，并在不带 `--update-goldens` 时复跑页面与点击后弹层 4/4 通过；截图证据已同步更新。

## 2026-09-01 Figma 与完整 Demo 终验

- Figma 当前页面采用“02 组件状态”，因此 Flutter Demo 保留该分组名称；组件内容顺序与官方小程序公开 Demo 对齐。
- 修复居中 Popup 240×240 固定尺寸压窄 311dp Dialog、裁切 `TInput` 的根因；带 Popup `centerSize` 主题时仍保持 Dialog 自适应。
- 三项及以上操作按 `TDialogAction.role` 稳定提升强调操作，全为普通操作时保持调用方声明顺序。
- 极小视口与放大的 `spacer32` token 组合不会产生负宽高约束。
- 文字按钮对齐 32dp Footer 顶间距、56dp 操作高度和 0.5dp 分隔线；三个及以上按钮按主要操作优先排列。
- 图片 Golden 显式等待仓库资产解码，防止把空白图片槽位误收为基线。

## 2026-09-03 PR #1036 冲突与设计稿复验

- 基于 PR head `3583cba34fbb6d148a80b811542f30224ccb40e7` 合并 `origin/develop@ed6ac81deea5d831dabf21c2c5345c72d7dd7522`；CI 功能测试清单取并集，保留 Dialog 并接纳 develop 新增的 ActionSheet、Badge、Loading、Message、Tabs 测试。
- Golden feedback 字体字符清单取两边并集，重建字体后 604 个可见必需字符全部存在；SHA-256 为 `7b39b695bd12fd77d798c5a4d24af0269c19f3c1f2d5706306eb33dc230e56f8`。
- 取消仅供 Dialog 使用的 `TPopupOptions.center(shrinkWrap:)` 公共参数；Dialog 改用 Flutter 标准模态路由，`TDialog` 与 `TPopupOptions` 公开 API 均无变化。
- Figma 分支设计稿的 Dialog 页面节点 `24386:5278` 已读取；复核 311dp 面板、12dp 圆角、长内容滚动、图片、输入、文字/基础/多按钮和关闭按钮状态。
- Flutter 3.32.0：Dialog 20 tests、Dialog Demo 8 tests 与定向 analyze 全部通过；Dialog 生产源码覆盖率 `226/230 = 98.26%`。本轮追加修复前，Popup 聚焦契约合计 23 tests、回归调度器 11 tests 与严格全量 analyze 已通过。
- Flutter 3.47.0：临时副本 clean + pub get 后 Dialog 18 tests、Dialog Demo 8 tests 与严格 analyze 全部通过。首次 Demo 运行因复制了 3.32 的 `ink_sparkle.frag` 缓存失败，清理 Example 缓存后复跑通过，确认不是源码回归。
- 当前 12 张 Dialog Golden 已人工检查；本轮未获授权把源码临时副本挂载到第三方 CNB Docker 镜像，因此没有把 Linux Golden 历史结果冒充为当前合并结果。

## 2026-09-03 CodeBuddy Review 修复复验

- 去除 `TConfirmDialog` 对 primary role 与 primary colorScheme 的重复声明，确认按钮仍解析为 fill + primary。
- 三个及以上文字操作改用带 24dp token 内边距的纵向布局；1～2 个文字操作继续使用贴边 Footer。
- `actionsPadding` / `actionSpacing` 使用“是否显式传入”判断优先级，显式 24/12 不再被数值不同的自定义 token 覆盖。
- Dialog Demo 接入共享结构测试，22 个公开入口数量契约进入实际测试路径。
- Flutter 3.32.0：定向 analyze 0 issues，Dialog 22 tests，Dialog Demo 9 tests，Dialog 生产源码覆盖率 `225/230 = 97.83%`。
- CNB 同款 Flutter 3.32.0 Linux：仅 4 张预期基线发生变化，更新后不带 `--update-goldens` 复跑 12/12 通过。

## Dialog 设计稿正文同步

- 直接读取用户指定 Figma 分支中 Dialog 的 `descriptions` 图层（节点 `28600:41090`）：原文为“告知当前状态、信息和解决方法，等内容。描述尽可能控制在三行内。”；Demo 保留设计稿标点，移除多出的“文案”并补齐句号，不修改组件 API 或限制正文行数。
- 新增反馈、确认、输入、图片和文字按钮场景的原文断言；Flutter 3.32.0 与 3.47.0 的 Demo 测试均为 10/10，定向严格 analyze 均为 0 issues，示例代码生成与 check 通过。
- Flutter 3.32.0 Linux 初次比较只有 10 张打开态正文发生预期变化（每张 2871px，约 0.94%），2 张页面基线不变；检查实际图、旧基线与差异图后更新，并在不带 `--update-goldens` 的精确比较下复跑 12/12 通过。此处验证文案与对应回归，不代表新增了真机或全页跨端像素一致性证据。

## 普通操作默认配色修复

- 根因位于 Dialog 的 normal role 默认解析，并非标准 Demo 缺少颜色参数。普通基础操作改为 `fill + light`；主要/危险操作、普通文字/描边/幽灵操作，以及显式配色与 ButtonStyle 覆盖保持原有语义，不修改共享 TButton，也不新增 API。
- 标准 Demo 去除与 role 重复的主操作默认配色；完全自定义的垂直操作区仍由调用方组合 TButton，其次要按钮同步为浅色填充。纯标题确认的浅色主操作继续保留显式场景选择。
- 新增回归首先在旧实现复现 `expected fill / actual outline`；修复后 Flutter 3.32.0 与 3.47.0 组件测试各 26/26，Demo 功能测试各 11/11，定向严格 analyze 均为 0 issues。实际 Material 背景与文字色验证覆盖明暗主题、自定义品牌 token、实例与 Dialog Theme 样式覆盖。
- Flutter 3.32.0 组件测试与回归调度器自测合计 37/37；Dialog 生产源码覆盖率 `227/231 = 98.27%`，超过 95% 门禁；既有组件、Demo 与 Golden 调度清单仍覆盖本次修改的文件。示例生成器及 check 通过。
- Flutter 3.32.0 与 3.47.0 全量 `flutter analyze --fatal-infos --no-pub` 均为 0 issues。
- Flutter 3.32.0 Linux 首次精确比较：8 张既有打开态出现预期按钮差异（单个取消按钮 5016～5017px，约 1.65%；多按钮 21000px，约 6.90%），页面和文字按钮共 4 张不变；另外新增三个确认场景及垂直操作的明暗 8 张 Golden。检查旧图、实际图及差异图后更新，在同一容器不带 `--update-goldens` 复跑 20/20，最终精确比较无差异，未放宽容差。
- 已在 Android 16 真机 25113PN0EC 安装并打开“确认类-带标题”，确认取消为浅色填充蓝字、确定为品牌色填充白字；此处仅为该场景真机验收，不代表完整跨端像素一致。
- 默认视觉属于 breaking change；保留旧外观的迁移方式见 spec.md。尚未提交、推送或更新远端 PR。

## 关闭来源与蒙层交互补充验收

- 用户反馈实际来自“确认类-带标题”，该入口未显式开启 `barrierDismissible`，默认 false，因此不应点蒙层关闭；“命令行操作”显式 true。未复现已开启蒙层关闭却无法触摸关闭的组件缺陷，保留既有默认值。
- 沿用 Flutter 的 `Future<T?>` 单一完成通道，增加可选 `barrierResult` 与 `closeButtonResult`，操作按钮继续使用 action.result。两项默认 null，不新增业务结果枚举或重复关闭回调；程序调用 Navigator.pop 可传自己的结果，系统返回和不传结果的程序关闭仍返回 null。
- 组件回归覆盖确认、取消、蒙层、关闭图标、系统返回、程序关闭、透明蒙层、PopScope 拦截、嵌套 Navigator、非自动关闭操作与 Future 仅完成一次。Demo 在 375×812 视口通过公开入口打开，实际点击面板四周验证命令调用关闭并显示来源，同时验证默认确认场景不关闭。
- Flutter 3.32.0 与 3.47.0：组件测试各 32/32，Demo 功能测试各 13/13，全量严格 analyze 均 0 issues；3.32.0 组件与回归调度器自测合计 43/43。Dialog 生产源码覆盖率为 `252/256 = 98.44%`，超过 95% 门禁；生成示例及 check、API 文档生成通过。
- Flutter 3.32.0 Linux：先不更新基线精确复验既有 20/20；仅新增命令调用打开态 light/dark 两张基线，人工检查关闭图标与按钮样式后，不带更新参数复跑 22/22，实际差异 0%，未放宽容差。
- 本轮未重新完成真机操作验收：设备正被用户使用，已停止操作，未用 Widget 测试或行覆盖率替代真机证据。之前只点击固定角落的组件测试与按钮关闭的 Demo 冒烟测试不足以证明真实 Demo 蒙层交互，本轮已补该自动化缺口。
- 当前修改未提交、推送，未触发远端 Review；此前普通操作配色修复一并保留。

## 确认类 Demo 显式开启蒙层关闭

- 根据用户后续确认，带标题、无标题、纯标题三个确认类 Demo 均显式传入 `barrierDismissible: true`；此前“默认确认场景不关闭”的记录描述调整前状态。本项仅改变 Demo 组合，不修改组件全局默认 false，不新增 API 或组件 breaking change。
- 新测试先在修改前复现“确认类-带标题 left 蒙层应关闭”失败；修改后，三个入口各验证左、右、上、下四个方向点击蒙层关闭，同时验证面板内部点击不关闭。原有 22 入口按钮关闭路径继续覆盖。
- Flutter 3.32.0 与 3.47.0 的 Demo 测试各 14/14 通过，严格 analyze 均 0 issues；生成片段仅新增三处显式参数，生成器 check 与 `git diff --check` 通过。
- Flutter 3.32.0 组件测试复验 32/32；Linux Golden 在不更新基线的精确比较下 22/22 通过，差异 0%，本轮未修改任何 Golden。
- 本轮未操作真机、未提交或推送；原有配色与关闭来源改动保持不动。

## 全部 Dialog Demo 统一蒙层交互

- 根据用户补充要求，将显式开启范围从确认类扩展到全部 22 个公开入口（17 处展示调用，其中图片 helper 被 6 个入口复用）；反馈、输入、图片、自定义操作等统一允许点击蒙层关闭，组件全局默认 false 保持不变。
- 回归先复现“反馈类-带标题 left 蒙层应关闭”失败；补齐显式参数后，375×812 视口逐入口验证四方向蒙层关闭，共 88 次，并验证每次面板内点击不关闭。补充滚动后等待布局稳定，避免在首屏外输入类入口布局未完成时查找失败；原有按钮关闭、输入及关闭来源测试继续保留。
- Flutter 3.32.0 与 3.47.0 Demo 测试各 14/14 通过；Linux 3.32.0 Golden 不更新基线精确复验 22/22，差异 0%。示例片段生成与 check、diff check 通过；本次不修改生产组件源码或 Golden 基线。
- 本轮未更新手机安装包、未提交或推送。此节覆盖此前仅确认类显式开启的 Demo 契约，不代表新增真机或跨端完整视觉验收。
