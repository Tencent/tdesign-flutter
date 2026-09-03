## API
### TDateTimePicker
#### 简介
日期/时间滚轮选择器。
纯滚轮组件，不包含工具栏、确认按钮或弹窗。
`value` 与 `onChanged` 构成严格受控状态；`onChanged` 为 null 时禁用。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| end | TDateTimePickerValue? | - | 可选范围上限。未指定时，年列最大值为初始选中年份加 10。 - **类型**：`TDateTimePickerValue`，仅传当前 mode 涉及的字段即可 - **语义**：超出范围的候选项会被裁剪；变更会触发列重建 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| mode | DateTimePickerMode? | - | 滚轮列结构。 - **类型**：`DateTimePickerMode`，通过 `DateMode`、`TimeMode` 组合列 - **默认**：未传时等价于 `DateTimePickerMode(dateMode: DateMode.date)`（年月日） - **变更语义**：列结构变化会重建滚轮并清空上次通知值 |
| onChanged | void Function(TDateTimePickerValue result)? | - | 选中值变化回调（滚动时实时触发，不代表用户已确认选择） - **触发时机**：滚轮选中变化且结果与上次通知值不同时 - **返回值**：`TDateTimePickerValue`；不含的列字段为 null - **典型用法**：维护业务侧受控状态 |
| renderLabel | DateTimePickerRenderLabel? | - | 自定义列展示文案 - **回调参数**：`column` 为 `DateTimeColumn`，`value` 为列数值 - **回退**：返回 null 时使用内置默认文案（含国际化单位后缀） |
| showWeek | bool | false | 日列是否在 label 后附加星期，默认 false - **生效范围**：仅 `DateTimeColumn.day` 列 - **变更语义**：变更会触发列重建 |
| start | TDateTimePickerValue? | - | 可选范围下限。未指定时，年列最小值为初始选中年份减 10。 - **类型**：`TDateTimePickerValue`，仅传当前 mode 涉及的字段即可 - **语义**：超出范围的候选项会被裁剪；变更会触发列重建 |
| steps | DateTimePickerSteps? | - | 各列选项步进 - **类型**：`DateTimePickerSteps`；未配置的列步进为 1 - **变更语义**：变更会触发列重建，保留当前选中时刻（在合法范围内 clamp） |
| value | TDateTimePickerValue | - | 受控选中值。 |


### DateTimePickerMode
#### 简介
滚轮列结构，由 `DateMode`、`TimeMode` 组合。
通过 `DateTimePickerMode(dateMode:, timeMode:)` 构造，至少传其一：
- `dateMode`：日期段粒度（年 / 年月 / 年月日 / 月日）；不传则不展示日期列
- `timeMode`：时间段粒度（时 / 时分 / 时分秒）；不传则不展示时间列
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| dateMode | DateMode? | - | 日期段粒度；为 null 时不展示日期列。 |
| timeMode | TimeMode? | - | 时间段粒度；为 null 时不展示时间列。 |


### TDateTimePickerValue
#### 简介
`TDateTimePicker.onChanged` 返回值；`null` 字段表示当前 mode 不含该列。
初始化 `TDateTimePicker.value`、`start`、`end` 时仅传相关字段即可；
提交后端时使用 `toDateTime`，partial 值须显式传入 `fallback`。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| day | int? | - | 日（1–31）；当前 mode 不含日列或未赋值时为 null。 |
| hour | int? | - | 时（0–23）；当前 mode 不含时列或未赋值时为 null。 |
| minute | int? | - | 分（0–59）；当前 mode 不含分列或未赋值时为 null。 |
| month | int? | - | 月（1–12）；当前 mode 不含月列或未赋值时为 null。 |
| second | int? | - | 秒（0–59）；当前 mode 不含秒列或未赋值时为 null。 |
| year | int? | - | 年（1–9999）；当前 mode 不含年列或未赋值时为 null。 |


### DateTimePickerSteps
#### 简介
各列选项步进，未配置的列步进为 1。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| day | int? | - | 日列步进。 |
| hour | int? | - | 时列步进。 |
| minute | int? | - | 分列步进。 |
| month | int? | - | 月列步进。 |
| second | int? | - | 秒列步进。 |
| year | int? | - | 年列步进。 |


### DateMode
#### 简介
日期段粒度，用于 `DateTimePickerMode` 的 `DateMode` 参数。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| year | 年。 |
| month | 年 + 月。 |
| date | 年 + 月 + 日。 |
| monthDay | 月 + 日，不显示年份。缺省年份按 2000 年计算，允许选择 2 月 29 日。 可通过受控值的 year 指定计算年；回调的 year 仍为 null。 若业务绑定特定年份，接收回调后应继续在 value 中传入该年份。 |


### TimeMode
#### 简介
时间段粒度，用于 `DateTimePickerMode` 的 `TimeMode` 参数。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| hour | 时。 |
| minute | 时 + 分。 |
| second | 时 + 分 + 秒。 |


### DateTimeColumn
#### 简介
滚轮列标识，用于 `DateTimePickerRenderLabel` 回调与 `DateTimePickerMode` 列展开。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| year | 年列。 |
| month | 月列。 |
| day | 日列。 |
| hour | 时列。 |
| minute | 分列。 |
| second | 秒列。 |


### DateTimePickerRenderLabel
#### 简介
自定义滚轮列展示文案；返回 null 时使用默认文案。
#### 类型定义

```dart
typedef DateTimePickerRenderLabel = String? Function(DateTimeColumn column, int value);
```
