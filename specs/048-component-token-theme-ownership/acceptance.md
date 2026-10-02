# 验收记录

## 2026-10-02 组件 Theme 动画回退与 API 文档修正

- `TTagThemeData` 的 danger/success 基础色、success 浅色及方角在 nullable 端点之间插值时保留“继承当前 Token/Material 值”的语义；绘制时才用当前配色预设与 `radiusSmall` 的有效回退计算连续中间值。`TProgressThemeData.circleInnerBgColor` 同理，在浅色按 `bgColorContainer`、暗色按透明背景插值，不再把未配置端一律当透明色。
- 插值中间值使用私有 ThemeExtension 子类型保存延迟解析数据，公开组件 Theme 类型及字段不变；组件测试额外验证 Flutter `ThemeData.lerp` 后仍可通过原类型查找扩展，并检查正向/反向、两端均空、端点、中途再次插值及实际绘制结果。
- Avatar 的插值状态也移至私有子类型，消除生成器误把 `TAvatarThemeData._interpolated` 和私有 `_AvatarDoubleLerp` 参数写入公开 API 文档的问题。公开构造函数和插值行为不变。生成器曾顺带移除无关 `showTDrawer` 文档，已保留该已有内容；不把这项生成器偏差混入本次 API 变更。
- Flutter 3.32.0/3.47.0 两版组件包完整 `flutter analyze --no-pub --fatal-infos` 均为 0 issues；Avatar/Tag（含 SelectTag）/Progress 聚焦测试在 3.32.0 共 185/185、3.47.0 改动的三份测试共 181/181 通过。3.32.0 生产源码覆盖率分别为 Avatar 262/273（95.97%）、Tag 264/275（96.00%）、Progress 540/544（99.26%）。
- 隔离 Linux amd64 Flutter 3.32.0 临时副本使用与工作树相同的 `pubspec.lock` 和图标包 0.0.6，Avatar/Progress Demo 6 项、Tag Demo 4 项及 Progress 共享组件 1 项 Golden 均以**无更新**方式通过；原工作区 Golden 未修改。静态 Golden 不覆盖 Theme 动画中间帧，连续插值由聚焦组件测试检验。此为本地证据，远端最终 PR head 的 CI 仍需单独核对。

## 2026-10-02 Avatar Theme 插值与已删除入口复核（本地工作区）

- `TAvatarThemeData.lerp` 对 `dimension`、`iconSize`、圆/方圆角及头像组描边宽度，不再将未配置端固定当作中号或固定全局 Token；在具体头像绘制时，分别按成员尺寸与当前全局 Theme 求有效回退，再插值。中途再次插值也保留这一解析路径。测试覆盖 small/medium/large、定制全局 `radiusCircle/radiusDefault`、`copyWith` 和中途切换。这个修复不改变默认设计尺寸，因此无需重新选择 Figma 数值。
- 自定义圆形头像圆角不足边长一半时，头像组外框的描边和阴影从完整圆改为与内容相同的圆角矩形；默认 `radiusCircle = 9999` 仍绘制完整圆。圆角参数负值断言有组件测试。
- 代码与手写 TabBar API 文档确认：`topBorder/showTopBorder/centerDistance` 均无公开入口或兼容字段；内置配色入口仍为 `colorPreset`，仅 Material 使用 `ColorScheme`。旧名仅留在 breaking 迁移记录以帮助用户改代码，不作为 API 保留。
- Flutter 3.32.0 Avatar 测试 42/42，通过生产源码覆盖率 247/258 = 95.74%；3.47.0 Avatar 与回归工具测试共 61/61 通过，两版完整组件包严格静态分析均 0 issues。Linux amd64 Flutter 3.32.0 使用固定图标包 0.0.6，无更新复跑 Avatar 公开 Demo 浅/暗 Golden 2/2 通过。本地通过不等于远端 PR head 的 CI 结果。

## 2026-10-02 PR 风险复核：SwipeCell release 互斥

- `TSwipeCellAction.builder` 与内置视觉字段的构造 `assert` 仅在启用断言时运行；现于 `build` 再检查相同冲突，并在 release 也抛出 `FlutterError`，避免背景、图文和图文样式参数被静默忽略。合法配置的绘制链未改变，因此不更新 Golden。
- Flutter 3.32.0、3.47.0 的 SwipeCell 聚焦测试各 27/27 通过，组件包 `flutter analyze --no-pub --fatal-infos` 各为 0 issues；新增了绕开构造期 `assert`、直接触发运行时 `build` 守卫的 Widget 测试。3.32.0 按组件清单三组测试 31/31，生产源码覆盖率 305/317 = 96.21%，通过 95% 门禁。release 专门运行时截图未执行，本条的 release 行为依据无条件 `build` 检查与两版编译结果，不冒充真机或 Golden 验收。
- `TButtonThemeData` 的各变体 `ButtonStyle` 移除后，显式 Flutter `ElevatedButtonTheme`、`OutlinedButtonTheme`、`TextButtonTheme` 仍能提供子树默认值；outline 和 ghost 共用 `OutlinedButtonTheme`，不等于保留原先的四套独立 TDesign Theme 字段。迁移文档已说明该能力边界。真实第三方调用迁移和组件变量 682 项最终消费仍待审。

## 2026-10-02 单实例文字样式与 SwipeCell/Popup 入口收敛

