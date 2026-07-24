## API
### TSlider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| divisions | int? | - | 离散刻度数；null 表示连续。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| max | double | 1 | 最大值。 |
| min | double | 0 | 最小值。 |
| onChanged | ValueChanged<double>? | - | 值变更回调；为 null 时禁用。 |
| onChangeEnd | ValueChanged<double>? | - | 结束拖动时触发。 |
| onChangeStart | ValueChanged<double>? | - | 开始拖动时触发。 |
| value | double | - | 受控滑块值。 |


### TRangeSlider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| divisions | int? | - | 离散刻度数；null 表示连续。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| max | double | 1 | 最大值。 |
| min | double | 0 | 最小值。 |
| onChanged | ValueChanged<RangeValues>? | - | 范围变更回调；为 null 时禁用。 |
| onChangeEnd | ValueChanged<RangeValues>? | - | 结束拖动时触发。 |
| onChangeStart | ValueChanged<RangeValues>? | - | 开始拖动时触发。 |
| value | RangeValues | - | 受控范围值。 |
