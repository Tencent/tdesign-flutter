## API

### TDProgress

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | Widget 的键值 |
| type | TDProgressType | - | 进度条类型 |
| value | double? | 0 | 进度值 (0.0 到 1.0 之间的正数) |
| label | TDLabelWidget? | - | 进度条标签 |
| progressStatus | TDProgressStatus | TDProgressStatus.primary | 进度条状态 |
| progressLabelPosition | TDProgressLabelPosition | TDProgressLabelPosition.inside | 标签显示位置 |
| strokeWidth | double? | - | 进度条粗细 (正数) |
| color | Color? | - | 进度条颜色 |
| backgroundColor | Color? | - | 进度条背景颜色 |
| borderRadius | BorderRadiusGeometry? | - | 进度条末端形状 |
| circleRadius | double? | - | 环形进度条半径 (正数) |
| showLabel | bool | true | 是否显示标签 |
| onTap | VoidCallback? | - | 点击事件 |
| onLongPress | VoidCallback? | - | 长按事件 |
| animationDuration | int | 300 | 动画持续时间 (正整数，单位为毫秒) |

### TDProgressType

进度条类型枚举

| 值 | 说明 |
| --- | --- |
| linear | 线性进度条 |
| circular | 环形进度条 |
| micro | 微型进度条 |
| button | 按钮进度条 |

### TDProgressLabelPosition

标签显示位置枚举

| 值 | 说明 |
| --- | --- |
| inside | 标签显示在进度条内部 |
| left | 标签显示在进度条左侧 |
| right | 标签显示在进度条右侧 |

### TDProgressStatus

进度条状态枚举

| 值 | 说明 |
| --- | --- |
| primary | 主要状态 |
| warning | 警告状态 |
| danger | 危险状态 |
| success | 成功状态 |

### TDLabelWidget

进度条标签抽象类

#### TDTextLabel

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| data | String | - | 文本内容 |
| key | Key? | - | Widget 的键值 |
| style | TextStyle? | - | 文本样式 |

#### TDIconLabel

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| icon | IconData | - | 图标数据 |
| key | Key? | - | Widget 的键值 |
| size | double? | - | 图标大小 |
| color | Color? | - | 图标颜色 |