- 当前源码：`TText.font` 仅作字体 Token 预设，`style` 控制实例完整文字样式；分散文字字段删除。SwipeCell 逐项视觉归 `TSwipeCellAction`，Theme 仅保留共享 `actionPadding`；Popup 蒙层 alpha 归 `Color`，动画时长归单次 Options。API breaking 迁移记录见 `migration.md`。
- Flutter 3.32.0、3.47.0 组件包和 Example 包严格 `flutter analyze --fatal-infos --no-pub` 均 0 issues；Text/Popup/SwipeCell/Theme 聚焦功能测试两版各 249/249 通过。Flutter 3.32.0 全部非 Golden 测试文件 2736/2736 通过。
- 在临时副本中用固定 `tdesign-flutter-golden-cache:3.32.0` Linux amd64 镜像无更新复跑，SwipeCell 组件 2/2、Popup/Progress/共享消费者与 M3 隔离 5/5、Text/SwipeCell/Popup 公开 Demo 40/40 通过。临时容器依赖解析到了图标包 0.0.7，而工作树使用 0.0.6；该结果不能代替当前提交的远端 CI 全量视觉矩阵。
- `sh ./demo_tool/all_build.sh` 重新生成 57 份 API 文档，保留生成器误删的无关 `showTDrawer` 文档；`dart run tool/generate_example_code.dart` 及 `--check` 通过。生成产物变化均由实际源码 API/Demo 迁移驱动。
- 真实第三方业务调用仓库的旧 API 编译、完整 Linux Golden 调度、覆盖率和远端 CI 仍须以最终推送 head 核验；上述本地结果不代表 PR 可直接合并。
- 推送后复核发现 `TSwipeCellAction.builder` 虽拒绝 `icon/label`，仍会静默忽略其余内置视觉字段；已扩大互斥断言到全部内置背景、图文和图文样式字段，同步 dartdoc/API 文档。Flutter 3.32.0 SwipeCell 组件测试 26/26、全包严格分析 0 issues；此补充不改变合法调用的默认绘制，故不更新 Golden。

## 2026-10-01 TText 完整实例样式移除（本地检查点）

- 公开 `TText`/`TText.rich` 不再接收 `style`；完整子树样式由 `TTextThemeData.textStyle` 持有。组合组件的状态相关逐项文字样式走仅库内使用的解析器，仍交给 Flutter 原生 `Text` 绘制；`TTextSpan.style` 保留其富文本局部语义。
- Flutter 3.32.0 与 3.47.0 全包 `flutter analyze --fatal-infos --no-pub` 均 0 issues；两版公开 Demo 非 Golden 回归各 274/274 通过。首轮全组件调度只有 Text 覆盖率暂为 94.40%；补上内部动态样式用例后，完整 57 套组件测试与各自 95% 生产源码覆盖率门禁全部通过。Text 独立复跑 36/36，生产覆盖率 229/232 = 98.71%。
- 隔离 Linux amd64 Flutter 3.32.0 无更新运行 `dart run tool/run_visual_regression.dart`，全部视觉回归套件通过。前期 Text、TabBar、Cascader 的 31 项与 Tag、Divider、Input、Calendar、Popover 的 78 项聚焦复跑也通过；首次聚焦调度误填不存在的 `tag_demo_golden_test.dart` 路径，正确路径随后通过。未更新 Golden；这不是与 Figma 的像素验收。
- Flutter 3.47.0 重新执行 `flutter pub get --offline` 以避免混用 3.32 SDK 的 `.dart_tool` 后，Text/Badge/Calendar/Picker/TabBar/ActionSheet/Theme 聚焦测试 175/175、完整公开 Demo 非 Golden 回归 274/274 均通过。此前 SDK 混用导致的编译错误不属于组件回归。
- 首次远端 head `76fec3f5` 的两个 Flutter 测试 job 仅在工具测试的共享 Golden 字形清单断言失败：新增内部注释的“棵”未被测试字体覆盖。注释改成已有字形的等义“个”，未扩充字体、改组件绘制或更新快照；Flutter 3.32.0 与 3.47.0 的该工具测试随后各 9/9 通过。修复提交的新 head CI 须另行确认。
- Example 包作为独立 path 依赖调用方通过静态分析；真实第三方仓库的旧 `TText(style: ...)` 调用仍需按 `migration.md` 迁移，本轮没有宣称其无需修改即可编译。

## 2026-10-01 SideBar 选中前景色单入口（本地检查点）

- `TSideBarThemeData.selectedColor` 已移除；选中文字、图标和指示线共用 `selectedTextStyle.color`，未指定颜色时仍读取全局品牌色。迁移方式见 `migration.md`。
- Flutter 3.32.0 与 3.47.0 的 SideBar 三份聚焦组件测试各 63/63 通过；3.47.0 的三份公开 Demo 非 Golden 测试 18/18 通过。两个 SDK 的组件包严格分析均为 0 issue。3.32.0 SideBar 生产源码覆盖率 236/236（100%）。
- 本地 macOS 没有写入 Linux Golden；需在最终提交的 Linux Flutter 3.32.0 CI 上确认默认视觉。当前未完成的 Text 和 SwipeCellAction 单入口、其余组件变量最终消费仍不能宣称已验收。

## 2026-09-29 Progress/Tag 与外部调用续验

- 固定小程序 `1a1c5ca`，Progress 9 个变量已逐项追到当前 Flutter 默认 Widget/Painter；暗色内圆覆盖引用的 `--bg-color-page` 在冻结源码未定义，宿主未定义时依 CSS 规则透明。Flutter 默认浅色 `bgColorContainer`、暗色透明，组件 Theme 可显式设置 `circleInnerBgColor`；新增浅/暗/覆盖 Widget 断言。其余组件变量仍未完成最终消费与跨端像素验收，见 `component-consumption-review.md`。
- Tag medium `TTag('Tag')` 在加载真实 Golden 字体后：正文 20.5078125dp、左右预算各 8dp、外宽 36.5078125dp；Figma 38px 反推的正文约 22px 尚非直接同字体测量。全局字体族已传到 Tag `Text`，并保留宿主 CJK 回退，不为单一实例添加固定宽度。
- Linux amd64 Flutter 3.32.0、图标包锁定 0.0.6：Tag Demo 全组 10/10（含 4 张 Golden）通过；Progress 暗色 2/2 Golden 通过，浅色 2 张各 15,015px 差异；Button/Form/Input 旧 Golden 7 张仍失败。浅色 Progress 的差异主要沿轨道/圆环，Button 的差异集中两处灰色按钮，Form/Input 多为细边线；均未完成与设计稿/旧实现的责任裁定。本轮**没有更新 Golden**。
- 仓库外独立 `path` 依赖消费夹具在 Flutter 3.32/3.47 各编译运行 1/1；覆盖迁移后的主要公开 Theme 类型和 Button/Input/Tag/Progress 实例调用，不代表真实第三方业务仓库已编译。两版本完整组件包与 Demo 包 `flutter analyze --fatal-infos` 均零诊断；Progress/Tag/Text/字体 Token 扩展聚焦测试两版本各 191/191。3.32 覆盖率：Progress 443/446、Progress Theme 47/47、Tag 154/162、Tag Theme 39/39、Text 解析 134/135、字体族 14/14，均达生产文件 95% 行覆盖门槛。示例代码生成并 `--check` 通过，57 份 API 文档重新生成，Progress 的公开组件 Theme 已纳入生成清单。

