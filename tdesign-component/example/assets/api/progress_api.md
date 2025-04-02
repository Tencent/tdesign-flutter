## API
### TDProgress
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| type | TDProgressType | - | 进度条类型 |
| value | double? | - | 进度值 (0.0 到 1.0 之间的正数) |
| label | TDLabelWidget? | - | 进度条标签 |
| progressStatus | TDProgressStatus | TDProgressStatus.primary | 进度条状态 |
| progressLabelPosition | TDProgressLabelPosition | TDProgressLabelPosition.inside | 标签显示位置 |
| strokeWidth | double? | - | 进度条粗细 (正数) |
| color | Color? | - | 进度条颜色 |
| backgroundColor | Color? | - | 进度条背景颜色 |
| linearBorderRadius | BorderRadiusGeometry? | - | 条形进度条末端形状 |
| circleRadius | double? | - | 环形进度条半径 (正数) |
| showLabel | bool | true | 是否显示标签 |
| customProgressLabel | Widget? | - | 自定义标签 |
| labelWidgetWidth | double? | - | 自定义标签宽度 |
| labelWidgetAlignment | Alignment? | - | 自定义标签对齐方式 |
| onTap | VoidCallback? | - | 点击事件 |
| onLongPress | VoidCallback? | - | 长按事件 |
| animationDuration | int? | 300 | 动画持续时间 (正整数，单位为毫秒) |
