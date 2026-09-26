# 验收记录

## 2026-09-27 顶边线和安全区 API 收敛

- 删除 `showTopBorder`、实例与 Theme 的 `topBorder`、`placeholder`。Filled 保持默认 0.5px 顶线，Capsule 仍无顶线；自定义 Demo 现在也使用默认线。`useSafeArea: true` 仍用组件背景填满底部安全区，false 不处理。需要仅避开安全区的场景须在组件外组合 `SafeArea`，此组合尚未作为公开 Demo 验证。
- Flutter 3.32.0 与 3.47.0：组件测试各 44/44、Demo 测试各 9/9；组件包和 Example 包完整 `flutter analyze --fatal-infos --no-pub` 均零问题。3.32.0 TabBar 生产源码覆盖率 504/513（98.25%），示例代码 `--check` 通过。
- Linux Flutter 3.32.0：先无更新比对，组件 Golden 14/14 与共享导航矩阵 2/2 通过；公开 Demo 有 8 张仅在自定义实例新增默认顶线的区域发生差异。审查差异后更新该 8 张，随后公开 Demo 无更新严格复跑 11/11 通过；两张文字 Toast Golden 不变。

## 2026-09-27 centerDistance API 删除

- `TTabBar` 构造参数及 `TTabBarThemeData` 字段均已删除，生成的 TabBar API 文档已同步。图文项沿用原默认：上下排列 0px，左右排列 4px，公开 Demo 配置不变；自定义间距无直接替代参数，这是有意的 breaking 收敛。
- Flutter 3.32.0 与 3.47.0：组件测试各 42/42，Demo 测试各 9/9；组件包与 Example 包 `flutter analyze --fatal-infos --no-pub` 均零问题。3.47.0 TabBar 生产源码 `LH/LF = 514/523 = 98.28%`，示例代码 `--check` 通过。
- 变更仅移除覆盖入口并保留原内部默认布局；未修改公开 Demo 与绘制默认值，因此本批次跳过 Golden，原有完整 Figma 页面和最终真机逐项验收缺口仍按下节记录。

## 2026-09-27 develop 隔离分支复核

- 本节的图文布局结论替代下方 2026-09-08 对 Figma Horizontal/Vertical 名称的旧解释：可访问组件展板显示该对变体是单项图文的上下/左右排列，两种标签栏都保持水平整栏。
- 从 `develop@97afb678` 建立独立 worktree，只迁移 TabBar 组件、公开 Demo、测试、Spec 和对应生成产物；原有 Token 重构工作树保持原状。适配 develop 已有 Token 名称，未引入全局 Token 改动。
- Flutter 3.32.0 与 3.47.0：组件测试各 42/42，公开 Demo 测试各 9/9；组件包与 Example 包完整 analyze 均零问题。3.32.0 TabBar 生产覆盖率 528/538 = 98.14%，示例代码生成 `--check` 通过。
- Linux Flutter 3.32.0 先运行不带更新参数的 Golden 并检查实际图、旧图和差异；更新 TabBar 组件明暗 14 张（包含新增的左右图文实例）及公开 Demo 明暗和操作后 10 张，随后两组无更新、无像素容差复跑分别 14/14 与 11/11 测试通过。Linux 临时副本使用本地工具依赖覆盖修复镜像缓存，未改工作树依赖声明；图片中的图标包版本与工作树锁文件同为 0.0.7。
- Draft PR #1146 的首轮 Linux CI 暴露共享导航组件矩阵仍含旧 TabBar 行：明暗分别 0.60%（2712px）、0.59%（2689px）。CI 差异图显示其他导航组件未变；本地相同环境复现相同差异，更新共享矩阵两张 Golden 后无更新严格复跑 2/2 通过。其他依赖该矩阵的 BackTop、Drawer、NavBar、Tabs 分组无需修改生产源码。
- Flutter 3.32.0 Android 16 真机 debug APK 构建、安装并启动成功；`com.tdesign.tdesign_flutter_example/.MainActivity` 已确认前台，UI 层级可见 TabBar 页面 3 组、9 实例。设备随后锁屏，本轮尚未对最终版逐项手动点击和截图核对。
- Flutter 3.47.0 Example Web release 构建成功；`synthetic-package` 与 Wasm dry-run 只产生既有提示。`git diff --check` 通过。
- 可访问的 Figma 副本 `5iZtzla34Rz25j4cK7viAz:25529:22098` 是 1440×2596 组件展板；完整 375px 移动端 Demo 节点 `28591:35219` 不在该副本中，原分支也无读取权限。当前无法据此宣称整页 Figma 逐像素一致，仍待提供可访问页面或导出图。