## 2026-09-29 严格单入口本地检查点

- Button/Input/Dialog action/TabsBar/Tag 新收敛范围见 `migration.md`；Flutter 3.32.0 与 3.47.0 完整组件包和公开 Demo 包严格 analyze 均 0 issues，相关非 Golden 功能测试各 398/398。
- 隔离 Linux 3.32.0 无更新 Golden：TabsBar 组件 2/2 通过；Button/Form/Input/Tag 公开 Demo 混合调度 33 通过、7 旧基线差异。本轮未更新 Golden，隔离副本依赖曾离线重新解析，不能将这些差异归因于本轮 API 改动。
- 全组件单入口仍未验收：Text、SwipeCellAction、SideBar 等见 `report.md`；外部调用方编译、固定依赖 Linux Golden 归因与 breaking 发布流程仍未完成。

## 2026-09-29 合并 PR 检查点

- 将 #1147 的组件 Theme 改动与 #1146 的 TabBar 公开布局合入同一提交历史；TabBar 具体视觉值保留组件 Theme 单入口，`centerDistance`、`showTopBorder`、`placeholder` 均不恢复。Tag 保留组件专属 danger/success 色，方角默认回退用户确认的全局 `radiusSmall = 3dp`。
- Flutter 3.32.0 TabBar 组件测试 44/44、公开 Demo 功能测试 9/9，组件包和 Example 包严格 analyze 零诊断；TabBar Demo 11 张与 Tag Demo 4 张 Linux Golden 在逐项核对后更新，随即在同一环境无更新严格复跑通过。两版本完整组件/示例调度器、全部 Linux Golden、API 生成产物及外部 breaking 调用方编译仍待最终检查。下文历史检查点的 12/35、Tag 4dp 和未通过截图数量不代表合并后的最终状态。

## 验证环境

- Flutter 分支：`rss1102/refactor/miniprogram-tokens`；工作区已有其他未提交改动，保留不覆盖。
- 小程序冻结基线：`develop@1a1c5ca135b0e9bf19abc43a59870c4908a28ad5`。
- 目标 SDK：Flutter 3.32.0 与最新稳定版；Golden 固定 Linux 3.32.0。

## 当前基线

- 全局 Token：小程序与 Flutter 各 216 个同名键，无两端独有键。当前已批准值差仅包括 `radiusCircle` 的平台表达和浅色 `grayColor3`（连带 4 个引用项）；未批准值差与缺失 getter 为 0。此行是当前状态，以下既有测试记录对应各自执行时的源码快照。
- 组件 CSS 变量：804 个已按冻结源码提取并逐项建立静态消费候选；Flutter 最终绘制值尚未逐项证明。406 项同目录全局 getter 候选、25 项 Theme 字段候选（10 项重叠）、291 项无直接证据、82 项无对应组件目录。Button 12 项、Tag 12 项默认 Widget 值与 Tag 7 项回退 Widget 路径已单独核验。
- 本批迁移后无更新复跑的 47 张受影响 Linux Golden：12 通过、35 差异，与任务开始前数量相同。这个数字是与旧 Flutter Golden 的差异，不是与小程序或设计稿的差异。

## 自动化验证

