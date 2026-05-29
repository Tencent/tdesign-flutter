---
title: DateTimePicker 时间选择器
description: 用于选择一个时间点或者一个时间段。
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
            title: '内嵌日期时间选择',
            initialValue:
                _inlineSelectedNotifier.value
                        ?.toDateTime(fallback: _kReplayFallback) ??
                    DateTime.now(),
            onChange: (result) => _inlineSelectedNotifier.value = result,
            onConfirm: (result) => _inlineSelectedNotifier.value = result,
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
            title: '请选择日期',
            initialValue: _baseSelected?.toDateTime(fallback: _kReplayFallback),
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (result) {
              setState(() => _baseSelected = result);
              Navigator.of(context).pop();
            },
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
            title: '请选择年月',
            initialValue:
                _yearMonthSelected?.toDateTime(fallback: _kReplayFallback),
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (result) {
              setState(() => _yearMonthSelected = result);
              Navigator.of(context).pop();
            },
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
            title: '请选择时分',
            initialValue: _timeSelected?.toDateTime(fallback: _kReplayFallback),
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (result) {
              setState(() => _timeSelected = result);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  

自定义选择范围（2024–2026）；细粒度列按「当前年/月/日」与边界对齐时裁剪，跨边界不全程收紧，详见 TDateTimePicker 文档
            
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
            title: '2024 ~ 2026',
            start: DateTime(2024, 1, 1),
            end: DateTime(2026, 12, 31, 23, 59),
            initialValue:
                _rangeSelected?.toDateTime(fallback: _kReplayFallback) ??
                    DateTime(2025, 6, 15, 12, 30),
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (result) {
              setState(() => _rangeSelected = result);
              Navigator.of(context).pop();
            },
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
      note: _formatWeekResult(_weekSelected),
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            showWeek: true,
            title: '请选择日期',
            initialValue: _weekSelected?.toDateTime(fallback: _kReplayFallback),
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (result) {
              setState(() => _weekSelected = result);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  


## API
### TDateTimePicker
#### 简介
日期/时间选择器。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cancel | Widget? | - | 工具栏左侧插槽（Widget）；null 时使用 `TPicker` 默认取消文案。 |
| confirm | Widget? | - | 工具栏右侧插槽（Widget）；null 时使用 `TPicker` 默认确认文案。 |
| end | DateTime? | - | 可选范围上界（闭区间）；null 时年列上界为打开时锚定年份 + 10（不随滚动漂移）。 |
| height | double? | - | 面板视窗高度（不含工具栏），默认 200。 |
| initialValue | DateTime? | - | 默认选中时间；缺省 DateTime.now，超出 `start, end` 会钳制。用于首次展示或外部重置，当前选中通过 `onChange` 获取。 |
| itemCount | int? | - | 每屏可见条目数量，默认 5。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| mode | DateTimePickerMode | - | 列结构（必填）。详见 `DateTimePickerMode`。 |
| onCancel | VoidCallback? | - | 点击「取消」按钮的回调。 |
| onChange | void Function(TDateTimePickerValue result)? | - | 选中值变化回调；`TDateTimePickerValue` 仅含当前 mode 对应列，与上次结果相同时不触发。 |
| onConfirm | void Function(TDateTimePickerValue result)? | - | 点击「确定」按钮的回调；参数为 `TDateTimePickerValue`。 |
| showWeek | bool | false | 日列 label 是否附加星期（如 19日 周六）；仅影响展示。 回调结果不含独立星期字段，请用 `TDateTimePickerValue.toDateTime`.weekday。 |
| start | DateTime? | - | 可选范围下界（闭区间）；null 时年列下界为打开时锚定年份 - 10（不随滚动漂移）。 |
| title | String? | - | 工具栏中部标题文本。 |
| titleWidget | Widget? | - | 工具栏中部自定义标题组件（优先级高于 `title`）。 |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| weekLabels | List<String> | - | 星期 label，下标 = weekday - 1（周一 … 周日），与 `showWeek` 日列文案一致。 |


### DateTimePickerMode
#### 简介
列结构模式。快捷常量见下方静态成员；自定义组合用 `DateTimePickerMode.combined`。
相同 `dateGranularity` + `timeGranularity` 配置的 mode 在 `==` / `hashCode` 上视为相等
（如 `date` 与 `combined(dateMode: DateMode.date)`）；比较列结构也可用 `columns`。
注意：`hour` / `minute` / `second` 快捷常量含完整年月日；仅时间列（如只要时分）请用
`combined(timeMode: TimeMode.minute)` 等。

#### 工厂构造方法

##### DateTimePickerMode.combined

组合模式：通过 `dateMode`、`timeMode` 自由搭配列结构。
至少传其一（否则 assert）；两者都有时按 date→time 顺序拼接列。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| dateMode | DateMode? | - | `DateMode.year`（年）、`DateMode.month`（年+月）、`DateMode.date`（年月日）；null 表示不含日期列。 |
| timeMode | TimeMode? | - | `TimeMode.hour`（时）、`TimeMode.minute`（时分）、`TimeMode.second`（时分秒）；null 表示不含时间列。 |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| hour | DateTimePickerMode | - | 快捷模式：年 + 月 + 日 + 时（含完整年月日 + 时）。 若只要「时」一列或不含日期段，请用 `DateTimePickerMode.combined`。 |
| minute | DateTimePickerMode | - | 快捷模式：年 + 月 + 日 + 时 + 分（含完整年月日 + 时分）。 若只要「时分」两列，请用 `combined(timeMode: TimeMode.minute)`。 |
| month | DateTimePickerMode | - | 快捷模式：年 + 月（只选年月）。 |
| second | DateTimePickerMode | - | 快捷模式：年 + 月 + 日 + 时 + 分 + 秒（含完整年月日 + 时分秒）。 若只要时间列组合，请用 `combined(timeMode: TimeMode.second)` 等。 |
| year | DateTimePickerMode | - | 快捷模式：年（只选年份）。 |
| date | DateTimePickerMode | - | 快捷模式：年月日（对齐 mobile-vue `mode: 'date'`）；等价于 `combined(dateMode: DateMode.date)`。 |


#### 方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| dateGranularity | DateMode? | - | 日期段粒度（`ShortcutMode` / `CombinedMode` 共用，供判等）。 |
| timeGranularity | TimeMode? | - | 时间段粒度（`ShortcutMode` / `CombinedMode` 共用，供判等）。 |
| columns | List<DateTimeColumn> | - | 将 mode 解析为按显示顺序的列列表；一般业务只需把 mode 传给 `TDateTimePicker`。 |
| == | bool | required Object other | - |
| hashCode | int | - | - |


### TDateTimePickerValue
#### 简介
选择结果；字段为 null 表示当前 `DateTimePickerMode` 不含该列。
需 `DateTime` 时调用 `toDateTime`（缺列由 `fallback` 补齐，部分列场景建议传安全 fallback）。
需星期请用 `toDateTime`.weekday（`TDateTimePicker.showWeek` 仅影响日列展示）。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| day | int? | - | 选中的日（1–31）；当前 mode 不含该列时为 `null`。 |
| hour | int? | - | 选中的时（0–23）；当前 mode 不含该列时为 `null`。 |
| minute | int? | - | 选中的分（0–59）；当前 mode 不含该列时为 `null`。 |
| month | int? | - | 选中的月（1–12）；当前 mode 不含该列时为 `null`。 |
| second | int? | - | 选中的秒（0–59）；当前 mode 不含该列时为 `null`。 |
| year | int? | - | 选中的年；当前 mode 不含该列时为 `null`。 |


  