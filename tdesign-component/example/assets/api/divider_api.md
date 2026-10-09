## API

### TDivider

分割线组件

包含两种绘制模式：
- 模式 A（纯线）：`child` 为空，横线可虚线、竖线强制实线
- 模式 B（线 + 中间）：`layout` 为 horizontal 且 `child` 非空

竖线（`TDividerLayout.vertical`）时强制忽略 `dashed`、`align`、`child`，
默认高度 14dp，左右外边距 16dp。

#### 主题配置

组件主题通过 `TDividerThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。可配置字段和未设置时的回退见本页的
`TDividerThemeData` 配置项。

#### 构造方法

##### TDivider

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| align | TDividerAlign? | - | 中间内容在线条中的位置，默认 `TDividerAlign.center` 仅 `TDividerLayout.horizontal` 生效 | 否 |
| child | Widget? | - | 中间子元素 纯文案用 `child: Text('……')` | 否 |
| dashed | bool? | - | 是否为虚线，默认 false 仅 `TDividerLayout.horizontal` 生效 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| layout | TDividerLayout? | - | 横/竖分割线，默认 `TDividerLayout.horizontal` | 否 |


### TDividerLayout

分割线布局方向
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| horizontal | TDividerLayout | - | 水平分割线 | - |
| vertical | TDividerLayout | - | 垂直分割线 | - |


### TDividerAlign

中间内容在线条中的位置（仅 `TDividerLayout.horizontal` 生效）
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| left | TDividerAlign | - | 内容靠左 | - |
| center | TDividerAlign | - | 内容居中 | - |
| right | TDividerAlign | - | 内容靠右 | - |


### TDividerThemeData

TDivider 组件级 ThemeExtension

通过 Theme 子树注入，控制子树的默认样式。
布局、内容和虚线选择由实例控制；视觉值从本主题读取，未配置时回退
TDesign Token 或组件内置值，不读取 Material DividerTheme。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| color | Color? | - | 线条颜色；未设置时使用 `bgColorComponent` Token。 | 否 |
| endIndent | double? | - | 纯水平线结束侧缩进；未设置时为 0，带内容或垂直线时不生效。 | 否 |
| gapPadding | EdgeInsetsGeometry? | - | 线与中间内容之间的间距，默认左右各使用 `spacer1`（12dp）。 | 否 |
| indent | double? | - | 纯水平线起始侧缩进；未设置时为 0，带内容或垂直线时不生效。 | 否 |
| margin | EdgeInsetsGeometry? | - | 外边距。未设置时，水平分割线使用上下 10dp，垂直分割线使用左右 16dp。 | 否 |
| textStyle | TextStyle? | - | child 为文本时的默认样式，覆盖 `fontBodySmall` / `textColorPlaceholder` Token。 | 否 |
| thickness | double? | - | 线粗：横线 = 高度，竖线 = 宽度（默认 0.5） | 否 |