## 2026-09-08 最终 develop 同步

- 已合并最新 `origin/develop@a841e3dd`。唯一文本冲突位于
  `example/test/fonts/README.md`，合并后同时保留 Cascader 与 TabBar 的字体清单及
  更新说明，不改变两者测试契约。
- 合并后重新执行 Flutter 3.32.0 与 3.47.0：TabBar 组件测试各 22/22、公开 Demo
  测试各 5/5；组件包与 Example 包 `flutter analyze --fatal-infos` 均零问题。
- Flutter 3.32.0 生产代码覆盖率 `514/525 = 97.90%`，回归清单自测 5/5，示例
  代码生成检查通过。
- Flutter 3.32.0 Linux 在无更新参数、无像素容差下复跑：组件明暗 Golden 12/12、
  Demo 明暗 Golden 4/4 全部通过。
- 最终远端 CI 与 CNB Review 以本节变更推送后的 head 为准。

## 2026-09-08 徽标契约收敛

- 删除 `TTabBarBadgeConfig` 及其重复的 `showBadge`、`badgeTopOffset`、
  `badgeRightOffset`；`TTabBarItemConfig.badge` 直接接收可空 `TBadge`，由 `null`
  唯一表达隐藏，逐项位置使用 `TBadge.offset`。
- TabBar 将标签内容作为 `TBadge.child` 的实际锚点，徽标不再依赖统一的
  `top: -2 / right: -10` 绝对位置。纯文本公开示例使用独立 offset，图标与图文
  示例使用徽标默认锚点，对应小程序公开 Demo 的配置差异。
- 已同步公开 Demo、生成代码片段、API manifest 与 API 文档；聚焦组件测试验证
  徽标保留自身 offset 且位于图标右上方，并验证 BadgeTheme offset 仍按主题优先级
  生效、徽标回调不会阻断 TabBar 选中回调。
- Flutter 3.32.0 与 3.47.0：TabBar 组件测试各 23/23、公开 Demo 测试各 5/5；
  组件包与 Example 包严格 analyze 均零问题。Flutter 3.32.0 生产覆盖率
  `511/522 = 97.89%`。
- 在 Google Chrome 打开的固定 Figma 节点与本轮实际渲染图之间人工核对：纯文本
  徽标改为右上锚定，不再与文字同高或遮挡；图标、图文继续使用 TBadge 默认锚点。
  本地 macOS Golden 仅用于生成走查图，未写回权威基线。
- Flutter 3.32.0 Linux 已核对并更新受影响的四张 Demo 明暗/菜单展开基线，随后
  不带更新参数、无像素容差严格复跑：组件 Golden 12/12、Demo Golden 4/4
  全部通过。移动设备与远端证据以后续验证结果为准。

## 2026-09-08 徽标点击门控复审

- `TBadge.onTap` 作为标签项点击链中的附加回调，沿用 `allowMultipleTaps` 门控：
  未选中项调用，重复点击当前选中项仅在 `allowMultipleTaps: true` 时调用，
  TabBar 禁用时不调用；因此不会与 `TTabBarItemConfig.onTap` 产生不一致的重复点击语义。
- 迁移映射保持明确：`showBadge: false` → `badge: null`，`tBadge` → `badge`，
  `badgeTopOffset` / `badgeRightOffset` → `TBadge.offset`；徽标内容由 TabBar
  作为 `TBadge.child` 锚点管理。
- 新增 `needInkWell: true` 下的受控状态回归，覆盖选中、未选中、重复点击及
  `allowMultipleTaps` 差异；组件测试当前 24/24 通过。

## 2026-09-08 补充复审与修复

本节为本轮结果；下方真机、构建及首轮检查是历史记录，不替代本轮证据。

