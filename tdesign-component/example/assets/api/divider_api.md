## API
### TDivider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| align | TDividerAlign? | - | 中间内容在线条中的位置，默认 `TDividerAlign.center` 仅 `TDividerLayout.horizontal` 生效 |
| child | Widget? | - | 中间子元素 纯文案用 `child: Text('……')` |
| dashed | bool? | - | 是否为虚线，默认 false 仅 `TDividerLayout.horizontal` 生效 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| layout | TDividerLayout? | - | 横/竖分割线，默认 `TDividerLayout.horizontal` |


### TDividerThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| color | Color? | - | 线条颜色 |
| endIndent | double? | - | 右缩进（对齐 Material `DividerThemeData.endIndent` 语义） |
| gapPadding | EdgeInsetsGeometry? | - | 线与中间内容之间的间距，默认左右各使用 `spacer1`（12dp）。 |
| indent | double? | - | 左缩进（对齐 Material `DividerThemeData.indent` 语义） |
| margin | EdgeInsetsGeometry? | - | 外边距。未设置时，水平分割线使用上下 10dp，垂直分割线使用左右 16dp。 |
| textStyle | TextStyle? | - | child 为文本时的默认样式，覆盖 `fontBodySmall` / `textColorPlaceholder` Token。 |
| thickness | double? | - | 线粗：横线 = 高度，竖线 = 宽度（默认 0.5） |


### TDividerLayout
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 水平分割线 |
| vertical | 垂直分割线 |


### TDividerAlign
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 内容靠左 |
| center | 内容居中 |
| right | 内容靠右 |
