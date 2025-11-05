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
    return TDCell(
      title: '选择时间',
      note: selected_1.isEmpty ? '请选择' : selected_1,
      arrow: true,
      onClick: (click) {
        TDPicker.showDatePicker(
          context,
          title: '选择时间',
          onConfirm: (selected) {
            setState(() {
              selected_1 = '${selected['year'].toString().padLeft(4, '0')}'
                  '-${selected['month'].toString().padLeft(2, '0')}'
                  '-${selected['day'].toString().padLeft(2, '0')}';
            });
            Navigator.of(context).pop();
          },
          dateStart: [1999, 01, 01],
          dateEnd: [2023, 12, 31],
          initialDate: [2012, 1, 1],
        );
      },
    );
  }</pre>

</td-code-block>
                                  

年月选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildYearMonth(BuildContext context) {
    return TDCell(
      title: '选择时间',
      note: selected_2.isEmpty ? '请选择' : selected_2,
      arrow: true,
      onClick: (click) {
        TDPicker.showDatePicker(
          context,
          title: '选择时间',
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
          initialDate: [2012, 1, 1],
        );
      },
    );
  }</pre>

</td-code-block>
                                  

月日选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildMonthDay(BuildContext context) {
    return TDCell(
      title: '选择时间',
      note: selected_3.isEmpty ? '请选择' : selected_3,
      arrow: true,
      onClick: (click) {
        TDPicker.showDatePicker(
          context,
          title: '选择时间',
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
          initialDate: [2012, 1, 1],
        );
      },
    );
  }</pre>

</td-code-block>
                                  

时分秒选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildHourMinuteSecond(BuildContext context) {
    return TDCell(
      title: '选择时间',
      note: selected_4.isEmpty ? '请选择' : selected_4,
      arrow: true,
      onClick: (click) {
        TDPicker.showDatePicker(
          context,
          title: '选择时间',
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
          dateEnd: [2023, 12, 31, 4, 12, 20],
          initialDate: [2023, 12, 31],
        );
      },
    );
  }</pre>

</td-code-block>
                                  

年月日时分秒选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildAll(BuildContext context) {
    return TDCell(
      title: '选择时间',
      note: selected_5.isEmpty ? '请选择' : selected_5,
      arrow: true,
      onClick: (click) {
        TDPicker.showDatePicker(
          context,
          title: '选择时间',
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
          initialDate: [2012, 1, 1],
        );
      },
    );
  }</pre>

</td-code-block>
                                  