- 基于 PR head `3ebf119f` 修复；重新核对 `develop@3d5ed773` 未变化。
- 文字与菜单的内置 defaults 低于显式 TextTheme、DefaultTextStyle、TTextThemeData；字体族/字号局部覆盖不顺带改变选中颜色。实例文字 style 保持最高优先级。
- 共享解析器仅在传入 defaults 时走字段级路径，内部只读投影视图不导出、不增加主题状态；既有 TText 及其他消费者原路径不变。
- 菜单路由捕获触发位置的 InheritedTheme；菜单行不再用默认底色覆盖面板自定义背景。内部路由、状态、画笔与徽标适配类私有化，迁移说明见 spec。
- 指示器 none/linear/elastic 动态切换时同步位置；中断动画从当前进度起步。Demo 双层级初始为“我的”，受控状态移入页面 State，查看代码及页面重建不会重置选择。
- 七个公开代码面板逐个真实打开并与生成片段匹配；核心片段标明必要 State、导入和接入方式。七份实际生成片段在最小宿主中编译/渲染；临时拼接测试不作为平行示例实现提交。
- Flutter 3.32.0 与 3.47.0：TabBar/Text/工具测试 67/67；Demo 五项和片段七项分别验证；严格 analyze 零问题。共享解析器另在 Steps 分支通过 2074/2074 全部非视觉组件测试。
- 生产覆盖率：TabBar 518/531 = 97.55%，Text 219/222 = 98.65%。
- Linux 3.32.0：组件明暗 14/14 原基线通过；整页明暗初始选中项变动约 1.00%，新增滚动后菜单展开明暗两张。四张 Demo 基线更新后严格复跑，无像素容差。菜单锚点通过几何断言与实际图检查。
- 本轮未重新进行 Android/iOS 真机逐像素核对，不能将代码/Golden 验证等同于与设计稿逐像素完全一致；新 head 远端 CI 与 CNB Review 待推送后核验。

## 2026-09-08 Layout 语义复核

- Google Chrome 中直接核对 Figma 子节点 `26951:13385`（normal-horizontal）与
  `26951:13389`（normal-vertical）：前者的普通项仍是图标在上，后者的普通项为
  图标在左，证明节点名描述整栏方向而不是内部图文方向。
- 小程序当前实现没有 Layout 属性：普通图文项固定纵向排列，双层级入口仅在菜单
  文案左侧加入 `view-list` 图标。Flutter 删除 `TTabBarLayout/layout` 草案，避免用
  局部 Row/Column 假装实现整栏方向。
- 水波纹路径只由内部 `InkWell` 接收 tap，普通路径只由外层 `GestureDetector`
  接收 tap；新增一次手势只触发一次 item `onTap` 和一次 `onChanged` 的回归。
- `onTap` 与 `allowMultipleTaps` dartdoc 明确选中变化、重复点击、禁用和通知边界。
- 撤回仅供 TabBar 使用的 `ExamplePage.navBarTitle`；页面壳继续使用既有单标题契约，
  不把页面展示差异扩散为共享 API。
- Flutter 3.32.0 与 3.47.0：TabBar 组件测试各 22/22、Demo 测试各 5/5；
  组件包与 Example 包严格 analyze 均零问题。TabBar 生产覆盖率
  `514/525 = 97.90%`，回归清单登记自测 5/5，示例片段生成检查通过。
- Flutter 3.32.0 Linux：删除两张误建模的横排基线后，组件明暗 Golden 12/12
  原基线通过；撤回共享导航标题 API 只改变页面壳标题，四张 Demo 基线核图后更新，
  随即在无更新参数下严格复跑 4/4，无像素容差。
- 本轮没有重新进行 Android/iOS 最终版本逐项操作，因此不把代码、Widget 测试或
  Linux Golden 宣称为移动设备逐像素完全一致；新 head CI 与 CNB Review 仍以推送后为准。

## 2026-09-08 develop 同步与主题复审

- 已合并 `origin/develop@3d5ed773`，保留公共 ExamplePage 的导航标题样式隔离。
- 修复 `TTabBarThemeData.lerp`：高度、间距和分割线尺寸从实际内置默认值插值；
  nullable 颜色和边线不再生成透明色或 `BorderSide.none` 高优先级覆盖。
- Flutter 3.32.0 `flutter analyze --fatal-infos` 通过；组件测试 17/17、集中回归
  清单自测 13/13 通过；生产源码覆盖率 510/527 = 96.77%。
- macOS 上公开 Demo 结构测试通过；整页 Golden 因 develop 的公共导航标题样式变更
  出现 4.72% 预期差异。权威基线只在 Flutter 3.32.0 Linux 更新，等待本轮 CI
  产出 Linux failure artifact 后核对并提交。

## 设计核对

