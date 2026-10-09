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
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TDividerThemeData` 说明。

#### 构造方法

##### TDivider

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| align | TDividerAlign? | - | 中间内容在线条中的位置，默认 `TDividerAlign.center` 仅 `TDividerLayout.horizontal` 生效 | 否 |
| child | Widget? | - | 中间子元素 纯文案用 `child: Text('……')` | 否 |
| dashed | bool? | - | 是否为虚线，默认 false 仅 `TDividerLayout.horizontal` 生效 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| layout | TDividerLayout? | - | 横/竖分割线，默认 `TDividerLayout.horizontal` | 否 |


### TDividerThemeData

TDivider 组件级 ThemeExtension

通过 Theme 子树注入，控制子树的默认样式。
布局、内容和虚线选择由实例控制；视觉值从本主题读取，未配置时回退
TDesign Token 或组件内置值，不读取 Material DividerTheme。

#### 构造方法

##### TDividerThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| color | Color? | - | 线条颜色；未设置时使用 `bgColorComponent` Token。 | 否 |
| endIndent | double? | - | 纯水平线结束侧缩进；未设置时为 0，带内容或垂直线时不生效。 | 否 |
| gapPadding | EdgeInsetsGeometry? | - | 线与中间内容之间的间距，默认左右各使用 `spacer1`（12dp）。 | 否 |
| indent | double? | - | 纯水平线起始侧缩进；未设置时为 0，带内容或垂直线时不生效。 | 否 |
| margin | EdgeInsetsGeometry? | - | 外边距。未设置时，水平分割线使用上下 10dp，垂直分割线使用左右 16dp。 | 否 |
| textStyle | TextStyle? | - | child 为文本时的默认样式，覆盖 `fontBodySmall` / `textColorPlaceholder` Token。 | 否 |
| thickness | double? | - | 线粗：横线 = 高度，竖线 = 宽度（默认 0.5） | 否 |


#### 实例方法

##### TDividerThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| color | Color? | - | 字段含义：线条颜色；未设置时使用 `bgColorComponent` Token。 调用时的空值行为见方法说明。 | 否 |
| thickness | double? | - | 字段含义：线粗：横线 = 高度，竖线 = 宽度（默认 0.5） 调用时的空值行为见方法说明。 | 否 |
| margin | EdgeInsetsGeometry? | - | 字段含义：外边距。未设置时，水平分割线使用上下 10dp，垂直分割线使用左右 16dp。 调用时的空值行为见方法说明。 | 否 |
| gapPadding | EdgeInsetsGeometry? | - | 字段含义：线与中间内容之间的间距，默认左右各使用 `spacer1`（12dp）。 调用时的空值行为见方法说明。 | 否 |
| textStyle | TextStyle? | - | 字段含义：child 为文本时的默认样式，覆盖 `fontBodySmall` / `textColorPlaceholder` Token。 调用时的空值行为见方法说明。 | 否 |
| indent | double? | - | 字段含义：纯水平线起始侧缩进；未设置时为 0，带内容或垂直线时不生效。 调用时的空值行为见方法说明。 | 否 |
| endIndent | double? | - | 字段含义：纯水平线结束侧缩进；未设置时为 0，带内容或垂直线时不生效。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TDividerThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TDividerThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TDividerThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TDividerThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


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
