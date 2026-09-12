# TabBar 设计稿对齐与 API 收敛

## 背景

当前 `TTabBarVariant` 同时表达内容类型、选项样式与标签栏外形，`text` 与
`weakText` 等命名还与设计稿的 Normal/Label 语义相反。公开 Demo 也未按新版
移动端设计稿展示独立的 Item Style 与 TabBar Style 维度。

## 设计证据

- Figma：`TDesign for mobile` branch `4SdclZkcv5bPgX6pa8AsmI`，node
  `28591:35219`。
- Figma 移动端 Demo 主页固定为 375px 宽、3 个分组和 9 个示例：组件类型含
  纯文本、图标加文本、纯图标、双层级文本；组件样式含弱选中 3 行与悬浮胶囊；
  自定义含 1 行自定义样式。公开 Demo 以该移动端画板为准。
- 同一节点右侧组件资产包含 Item Style Normal/Label、TabBar Style
  Filled/Capsule，以及名为 Horizontal/Vertical 的整栏方向资产。进一步核对
  `26951:13385` 与 `26951:13389` 后确认：该 Layout 命名描述 TabBar 整体方向，
  不是普通图文项内部的排列开关；当前 PR 不实现整栏纵向导航，因此不公开
  `layout` API，也不把参数展板错误搬进 Demo 主页。
- 小程序公开 Demo：纯文本、图文、纯图标、双层级、弱选中、悬浮胶囊和
  自定义主题；`theme`、`shape`、`split` 为独立维度。普通图文项固定图标在上、
  文字在下；双层级菜单入口固定菜单图标在文字左侧，没有通用 Layout 属性。

## 目标

- 按固定 Figma 节点的移动端展示画板重建公开 Demo 的三个分组和九个示例。
- 将内容类型、选项样式和标签栏外形拆成三个独立公开参数。
- 保留 Flutter 受控值模型、逐项回调、徽标、二级菜单与安全区能力。
- Theme 仅保存可复用视觉值，行为和结构选择由组件实例拥有。
- 为行为、Demo 契约与 Flutter 3.32 Linux 明暗视觉提供回归证据。

## 非目标

- 不机械复制小程序的路由、字符串 value、fixed 或 z-index API。
- 不改变 `TTabs` 或应用路由结构。
- 不手工维护 `CHANGELOG.md`。

## 行为契约

- `type` 仅表达内容：`text`、`iconText`、`icon`、`doubleLayer`。
- `itemStyle` 仅表达选项选中样式：`normal`、`label`。
- `style` 仅表达标签栏外形：`filled`、`capsule`。
- `iconText` 作为底部标签栏固定使用图标在上、文字在下的结构；双层级菜单入口
  固定使用菜单图标在文字左侧的结构。两者不共享布局选择器。
- `value` 是唯一选中状态；`onChanged == null` 时整栏只读并禁用交互。
- `indicatorAnimation` 在 none、linear、elastic 间切换时始终与当前 value 对齐；动画中再次切换值从当前位置继续。
- 每项 `onTap` 是选中变化时的附加动作；重复点击仅在
  `allowMultipleTaps == true` 时调用。`needInkWell` 只改变水波纹视觉，一次手势
  仍只进入一次选中与回调链路。
- `itemStyle == label` 时选中项显示品牌浅色背景；`normal` 只改变前景色。
- `style == capsule` 时标签栏具有 16px 外边距、圆角与顶部阴影，不显示顶部边线。
- `split` 仅在 Normal 选项样式中绘制分隔线。
- 单项徽标由可空的 `TBadge` 唯一表达；`null` 表示不显示，内容、形态和逐项偏移
  均由 `TBadge` 自身配置。TabBar 不再保存重复的显隐开关或定位字段。
- 颜色和字体默认值来自 `TThemeData`；实例参数优先于 `TTabBarThemeData`，
  Theme 优先于全局 Token。
- Theme 动画中 nullable 尺寸按运行时内置默认值插值；nullable 颜色与边线保持
  “未覆盖”语义，不得插值出透明色或 `BorderSide.none` 污染低优先级 Token。
- 内置文字样式使用共享解析器的低优先级 defaults；显式 TTextThemeData、DefaultTextStyle、TextTheme 按字段覆盖，单项 TextStyle 最高优先。
- 二级菜单通过 InheritedTheme 捕获触发处的局部 Theme；菜单背景配置同时作用于面板和菜单行，不被内部容器背景遮挡。
- 路由、弹层 Widget、State、绘制器及带徽标的内部单项均为私有实现，不再从包入口公开；使用者通过 TTabBar 和菜单配置组合，属于 breaking 迁移。
- 双层级 Demo 初始选中“我的”，菜单内容为“基本信息 / 个人主页 / 设置”，选择后反馈所选内容。
- 所有 Demo 的受控值由页面 State 持有，代码面板和主题重建不重置选择。核心片段写明状态字段、初始值与 build 接入方式，并由实际 Demo 源码生成。
- 组合文字解析通过内部只读投影视图辨认 Material 自动补全；不移动共享主题类、不改变无 defaults 的既有 TText 路径。共享消费者无需迁移 API。

## 验收标准

- [x] Demo 的分组、文案、实例顺序与 Figma node `28591:35219` 一致。
- [x] 普通图文项固定图标在上、文字在下；双层级菜单入口固定图标在左，并由
  组件测试与 Golden 覆盖。
- [x] Normal/Label、Filled/Capsule、split、badge 和 doubleLayer 各自独立。
- [x] 明暗主题均不使用硬编码业务颜色。
- [x] 组件测试、Demo 测试、Flutter 3.32 Linux 明暗 Golden、双版本 analyze/test 通过。
- [x] 首轮 Demo 已在 iOS Simulator 热重启、逐项操作和明暗主题核对；维护者确认可先以模拟器证据推送。
- [ ] 本轮补充修复后的最终版本重新进行移动设备逐项视觉操作核对；不以首轮设备证据或本轮 Golden 冒充。
