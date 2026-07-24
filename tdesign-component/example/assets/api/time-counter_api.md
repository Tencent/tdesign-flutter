## API
### TTimeCounter
#### 简介
计时组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autoStart | bool | true | 是否自动开始倒计时 |
| content | TTimeCounterBuilder? | - | 自定义计时内容；为空时使用标准数字块。 |
| controller | TTimeCounterController? | - | 控制器，可控制开始/暂停/继续/重置 |
| direction | TTimeCounterDirection | TTimeCounterDirection.down | 计时方向，默认倒计时 |
| format | String | 'HH:mm:ss' | 时间格式，DD-日，HH-时，mm-分，ss-秒，SSS-毫秒（分隔符必须为长度为1的非空格的字符） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<int>? | - | 时间变化时触发回调 |
| onFinish | VoidCallback? | - | 计时结束时触发回调 |
| showMillisecond | bool? | - | 是否显示毫秒；优先于组件 Theme。 |
| size | TTimeCounterSize? | - | 计时器尺寸；优先于组件 Theme。 |
| splitWithUnit | bool? | - | 是否使用本地化时间单位分隔；优先于组件 Theme。 |
| time | int | - | 必需；计时时长，单位毫秒 |
| variant | TTimeCounterVariant? | - | 视觉形态；优先于组件 Theme。 |


### TTimeCounterController
#### 简介
倒计时组件控制器，可控制开始(`start()`)/暂停(`pause()`)/继续(`resume()`)/重置(`reset([int? time])`)

### TTimeCounterThemeData
#### 简介
计时器组件的视觉和展示默认值。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| showMillisecond | bool? | - | 默认是否显示毫秒。 |
| size | TTimeCounterSize? | - | 默认尺寸。 |
| splitWithUnit | bool? | - | 默认是否使用本地化时间单位分隔。 |
| variant | TTimeCounterVariant? | - | 默认视觉形态。 |


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
| defaultTheme | 无数字块背景。 |
| round | 圆形数字块。 |
| square | 方形数字块。 |


### TTimeCounterStatus
#### 简介
计时组件控制器转态
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| start | 开始 |
| pause | 暂停 |
| resume | 继续 |
| reset | 重置 |
| idle | 空，默认值 |


### TTimeCounterBuilder
#### 简介
自定义计时内容构建器。
#### 类型定义

```dart
typedef TTimeCounterBuilder = Widget Function(int time);
```