- Figma 固定节点：`28591:35219`。
- 小程序公开参考：`components/tab-bar?tab=demo` 与
  `Tencent/tdesign-miniprogram/packages/components/tab-bar`。
- Figma 的 Horizontal/Vertical 是整栏方向轴；当前 Flutter PR 未实现完整纵向
  TabBar，不能用普通项内部 Row/Column 冒充该能力。
- 公开 Demo 以节点内 `TabBar 底部标签栏 移动端展示` 画板为准，而不是右侧组件
  资产展板：3 个分组、9 个示例、固定首页/应用/聊天/我的四项。

## 实际验证

- Android 16 真机构建并安装 debug APK，Flutter attach 后大写 `R` 在 1.533s
  完成；随后按用户要求改用桌面可见的 iPhone 16 Pro Simulator 继续逐轮验证。
- 最终 Demo 在 Simulator 大写 `R`（588ms、527ms）后打开页面，实际点击纯文本第二项、
  打开并选择双层级菜单、滚动检查弱选中三行/悬浮胶囊/自定义，并切换真实暗色主题。
- Figma 人工对照确认正文标题与说明、3 个分组、9 个示例、四项文案、
  徽标类型、胶囊和自定义行一致；Horizontal/Vertical 属于整栏方向，当前未实现的
  纵向整栏不以单项图文排列测试代替。
- Flutter 3.32.0 Linux 离线固定环境：组件明暗 Golden 14/14、Demo 整页明暗
  Golden 2/2，更新后立即去掉 `--update-goldens` 精确复跑 16/16；人工看片发现并
  修复中文子集缺字后再次生成、复跑和检查，无方框、裁切、溢出或暗色残留。
- Flutter 3.32.0：严格 analyze 零问题，组件 16/16、Demo 1/1；生产源码覆盖率
  `496/511 = 97.06%`。Flutter 3.47.0：严格 analyze 零问题，同组测试 17/17。
- Flutter 3.32.0 与 3.47.0 的 Example Web release build 均成功；3.47.0 仅输出
  既有 `synthetic-package` 废弃提示及 Wasm dry-run 建议，不是构建失败。

## 未覆盖项

- 维护者已确认当前可先以 Simulator 证据推送并发起 CNB Review；Android 真机重新
  连接后再补最终版本逐项操作，Simulator 证据不冒充真机证据。
- GitHub #1085 / CNB #152 已存在；本轮新 head 远端 CI 与 CodeBuddy Review 待推送后核验。

## 2026-09-17 双层菜单默认宽度补充验收

- Figma node `28591:35265` 的双层菜单为 107px 宽、152px 高，包含 3 个
  48px 菜单行；修复前 375px 四等分场景默认宽度约 73.25px，修复后为 107px。
- 修复前 / 修复后 / Figma 三栏标注图和修复前后像素 Diff 作为 PR Review 证据
  单独生成，不提交进仓库或 Spec，避免长期积累二进制审查资产。
- Flutter 3.32.0 与 3.47.0 的组件测试、Demo 测试及 analyze 均通过；Linux
  Flutter 3.32.0 的 10 个视觉用例与 1 个注册集合测试更新后无更新参数复跑
  11/11 通过。
- 本轮尚未用最终提交在移动设备重新逐项操作，因此对应移动设备验收项继续保持
  未完成，不以测试或 Golden 替代。

### Demo Golden 覆盖矩阵

| 公开范围 | 初始态 | 点击后稳定态 | 独立交互态 | 明暗主题 |
| --- | --- | --- | --- | --- |
| 纯文本 | 整页 Golden | 第二项选中整页 Golden | “点击了 Item 2” Toast | light / dark |
| 图标加文本 | 整页 Golden | 第二项选中整页 Golden | 无额外视觉结果 | light / dark |
| 纯图标 | 整页 Golden | 第二项选中整页 Golden | 无额外视觉结果 | light / dark |
| 双层级文本 | 整页 Golden | 第二项选中整页 Golden | 菜单展开、“选择了个人主页” Toast | light / dark |
| 弱选中纯文本 | 整页 Golden | 第二项选中整页 Golden | 无额外视觉结果 | light / dark |
| 弱选中纯图标 | 整页 Golden | 第二项选中整页 Golden | 无额外视觉结果 | light / dark |
| 弱选中图标加文本 | 整页 Golden | 第二项选中整页 Golden | 无额外视觉结果 | light / dark |
| 悬浮胶囊 | 整页 Golden | 第二项选中整页 Golden | 无额外视觉结果 | light / dark |
| 自定义样式 | 整页 Golden | 第二项选中整页 Golden | 无额外视觉结果 | light / dark |

