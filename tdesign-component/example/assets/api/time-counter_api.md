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

### TTimeCounterStyle
#### 简介
计时组件样式

#### 工厂构造方法

##### TTimeCounterStyle.generateStyle

生成默认样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| size | TTimeCounterSize? | - | - |
| theme | TTimeCounterVariant? | - | - |
| splitWithUnit | bool? | - | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| space | double? | - | 时间与分隔符的间隔 |
| splitColor | Color? | - | 分隔符字体颜色 |
| splitFontHeight | double? | - | 分隔符字体行高 |
| splitFontSize | double? | - | 分隔符字体尺寸 |
| splitFontWeight | FontWeight? | - | 分隔符字体粗细 |
| timeBox | BoxDecoration? | - | 时间容器装饰 |
| timeColor | Color? | - | 时间字体颜色 |
| timeFontFamily | FontFamily? | - | 时间字体 |
| timeFontHeight | double? | - | 时间字体行高 |
| timeFontSize | double? | - | 时间字体尺寸 |
| timeFontWeight | FontWeight? | - | 时间字体粗细 |
| timeHeight | double? | - | 时间容器高度 |
| timeMargin | EdgeInsets? | - | 时间容器外边距 |
| timePadding | EdgeInsets? | - | 时间容器内边距 |
| timeWidth | double? | - | 时间容器宽度 |


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
