---
title: DateTimePicker 时间选择器
description: 纯滚轮选择日期/时间，选中值通过 onChange 回调。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[t_date_time_picker_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_date_time_picker_page.dart)

### 1 基础用法

不使用弹窗（内嵌）
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildInline(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(TTheme.of(context).radiusDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: ValueListenableBuilder<TDateTimePickerValue?>(
              valueListenable: _inlineSelectedNotifier,
              builder: (context, selected, _) => TText(
                '当前选择：${_formatResult(selected)}',
                textColor: TTheme.of(context).textColorSecondary,
              ),
            ),
          ),
          TDateTimePicker(
            mode: DateTimePickerMode(
              dateMode: DateMode.date,
              timeMode: TimeMode.minute,
            ),
            initialValue: _kInlineInitialValue,
            onChange: (result) => _inlineSelectedNotifier.value = result,
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

年月日选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBase(BuildContext context) {
    return TCell(
      title: '年月日选择器',
      note: _formatResult(_baseSelected),
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            initialValue: _baseSelected,
            onChange: (result) => setState(() => _baseSelected = result),
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  

选择年月
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildYearMonth(BuildContext context) {
    return TCell(
      title: '选择年月',
      note: _formatResult(_yearMonthSelected),
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.month),
            initialValue: _yearMonthSelected,
            onChange: (result) => setState(() => _yearMonthSelected = result),
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  

选择时分
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTime(BuildContext context) {
    return TCell(
      title: '选择时分',
      note: _formatResult(_timeSelected),
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(timeMode: TimeMode.minute),
            initialValue: _timeSelected,
            onChange: (result) => setState(() => _timeSelected = result),
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  

自定义选择范围（2024–2026）；各列在 [start, end] 内按当前选中上下文收紧
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomRange(BuildContext context) {
    return TCell(
      title: '自定义选择范围',
      note: _formatResult(_rangeSelected),
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(
              dateMode: DateMode.date,
              timeMode: TimeMode.minute,
            ),
            start: TDateTimePickerValue.fromDateTime(DateTime(2024, 1, 1)),
            end: TDateTimePickerValue.fromDateTime(
              DateTime(2026, 12, 31, 23, 59),
            ),
            initialValue: _rangeSelected ??
                TDateTimePickerValue.fromDateTime(
                  DateTime(2025, 6, 15, 12, 30),
                ),
            onChange: (result) => setState(() => _rangeSelected = result),
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  

年月日 + 星期
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildWeek(BuildContext context) {
    return TCell(
      title: '年月日 + 星期',
      note: _formatWeekResult(context, _weekSelected),
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            showWeek: true,
            initialValue: _weekSelected,
            onChange: (result) => setState(() => _weekSelected = result),
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


## API
### TDateTimePicker
#### 简介
日期/时间滚轮选择器。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| end | TDateTimePickerValue? | - | 可选范围上限，类型同 `initialValue`。 |
| height | double? | - | 滚轮视窗高度，默认 200。 |
| initialValue | TDateTimePickerValue? | - | 初始选中值（非受控）；缺省为当前时间。 |
| itemCount | int? | - | 每屏可见条目数，默认 5。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| mode | DateTimePickerMode? | - | 滚轮列结构；通过 `DateTimePickerMode` 组合 `DateMode`、`TimeMode`，默认年月日。 |
| onChange | void Function(TDateTimePickerValue result)? | - | 选中值变化回调，返回 `TDateTimePickerValue`。 |
| renderLabel | DateTimePickerRenderLabel? | - | 自定义列展示文案；`column` 为 `DateTimeColumn`，`value` 为数值，返回 null 用默认文案。 |
| showWeek | bool | false | 日列是否显示星期，默认 false。 |
| start | TDateTimePickerValue? | - | 可选范围下限，类型同 `initialValue`。 |
| steps | DateTimePickerSteps? | - | 各列选项步进。 |


### DateTimePickerMode
#### 简介
滚轮列结构，由 `DateMode`、`TimeMode` 组合；通过 `DateTimePickerMode(dateMode:, timeMode:)` 构造。

#### 工厂构造方法

##### DateTimePickerMode.forImplementation
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| dateMode | DateMode? | - | - |
| timeMode | TimeMode? | - | - |


### TDateTimePickerValue
#### 简介
`TDateTimePicker.onChange` 返回值；`null` 字段表示当前 mode 不含该列。
提交后端时调用 `toDateTime`；从 `DateTime` 初始化用 `fromDateTime`。

#### 工厂构造方法

##### TDateTimePickerValue.fromDateTime

从 `DateTime` 构造，用于 `TDateTimePicker.initialValue` 或 `TDateTimePicker.start`/`end`。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| dateTime | DateTime | - | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| day | int? | - | 日。 |
| hour | int? | - | 时。 |
| minute | int? | - | 分。 |
| month | int? | - | 月。 |
| second | int? | - | 秒。 |
| year | int? | - | 年。 |


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


### TimeMode
#### 简介
时间段粒度，用于 `DateTimePickerMode` 的 `TimeMode` 参数。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| hour | 时。 |
| minute | 时 + 分。 |
| second | 时 + 分 + 秒。 |