| 命令/门禁 | 结果 | 备注 |
| --- | --- | --- |
| 组件 Theme/API 同名盘点 | 同名候选已清零 | AST 初筛 116 个同名候选对；按包导出范围过滤后的 64 项已降至 0。异名同义字段仍须人工审查，见 `report.md` |
| SearchBar / Collapse / Table 的 3.32.0 组件测试 | 通过 | 10 + 27 + 51 个测试；只验证当前三项迁移，不代表全仓完成 |
| SearchBar / Collapse / Table 的 3.47.0 组件测试 | 通过 | 合计 88 个测试 |
| 3.32.0 定向 analyze | 通过 | 上述组件、测试和受影响 Demo：0 issues |
| BackTop / Theme 的 3.32.0 功能测试 | 通过 | 69 项，`radiusCircle` 默认固定半径、自定义 dp、BackTop 正圆/半圆分流 |
| Link / Cell / Input / Textarea / Switch / TimeCounter 的 3.32.0 功能测试 | 通过（分批） | 分别 20 / 24 / 63 / 15 / 47 项；尚非全仓门禁 |
| 全包双版本静态分析 | 部分通过 | `lib test` 在 Flutter 3.32.0 与 3.47.0 严格分析均 0 issues；3.32.0 完整包仍有 20 条示例代码 `RegExp` 弃用提示，不能记为全包通过 |
| 全仓双版本功能测试 | 未运行 | 待异名同义字段定型 |
| Linux 3.32.0 Table API Golden（无更新） | 1 通过、1 差异 | light 通过；dark 与旧基线差 4,056px / 1.52%，失败图在隔离测试副本。测试场景未设置 `TTableThemeData.bordered/stripe`，不能据此归因为本轮单入口迁移；仍须与变更前同环境渲染做消融比对 |
| Linux 3.32.0 BackTop Golden | 4 通过、4 差异 | 组件 light 通过、dark 差 601px / 1.29%；Demo light 3 张通过、dark 3 张差 3,758 / 952 / 795px。最终源码稳定后已复跑，数量不变；隔离差异图主要见文本和图标区域，未见圆角轮廓 |
| Linux 3.32.0 TimeCounter Demo Golden（无更新） | 2 通过、2 差异 | light 2 张通过；dark 页面 11,009px / 1.75%，advanced 10,875px / 1.72%。隔离消融将圆块恢复旧 `BoxShape.circle` 后，两张暗色实际 PNG SHA-256 与新实现逐字节一致，证明现有默认 Golden 差异不是本次 `radiusCircle` 修复造成；旧基线差异仍需追查字体/颜色等其他因素 |
| Linux 3.32.0 全 47 张目标 Golden | 12 通过、35 差异 | 本批迁移后无更新重跑；未新增差异，见 `report.md` |
| Linux 3.32.0 Avatar/BackTop/Skeleton/TimeCounter Demo | 6 通过、8 差异 | `radiusCircle` 相关消费端取样；Avatar/TimeCounter 消融的实际 PNG SHA 不变，不能将差异归于圆角修复 |
| Linux 3.32.0 Dialog 图片/Popover 定制内容浅色 Golden | 2 通过 | 局部 Theme 迁移后旧基线保持一致，未覆盖所有状态 |
| Text 组件 Theme 恢复后的双版本 analyze（历史检查点） | `lib test` 通过；3.47.0 全包通过，3.32.0 全包未过 | Flutter 3.32.0 与 3.47.0 的 `lib test` 严格检查均 0 issues，3.47.0 全包 0 issues；3.32.0 全包分析另有 20 条示例代码的 `RegExp` 弃用提示。当时仍保留 `TText.style`，已由上方新检查点取代 |
| Text/Button/Input 及共享消费者聚焦测试 | 上轮双版本各 187 通过 | 含 Text、Button、Input、Steps、Cascader、Picker、TabBar 和 Theme；本轮另以干净 3.47.0 隔离副本复跑 Button/Text 相关 143 项通过；不是全仓功能测试 |
| API 文档及 Demo 片段生成 | 通过 | `node tool/generate_api.mjs` 生成 57 份 API 文档；`dart run tool/generate_example_code.dart --check` 通过 |
| Linux 3.32.0 Text Demo Golden | 2 通过 | 旧图 375×1618；修正隐式 Material `bodyLarge` 错误升格和小程序正文回退后为 375×1616。核对源码与实际图，仅更新这两张；在同一固定 Linux 3.32.0 环境无更新复跑 2/2 通过。不是 Figma 像素验收 |
| Linux 3.32.0 Button Demo Golden（无更新） | 0 通过、4 差异 | 样本实际 PNG 在 Button 优先级修复前后 SHA 相同；outline 状态变更后这四张仍逐字节相同，旧基线差异待独立裁定 |
| 组件 Token 804 项审计 | 已输出逐项静态表，最终消费未通过 | 见 `component-consumption-audit.json`；早期“113 项 Less 别名未引用”误判已修正：100 项可经 Less 动态 `@@` 消费，10 项在冻结源码中未见静态消费者。81 项已有小程序消费者但无对应 Flutter 组件；其余 682 项仍待最终裁定 |
| Tag 回退链与尺寸修复 | 双版本各 66 项聚焦测试通过；Linux 旧 Golden 0/4 | 浅色三色、outline 背景与默认描边、square 圆角、关闭图标色及四档默认尺寸对齐小程序源码。Flutter 3.32/3.47 改动文件严格 analyze 零告警；四张 Golden 与旧基线差异未全部归因，未更新 |

## 人工验收及未覆盖项

### 2026-09-28 Figma Tag 实例数值回归

- 可访问的 Figma 副本中，Tag 实例 `26795:11055` 的 `primary/light/medium` 浅色填充为 `#F2F3FF`、文字为 `#0052D9`，水平/垂直内边距为 `8px/2px`。组件测试已对最终 Container/Text 值增加确定值断言，Flutter 3.32.0 聚焦测试 67/67 通过，Dart 定向分析 0 issues。
- 同一 Figma 实例显示高度 `20px`、圆角 `3px`。当前 Flutter 的 medium 默认外高仍为 `24dp`，方角经后续裁定改为回退全局 `radiusSmall = 3dp`，因此圆角数值已一致，高度差仍待按完整变体上下文裁定。Figma 结构化接口返回 Starter 配额限制；不将单实例的圆角数值一致扩大为整页设计验收通过。
- Demo 间距复核：以现有 Figma 页面证据和当前 Linux 3.32.0 源码实测图核对，Tag 连续实例说明的纵向步距均约 `86px`，Avatar 约 `110px`，Slider 约 `118px`；未为修正文字像素基线而整体改动 `ExamplePage` 间距。Tag 圆弧 Demo 按小程序类型示例和 Figma 补齐第三个 `mark + outline` 实例。
- Tag 默认 `light-outline` 边框由小程序的 `@component-border` 回退，而普通 `outline` 仍由 `@tag-default-color` 回退至 `@bg-color-component`；Flutter 已分开取值并加测试。小程序的方角 `8rpx = 4dp` 和中尺寸内边距 `2rpx 14rpx = 1dp 7dp` 是组件专属变量，不能将全局 `radiusSmall` 或 `spacer2/3` 改名/升档来模拟。
- 基于本地当前工作区重新制作隔离副本并在 Linux Flutter 3.32.0 无更新运行 Tag/Theme Golden，Tag 四张及 Theme 两张仍与旧基线不符；其中 Tag 已增加第三实例，Theme 色板 Demo 已修正旧 Token 键名与无效色块。当前渲染图作为 `current` 证据，旧图片仅为历史参考；Figma 的 Tag 高度/圆角差异仍未裁定，因此未更新这些 Golden。
- 提交前集中式组件回归首轮只有 Switch 覆盖率与 Theme 测试期望失败：Switch Theme 中间态插值未覆盖，原为 `324/354 = 91.53%`；Theme 测试仍按旧 `fontBodyLarge` 断言新 `fontBodyMedium` 默认。补充插值各字段断言并改正测试 Token 后，Flutter 3.32.0 Switch 33/33、`339/354 = 95.76%`，Theme 96/96、`479/504 = 95.04%`；Flutter 3.47.0 对应测试也通过。最终源码已在 Flutter 3.32.0 下重跑完整集中式组件回归，57/57 组件及各自 `LH/LF >= 95%` 门禁通过；这不替代 Demo、Golden 或远端 CI。
- Flutter 3.32.0 公开 Demo 功能回归首轮仅 Picker 头部标题测试的 `TextDecoration.none` 原始字段断言失败。最终解析出的 `null` 与 `none` 均不绘制下划线；测试改为断言最终无下划线后，完整 `run_example_regression.dart` **271/271** 通过。缺失示例代码资源的日志来自预期的错误处理测试，并非回归失败。Golden 差异仍未据此裁定。
- 回归调度器自测 19/19 通过。首次失败仅因新 Text 解析器注释中四个不用于可见文案的字不在测试字体子集中；将注释改为等义、既有字形的表述后通过，未扩充共享字体或改动 Golden。

