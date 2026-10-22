# TabBar 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

胶囊布局、徽标锚点和弹层菜单曾依赖页面补偿。

当前 `TTabBarVariant` 同时表达内容类型、选项样式与标签栏外形，`text` 与
`weakText` 等命名还与设计稿的 Normal/Label 语义相反。公开 Demo 也未按新版
移动端设计稿展示独立的 Item Style 与 TabBar Style 维度。

- Figma：`TDesign for mobile` branch `4SdclZkcv5bPgX6pa8AsmI`，node
  `28591:35219`。
- Figma 移动端 Demo 主页固定为 375px 宽、3 个分组和 9 个示例：组件类型含
  纯文本、图标加文本、纯图标、双层级文本；组件样式含弱选中 3 行与悬浮胶囊；
  自定义含 1 行自定义样式。公开 Demo 以该移动端画板为准。
- 同一节点右侧组件资产包含 Item Style Normal/Label、TabBar Style
  Filled/Capsule，以及图文项的 Horizontal/Vertical Layout。Community 文件
  `628tlvI3SQbEg99XNN52oz` 中实例 `26969:14345` 的图标在上、文字在下，
  `26969:14344` 的图标在左、文字在右；两者的标签栏本身均为水平排列。
  Flutter 以 `stacked`/`inline` 命名图文项布局，避免把设计文件中容易误解的
  Horizontal/Vertical 名称机械搬入 API。
- 小程序公开 Demo：纯文本、图文、纯图标、双层级、弱选中、悬浮胶囊和
  自定义主题；`theme`、`shape`、`split` 为独立维度。普通图文项固定图标在上、
  文字在下；双层级菜单入口固定菜单图标在文字左侧，没有通用 Layout 属性。

## 范围与非目标

### 目标

- 按固定 Figma 节点的移动端展示画板重建公开 Demo 的三个分组和九个示例。
- 将内容类型、选项样式和标签栏外形拆成三个独立公开参数。
- 保留 Flutter 受控值模型、逐项回调、徽标、二级菜单与安全区能力。
- Theme 仅保存可复用视觉值，行为和结构选择由组件实例拥有。
- 为行为、Demo 契约与 Flutter 3.32 Linux 明暗视觉提供回归证据。

### 不涉及

- 不机械复制小程序的路由、字符串 value、fixed 或 z-index API。
- 不改变 `TTabs` 或应用路由结构。
- 不手工维护 `CHANGELOG.md`。

## 最终方案与行为契约

- `type` 仅表达内容：`text`、`iconText`、`icon`、`doubleLayer`。
- `itemStyle` 仅表达选项选中样式：`normal`、`label`。
- `style` 仅表达标签栏外形：`filled`、`capsule`。
- `iconTextLayout` 仅对 `iconText` 生效，默认 `stacked`（图标在上、文字在下），
  可选 `inline`（图标在左、文字在右）；双层级菜单入口固定使用菜单图标在文字
  左侧的结构，不受此参数影响。`inline` 使用 20px 图标、16px/24px 文字及
  默认 4px 图文间距；上下排列使用 0px。图文间距由组件内部决定，不提供公开覆盖参数。
- `inline` 图文项的徽标锚定整组图文右上角；默认 `stacked` 仍锚定图标右上角。
  Filled 栏按项数分配等宽交互区域：不超过 3 项时每项水平内边距 12px，
  更多项时 8px，Label 选中底色只覆盖内容盒（375px 下 3 项为 101px、
  4 项为 77.75px）；Capsule 栏仍用两侧各 8px、项间 8px，保留 16px 外边距。
- `value` 是唯一选中状态；`onChanged == null` 时整栏只读并禁用交互。
- `indicatorAnimation` 在 none、linear、elastic 间切换时始终与当前 value 对齐；动画中再次切换值从当前位置继续。
- 每项 `onTap` 是选中变化时的附加动作；重复点击仅在
  `allowMultipleTaps == true` 时调用。`needInkWell` 只改变水波纹视觉，一次手势
  仍只进入一次选中与回调链路。
- `itemStyle == label` 时选中项显示品牌浅色背景；`normal` 只改变前景色。
- `style == capsule` 时标签栏具有 16px 外边距、圆角与顶部阴影，不显示顶部边线。
- Filled 标签栏始终绘制默认顶边线（组件描边色、0.5px），不提供显隐或样式覆盖参数；自定义 Demo 同样使用该默认线。
- `useSafeArea` 为 true 时使用标签栏背景填满底部安全区，为 false 时不处理安全区；不提供单独的占位模式。
- `split` 仅在 Normal 选项样式中绘制分隔线。
- 单项徽标由可空的 `TBadgeConfig` 唯一表达；`null` 表示不显示，内容、形态和
  可选逐项偏移均由配置提供。TabBar 不再保存重复的显隐开关或定位字段。
