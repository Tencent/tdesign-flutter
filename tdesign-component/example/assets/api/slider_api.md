## API
### TSlider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| boxDecoration | Decoration? | - | 自定义盒子样式 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftLabel | String? | - | 左侧标签 |
| onChanged | ValueChanged<double>? | - | 滑动变化监听 |
| onChangeEnd | ValueChanged<double>? | - | 滑动结束监听 |
| onChangeStart | ValueChanged<double>? | - | 滑动开始监听 |
| onTap | Function(Offset offset, double value)? | - | Thumb 点击事件 坐标、当前值 |
| onThumbTextTap | Function(Offset offset, double value)? | - | Thumb 点击浮标文字 坐标、当前值 |
| rightLabel | String? | - | 右侧标签 |
| sliderThemeData | TSliderThemeData? | - | 样式 |
| value | double | - | 默认值 |


### TRangeSlider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| boxDecoration | Decoration? | - | 自定义盒子样式 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leftLabel | String? | - | 左侧标签 |
| onChanged | ValueChanged<RangeValues>? | - | 滑动变化监听 |
| onChangeEnd | ValueChanged<RangeValues>? | - | 滑动结束监听 |
| onChangeStart | ValueChanged<RangeValues>? | - | 滑动开始监听 |
| onTap | Function(Position position, Offset offset, double value)? | - | Thumb 点击事件 位置、坐标、当前值 |
| onThumbTextTap | Function(Position position, Offset offset, double value)? | - | Thumb 点击浮标文字 位置、坐标、当前值 |
| rightLabel | String? | - | 右侧标签 |
| sliderThemeData | TSliderThemeData? | - | 样式 |
| value | RangeValues | - | 默认值 |


### Position
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| start | - |
| end | - |