### 2026-10-02 AvatarGroup 设计稿对齐

- 依据可访问的 Figma Avatar 公开展板 `25054:18489` 及组件集 `26722:7669`，组成员保持单行、48dp 中号、8dp 重叠，所有成员按小/中/大使用 1/2/3dp 容器色描边和 1dp 水平偏移、2dp 模糊、15% 黑色阴影。尺寸通过已有 `TAvatar.size` 选择，具体描边和阴影通过组件 Theme 覆盖；不新增重复实例入口，也不把小程序 WXML 的仅折叠头像描边及换行当作此设计实例的要求。
- 公开 Demo 图片顺序、`+2` 折叠文案及右侧成员在上的层叠方向已与展板一致。相同的 248×48px 浅色头像组区域，Figma PNG、固定 Linux 3.32.0 的 develop Golden 与本次 current 实际渲染进行无缩放裁切；最大通道差大于 10 的像素数分别为 5,613/11,904（Figma vs develop）和 939/11,904（Figma vs current）。后者残差主要分布于人物贴图/文字栅格和边缘阴影，不等于跨渲染器逐像素零差。
- 当前分支旧 Golden 对本轮实际图：浅色 15,015px、暗色 15,066px，差异边界均局限在两行头像组（x=16..264、y=748..905）。仅更新这两张 Linux Golden；修复隐藏成员尺寸继承边界后无更新复跑仍为 2/2 通过。Flutter 3.32.0/3.47.0 组件聚焦测试各 39/39、公开 Demo 测试各 4/4、严格静态分析通过；最终源码的 Linux 3.32.0 生产源码覆盖率 197/202 = 97.52%。组件/Golden 登记与共享字体字形自测 19/19 通过。此项只验收 AvatarGroup，不替代整份 PR 的其他组件门禁。

### 2026-09-30 组件配色预设 API 命名

- 已导出的五个 `T*ColorScheme` 枚举改为 `T*ColorPreset`；对应实例、静态展示方法、Dialog 操作与内部转发统一改用 `colorPreset`，无兼容别名。枚举成员、默认值、颜色解析顺序和绘制逻辑不变；Material `ColorScheme` / `ThemeData.colorScheme` 仍按原用途使用。迁移见 `migration.md`，属于源码级 breaking change。
- Flutter 3.32.0、3.47.0 完整组件包严格 `flutter analyze --no-pub --fatal-infos` 均 0 issues；受影响的十份组件测试各 370/370。公开 Demo 十份非 Golden 测试各 51/51；3.47 在工作树首次混合测试有 4 项失败，单独复现为旧缓存的 `ink_sparkle.frag` runtime-stage 格式错误，在排除 `build/.dart_tool` 的隔离副本中相同 51 项全部通过，非组件断言失败。
- 仓库外独立 `path` 消费包用新版 Button、Tag、Link、BackTop、Popover、DialogAction API 在 3.32.0、3.47.0 各编译运行 1/1；不代表真实第三方业务仓库已迁移。API 文档由 57 个 manifest 条目重新生成，五个预设枚举已进入相应文档；Demo 片段生成与 `--check` 通过，Link/Popover “查看代码”入口同步改名。
- 本次只改公开命名，不改预设映射、默认值或绘制；未据此更新 Golden。历史视觉差异继续按原任务逐项归因，不以命名迁移冒充视觉验收。

- [ ] 已修改组件逐项核对小程序默认表达和 Flutter 最终样式。
- [ ] Golden 差异有来源分类，未归因项保持阻塞状态。
- [ ] 公开 API 删除已记录迁移草案，但最终 diff、外部调用方编译与 breaking 发布安排尚未验收。

### 2026-09-28 Avatar/Popover 单入口补充验收

