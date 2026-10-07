## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TDivider
#### 简介
分割线组件
T3 自绘层级，不包装 Material `Divider`。包含两种绘制模式：
- 模式 A（纯线）：`child` 为空，横线可虚线、竖线强制实线
- 模式 B（线 + 中间）：`layout` 为 horizontal 且 `child` 非空
竖线（`TDividerLayout.vertical`）时强制忽略 `dashed`、`align`、`child`，
默认高度 14dp，左右外边距 16dp。
示例：

#### 声明

```dart
class TDivider extends StatelessWidget
```

#### 默认构造方法


```dart
const TDivider({super.key, this.layout, this.align, this.dashed, this.child})
```

#### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| align | TDividerAlign? | - | 中间内容在线条中的位置，默认 `TDividerAlign.center` 仅 `TDividerLayout.horizontal` 生效 | 否 |
| child | Widget? | - | 中间子元素 纯文案用 `child: Text('……')` | 否 |
| dashed | bool? | - | 是否为虚线，默认 false 仅 `TDividerLayout.horizontal` 生效 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| layout | TDividerLayout? | - | 横/竖分割线，默认 `TDividerLayout.horizontal` | 否 |


### TDividerThemeData
#### 简介
TDivider 组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认样式。
构造器参数优先于 Theme（L1/L2 > Theme > DividerTheme > Token）。

#### 声明

```dart
class TDividerThemeData extends ThemeExtension<TDividerThemeData>
```

#### 默认构造方法


```dart
const TDividerThemeData({
  this.color,
  this.thickness,
  this.margin,
  this.gapPadding,
  this.textStyle,
  this.indent,
  this.endIndent,
})
```

#### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| color | Color? | - | 线条颜色 | 否 |
| endIndent | double? | - | 右缩进（对齐 Material `DividerThemeData.endIndent` 语义） | 否 |
| gapPadding | EdgeInsetsGeometry? | - | 线与中间内容之间的间距，默认左右各使用 `spacer1`（12dp）。 | 否 |
| indent | double? | - | 左缩进（对齐 Material `DividerThemeData.indent` 语义） | 否 |
| margin | EdgeInsetsGeometry? | - | 外边距。未设置时，水平分割线使用上下 10dp，垂直分割线使用左右 16dp。 | 否 |
| textStyle | TextStyle? | - | child 为文本时的默认样式，覆盖 `fontBodySmall` / `textColorPlaceholder` Token。 | 否 |
| thickness | double? | - | 线粗：横线 = 高度，竖线 = 宽度（默认 0.5） | 否 |


#### 实例方法

##### TDividerThemeData.copyWith

```dart
TDividerThemeData copyWith({
  Color? color,
  double? thickness,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? gapPadding,
  TextStyle? textStyle,
  double? indent,
  double? endIndent,
})
```


返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TDividerThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| color | Color? | - | 线条颜色 | 否 |
| thickness | double? | - | 线粗：横线 = 高度，竖线 = 宽度（默认 0.5） | 否 |
| margin | EdgeInsetsGeometry? | - | 外边距。未设置时，水平分割线使用上下 10dp，垂直分割线使用左右 16dp。 | 否 |
| gapPadding | EdgeInsetsGeometry? | - | 线与中间内容之间的间距，默认左右各使用 `spacer1`（12dp）。 | 否 |
| textStyle | TextStyle? | - | child 为文本时的默认样式，覆盖 `fontBodySmall` / `textColorPlaceholder` Token。 | 否 |
| indent | double? | - | 左缩进（对齐 Material `DividerThemeData.indent` 语义） | 否 |
| endIndent | double? | - | 右缩进（对齐 Material `DividerThemeData.endIndent` 语义） | 否 |


##### TDividerThemeData.lerp

```dart
TDividerThemeData lerp(ThemeExtension<TDividerThemeData>? other, double t)
```


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TDividerThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TDividerThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TDividerLayout
#### 简介
分割线布局方向
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 水平分割线 |
| vertical | 垂直分割线 |


### TDividerAlign
#### 简介
中间内容在线条中的位置（仅 `TDividerLayout.horizontal` 生效）
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 内容靠左 |
| center | 内容居中 |
| right | 内容靠右 |
