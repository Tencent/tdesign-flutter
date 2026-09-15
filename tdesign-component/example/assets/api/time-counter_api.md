## API
### TTimeCounter
#### 简介
通用计时器组件，支持正向计时与倒计时。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autoStart | bool | true | 首次挂载时是否自动开始计时，默认为 true。 该值只决定初始行为；挂载后的开始、暂停和重置由 `controller` 控制。 |
| content | TTimeCounterBuilder? | - | 自定义计时内容；为空时使用标准数字块。 |
| controller | TTimeCounterController? | - | 控制器，可控制开始、暂停和重置。 |
| direction | TTimeCounterDirection | TTimeCounterDirection.down | 计时方向，默认倒计时。 |
| format | String | 'HH:mm:ss' | 时间格式，D-日、H-时、m-分、s-秒、S-毫秒，默认为 `HH:mm:ss`。 每段可重复字符控制最小位数，相邻时间段之间仅允许一个非空白分隔符； 最后一段后可追加一个单位字符。例如 `HH:mm:ss`、`mmmm分sss秒`。 包含 `S` 段时按绘制帧更新，否则仅在格式化后的可见值变化时更新。 使用 `content` 时，该字段仍决定计时更新精度。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<int>? | - | 格式化后的可见值变化时触发，回调值为当前毫秒数。 `format` 包含毫秒段时按绘制帧触发，否则仅在可见时间段变化时触发。 |
| onFinish | VoidCallback? | - | 计时自然到达终点时触发一次回调。 |
| size | TTimeCounterSize? | - | 计时器尺寸；优先于组件 Theme。 |
| splitWithUnit | bool | false | 是否使用本地化时间单位分隔，默认为 false。 |
| time | int | - | 必需；计时时长，单位毫秒 |
| variant | TTimeCounterVariant? | - | 视觉形态；优先于组件 Theme。 |


### TTimeCounterController
#### 简介
计时器控制器，可控制开始、暂停和重置。
Controller 由调用方创建并负责释放。

### TTimeCounterThemeData
#### 简介
计时器组件的视觉默认值。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaultSize | TTimeCounterSize? | - | 默认尺寸。 |
| defaultVariant | TTimeCounterVariant? | - | 默认视觉形态。 |


### TTimeCounterDirection
#### 简介
计时方向。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| down | 倒计时。 |
| up | 正向计时。 |


### TTimeCounterSize
#### 简介
计时器尺寸。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸。 |
| medium | 中等尺寸。 |
| large | 大尺寸。 |


### TTimeCounterVariant
#### 简介
计时器视觉形态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| plain | 无数字块背景。 |
| highlight | 无数字块背景，并以错误色突出数字。 |
| round | 圆形数字块。 |
| square | 方形数字块。 |


### TTimeCounterBuilder
#### 简介
自定义计时内容构建器。
#### 类型定义

```dart
typedef TTimeCounterBuilder = Widget Function(int time);
```
