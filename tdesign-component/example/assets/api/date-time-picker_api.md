## API
### TDateTimePicker
#### 简介
日期/时间选择器。
纯滚轮 UI，无顶部取消/确定栏。滚轮中心项变化时通过 `onChange` 通知选中结果，
与上次 `TDateTimePickerValue` 相同时不重复触发。弹窗场景的关闭与提交由
`TPopup` 或页面逻辑处理。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| end | DateTime? | - | 可选范围上界（闭区间）。 为 `null` 时年列上界为组件打开时锚定年份 + 10，且不随年列滚动漂移。 若 `start` 晚于 `end`，debug 下 assert，release 下忽略 `end`。 |
| height | double? | - | 滚轮视窗高度，默认 200。 |
| initialValue | DateTime? | - | 默认选中时间。 缺省为 `DateTime.now`；超出 `start`、`end` 时钳制到范围内。 用于首次展示或父组件更新时重置；滚动中的当前值请通过 `onChange` 获取， 勿将 `onChange` 的结果同步回本参数并触发父组件重建。 |
| itemCount | int? | - | 每屏可见条目数，默认 5。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| mode | DateTimePickerMode? | - | 列结构。 |
| onChange | void Function(TDateTimePickerValue result)? | - | 选中值变化回调。 `TDateTimePickerValue` 仅包含当前 `mode` 中存在的列； 与上一次回调结果相同时不触发。 |
| renderLabel | DateTimePickerRenderLabel? | - | 自定义列 label，仅影响展示；返回 `null` 时使用 `TResourceDelegate` 默认文案。 |
| showWeek | bool | false | 是否在日列 label 附加星期（如 `19日 周六`），仅影响展示。 回调结果无星期字段，请用 `TDateTimePickerValue.toDateTime`.weekday。 |
| start | DateTime? | - | 可选范围下界（闭区间）。 为 `null` 时年列下界为组件打开时锚定年份 − 10，且不随年列滚动漂移。 若 `start` 晚于 `end`，debug 下 assert，release 下忽略 `end`。 |
| steps | DateTimePickerSteps? | - | 各列选项步进，如 `DateTimePickerSteps(minute: 5)`；未配置的列步进为 1。 |


### DateTimePickerMode
#### 简介
列结构模式。
通过 `DateMode`、`TimeMode` 组合列，至少传其一。相同列配置在 `==` / `hashCode`
上相等。

#### 工厂构造方法

##### DateTimePickerMode.forImplementation
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| dateMode | DateMode? | - | - |
| timeMode | TimeMode? | - | - |


#### 方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| columns | List<DateTimeColumn> | - | 按显示顺序展开的列列表。 |
| == | bool | required Object other | - |
| hashCode | int | - | - |


### TDateTimePickerValue
#### 简介
选择结果。
字段为 `null` 表示当前 `DateTimePickerMode` 不含该列。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| day | int? | - | 选中的日（1–31）；当前 mode 不含该列时为 `null`。 |
| hour | int? | - | 选中的时（0–23）；当前 mode 不含该列时为 `null`。 |
| minute | int? | - | 选中的分（0–59）；当前 mode 不含该列时为 `null`。 |
| month | int? | - | 选中的月（1–12）；当前 mode 不含该列时为 `null`。 |
| second | int? | - | 选中的秒（0–59）；当前 mode 不含该列时为 `null`。 |
| year | int? | - | 选中的年；当前 mode 不含该列时为 `null`。 |


### DateTimePickerSteps
#### 简介
各列选项步进。
对齐 mobile-vue `steps`（如 `{ minute: 5 }`）。未配置的列步进为 1。
与 `TDateTimePicker.start`、`end` 同时使用时，在闭区间内按步进生成选项，
选中值吸附到最近合法步进点。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| day | int? | - | 日列步进。 |
| hour | int? | - | 时列步进。 |
| minute | int? | - | 分列步进。 |
| month | int? | - | 月列步进。 |
| second | int? | - | 秒列步进。 |
| year | int? | - | 年列步进。 |


### DateTimeColumn
#### 简介
选择器列类型。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| year | 年。 |
| month | 月（1–12）。 |
| day | 日（1–31，按该年该月实际天数）。 |
| hour | 时（0–23）。 |
| minute | 分（0–59）。 |
| second | 秒（0–59）。 |


### DateMode
#### 简介
`DateTimePickerMode` 的日期段粒度。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| year | 年。 |
| month | 年 + 月。 |
| date | 年 + 月 + 日。 |


### TimeMode
#### 简介
`DateTimePickerMode` 的时间段粒度。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| hour | 时。 |
| minute | 时 + 分。 |
| second | 时 + 分 + 秒。 |


### DateTimePickerRenderLabel
#### 简介
自定义列 label。
`column` 为列类型，`value` 为该列数值；返回 `null` 时使用默认文案。
#### 类型定义

```dart
typedef DateTimePickerRenderLabel = String? Function(DateTimeColumn column, int value);
```
