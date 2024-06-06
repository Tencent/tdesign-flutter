## API
### TDDivider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| color | Color? | - | 线条颜色 |
| margin | EdgeInsetsGeometry? | - | 外部填充 |
| width | double? | - | 宽度，需要竖向线条时使用 |
| height | double? | - | 高度，横向线条使用 |
| text | String? | - | 文本字符串，使用默认样式 |
| textStyle | TextStyle? | - | 自定义文本样式 |
| widget | Widget? | - | 中间控件，可自定义样式 |
| gapPadding | EdgeInsetsGeometry? | - | 线条和中间文本之间的填充 |
| hideLine | bool | false | 隐藏线条，使用纯文本分割 |
| isDashed | bool | false | 是否为虚线 |
| alignment | TextAlignment | TextAlignment.center | 文字位置 |
| direction | Axis | Axis.horizontal | 方向,竖直虚线必须传 |
