# 验收记录

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

## 2026-09-08 develop 同步与主题复审

- 已合并 `origin/develop@3d5ed773`，保留公共 ExamplePage 的导航标题样式隔离，
  同时保留 TabBar 页面独立 `navBarTitle`。
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
- 新 Figma 相比小程序明确新增 Horizontal/Vertical 展示轴；记录该差异并由
  Flutter 独立 `layout` 参数表达。
- 公开 Demo 以节点内 `TabBar 底部标签栏 移动端展示` 画板为准，而不是右侧组件
  资产展板：3 个分组、9 个示例、固定首页/应用/聊天/我的四项。

## 实际验证

- Android 16 真机构建并安装 debug APK，Flutter attach 后大写 `R` 在 1.533s
  完成；随后按用户要求改用桌面可见的 iPhone 16 Pro Simulator 继续逐轮验证。
- 最终 Demo 在 Simulator 大写 `R`（588ms、527ms）后打开页面，实际点击纯文本第二项、
  打开并选择双层级菜单、滚动检查弱选中三行/悬浮胶囊/自定义，并切换真实暗色主题。
- Figma 人工对照确认顶部 `TabBar`、正文标题与说明、3 个分组、9 个示例、四项文案、
  徽标类型、胶囊和自定义行一致；组件资产中的 Horizontal/Vertical 由独立组件测试覆盖。
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
