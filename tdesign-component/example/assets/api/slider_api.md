## API

### TSlider

基于 Material `Slider` 的严格受控单值滑块。

#### 主题配置

组件主题通过 `TSliderThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TSliderThemeData` 说明。

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


### TSliderThemeData

TSlider 与 TRangeSlider 共用的组件级 ThemeExtension。

轨道、滑块和提示标签由组件 Theme 控制，不读取 Material SliderTheme。

#### 构造方法

##### TSliderThemeData

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


#### 实例方法

##### TSliderThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| activeTrackColor | Color? | - | 字段含义：选中轨道颜色；为空时使用全局品牌色。 调用时的空值行为见方法说明。 | 否 |
| inactiveTrackColor | Color? | - | 字段含义：未选中轨道颜色；为空时使用全局组件边框色。 调用时的空值行为见方法说明。 | 否 |
| thumbColor | Color? | - | 字段含义：滑块填充颜色；为空时使用全局反色文字色。 调用时的空值行为见方法说明。 | 否 |
| disabledThumbColor | Color? | - | 字段含义：禁用滑块填充颜色；为空时使用全局反色文字色。 调用时的空值行为见方法说明。 | 否 |
| thumbBorderColor | Color? | - | 字段含义：滑块描边颜色；为空时使用全局灰阶色。 调用时的空值行为见方法说明。 | 否 |
| disabledThumbBorderColor | Color? | - | 字段含义：禁用滑块描边颜色；为空时浅色使用 componentBorder Token， 暗色使用 bgColorComponentDisabled Token。 调用时的空值行为见方法说明。 | 否 |
| overlayColor | Color? | - | 字段含义：交互反馈颜色；为空时使用品牌色的透明层。 调用时的空值行为见方法说明。 | 否 |
| valueIndicatorColor | Color? | - | 字段含义：数值提示背景颜色；为空时使用全局品牌色。 调用时的空值行为见方法说明。 | 否 |
| valueIndicatorTextColor | Color? | - | 字段含义：数值提示文字颜色；为空时使用全局主要文字色。 调用时的空值行为见方法说明。 | 否 |
| trackHeight | double? | - | 字段含义：普通轨道粗细；胶囊形态仍使用其内置规格。 null 时为 4 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| decoration | Decoration? | - | 字段含义：滑块外层装饰。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSliderThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TSliderThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TSliderThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSliderThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


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
