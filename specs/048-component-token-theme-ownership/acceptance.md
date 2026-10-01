# 验收记录

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
- 当前分支旧 Golden 对本轮实际图：浅色 15,015px、暗色 15,066px，差异边界均局限在两行头像组（x=16..264、y=748..905）。仅更新这两张 Linux Golden；无更新复跑 2/2 通过。补充 Theme 阴影插值断言后，Flutter 3.32.0/3.47.0 组件聚焦测试各 38/38、公开 Demo 测试各 4/4、严格静态分析通过；Linux 3.32.0 生产源码覆盖率 191/199 = 95.98%。此项只验收 AvatarGroup，不替代整份 PR 的其他组件门禁。

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
