# 验收记录

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
