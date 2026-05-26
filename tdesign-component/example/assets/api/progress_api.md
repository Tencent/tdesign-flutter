## API
### TProgress
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | int | 300 | 动画持续时间（正整数，单位为毫秒） |
| backgroundColor | Color? | - | 进度条背景颜色 |
| circleRadius | double? | - | 环形进度条半径（正数） |
| color | Color? | - | 进度条颜色 |
| customProgressLabel | Widget? | - | 自定义标签 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | TLabelWidget? | - | 进度条标签 |
| labelWidgetAlignment | Alignment? | - | 自定义标签对齐方式 |
| labelWidgetWidth | double? | - | 自定义标签宽度 |
| linearBorderRadius | BorderRadiusGeometry? | - | 条形进度条末端形状 |
| onLongPress | VoidCallback? | - | 长按事件 |
| onTap | VoidCallback? | - | 点击事件 |
| progressLabelPosition | TProgressLabelPosition | TProgressLabelPosition.inside | 标签显示位置 |
| progressStatus | TProgressStatus | TProgressStatus.primary | 进度条状态 |
| showLabel | bool | true | 是否显示标签 |
| strokeWidth | double? | - | 进度条粗细（正数） |
| type | TProgressType | - | 进度条类型 |
| value | double? | - | 进度值（0.0 到 1.0 之间的正数） |


### TProgressType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| linear | - |
| circular | - |
| micro | - |
| button | - |


### TProgressLabelPosition
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| inside | - |
| left | - |
| right | - |


### TProgressStatus
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| primary | - |
| warning | - |
| danger | - |
| success | - |