- TabBar 负责选择徽标的语义锚点和标准位置：纯文本项在调用方未显式提供
  `TBadgeConfig.offset`、局部 `BadgeTheme.offset` 或全局 `BadgeThemeData.offset` 时，
  使用 TabBar 的文本徽标内置位置；纯图标项以图标作为内部徽标锚点；上下图文
  项以图标作为锚点，文字不参与锚点宽度计算；左右图文项以整组图文作为锚点。
  图标场景均使用 `TBadge` 的默认右上角位置。公开默认 Demo 不传固定 offset，
  显式 offset 仅用于逐项自定义。
- 颜色和字体默认值来自 `TThemeData`；实例参数优先于 `TTabBarThemeData`，
  Theme 优先于全局 Token。
- Theme 动画中 nullable 尺寸按运行时内置默认值插值；nullable 颜色保持
  “未覆盖”语义，不得插值出透明色污染低优先级 Token。
- 内置文字优先使用明确的实例/组件 TDesign 样式和 Token；不从外部 Material TextTheme 或 DefaultTextStyle 反推配置，自定义弹出菜单文字槽接入组件默认样式，显式样式与内容内部更近的局部主题优先；其他自定义能力保留。
- 二级菜单通过 InheritedTheme 捕获触发处的局部 Theme；菜单背景配置同时作用于面板和菜单行，不被内部容器背景遮挡。
- 路由、弹层 Widget、State、绘制器及带徽标的内部单项均为私有实现，不再从包入口公开；使用者通过 TTabBar 和菜单配置组合，属于 breaking 迁移。
- 双层级 Demo 初始选中“我的”，菜单内容为“基本信息 / 个人主页 / 设置”，选择后反馈所选内容。
- 双层级菜单未显式设置 `popUpWidth` 时，默认宽度为
  `max(107px, 标签项宽度 - 20px)`；375px 四等分场景使用设计稿的 107px。
  显式 `popUpWidth` 继续拥有最高优先级，Demo 不传固定宽度掩盖默认行为。
- 所有 Demo 的受控值由页面 State 持有，代码面板和主题重建不重置选择。核心片段写明状态字段、初始值与 build 接入方式，并由实际 Demo 源码生成。
- 九个公开 Demo 的每次标签点击都显示“第 N 项”的 Toast（N 从 1 开始）；重复点击已选中项也提示。Toast 由 Demo 的单项 `onTap` 提供，`onChanged` 只更新受控选中值，不修改组件默认回调语义。

### 2026-09-25 胶囊布局补充

- 新增的对照目标是 Community 文件 `628tlvI3SQbEg99XNN52oz` 的 TabBar
  组件展板（画板 `25529:22098`）中 4 项、图文、首项圆点徽标的胶囊实例；
  它是组件形态证据，不替换上文 375px 移动端公开 Demo 的整体分组契约。
- 该实例外栏宽 343px、高 56px，水平及垂直内边距各 8px，项间距 8px；
  4 个等宽项各 75.75px，选中背景覆盖单项的 75.75×40px 区域。
  项内图标在上、文字在下，图标徽标锚定图标右上角；文字和徽标属于有效配置，
  不允许 Demo 外层补偿布局。
- 同样的胶囊几何适用于纯图标、纯文字、图文组合；不同项数按剩余宽度等分，
  小宽度下不能产生负宽度或溢出。已有 Filled 样式不受胶囊布局修正影响。
- 胶囊公开示例将原先纯图标的 4 项配置调整为该展板实例的 4 个 `Item`
  图文项与首项圆点徽标；保留移动端 Demo 的分组、顺序和其他实例，不把展板里的
  其他 Normal/Label/Layout 变体机械搬入。
- 默认 Demo 不覆盖胶囊选中背景、图文间距或标签字体；几何与默认样式由
  `TTabBar` 和 Token 负责。Golden 测试可配置确定性字体，但不得改变 Demo
  的组件参数。
- 图标项与图文项的内置图标尺寸为 20px，由 `TTabBar` 提供；调用方传入的
  `Icon(size: …)` 仍可显式覆盖。默认 Demo 只提供图标内容，不传尺寸补丁。

- Demo 的分组、文案、实例顺序与 Figma node `28591:35219` 一致。
- 普通图文项同时支持上下和左右排列；双层级菜单入口固定图标在左，并由
  组件测试与必要 Golden 覆盖。
