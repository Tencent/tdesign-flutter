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
            mode: DateTimePickerMode.date,
            title: '请选择日期',
            defaultValue: _baseSelected?.toDateTime(fallback: _kReplayFallback),
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
            mode: DateTimePickerMode.month,
            title: '请选择年月',
            defaultValue:
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
            mode: DateTimePickerMode.combined(time: TimeMode.minute),
            title: '请选择时分',
            defaultValue: _timeSelected?.toDateTime(fallback: _kReplayFallback),
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
            mode: DateTimePickerMode.combined(
              date: DateMode.date,
              time: TimeMode.minute,
            ),
            title: '2024 ~ 2026',
            start: DateTime(2024, 1, 1),
            end: DateTime(2026, 12, 31, 23, 59),
            defaultValue:
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
            mode: DateTimePickerMode.date,
            showWeek: true,
            title: '请选择日期',
            defaultValue: _weekSelected?.toDateTime(fallback: _kReplayFallback),
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
### TPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用整个选择器（禁止滚动和操作），默认 false |
| height | double | 200 | 视窗高度，默认 200 |
| initialValue | List? | - | 初始选中值列表（按 value 匹配） |
| itemCount | int | 5 | 每屏显示 item 数，默认 5 |
| items | dynamic | - | 数据源（必填） |
| key |  | - |  |
| onChange | void Function(TPickerValue)? | - | 值改变回调 |
| onLoad | void Function(TPickerLoadEvent)? | - | 接近底部时加载回调 |
| preloadThreshold | int | 5 | 预加载阈值（距底部剩余 N 项时触发），默认 5 |


  