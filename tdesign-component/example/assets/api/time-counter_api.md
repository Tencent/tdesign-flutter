## API

### TTimeCounter

通用计时器组件，支持正向计时与倒计时。

#### 主题配置

组件主题通过 `TTimeCounterThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。可配置字段和未设置时的回退见本页的
`TTimeCounterThemeData` 配置项。

#### 构造方法

##### TTimeCounter

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| autoStart | bool | true | 首次挂载时是否自动开始计时，默认为 true。 该值只决定初始行为；挂载后的开始、暂停和重置由 `controller` 控制。 设置为 false 后仍需启动计时时，应同时传入 `controller`。 | 否 |
| content | TTimeCounterBuilder? | - | 自定义计时内容；为空时使用标准数字块。 | 否 |
| controller | TTimeCounterController? | - | 控制器，可控制开始、暂停和重置。 | 否 |
| direction | TTimeCounterDirection | TTimeCounterDirection.down | 计时方向，默认倒计时。 | 否 |
| format | String | 'HH:mm:ss' | 时间格式，D-日、H-时、m-分、s-秒、S-毫秒，默认为 `HH:mm:ss`。 每段可重复字符控制最小位数，相邻时间段之间仅允许一个非空白分隔符； 最后一段后可追加一个单位字符。例如 `HH:mm:ss`、`mmmm分sss秒`。 两位 `H`、`m`、`s` 分别按 24、60、60 取余；需要展示累计值时， 可将对应时间段扩展为三位及以上，例如 `HHH:mm:ss` 会展示累计小时数。 包含 `S` 段时按绘制帧更新，否则仅在格式化后的可见值变化时更新。 使用 `content` 时，该字段仍决定计时更新精度。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onChanged | ValueChanged&lt;int&gt;? | - | 计时推进或控制器 reset 导致格式化后的可见值变化时触发，回调值为当前毫秒数。 `format` 包含毫秒段时随绘制帧更新，否则仅在可见时间段变化时通知。 父组件更新 time 或 direction 导致的声明式重置不触发本回调；初始化也不触发。 | 否 |
| onFinish | VoidCallback? | - | 计时到达终点时触发一次回调。 初始值或重置值已在终点时不会自动触发；此时显式调用 `TTimeCounterController.start` 会触发一次。 | 否 |
| size | TTimeCounterSize? | - | 计时器尺寸；null 时使用 TTimeCounterSize.medium。 | 否 |
| splitWithUnit | bool | false | 是否使用本地化时间单位分隔，默认为 false。 | 否 |
| time | int | - | 必需；计时时长，单位毫秒。 父组件更新该值时会按新的声明式配置重置计时，并覆盖此前 `TTimeCounterController.reset` 传入的临时目标时长。 必须大于或等于 0。 | 是 |
| variant | TTimeCounterVariant? | - | 视觉形态；null 时使用 TTimeCounterVariant.plain。 | 否 |


### TTimeCounterController

计时器控制器，可控制开始、暂停和重置。

Controller 由调用方创建并负责释放。绑定多个 `TTimeCounter` 时，
每条命令会广播给所有已绑定组件。

#### 构造方法

##### TTimeCounterController

无参数。

#### 实例方法

##### TTimeCounterController.pause

无参数。

暂停计时。

##### TTimeCounterController.reset

位置参数：`time`


重置计时并保持暂停；`time` 为空时恢复为组件当前配置的时长。

重置后如需继续计时，请显式调用 `start`。
父组件后续更新 `TTimeCounter.time` 时，新的声明式配置优先。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| time | int? | - | 重置时长，单位为毫秒；为空时恢复组件当前时长，负数抛出 ArgumentError。 | 否 |


##### TTimeCounterController.start

无参数。

开始或继续计时。

### TTimeCounterDirection

计时方向。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| down | TTimeCounterDirection | - | 倒计时。 | - |
| up | TTimeCounterDirection | - | 正向计时。 | - |


### TTimeCounterSize

计时器尺寸。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| small | TTimeCounterSize | - | 小尺寸。 | - |
| medium | TTimeCounterSize | - | 中等尺寸。 | - |
| large | TTimeCounterSize | - | 大尺寸。 | - |


### TTimeCounterVariant

计时器视觉形态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| plain | TTimeCounterVariant | - | 无数字块背景。 | - |
| highlight | TTimeCounterVariant | - | 无数字块背景，并以错误色突出数字。 | - |
| round | TTimeCounterVariant | - | 圆形数字块。 | - |
| square | TTimeCounterVariant | - | 方形数字块。 | - |


### TTimeCounterBuilder

自定义计时内容构建器。

位置参数：`time`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| time | int | - | 当前计时值，单位为毫秒。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | 自定义计时展示内容。 | - |


### TTimeCounterThemeData

计时器组件的具体视觉默认值。

尺寸档位与形态由 `TTimeCounter.size` / `variant` 唯一选择；未设置的视觉值
在使用时回退当前 TDesign 全局 Token，而不是在 Theme 中冻结默认值。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| blockBackgroundColor | Color? | - | 圆形、方形数字块的背景色；未设置时回退 `errorColor`。 | 否 |
| blockTextColor | Color? | - | 圆形、方形数字块的文字颜色；未设置时回退 `textColorAnti`。 | 否 |
| defaultTextColor | Color? | - | 纯文本计时数字颜色；未设置时回退 `textColorPrimary`。 | 否 |
| roundBorderRadius | double? | - | 圆形数字块的圆角，单位为逻辑像素；未设置时回退 `radiusCircle`。 默认数字块宽高相等，故固定大半径显示为正圆。自定义较小半径时显示 对应的圆角方块，不再被固定 `BoxShape.circle` 忽略。 | 否 |
| squareBorderRadius | double? | - | 方形数字块的圆角，单位为逻辑像素；未设置时回退 `radiusSmall`。 | 否 |