- Normal/Label、Filled/Capsule、split、badge 和 doubleLayer 各自独立。
- 明暗主题均不使用硬编码业务颜色。
- 当前胶囊图文调整后的组件测试、Demo 测试与双版本 analyze/test 通过；
  Flutter 3.32 Linux 明暗 Golden 已审查并无更新复跑（见 acceptance.md）。
- 首轮 Demo 已在 iOS Simulator 热重启、逐项操作和明暗主题核对；维护者确认可先以模拟器证据推送。
- 本轮补充修复后的最终版本重新进行移动设备逐项视觉操作核对；不以首轮设备证据或本轮 Golden 冒充。
- 二级菜单默认宽度与 Figma 107px 对齐，并由组件测试及展开态 Golden 覆盖。
- 九个公开 TabBar 实例的点击后选中状态由单张明暗 postAction Golden 覆盖。
- 纯文本点击 Toast、双层菜单展开及菜单选择 Toast 均有独立明暗 Golden，
  不以等待反馈消失后的整页截图替代。
- 纯文本、纯图标与图文三种 Badge 均按各自 Figma 锚点完成修复前后截图复核；
  图文 Badge 必须锚定图标，不能受下方文字宽度影响。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 标签项、徽标和多级菜单共享组件内布局与定位；胶囊阴影和圆角由组件解析。 |
| 保留的边界与代价 | 保留真实弹层生命周期与点击边界，不用 Demo 位移或虚假的命中区替代。 |

### 设计演变中的关键理由

- 未显式设置 `Icon.size` 的图标项从 Flutter 隐式 24px 变为组件默认 20px，
  属于可见默认行为变化；需要保留旧尺寸时可传 `Icon(size: 24)`。
- 默认菜单宽度变化属于公开默认行为调整：窄标签项下菜单会变宽；显式设置
  `popUpWidth` 的调用不受影响。按仓库规范以 breaking change 记录。
- 当前包仍处于 alpha；选择一次性收敛冲突状态源，不保留会继续误导的新旧双 API。
- 小程序作为公开效果和操作参考；Flutter 保留 Widget、回调和受控状态惯例。
- 固定几何仅用于 TabBar 专有结构；颜色、字体、圆角与阴影优先使用 TDesign Token。
- 纯文本徽标位置属于 TabBar 专有组合几何，不修改 `TBadge` 的全局默认位置，避免
  影响 Tabs、SideBar、Avatar 等其他消费者。

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

- Figma 固定节点：`28591:35219`。
- 小程序公开参考：`components/tab-bar?tab=demo` 与
  `Tencent/tdesign-miniprogram/packages/components/tab-bar`。
- Figma 的 Horizontal/Vertical 是整栏方向轴；当前 Flutter PR 未实现完整纵向
  TabBar，不能用普通项内部 Row/Column 冒充该能力。
- 公开 Demo 以节点内 `TabBar 底部标签栏 移动端展示` 画板为准，而不是右侧组件
  资产展板：3 个分组、9 个示例、固定首页/应用/聊天/我的四项。

## 兼容性与迁移

此前设计记录整理未改变运行行为。本轮自定义文字槽默认值调整按 minor 交付，见下文；不新增公开参数，兼容性按最终源码、回归和迁移指南核对。

## 验收标准

- 默认、显式配置、关键状态与边界行为符合最终方案；功能、视觉和人工路径按适用范围分别验收。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

## 自定义文字槽一致性

弹出菜单 itemWidget 子树接入内置 value 的文字默认值。默认自适应时，含自定义项的菜单按实际布局高度取最大值（至少 48），所有项等高，布局包装、局部主题与文字缩放参与测量；超出视口的菜单可纵向滚动。显式 popUpItemHeight 仍固定，不擅自增长。不递归推测任意 Widget 的文字。自适应测量要求内容能确定有限自然高度；依赖有界高度的 Column + Expanded 等内容应通过既有 popUpItemHeight 显式提供高度。

保留 TText 全局隔离，不读取外部 Material 文字默认值，不新增公开配置。显式文字样式按字段覆盖，内容内部更近的局部 TTextThemeData（原生 Text 可用 DefaultTextStyle）优先。布局约束仍由自定义内容遵守。

兼容性：这会改变原先未显式配置的自定义文字默认行为，属于用户可感知的默认行为变化（minor 交付）；迁移时显式指定需保留的字号、字重、颜色、行高或在内容内部设置局部文字主题。仅指定部分样式的用户仍会接入其余默认字段。