| 检查 | 结果 | 边界 |
| --- | --- | --- |
| 公开 API | Avatar Theme 移除 `textStyle`，统一由 `foregroundColor` 控制默认前景；Popover 实例移除 `overlayColor/radius`，由 Theme `barrierColor/borderRadius` 控制；后者改为 `BorderRadius?` | 均为 breaking；迁移见 `migration.md`；其余异名同义字段不在此结果内 |
| 组件聚焦测试 | Flutter 3.32.0 Linux 100/100；Flutter 3.47.0 macOS 100/100 | 包含自定义全局 `radiusDefault` → Popover 最终圆角、局部 Theme 覆盖、逐角圆角和 Theme 插值 |
| 公开 Demo 功能 | Flutter 3.32.0、3.47.0 各 7/7 | 不替代所有操作后 Golden |
| 组件覆盖率 | Linux 3.32.0：Avatar 169/173 = 97.69%；Popover 620/632 = 98.10% | 仅生产源码；在隔离临时副本生成 |
| 严格静态分析 | Flutter 3.32.0 与 3.47.0 的完整组件包、完整 Demo 包均为 0 issues | `flutter analyze --no-pub --fatal-infos`；这是本补充批次的当前结果，替代上文较早的阶段性统计 |
| 受影响 Demo Golden 无更新复跑 | Linux 3.32.0：Avatar/Popover 合计 25 通过、27 差异；Avatar 浅/暗各差 16,958px/20,571px | Avatar 数值与前批相同；Popover 失败含旧基线/Token 差异，未逐张归因；未更新基线，视觉门禁未通过 |
| 文档与片段 | 重新生成 Avatar/Popover API 文档；示例代码 `--check` 通过 | API 文档已无被删除的字段；未进行远端 PR/CI 验证 |

### 2026-09-30 Cascader、Theme、Slider Golden 裁定

- 用户确认这三类当前视觉结果符合预期，允许更新相应旧基线；不据此裁定其他组件或共享组合快照。
- 在隔离的 Linux amd64 / Flutter 3.32.0 副本中先无更新参数复现，再仅更新实际变化的 12 张 Golden：Cascader 组件 1 张、Slider 组件与 Demo 7 张、Theme 组件与 Demo 4 张。Cascader Demo 基线已有最新布局，无需改动。
- 差异包括 Cascader 组件分隔线 `#E7E7E7 → #E8E8E8`（343×1 像素）、Slider 轨道及 Demo 配色、Theme 色板项目和页面高度；Theme light/dark 页面分别从 375×2991 / 375×2969 变为 375×2837。Theme 的 Popup ActionSheet 共享样例底部分隔区域也随 Token 改变，归入本次 Theme 基线。
- 更新后立即在相同 Linux 环境移除更新参数复跑：组件相关测试 8/8、Demo 相关测试 28/28 通过。此结果仅证明上述受影响场景的新基线可复现；全量视觉回归和 PR 最终 head 的远端 CI 仍须另验。

### 2026-10-02 组件 Theme 插值与 Progress 尺寸命名补充

- Figma Copy 节点 `26805:11064` 返回 Tag 正文 12px/20px、水平/垂直 padding 8px/2px、方角 3px；本轮未修改这些默认视觉值。修正 Tag 通用前景/背景色与 padding 的 nullable 插值，使动画按当前配色和尺寸的有效默认值过渡；自适应与固定宽度之间采用离散切换，不将自适应误作 0 宽。
- Avatar 组间距在最终成员尺寸下解析并约束，避免两个合法 Theme 端点的中间态违反构造断言；Button 图文间距按内置 4dp 起点插值；Progress 不确定态比例、时长及依赖 variant/状态/Token 的尺寸和绘制字段均按有效默认值插值。`TProgressThemeData.circleRadius` 改名为 `circleSize`，数值含义仍是外框边长，不保留旧名。
- Flutter 3.32.0 与 3.47.0：Avatar、Progress、Tag、Button 四份组件测试各 289/289；组件包与 Example 包 `flutter analyze --fatal-infos` 均零诊断。57 份 API 文档由生成器重建，仅 Progress 文档保留本次公开字段变化；生成器额外删掉的无关 Drawer 入口已还原。
- 本轮在 macOS 执行非视觉验证，未生成或更新 Linux Golden；默认静态值未有意更改，但动画中间帧和公开 API 仍需在 PR 最终 head 的 Linux 3.32.0 回归与外部调用方编译中验收。Material `ColorScheme`/`TextTheme` 的字段级显式来源识别仍待单独裁定，不以整体色板比较作为临时兼容桥接。

### 2026-10-02 文字样式单一来源补充（本地未提交）

- 移除 Material `TextTheme` 显式来源推断，以及 `DefaultTextStyle` 到 TDesign 文字样式的自动桥接。默认文字只由全局 `TThemeData`、组件 `ThemeExtension` 和现存的实例样式解析；TThemeBuilder 向 Material `TextTheme` 的投影仍供原生 Material 控件使用，但 TDesign 组件不回读。`TStyleResolver` 不再提供 `textTheme/colorScheme/materialTheme` 转发 getter。
- Drawer 内置标题若收到 `TText`，由 Drawer 组件 Theme 显式传递标题样式；任意 Flutter `Text` 子节点仍可读取内部 `DefaultTextStyle`，但外层 Material 文字主题不参与 TDesign 解析。Tag 与 Progress 的字体族/回退仅取 TDesign Token。测试专用 Golden 字体通过 `TThemeData.fontFamilyMap` 注入，避免仅配置 Material `TextTheme` 时中文丢字。
- Flutter 3.32.0 / 3.47.0 严格分析各零诊断；两个版本受影响组件功能测试各 1090/1090 通过，Golden 字体注入单测各 1/1 通过。固定 Linux 3.32.0 使用隔离源码副本无更新跑视觉矩阵，已发现多个旧基线差异：Badge 单页 light/dark 各 0.09%（487/484 像素，集中在 Badge 小字）；Text Demo 高度 1616→1604，Tag/Progress/ActionSheet 等差异集中于文字字形或行盒；BackTop、Cascader 等还出现尺寸差异。不能仅凭功能通过或文字来源变动批量更新 Golden，须按最终源码逐类复核尺寸与像素后再更新并重跑。未修改仓库 Golden。

### 2026-10-03 文字来源变更后的 CI 修复与 Linux 基线

