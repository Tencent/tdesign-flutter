## API

### TDateTimePicker

日期/时间滚轮选择器。

纯滚轮组件，不包含工具栏、确认按钮或弹窗。
`value` 与 `onChanged` 构成严格受控状态；`onChanged` 为 null 时禁用。

#### 构造方法

##### TDateTimePicker

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| end | TDateTimePickerValue? | - | 可选范围上限。未指定时，年列最大值为初始选中年份加 10。 start 不应晚于 end；debug 模式会断言，release 模式遇到逆序范围时忽略 end。 - **类型**：`TDateTimePickerValue`，仅传当前 mode 涉及的字段即可 - **语义**：超出范围的候选项会被裁剪；变更会触发列重建 - **月日模式**：未传 year 时使用 `value` 的计算年，value 也未传 year 时使用 2000 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| mode | DateTimePickerMode? | - | 滚轮列结构。 - **类型**：`DateTimePickerMode`，通过 `DateMode`、`TimeMode` 组合列 - **默认**：未传时等价于 `DateTimePickerMode(dateMode: DateMode.date)`（年月日） - **变更语义**：列结构变化会重建滚轮并清空上次通知值 | 否 |
| onChanged | void Function(TDateTimePickerValue result)? | - | 选中值变化回调（滚动时实时触发，不代表用户已确认选择） - **触发时机**：滚轮选中变化且结果与上次通知值不同时 - **返回值**：`TDateTimePickerValue`；不含的列字段为 null - **典型用法**：维护业务侧受控状态 | 否 |
| renderLabel | DateTimePickerRenderLabel? | - | 自定义列展示文案 - **回调参数**：`column` 为 `DateTimeColumn`，`value` 为列数值 - **回退**：返回 null 时使用内置默认文案（含国际化单位后缀） | 否 |
| showWeek | bool | false | 日列是否在 label 后附加星期，默认 false - **生效范围**：仅 `DateTimeColumn.day` 列 - **变更语义**：变更会触发列重建 | 否 |
| start | TDateTimePickerValue? | - | 可选范围下限。未指定时，年列最小值为初始选中年份减 10。 - **类型**：`TDateTimePickerValue`，仅传当前 mode 涉及的字段即可 - **语义**：超出范围的候选项会被裁剪；变更会触发列重建 - **月日模式**：未传 year 时使用 `value` 的计算年，value 也未传 year 时使用 2000 | 否 |
| steps | DateTimePickerSteps? | - | 各列选项步进 - **类型**：`DateTimePickerSteps`；未配置或小于等于 1 的列步进按 1 处理 - **变更语义**：变更会触发列重建，保留当前选中时刻（在合法范围内 clamp） | 否 |
| value | TDateTimePickerValue | - | 受控选中值。 父级接受 `onChanged` 的结果后重建并回传新值。滚动结束后父级未接受 的候选值自动恢复为按当前模式、边界和步进归一化后的值。 | 是 |


### DateTimePickerMode

滚轮列结构，由 `DateMode`、`TimeMode` 组合。

通过 `DateTimePickerMode(dateMode:, timeMode:)` 构造，至少传其一：
- `dateMode`：日期段粒度（年 / 年月 / 年月日 / 月日）；不传则不展示日期列
- `timeMode`：时间段粒度（时 / 时分 / 时分秒）；不传则不展示时间列

#### 构造方法

##### DateTimePickerMode

创建滚轮列结构；`dateMode`、`timeMode` 至少传其一。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| dateMode | DateMode? | - | 日期段粒度；为 null 时不展示日期列。 | 否 |
| timeMode | TimeMode? | - | 时间段粒度；为 null 时不展示时间列。 | 否 |


### TDateTimePickerValue

`TDateTimePicker.onChanged` 返回值；`null` 字段表示当前 mode 不含该列。

初始化 `TDateTimePicker.value`、`start`、`end` 时仅传相关字段即可；
提交后端时使用 `toDateTime`，partial 值须显式传入 `fallback`。