年月日带星期选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildWeekDay(BuildContext context) {
    return TDCell(
      title: '选择时间',
      note: selected_6.isEmpty ? '请选择' : selected_6,
      arrow: true,
      onClick: (click) {
        TDPicker.showDatePicker(
          context,
          title: '选择时间',
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
          initialDate: [2012, 1, 1],
        );
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

是否带标题
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildWithTitle(BuildContext context) {
    return TDCell(
      title: '选择时间',
      note: selected_7.isEmpty ? '请选择' : selected_7,
      arrow: true,
      onClick: (click) {
        TDPicker.showDatePicker(
          context,
          title: '选择时间',
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
          initialDate: [2012, 1, 1],
        );
      },
    );
  }</pre>

</td-code-block>
                                  

不带标题
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildWithoutTitle(BuildContext context) {
    return TDCell(
      title: '选择时间',
      note: selected_8.isEmpty ? '请选择' : selected_8,
      arrow: true,
      onClick: (click) {
        TDPicker.showDatePicker(
          context,
          // 不传或传空字符串、null，则不显示标题
          // title: '',
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
          initialDate: [2012, 1, 1],
        );
      },
    );
  }</pre>

</td-code-block>
                                  

不使用弹窗、不带顶部内容
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildWithoutHeader(BuildContext context) {
    return TDDatePicker(
      header: false,
      model: DatePickerModel(
        useYear: true,
        useMonth: true,
        useDay: true,
        useHour: true,
        useMinute: true,
        useSecond: true,
        useWeekDay: false,
        dateStart: [1999, 01, 01],
        dateEnd: [2023, 12, 31],
        dateInitial: [2012, 1, 1],
      ),
      onChange: (selected) {
        print('onChange ${selected}');
      },
    );
  }</pre>

</td-code-block>
                                  


## API
### TDDatePicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| centerTextStyle | TextStyle? | - | 自定义中间文案样式 |
| customSelectWidget | Widget? | - | 自定义选择框样式 |
| header | bool | true | 是否显示头部内容 |
| isTimeUnit | bool? | - | 是否时间显示 |
| itemBuilder | ItemBuilderType? | - | 自定义item构建 |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 根据距离计算字体颜色、透明度、粗细 |
| key |  | - |  |
| leftPadding | double? | - | 左边填充 |
| leftText | String? | - | 左侧按钮文案 |
| leftTextStyle | TextStyle? | - | 自定义左侧文案样式 |
| model | DatePickerModel | - | 数据模型 |
| onCancel | DatePickerCallback? | - | 选择器取消按钮回调 |
| onChange | DatePickerCallback? | - | 选择器值改变回调 |
| onConfirm | DatePickerCallback? | - | 选择器确认按钮回调 |
| onSelectedItemChanged | void Function(int wheelIndex, int index)? | - | 选择器选中项改变回调 |
| padding | EdgeInsets? | - | 适配padding |
| pickerHeight | double | 200 | 选择器List的视窗高度，默认200 |
| pickerItemCount | int | 5 | 选择器List视窗中item个数，pickerHeight / pickerItemCount，即item高度 |
| rightPadding | double? | - | 右边填充 |
| rightText | String? | - | 右侧按钮文案 |
| rightTextStyle | TextStyle? | - | 自定义右侧文案样式 |
| title | String? | - | 选择器标题 |
| titleDividerColor | Color? | - | 标题分割线颜色 |
| titleHeight | double? | - | 标题高度 |
| topPadding | double? | - | 顶部填充 |
| topRadius | double? | - | 顶部圆角 |

```
```
 ### TDPicker

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showDatePicker |  |   required null context,  String? title,  double? titleHeight,  Color? titleDividerColor,  required DatePickerCallback? onConfirm,  DatePickerCallback? onCancel,  DatePickerCallback? onChange,   Function(int wheelIndex, int index)? onSelectedItemChanged,  String? leftText,  TextStyle? leftTextStyle,  TextStyle? centerTextStyle,  String? rightText,  TextStyle? rightTextStyle,  EdgeInsets? padding,  double? leftPadding,  double? topPadding,  double? rightPadding,  double? topRadius,  Color? backgroundColor,  Widget? customSelectWidget,  bool useYear,  bool useMonth,  bool useDay,  bool useHour,  bool useMinute,  bool useSecond,  bool useWeekDay,  List<int> dateStart,  List<int>? dateEnd,  List<int>? initialDate,  List<int> Function(DateTypeKey key, List<int> nums)? filterItems,  double pickerHeight,  int pickerItemCount,  bool isTimeUnit,  ItemBuilderType? itemBuilder,  Color? barrierColor,  Duration duration, | 显示时间选择器 |
| showMultiLinkedPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required List initialData,  required Map data,  required int columnNum,  double pickerHeight,  int pickerItemCount,  Widget? customSelectWidget,  String? rightText,  String? leftText,  TextStyle? leftTextStyle,  TextStyle? centerTextStyle,  TextStyle? rightTextStyle,  double? titleHeight,  double? topPadding,  double? leftPadding,  double? rightPadding,  Color? titleDividerColor,  Color? backgroundColor,  double? topRadius,  EdgeInsets? padding,  ItemBuilderType? itemBuilder,  bool keepSameSelection,  Color? barrierColor,  Duration duration, | 显示多级联动选择器 |
| showMultiPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required List<List<String>> data,  double pickerHeight,  int pickerItemCount,  List<int>? initialIndexes,  String? rightText,  String? leftText,  TextStyle? leftTextStyle,  TextStyle? centerTextStyle,  TextStyle? rightTextStyle,  double? titleHeight,  double? topPadding,  double? leftPadding,  double? rightPadding,  Color? titleDividerColor,  Color? backgroundColor,  double? topRadius,  EdgeInsets? padding,  Widget? customSelectWidget,  ItemBuilderType? itemBuilder,  Duration duration,  Color? barrierColor, | 显示多级选择器 |


  