- Cell、Popup 接收任意标题 Widget 的插槽，在组件内部同时向 `TTextThemeData.textStyle` 与原生 `DefaultTextStyle` 提供局部默认样式；不恢复 `TText` 从外层 Material 字体主题自动推断样式。Steps 旧测试改用显式 TDesign 组件 Theme 验证，实例样式仍优先。新增插槽优先级测试及 Text 字体回退、富文本语义测试。
- Flutter 3.32.0 完整组件回归通过，Text 生产源码覆盖率 132/134 = 98.51%；Flutter 3.47.0 隔离副本的组件回归功能断言全部通过，补充测试后的 Text 聚焦覆盖率 131/134 = 97.76%。两版本完整组件包严格 analyze 均零诊断；3.32.0 受影响的 Example 功能测试 11/11 通过。
- 固定 Linux amd64 / Flutter 3.32.0 使用隔离副本重现旧 Golden 失败。逐张比较仓库原图与候选图，共有 450 张同尺寸像素差异、102 张尺寸差异；其中 4 张差异在首轮失败清单外，故首轮清单只记录 446 张同尺寸差异。抽查 Indexes、Dialog、Cell、Popup、Steps、Avatar、BackTop、Calendar、Cascader、Tag、Theme、TabBar 等原图与新图，高差异主要是文字字形、行盒及列表逐行累积位移；未通过 Demo 覆盖组件样式。102 张尺寸差异中，100 张仅页面高度变化（最大缩小 30px），BackTop 状态矩阵浅/暗两张宽度各缩小 1px。
- 在隔离副本中生成候选基线后，完整视觉矩阵以**无更新参数**严格复跑并全部通过，随后只同步 552 张内容变化的 Golden PNG 至仓库。606 张 Golden 中其余 54 张未改动；这验证固定 Linux 基线可复现，不等同于 606 张逐项 Figma 像素验收或最终远端 CI 通过。
- 推送后远端 Flutter latest Example 功能测试 274 通过、1 失败：`example/test/widget_test.dart` 的紧凑模块标题测试仍期待 Material `TextTheme.titleLarge` 将 TDesign 的 20dp/28dp Token 改写成 22dp/1.5。实际组件壳已显式读取 `fontTitleLarge`，故修正旧断言为两种 Material 配置均保持 20dp/1.4、w500；Flutter 3.32.0 和 3.47.0 聚焦 Example 测试各 8/8 通过。此修正不改渲染源码或 Golden，仍需新 head 远端 CI 复验。

### 2026-10-03 Tag 前景与 Material 色板字段优先级

- 先用两个新增聚焦测试复现原行为：`TTagThemeData.textColor` 只改变正文，前置图标仍取预设色；仅修改 Flutter `ThemeData.colorScheme.primaryContainer` 时，`tExplicitColorScheme` 返回 `null`。两项在修复前均按预期失败。
- 修复后 Tag 前置图标与正文共用有效前景色，关闭图标仍取独立占位色，禁用态不受普通组件 Theme 覆盖。共享 Material 色板读取器逐字段比较调用方色板与隐式 Material 基准或 TDesign Token 投影；未改动字段返回 `null` 并继续回退组件原有全局 Token。测试锁定“组件 Theme > 显式 Material 字段 > Token”及单字段修改不污染其他颜色。Flutter `ThemeData` 不记录显式赋值来源，显式设置为与基准完全相同的值按未修改处理。
- Flutter 3.32.0 完整组件回归调度器全部通过，包含各组件生产源码覆盖率门禁；Flutter 3.32.0 与 3.47.0 的 Tag + Material 优先级聚焦测试各 93/93 通过，完整组件包严格 analyze 各 0 issues。57 份 API 文档已运行生成器，保留本次 Tag 文档变更；生成器顺带删除的无关 Drawer 文档段落已恢复。
- 在隔离临时副本中使用 Linux amd64 / Flutter 3.32.0 执行完整 `dart run tool/run_visual_regression.dart`，未更新 Golden，全部视觉套件通过；原仓库 PNG 未改。镜像离线 `pub get` 将图标包从工作树锁定的 0.0.6 解析为 0.0.7，因此该结果仅为辅助验证，不代替最终 PR head 的 CI 同依赖回归。新增测试不改变公开 Demo 的默认视觉，也未生成新 Golden。
- `ThemeData.tExplicitColorScheme` 的返回类型由 `ColorScheme?` 改为逐字段可空的 `TExplicitColorSchemeColors?`，属于公开 Dart 类型的 breaking 迁移，见 `migration.md`；Tag 自身仍只通过 `colorPreset` 选择配色，没有恢复组件 `colorScheme` 参数。本地未提交、未推送，远端 CI 未对此批次运行。

### 2026-10-03 全组件单向主题链（替代上一节的 Material 反向优先级方案）