#### 构造方法

##### TDateTimePickerValue

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| day | int? | - | 日（1–31）；当前 mode 不含日列或未赋值时为 null。 | 否 |
| hour | int? | - | 时（0–23）；当前 mode 不含时列或未赋值时为 null。 | 否 |
| minute | int? | - | 分（0–59）；当前 mode 不含分列或未赋值时为 null。 | 否 |
| month | int? | - | 月（1–12）；当前 mode 不含月列或未赋值时为 null。 | 否 |
| second | int? | - | 秒（0–59）；当前 mode 不含秒列或未赋值时为 null。 | 否 |
| year | int? | - | 年（1–9999）；当前 mode 不含年列或未赋值时为 null。 | 否 |


#### 实例方法

##### TDateTimePickerValue.toDateTime

转为 `DateTime`

- **完整值**：六元组均有值时直接构造
- **partial 值**：缺字段用 `fallback` 补齐；未传 `fallback` 时抛出 `ArgumentError`
- **日期归一化**：按 Dart `DateTime` 构造规则组合字段；例如 2 月配合 31 日
的 fallback 会跨月归一化，不会自动按 Picker 范围裁剪。
- **典型用法**：提交后端前调用；partial 值须传入能组成业务合法日期的 `fallback`

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| fallback | DateTime? | - | 补齐未指定日期时间字段的业务基准；partial 值未提供它时抛出 ArgumentError。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | DateTime | - | 以六个时间字段构造的本地 DateTime；缺失字段由 fallback 补齐，未提供所需 fallback 时抛出 ArgumentError， 日期字段按 Dart DateTime 规则归一化。 | - |


### DateTimePickerSteps

各列选项步进，未配置或小于等于 1 的列步进按 1 处理。

#### 构造方法

##### DateTimePickerSteps

创建步进配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| day | int? | - | 日列步进。 | 否 |
| hour | int? | - | 时列步进。 | 否 |
| minute | int? | - | 分列步进。 | 否 |
| month | int? | - | 月列步进。 | 否 |
| second | int? | - | 秒列步进。 | 否 |
| year | int? | - | 年列步进。 | 否 |


### DateMode

日期段粒度，用于 `DateTimePickerMode` 的 `DateMode` 参数。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| year | DateMode | - | 年。 | - |
| month | DateMode | - | 年 + 月。 | - |
| date | DateMode | - | 年 + 月 + 日。 | - |
| monthDay | DateMode | - | 月 + 日，不显示年份。缺省年份按 2000 年计算，允许选择 2 月 29 日。 可通过受控值的 year 指定计算年；回调的 year 仍为 null。 若业务绑定特定年份，接收回调后应继续在 value 中传入该年份。 | - |


### TimeMode

时间段粒度，用于 `DateTimePickerMode` 的 `TimeMode` 参数。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| hour | TimeMode | - | 时。 | - |
| minute | TimeMode | - | 时 + 分。 | - |
| second | TimeMode | - | 时 + 分 + 秒。 | - |


### DateTimeColumn

滚轮列标识，用于 `DateTimePickerRenderLabel` 回调与 `DateTimePickerMode` 列展开。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| year | DateTimeColumn | - | 年列。 | - |
| month | DateTimeColumn | - | 月列。 | - |
| day | DateTimeColumn | - | 日列。 | - |
| hour | DateTimeColumn | - | 时列。 | - |
| minute | DateTimeColumn | - | 分列。 | - |
| second | DateTimeColumn | - | 秒列。 | - |


### DateTimePickerRenderLabel

自定义滚轮列展示文案。

位置参数：`column, value`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| column | DateTimeColumn | - | 当前列，见 `DateTimeColumn`。 | 是 |
| value | int | - | 列数值。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | String? | - | 选项展示文案；返回 null 时使用该列默认文案。 | - |
