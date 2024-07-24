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

[td_data_picker_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_data_picker_page.dart)

### 1 组件类型

年月日选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildYearMonthDay(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_1 = '${selected['year'].toString().padLeft(4, '0')}-${selected['month'].toString().padLeft(2, '0')}-${selected['day'].toString().padLeft(2, '0')}';
              });
              Navigator.of(context).pop();
            },
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_1, '选择时间'),
    );
  }</pre>

</td-code-block>
                                  

年月选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildYearMonth(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_2 = '${selected['year'].toString().padLeft(4, '0')}-'
                    '${selected['month'].toString().padLeft(2, '0')}';
              });
              Navigator.of(context).pop();
            },
            useDay: false,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_2, '选择时间'),
    );
  }</pre>

</td-code-block>
                                  

月日选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildMonthDay(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_3 = '${selected['month'].toString().padLeft(2, '0')}-'
                    '${selected['day'].toString().padLeft(2, '0')}';
              });
              Navigator.of(context).pop();
            },
            useYear: false,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_3, '选择时间'),
    );
  }</pre>

</td-code-block>
                                  

时分秒选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildHourMinuteSecond(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_4 = '${selected['hour'].toString().padLeft(2, '0')}:'
                    '${selected['minute'].toString().padLeft(2, '0')}:'
                    '${selected['second'].toString().padLeft(2, '0')}';
              });
              Navigator.of(context).pop();
            },
            useYear: false,
            useMonth: false,
            useDay: false,
            useHour: true,
            useMinute: true,
            useSecond: true,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_4, '选择时间'),
    );
  }</pre>

</td-code-block>
                                  

年月日时分秒选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildAll(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_5 = '${selected['year'].toString().padLeft(4, '0')}-'
                    '${selected['month'].toString().padLeft(2, '0')}-'
                    '${selected['day'].toString().padLeft(2, '0')} '
                    '${selected['hour'].toString().padLeft(2, '0')}:'
                    '${selected['minute'].toString().padLeft(2, '0')}:'
                    '${selected['second'].toString().padLeft(2, '0')}';
              });
              Navigator.of(context).pop();
            },
            useHour: true,
            useMinute: true,
            useSecond: true,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_5, '选择时间'),
    );
  }</pre>

</td-code-block>
                                  

年月日带星期选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildWeekDay(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_6 = '${selected['year'].toString().padLeft(4, '0')}-'
                    '${selected['month'].toString().padLeft(2, '0')}-'
                    '${selected['day'].toString().padLeft(2, '0')} '
                    '${weekDayList[selected['weekDay']! - 1]}';
              });
              Navigator.of(context).pop();
            },
            useWeekDay: true,
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_6, '选择时间'),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

是否带标题
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildWithTitle(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_7 = '${selected['year'].toString().padLeft(4, '0')}-'
                    '${selected['month'].toString().padLeft(2, '0')}-'
                    '${selected['day'].toString().padLeft(2, '0')}';
              });
              Navigator.of(context).pop();
            },
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_7, '带标题时间选择器'),
    );
  }</pre>

</td-code-block>
                                  

不带标题
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildWithoutTitle(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showDatePicker(context, title: '',
            onConfirm: (selected) {
              setState(() {
                selected_8 = '${selected['year'].toString().padLeft(4, '0')}-'
                    '${selected['month'].toString().padLeft(2, '0')}-'
                    '${selected['day'].toString().padLeft(2, '0')}';
              });
              Navigator.of(context).pop();
            },
            dateStart: [1999, 01, 01],
            dateEnd: [2023, 12, 31],
            initialDate: [2012, 1, 1]);
      },
      child: buildSelectRow(context, selected_8, '无标题时间选择器'),
    );
  }</pre>

</td-code-block>
                                  


## API
### TDDatePicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | String | - | 选择器标题 |
| onConfirm | DatePickerCallback? | - | 选择器确认按钮回调 |
| rightText | String? | - | 右侧按钮文案 |
| leftText | String? | - | 左侧按钮文案 |
| onCancel | DatePickerCallback? | - | 选择器取消按钮回调 |
| backgroundColor | Color? | - | 背景颜色 |
| titleDividerColor | Color? | - | 标题分割线颜色 |
| topRadius | double? | - | 顶部圆角 |
| titleHeight | double? | - | 标题高度 |
| padding | EdgeInsets? | - | 适配padding |
| leftPadding | double? | - | 左边填充 |
| rightPadding | double? | - | 右边填充 |
| leftTextStyle | TextStyle? | - | 自定义左侧文案样式 |
| rightTextStyle | TextStyle? | - | 自定义右侧文案样式 |
| centerTextStyle | TextStyle? | - | 自定义中间文案样式 |
| customSelectWidget | Widget? | - | 自定义选择框样式 |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 根据距离计算字体颜色、透明度、粗细 |
| model | DatePickerModel | - | 数据模型 |
| showTitle | bool | true | 是否展示标题 |
| pickerHeight | double | 200 | 选择器List的视窗高度，默认200 |
| pickerItemCount | int | - | 选择器List视窗中item个数，pickerHeight / pickerItemCount即item高度 |
| key |  | - |  |

```
```
 ### TDPicker

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showDatePicker |  |   required null context,  required String title,  required DatePickerCallback? onConfirm,  DatePickerCallback? onCancel,  bool useYear,  bool useMonth,  bool useDay,  bool useHour,  bool useMinute,  bool useSecond,  bool useWeekDay,  Color? barrierColor,  List<int> dateStart,  List<int>? dateEnd,  List<int>? initialDate,  String? rightText,  String? leftText,  Duration duration,  double pickerHeight,  int pickerItemCount, | 显示时间选择器 |
| showMultiPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required List<List<String>> data,  List<int>? initialIndexes,  Duration duration,  Color? barrierColor,  double pickerHeight,  int pickerItemCount, | 显示多级选择器 |
| showMultiLinkedPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required Map data,  required int columnNum,  required List initialData,  Duration duration,  Color? barrierColor,  double pickerHeight,  int pickerItemCount, | 显示多级联动选择器 |


  