- 最终约定是实例显式样式 → TDesign 组件 Theme → 全局 TDesign Token；Material `ThemeData` 只承载 TDesign 扩展并接收面向原生 Flutter 控件的投影，不反向控制 TDesign 组件。因此上一节的 `tExplicitColorScheme` 字段级读取及其返回类型迁移方案已废弃，代码中不保留相关 getter 或 `TExplicitColorSchemeColors`。
- 已逐组件移除 Material `ColorScheme`、Material 组件 Theme、`IconTheme` 等外观回读；Badge 与 Slider 的必要子树视觉字段分别由 `TBadgeThemeData`、`TSliderThemeData` 承担。`TIcon` 独立使用时显式采用 24dp/全局文字主色，Button 与 Tabs 的库内图标作用域只转发自身已解析样式。Table 内纯图标 Checkbox 适配父布局的有限约束，避免 37.5dp 行高的 11px 溢出。明暗模式选择和组合组件内部传递已解析样式不属于 Material 外观覆盖。
- Flutter 3.32.0 与 3.47.0 的组件包及 Example 严格 analyze 均零诊断；3.47.0 的单向主题、Icon、Button、Table 聚焦测试全部通过。3.32.0 全量非 Golden 组件测试 2676/2676 通过。隔离 Linux amd64 环境使用工作树锁定的图标包 0.0.6，7 份受影响组件 Golden 共 26 项严格无更新通过。公开 Demo 的 Avatar 旧 54px 角标差异由无效的 Material `BadgeTheme.smallSize` 示例配置造成，改为组件 `TBadgeThemeData.dotSize` 后严格快照通过。Badge light/dark 两张差异各约 0.41%（2349/2350px），集中于 large ribbon/triangle 角标：旧实现从 Material BadgeTheme 投影强制取 16dp，现按 `fontMarkSmall` 的 20dp 行盒解析。Icon Demo 改为展示 Token 默认值，Theme 页禁用按钮改由 TDesign Token 控制；这三类共八张实际变化的 Linux Golden 已按候选更新。最终仓库基线在隔离 Linux 3.32.0 上执行完整 `dart run tool/run_visual_regression.dart`，**不带更新参数**，全部视觉套件通过。
- 本节记录提交前的本地验证；提交后的远端 CI 和真实第三方调用方迁移编译须另行验收。本地视觉矩阵通过不等于逐张 Figma 像素验收。
- PR head `489f01f9` 的远端双版本 analyze、Linux Golden 与全部构建通过，但双版本组件回归均仅因 Icon 生产源码覆盖率 `14/17 = 82.35%` 低于 95% 失败；21 项 Icon 功能断言本身全部通过。补充库内 `TIconStyleScope` 的样式传递、实例优先级和变更通知测试后，Flutter 3.32.0/3.47.0 各 23/23 通过，Icon 生产源码覆盖率各 `17/17 = 100%`，两版组件包严格分析零诊断。该作用域只供组合组件传递已解析样式，已从 `tdesign_flutter.dart` 总导出中排除；修复后的远端 CI 仍须以新 head 复验。

### 2026-10-03 Switch 组件 Token 消费补核

- PR head `36a4e386` 的远端 Flutter 3.32.0/latest 分析、测试、Linux Golden、APK/iOS/Web、Autofix、站点和扫描均通过；但 CLA 因 `autofix-ci[bot]` 未签署而 Pending，PR 仍为 Draft 且缺一位必需 Review。远端通过不等于 804 项组件变量最终消费或真实第三方 breaking 迁移验收。
- 本轮逐项复核发现 `switchUncheckedColor`：小程序回退 `@bg-color-secondarycontainer-active`（浅 `#dcdcdc`、暗 `#383838`），Flutter 却取 `textColorDisabled`。组件现改取 `bgColorSecondaryContainerActive`，保留 `TSwitchThemeData.trackOffColor` 的显式覆盖。Flutter 3.32.0 与 3.47.0 聚焦 Switch 测试各 16/16 通过，新增断言验证最终传入 `TCupertinoSwitch.trackColor` 的浅色为 `#dcdcdc`。
- 隔离 Linux amd64 / Flutter 3.32.0 无更新完整视觉回归仅在 Switch Demo、Cell Demo、Theme Component 三个套件失败。逐张检查差异集中于未选中轨道的颜色区域，无尺寸或布局位移；仅更新由此变化的 Switch 4 张、Cell 2 张、Theme 1 张 Golden。三套件随后无更新复跑通过；完整矩阵的其他套件在更新前均通过，最终完整矩阵与新 head 远端 CI 仍需验收。
- 审计脚本在当前源码上重新生成 804 项映射；Switch 此项从 `pending` 移为“回退链与 Widget 已验证，跨端视觉待裁定”，其余 `pending` 为 681 项。静态 getter 分类随此前源码行和 getter 更新为 411 / 286，不把这类自动分类变化计作逐项验收。

### 2026-10-03 Form 与 DropdownItem 默认消费补核

- 小程序 `--td-form-bg-color` 在 Form 根节点消费；Flutter 先前仅 FormItem 读取该回退。根节点现与 FormItem 共用 `TFormThemeData.backgroundColor → bgColorContainer`，无同义实例参数。组件测试检查亮/暗 Token 与组件 Theme 覆盖。Linux Form 六张 Golden 中仅竖向排布亮/暗两张变化：亮色第 1383 行 375px，由 `#ececec` 变 `#eeeeee`；暗色各有一条水平线，共 750px，由 `#2e2e2e` 变 `#2f2f2f`。仅同步这两张。
- 小程序 `--td-dropdown-body-max-height` 的默认 560rpx 对应 280dp，只约束可滚动主体，不包含多选底部操作区。Flutter 单选/多选默认主体改为 280dp，已有实例 `maxHeight` 继续控制显式上限，不增加同义 Theme 字段。长列表 Widget 测试分别检查主体高度、多选操作区和整面板高度；现有 Dropdown 组件交互测试 95/95 通过。Linux Dropdown 16 张公开 Demo Golden 中仅四张单列/双列多选打开态变化，各约 12.7%–13.0%，由主体收短和操作区上移引起，未改变其余 12 张。
- Fab 阴影与 PullDownRefresh 提示色核对到最终 Widget，未改渲染源码。两版聚焦测试均通过（Flutter 3.32.0 当前批次 Form/Refresh/Fab 168/168、Dropdown 95/95；Flutter 3.47.0 隔离副本合计 263/263）。两版组件包及 Flutter 3.32.0 Example 的 `flutter analyze --fatal-infos` 均零诊断。固定 Linux amd64 / Flutter 3.32.0 上 Form 与 Dropdown 合计 22 张 Golden 严格无更新复跑通过，随后完整 `dart run tool/run_visual_regression.dart` 无更新参数复跑全部视觉套件通过；远端 CI 仍需以新 head 另验。
- 审计 JSON 仍有 804 项，`pending` 从 681 降至 677。仅四项新增最终 Widget 证据，不把其余静态命中或现有 Golden 自动判为跨端逐像素通过。
