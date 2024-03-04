## API
### TDProgress
#### 简介
进度条组件
 展示操作的当前进度
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| color | List<Color>? | - | 进度条颜色,多个颜色会形成渐变色 |
| showLabel | bool | true | 是否显示标签 |
| label | Widget? | - | 标签 |
| percentage | double | 0 | 进度条百分比 0-100 |
| circleSize | Size? | - | 环形进度条尺寸，不为空则覆盖[size]中的默认值 |
| size | TDProgressSize | TDProgressSize.medium | 进度条尺寸 |
| status | TDProgressStatus? | - | 进度条状态 |
| strokeWidth | double? | - | 进度条线宽。宽度数值不能超过 size 的一半，否则不能输出环形进度 |
| theme | TDProgressTheme | TDProgressTheme.line | 进度条风格。 |
| trackColor | Color? | - | 进度条未完成部分颜色 |
| strokeCap | StrokeCap | StrokeCap.round | 线条末端的形状 |
| textStyle | TextStyle? | - | 文本样式 |
| curve |  | Curves.linear |  |
| duration |  | const Duration(milliseconds: 200) |  |
| onEnd |  | - |  |
