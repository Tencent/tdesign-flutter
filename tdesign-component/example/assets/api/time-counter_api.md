## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TTimeCounter
#### 简介
通用计时器组件，支持正向计时与倒计时。

#### 声明

```dart
class TTimeCounter extends StatefulWidget
```

#### 默认构造方法


```dart
const TTimeCounter({
  super.key,
  this.autoStart = true,
  this.content,
  this.format = 'HH:mm:ss',
  this.size,
  this.splitWithUnit = false,
  this.variant,
  required this.time,
  this.onChanged,
  this.onFinish,
  this.direction = TTimeCounterDirection.down,
  this.controller,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
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
#### 简介
计时器控制器，可控制开始、暂停和重置。
Controller 由调用方创建并负责释放。绑定多个 `TTimeCounter` 时，
每条命令会广播给所有已绑定组件。

#### 声明

```dart
class TTimeCounterController extends ChangeNotifier
```

#### 默认构造方法


```dart
TTimeCounterController()
```


#### 实例方法

##### TTimeCounterController.pause

```dart
void pause()
```


暂停计时。

返回类型：`void`

##### TTimeCounterController.reset

```dart
void reset([int? time])
```


重置计时并保持暂停；`time` 为空时恢复为组件当前配置的时长。
重置后如需继续计时，请显式调用 `start`。
父组件后续更新 `TTimeCounter.time` 时，新的声明式配置优先。

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| time | int? | - | 重置时长，单位为毫秒；为空时恢复组件当前时长，负数抛出 ArgumentError。 | 否 |


##### TTimeCounterController.start

```dart
void start()
```


开始或继续计时。

返回类型：`void`

### TTimeCounterThemeData
#### 简介
计时器组件的具体视觉默认值。
尺寸档位与形态由 `TTimeCounter.size` / `variant` 唯一选择；未设置的视觉值
在使用时回退当前 TDesign 全局 Token，而不是在 Theme 中冻结默认值。
{@category ComponentTheme}

#### 声明

```dart
class TTimeCounterThemeData extends ThemeExtension<TTimeCounterThemeData>
```

#### 默认构造方法


```dart
const TTimeCounterThemeData({
  this.defaultTextColor,
  this.blockTextColor,
  this.blockBackgroundColor,
  this.squareBorderRadius,
  this.roundBorderRadius,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| blockBackgroundColor | Color? | - | 圆形、方形数字块的背景色；未设置时回退 `errorColor`。 | 否 |
| blockTextColor | Color? | - | 圆形、方形数字块的文字颜色；未设置时回退 `textColorAnti`。 | 否 |
| defaultTextColor | Color? | - | 纯文本计时数字颜色；未设置时回退 `textColorPrimary`。 | 否 |
| roundBorderRadius | double? | - | 圆形数字块的圆角，单位为逻辑像素；未设置时回退 `radiusCircle`。 默认数字块宽高相等，故固定大半径显示为正圆。自定义较小半径时显示 对应的圆角方块，不再被固定 `BoxShape.circle` 忽略。 | 否 |
| squareBorderRadius | double? | - | 方形数字块的圆角，单位为逻辑像素；未设置时回退 `radiusSmall`。 | 否 |


#### 实例方法

##### TTimeCounterThemeData.copyWith

```dart
TTimeCounterThemeData copyWith({
  Color? defaultTextColor,
  Color? blockTextColor,
  Color? blockBackgroundColor,
  double? squareBorderRadius,
  double? roundBorderRadius,
})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TTimeCounterThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| defaultTextColor | Color? | - | 纯文本计时数字颜色；未设置时回退 `textColorPrimary`。 | 否 |
| blockTextColor | Color? | - | 圆形、方形数字块的文字颜色；未设置时回退 `textColorAnti`。 | 否 |
| blockBackgroundColor | Color? | - | 圆形、方形数字块的背景色；未设置时回退 `errorColor`。 | 否 |
| squareBorderRadius | double? | - | 方形数字块的圆角，单位为逻辑像素；未设置时回退 `radiusSmall`。 | 否 |
| roundBorderRadius | double? | - | 圆形数字块的圆角，单位为逻辑像素；未设置时回退 `radiusCircle`。 默认数字块宽高相等，故固定大半径显示为正圆。自定义较小半径时显示 对应的圆角方块，不再被固定 `BoxShape.circle` 忽略。 | 否 |


##### TTimeCounterThemeData.lerp

```dart
TTimeCounterThemeData lerp(
  ThemeExtension<TTimeCounterThemeData>? other,
  double t,
)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TTimeCounterThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TTimeCounterThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


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
`time` 当前计时值，单位为毫秒。
## 返回值
自定义计时展示内容。
#### 类型定义

```dart
typedef TTimeCounterBuilder = Widget Function(int time);
```
