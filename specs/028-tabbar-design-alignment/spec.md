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
  Filled/Capsule，以及图文项的 Horizontal/Vertical Layout。Community 文件
  `628tlvI3SQbEg99XNN52oz` 中实例 `26969:14345` 的图标在上、文字在下，
  `26969:14344` 的图标在左、文字在右；两者的标签栏本身均为水平排列。
  Flutter 以 `stacked`/`inline` 命名图文项布局，避免把设计文件中容易误解的
  Horizontal/Vertical 名称机械搬入 API。
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
- `iconTextLayout` 仅对 `iconText` 生效，默认 `stacked`（图标在上、文字在下），
  可选 `inline`（图标在左、文字在右）；双层级菜单入口固定使用菜单图标在文字
  左侧的结构，不受此参数影响。`inline` 使用 20px 图标、16px/24px 文字及
  默认 4px 图文间距；上下排列使用 0px。图文间距由组件内部决定，不提供公开覆盖参数。
- `inline` 图文项的徽标锚定整组图文右上角；默认 `stacked` 仍锚定图标右上角。
  Filled 栏按两侧各 8px、项间 8px 分配，Label 选中底色覆盖整个项宽；
  Capsule 栏沿用同一内部间距并保留 16px 外边距。
- `value` 是唯一选中状态；`onChanged == null` 时整栏只读并禁用交互。
- `indicatorAnimation` 在 none、linear、elastic 间切换时始终与当前 value 对齐；动画中再次切换值从当前位置继续。
- 每项 `onTap` 是选中变化时的附加动作；重复点击仅在
  `allowMultipleTaps == true` 时调用。`needInkWell` 只改变水波纹视觉，一次手势
  仍只进入一次选中与回调链路。
- `itemStyle == label` 时选中项显示品牌浅色背景；`normal` 只改变前景色。
- `style == capsule` 时标签栏具有 16px 外边距、圆角与顶部阴影，不显示顶部边线。
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
- Theme 动画中 nullable 尺寸按运行时内置默认值插值；nullable 颜色与边线
  保持“未覆盖”语义，不得插值出透明色或
  `BorderSide.none` 污染低优先级 Token。
- 内置文字样式使用共享解析器的低优先级 defaults；显式 TTextThemeData、DefaultTextStyle、TextTheme 按字段覆盖，单项 TextStyle 最高优先。
- 二级菜单通过 InheritedTheme 捕获触发处的局部 Theme；菜单背景配置同时作用于面板和菜单行，不被内部容器背景遮挡。
- 路由、弹层 Widget、State、绘制器及带徽标的内部单项均为私有实现，不再从包入口公开；使用者通过 TTabBar 和菜单配置组合，属于 breaking 迁移。
- 双层级 Demo 初始选中“我的”，菜单内容为“基本信息 / 个人主页 / 设置”，选择后反馈所选内容。
- 双层级菜单未显式设置 `popUpWidth` 时，默认宽度为
  `max(107px, 标签项宽度 - 20px)`；375px 四等分场景使用设计稿的 107px。
  显式 `popUpWidth` 继续拥有最高优先级，Demo 不传固定宽度掩盖默认行为。
- 所有 Demo 的受控值由页面 State 持有，代码面板和主题重建不重置选择。核心片段写明状态字段、初始值与 build 接入方式，并由实际 Demo 源码生成。
- 九个公开 Demo 的每次标签点击都显示“第 N 项”的 Toast（N 从 1 开始）；重复点击已选中项也提示。Toast 由 Demo 的单项 `onTap` 提供，`onChanged` 只更新受控选中值，不修改组件默认回调语义。
- 组合文字解析通过内部只读投影视图辨认 Material 自动补全；不移动共享主题类、不改变无 defaults 的既有 TText 路径。共享消费者无需迁移 API。

## 验收标准

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

- [x] Demo 的分组、文案、实例顺序与 Figma node `28591:35219` 一致。
- [x] 普通图文项同时支持上下和左右排列；双层级菜单入口固定图标在左，并由
  组件测试与必要 Golden 覆盖。
- [x] Normal/Label、Filled/Capsule、split、badge 和 doubleLayer 各自独立。
- [x] 明暗主题均不使用硬编码业务颜色。
- [x] 当前胶囊图文调整后的组件测试、Demo 测试与双版本 analyze/test 通过；
  Flutter 3.32 Linux 明暗 Golden 已审查并无更新复跑（见 acceptance.md）。
- [x] 首轮 Demo 已在 iOS Simulator 热重启、逐项操作和明暗主题核对；维护者确认可先以模拟器证据推送。
- [ ] 本轮补充修复后的最终版本重新进行移动设备逐项视觉操作核对；不以首轮设备证据或本轮 Golden 冒充。
- [x] 二级菜单默认宽度与 Figma 107px 对齐，并由组件测试及展开态 Golden 覆盖。
- [x] 九个公开 TabBar 实例的点击后选中状态由单张明暗 postAction Golden 覆盖。
- [x] 纯文本点击 Toast、双层菜单展开及菜单选择 Toast 均有独立明暗 Golden，
  不以等待反馈消失后的整页截图替代。
- [x] 纯文本、纯图标与图文三种 Badge 均按各自 Figma 锚点完成修复前后截图复核；
  图文 Badge 必须锚定图标，不能受下方文字宽度影响。
