# TabBar 设计稿对齐与 API 收敛

## 背景

当前 `TTabBarVariant` 同时表达内容类型、选项样式与标签栏外形，`text` 与
`weakText` 等命名还与设计稿的 Normal/Label 语义相反。组件只支持纵向图文，
公开 Demo 也未按新版移动端设计稿展示独立的 Item Style、TabBar Style 和
Layout 维度。

## 设计证据

- Figma：`TDesign for mobile` branch `4SdclZkcv5bPgX6pa8AsmI`，node
  `28591:35219`。
- Figma 移动端 Demo 主页固定为 375px 宽、3 个分组和 9 个示例：组件类型含
  纯文本、图标加文本、纯图标、双层级文本；组件样式含弱选中 3 行与悬浮胶囊；
  自定义含 1 行自定义样式。公开 Demo 以该移动端画板为准。
- 同一节点右侧组件资产的设计轴为 Item Style Normal/Label、TabBar Style
  Filled/Capsule、Layout Horizontal/Vertical；这些轴用于 API 与组件测试，
  不把参数展板错误搬进 Demo 主页。
- 小程序公开 Demo：纯文本、图文、纯图标、双层级、弱选中、悬浮胶囊和
  自定义主题；`theme`、`shape`、`split` 为独立维度。

## 目标

- 按固定 Figma 节点的移动端展示画板重建公开 Demo 的三个分组和九个示例。
- 将内容类型、选项样式、标签栏外形和图文布局拆成四个独立公开参数。
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
- `layout` 仅表达图标与文字排列：`vertical`、`horizontal`；纯文本、纯图标和
  双层级类型不因该值改变语义。
- `value` 是唯一选中状态；`onChanged == null` 时整栏只读并禁用交互。
- 每项 `onTap` 是选中变化时的附加动作；重复点击仅在
  `allowMultipleTaps == true` 时调用。
- `itemStyle == label` 时选中项显示品牌浅色背景；`normal` 只改变前景色。
- `style == capsule` 时标签栏具有 16px 外边距、圆角与顶部阴影，不显示顶部边线。
- `split` 仅在 Normal 选项样式中绘制分隔线。
- 颜色和字体默认值来自 `TThemeData`；实例参数优先于 `TTabBarThemeData`，
  Theme 优先于全局 Token。

## 验收标准

- [x] Demo 的分组、文案、实例顺序与 Figma node `28591:35219` 一致。
- [x] Horizontal/Vertical 图文布局均可点击且无溢出，并由组件测试与 Golden 覆盖。
- [x] Normal/Label、Filled/Capsule、split、badge 和 doubleLayer 各自独立。
- [x] 明暗主题均不使用硬编码业务颜色。
- [x] 组件测试、Demo 测试、Flutter 3.32 Linux 明暗 Golden、双版本 analyze/test 通过。
- [x] 当前最终 Demo 已在 iOS Simulator 热重启、逐项操作和明暗主题核对；按维护者
  确认先以模拟器证据推送和发起 CNB Review，Android 真机最终版验证作为 PR 后补证据。
