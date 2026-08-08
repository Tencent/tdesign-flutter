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

[td_date-time-picker_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_date-time-picker_page.dart)

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
                                  

自定义选择范围（2025-06-10 09:30:00 ~ 2025-08-25 18:45:30）；月/日/时/分/秒在边界上下文收紧
            
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
              timeMode: TimeMode.second,
            ),
            start: _kRangeStart,
            end: _kRangeEnd,
            initialValue: _rangeSelected ?? _kRangeInitial,
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
与 ``TCalendar``、``TPicker`` 为三个独立对外组件；本组件底层复用 ``TPicker``
滚轮能力（经内部 ``DateTimePickerWheel``），与 ``TCalendar`` 无代码耦合。
纯滚轮组件：不含工具栏、确认按钮或弹窗；选中变化通过 `onChange` 实时回调
（无 `TPicker.onConfirm` 语义）。弹窗与确认请配合 `TPopup` 等自行组装。
`initialValue` 为非受控初始值；外部重置选中请变更 `initialValue` 或 `key`。
与 `TPicker` 不同，本组件不提供受控 `value` 参数。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| end | TDateTimePickerValue? | - | 可选范围上限 - **类型**：`TDateTimePickerValue`，仅传当前 mode 涉及的字段即可 - **语义**：超出范围的候选项会被裁剪；变更会触发列重建 |
| height | double? | - | 滚轮视窗高度（像素），默认 200 |
| initialValue | TDateTimePickerValue? | - | 初始选中值（非受控） - **默认**：未传时使用当前系统时间 - **语义**：非受控 —— 运行期变更会重建滚轮并同步到新初始值（与 `TPicker.initialValue` 的 initState-only 不同） - **重置**：配合 `Key` 强制重建，或直接变更本参数 - **partial**：仅传当前 mode 涉及的字段，缺字段由内部 fallback 补齐 |
| itemCount | int? | - | 每屏显示 item 数（奇数更利于中央高亮），默认 5 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| mode | DateTimePickerMode? | - | 滚轮列结构（必填） - **类型**：`DateTimePickerMode`，通过 `DateMode`、`TimeMode` 组合列 - **默认**：未传时等价于 `DateTimePickerMode(dateMode: DateMode.date)`（年月日） - **变更语义**：列结构变化会重建滚轮并清空上次通知值 |
| onChange | void Function(TDateTimePickerValue result)? | - | 选中值变化回调（滚动时实时触发，不代表用户已确认选择） - **触发时机**：滚轮选中变化且结果与上次通知值不同时 - **返回值**：`TDateTimePickerValue`；不含的列字段为 null - **典型用法**：维护 draft 状态；弹窗场景配合 `TPopup` 确认后再提交 |
| renderLabel | DateTimePickerRenderLabel? | - | 自定义列展示文案 - **回调参数**：`column` 为 `DateTimeColumn`，`value` 为列数值 - **回退**：返回 null 时使用内置默认文案（含国际化单位后缀） |
| showWeek | bool | false | 日列是否在 label 后附加星期，默认 false - **生效范围**：仅 `DateTimeColumn.day` 列 - **变更语义**：变更会触发列重建 |
| start | TDateTimePickerValue? | - | 可选范围下限 - **类型**：`TDateTimePickerValue`，仅传当前 mode 涉及的字段即可 - **语义**：超出范围的候选项会被裁剪；变更会触发列重建 |
| steps | DateTimePickerSteps? | - | 各列选项步进 - **类型**：`DateTimePickerSteps`；未配置的列步进为 1 - **变更语义**：变更会触发列重建，保留当前选中时刻（在合法范围内 clamp） |


### DateTimePickerMode
#### 简介
滚轮列结构，由 `DateMode`、`TimeMode` 组合。
通过 `DateTimePickerMode(dateMode:, timeMode:)` 构造，至少传其一：
- `dateMode`：日期段粒度（年 / 年月 / 年月日）；不传则不展示日期列
- `timeMode`：时间段粒度（时 / 时分 / 时分秒）；不传则不展示时间列
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| dateMode | DateMode? | - | - |
| timeMode | TimeMode? | - | - |


### TDateTimePickerValue
#### 简介
`TDateTimePicker.onChange` 返回值；`null` 字段表示当前 mode 不含该列。
初始化 `TDateTimePicker.initialValue`、`start`、`end` 时仅传相关字段即可；
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


  