整页 Golden 使用 375×1260 视口完整包含 9 个实例，不是首屏截图；Toast 与展开菜单
使用 375×812 手机视口的 Overlay Golden。注册集合测试将上述 9 个初始态、9 个
选中态及 3 类独立交互态逐主题登记，避免后续删掉测试却继续宣称覆盖完整。

## 2026-09-18 纯文本徽标默认定位收敛

- 基于本地 `develop@0de62b9b`，将公开 Demo 的 `Offset(16, -8)` 收回 TabBar
  纯文本项内部；实例 `TBadge.offset`、局部 `BadgeTheme.offset`、全局
  `BadgeThemeData.offset` 仍依次优先，图标与图文项继续使用 `TBadge` 默认位置。
- 公开 Demo 四个纯文本徽标均不再传 offset；示例片段和 TabBar API 文档由源码
  重新生成，`generate_example_code.dart --check` 通过。
- Flutter 3.32.0：TabBar 组件 27/27、TabBar Demo 7/7 通过；组件包与 Example
  `flutter analyze --fatal-infos --no-pub` 均零问题。
- Flutter 3.47.0：TabBar 与 SideBar 聚焦组件测试合计 94/94、TabBar Demo 7/7
  通过；组件包与 Example 严格 analyze 均零问题。
- Flutter 3.32.0 聚焦覆盖率门禁通过：TabBar 生产代码 520/531，97.93%（门槛
  95%）。
- macOS Flutter 3.32.0 无更新运行组件 Golden 时，纯文本、图文和胶囊等不含
  Badge 的场景也出现 0.20%–0.40% 字形栅格差异；纯图标场景通过。已检查实际图、
  基线图和差异图，未更新 Linux 权威基线；Flutter 3.32.0 Linux Golden 仍待验证。
- 本轮未重新打开 Figma 或运行移动设备，不将功能测试视为最终逐像素验收。

## 2026-09-18 图文徽标锚点修复

- PR 分支已快进到最新 `origin/develop@cec91a38` 后重新验证；上游新增的 Indexes
  与 Table 改动不在本次 diff 中。
- 图文项不再把“图标 + 文字”整列注入 `TBadge.child`，改为仅以 icon 作为徽标
  锚点；因此下方文字宽度不再改变 Badge 的水平位置。纯文本项与纯图标项行为不变。
- 新增长文案图文项几何断言：默认 Badge 中心与 icon 右上角重合；既有显式
  offset 用例同时断言 icon 位于 `TBadge` 内、文字位于 `TBadge` 外。
- Flutter 3.32.0 聚焦组件测试 95/95、四个 Badge 相关公开 Demo 测试 27/27
  通过；组件和 Example 聚焦 `flutter analyze --fatal-infos` 均零问题，
  `git diff --check` 通过。
- Flutter 3.47.0 同组组件测试 95/95、公开 Demo 测试 27/27 通过，组件包与
  Example 严格 analyze 均零问题。首次并行 Demo 测试命中跨 SDK
  `ink_sparkle.frag` 缓存污染；使用 3.47.0 clean + pub get 后串行复跑通过。
- Flutter 3.32.0 生产源码覆盖率：TabBar `524/535 = 97.94%`，SideBar
  `262/262 = 100.00%`，均高于 95% 门槛；示例代码生成检查通过。
- 使用同一环境的修复前、修复后截图与 Figma 节点重新生成三栏标注图；TabBar
  纯文本、纯图标、图文三种形态均单列，图文差异标注为“整列锚点 → icon 锚点”。
  SideBar、Avatar、Cell、ActionSheet 列表和宫格也保留各自形态与所有权结论。
- macOS Flutter 3.32.0 对现有 TabBar Golden 的无更新复跑存在约 4.73%–5.97%
  的整页字形/环境差异，未写回 Linux 权威基线；本轮视觉结论来自同环境前后截图、
  Figma 标注图及精确几何断言，不把该本地 Golden 失败误报为回归通过。
- 最新 debug APK 已构建并安装到 Android 16 真机 `40302eeb`；包
  `com.tdesign.tdesign_flutter_example` 的 `MainActivity` 已确认处于前台，detach
  后进程仍在运行。
