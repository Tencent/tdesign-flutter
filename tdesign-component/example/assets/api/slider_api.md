## API

### TSlider

基于 Material `Slider` 的严格受控单值滑块。

#### 构造方法

##### TSlider

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| divisions | int? | - | 离散刻度数；null 表示连续。 非 null 时必须大于 0。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| max | double | 1 | 最大值。 必须大于 min。 | 否 |
| min | double | 0 | 最小值。 max 必须大于 min。 | 否 |
| onChanged | ValueChanged&lt;double&gt;? | - | 值变更回调；为 null 时禁用。 | 否 |
| onChangeEnd | ValueChanged&lt;double&gt;? | - | 结束拖动时触发。 | 否 |
| onChangeStart | ValueChanged&lt;double&gt;? | - | 开始拖动时触发。 | 否 |
| scaleFormatter | TSliderThumbFormatter? | - | 刻度值格式化回调。 | 否 |
| showScaleValue | bool | false | 是否显示刻度值；开启时必须提供 `divisions`。 | 否 |
| showThumbValue | bool | false | 是否持续显示拇指上方数值。 | 否 |
| thumbFormatter | TSliderThumbFormatter? | - | 拇指上方数值格式化回调。 | 否 |
| value | double | - | 受控滑块值；应处于 min 与 max 指定的范围内，父组件需回传新值。 | 是 |
| variant | TSliderVariant | TSliderVariant.normal | 滑块视觉结构，默认使用标准细轨道。 | 否 |


### TRangeSlider

基于 Material `RangeSlider` 的严格受控范围滑块。

#### 构造方法

##### TRangeSlider

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| divisions | int? | - | 离散刻度数；null 表示连续。 非 null 时必须大于 0。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| max | double | 1 | 最大值。 必须大于 min。 | 否 |
| min | double | 0 | 最小值。 max 必须大于 min。 | 否 |
| onChanged | ValueChanged&lt;RangeValues&gt;? | - | 范围变更回调；为 null 时禁用。 | 否 |
| onChangeEnd | ValueChanged&lt;RangeValues&gt;? | - | 结束拖动时触发。 | 否 |
| onChangeStart | ValueChanged&lt;RangeValues&gt;? | - | 开始拖动时触发。 | 否 |
| scaleFormatter | TSliderThumbFormatter? | - | 刻度值格式化回调。 | 否 |
| showScaleValue | bool | false | 是否显示刻度值；开启时必须提供 `divisions`。 | 否 |
| showThumbValue | bool | false | 是否持续显示拇指上方数值。 | 否 |
| thumbFormatter | TSliderThumbFormatter? | - | 拇指上方数值格式化回调。 | 否 |
| value | RangeValues | - | 受控范围值；两端值应处于 min 与 max 指定的范围内，父组件需回传新值。 | 是 |
| variant | TSliderVariant | TSliderVariant.normal | 滑块视觉结构，默认使用标准细轨道。 | 否 |


### TSliderVariant

Slider visual structure.
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| normal | TSliderVariant | - | Standard thin track. | - |
| capsule | TSliderVariant | - | Capsule track with a 3px inset active segment and 20px thumbs. | - |


### TSliderThumbFormatter

格式化滑块提示文案。

位置参数：`value`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| value | double | - | 当前滑块数值。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String | - | 显示在滑块提示中的格式化文案。 | - |


### TSliderThemeData

TSlider 与 TRangeSlider 共用的组件级 ThemeExtension。

轨道、滑块和提示标签由组件 Theme 控制，不读取 Material SliderTheme。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| activeTrackColor | Color? | - | 选中轨道颜色；为空时使用全局品牌色。 | 否 |
| decoration | Decoration? | - | 滑块外层装饰。 | 否 |
| disabledThumbBorderColor | Color? | - | 禁用滑块描边颜色；为空时浅色使用 componentBorder Token， 暗色使用 bgColorComponentDisabled Token。 | 否 |
| disabledThumbColor | Color? | - | 禁用滑块填充颜色；为空时使用全局反色文字色。 | 否 |
| inactiveTrackColor | Color? | - | 未选中轨道颜色；为空时使用全局组件边框色。 | 否 |
| overlayColor | Color? | - | 交互反馈颜色；为空时使用品牌色的透明层。 | 否 |
| thumbBorderColor | Color? | - | 滑块描边颜色；为空时使用全局灰阶色。 | 否 |
| thumbColor | Color? | - | 滑块填充颜色；为空时使用全局反色文字色。 | 否 |
| trackHeight | double? | - | 普通轨道粗细；胶囊形态仍使用其内置规格。 null 时为 4 逻辑像素。 | 否 |
| valueIndicatorColor | Color? | - | 数值提示背景颜色；为空时使用全局品牌色。 | 否 |
| valueIndicatorTextColor | Color? | - | 数值提示文字颜色；为空时使用全局主要文字色。 | 否 |
