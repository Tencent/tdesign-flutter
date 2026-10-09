## API

### TSlider

#### 构造方法

##### TSlider

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| divisions | int? | - | 离散刻度数；null 表示连续。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| max | double | 1 | 最大值。 | 否 |
| min | double | 0 | 最小值。 | 否 |
| onChanged | ValueChanged&lt;double&gt;? | - | 值变更回调；为 null 时禁用。 | 否 |
| onChangeEnd | ValueChanged&lt;double&gt;? | - | 结束拖动时触发。 | 否 |
| onChangeStart | ValueChanged&lt;double&gt;? | - | 开始拖动时触发。 | 否 |
| scaleFormatter | TSliderThumbFormatter? | - | 刻度值格式化回调。 | 否 |
| showScaleValue | bool | false | 是否显示刻度值。 | 否 |
| showThumbValue | bool | false | 是否持续显示拇指上方数值。 | 否 |
| thumbFormatter | TSliderThumbFormatter? | - | 拇指上方数值格式化回调。 | 否 |
| value | double | - | 受控滑块值。 | 是 |
| variant | TSliderVariant | TSliderVariant.normal | 滑块视觉结构，默认使用标准细轨道。 | 否 |


### TRangeSlider

#### 构造方法

##### TRangeSlider

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| divisions | int? | - | 离散刻度数；null 表示连续。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| max | double | 1 | 最大值。 | 否 |
| min | double | 0 | 最小值。 | 否 |
| onChanged | ValueChanged&lt;RangeValues&gt;? | - | 范围变更回调；为 null 时禁用。 | 否 |
| onChangeEnd | ValueChanged&lt;RangeValues&gt;? | - | 结束拖动时触发。 | 否 |
| onChangeStart | ValueChanged&lt;RangeValues&gt;? | - | 开始拖动时触发。 | 否 |
| scaleFormatter | TSliderThumbFormatter? | - | 刻度值格式化回调。 | 否 |
| showScaleValue | bool | false | 是否显示刻度值。 | 否 |
| showThumbValue | bool | false | 是否持续显示拇指上方数值。 | 否 |
| thumbFormatter | TSliderThumbFormatter? | - | 拇指上方数值格式化回调。 | 否 |
| value | RangeValues | - | 受控范围值。 | 是 |
| variant | TSliderVariant | TSliderVariant.normal | 滑块视觉结构，默认使用标准细轨道。 | 否 |


### TSliderVariant
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| normal | TSliderVariant | - | Standard thin track. | - |
| capsule | TSliderVariant | - | Capsule track with a 3px inset active segment and 20px thumbs. | - |


### TSliderThumbFormatter

位置参数：`value`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| value | double | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | - | - |
