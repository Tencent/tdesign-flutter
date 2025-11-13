---
title: Picker 选择器
description: 用于一组预设数据中的选择。
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

[td_picker_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_picker_page.dart)

### 1 组件类型

基础选择器--地区
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildArea(BuildContext context) {
    const title = '选择地区';
    return TDCell(
      title: title,
      note: selected_1.isEmpty ? '请选择' : selected_1,
      arrow: true,
      onClick: (click) {
        TDPicker.showMultiPicker(
          context,
          title: title,
          onConfirm: (selected) {
            setState(() {
              selected_1 = '${data_1[selected[0]]}';
            });
            Navigator.of(context).pop();
          },
          data: [data_1],
        );
      },
    );
  }</pre>

</td-code-block>
                                  

基础选择器--时间
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildTime(BuildContext context) {
    const title = '选择时间';
    return TDCell(
      title: title,
      note: selected_2.isEmpty ? '请选择' : selected_2,
      arrow: true,
      onClick: (click) {
        TDPicker.showMultiPicker(
          context,
          title: title,
          onConfirm: (selected) {
            print('selected ${selected}');
            setState(() {
              selected_2 =
                  '${data_2[0][selected[0]]} ${data_2[1][selected[1]]}';
            });
            Navigator.of(context).pop();
          },
          data: data_2,
        );
      },
    );
  }</pre>

</td-code-block>
                                  

基础选择器--地区--联动
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildMultiArea(BuildContext context) {
    const title = '选择地区';
    return TDCell(
      title: title,
      note: selected_3.isEmpty ? '请选择' : selected_3,
      arrow: true,
      onClick: (click) {
        TDPicker.showMultiLinkedPicker(
          context,
          title: title,
          onConfirm: (selected) {
            setState(() {
              selected_3 = '${selected[0]} ${selected[1]} ${selected[2]}';
            });
            Navigator.of(context).pop();
          },
          data: dataTest,
          columnNum: 3,
          initialData: ['浙江省', '杭州市', '西湖区'],
        );
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

带标题选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildAreaWithTitle(BuildContext context) {
    const title = '选择地区';
    return TDCell(
      title: title,
      note: selected_4.isEmpty ? '请选择' : selected_4,
      arrow: true,
      onClick: (click) {
        TDPicker.showMultiPicker(
          context,
          title: '带标题选择器',
          onConfirm: (selected) {
            setState(() {
              selected_4 = '${data_1[selected[0]]}';
            });
            Navigator.of(context).pop();
          },
          data: [data_1],
        );
      },
    );
  }</pre>

</td-code-block>
                                  

无标题选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildAreaWithoutTitle(BuildContext context) {
    return TDCell(
      title: '选择地区',
      note: selected_5.isEmpty ? '请选择' : selected_5,
      arrow: true,
      onClick: (click) {
        TDPicker.showMultiPicker(
          context,
          // 不传或传空字符串、null，则不显示标题
          // title: '',
          onConfirm: (selected) {
            setState(() {
              selected_5 = '${data_1[selected[0]]}';
            });
            Navigator.of(context).pop();
          },
          data: [data_1],
        );
      },
    );
  }</pre>

</td-code-block>
                                  

不使用弹窗、不带顶部内容
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildWithoutHeader(BuildContext context) {
    return TDMultiPicker(
      /// 不显示header内容
      header: false,
      /// todo onChange
      onConfirm: (selected) {
        setState(() {
          selected_5 = '${data_1[selected[0]]}';
        });
        Navigator.of(context).pop();
      },
      data: [data_1],
    );
  }</pre>

</td-code-block>
                                  


## API
### TDMultiPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| centerTextStyle | TextStyle? | - | 自定义中间文案样式 |
| customSelectWidget | Widget? | - | 自定义选择框样式 |
| data | Map | - | 总的数据 |
| header | bool | true | 是否显示头部内容 |
| initialIndexes | List<int>? | - | 若为null表示全部从零开始 |
| itemBuilder | ItemBuilderType? | - | 自定义item构建 |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 不同距离自选项计算策略 |
| key |  | - |  |
| leftPadding | double? | - | 左边填充 |
| leftText | String? | - | 左侧按钮文案 |
| leftTextStyle | TextStyle? | - | 自定义左侧文案样式 |
| onCancel | MultiPickerCallback? | - | 选择器取消按钮回调 |
| onChange | MultiPickerCallback? | - | todo 选择器数据改变时回调 |
| onConfirm | MultiPickerCallback? | - | 选择器确认按钮回调 |
| padding | EdgeInsets? | - | 适配padding |
| pickerHeight | double | 200 |  |
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
 ### TDMultiLinkedPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| centerTextStyle | TextStyle? | - | 自定义中间文案样式 |
| columnNum | int | - | 总列数 |
| customSelectWidget | Widget? | - | 自定义选择框样式 |
| data | Map | - | 总的数据 |
| header | bool | true | 是否显示头部内容 |
| itemBuilder | ItemBuilderType? | - | 自定义item构建 |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 不同距离自选项计算策略 |
| keepSameSelection | bool | false | 是否保留相同选项 |
| key |  | - |  |
| leftPadding | double? | - | 左边填充 |
| leftText | String? | - | 左侧按钮文案 |
| leftTextStyle | TextStyle? | - | 自定义左侧文案样式 |
| onCancel | MultiPickerCallback? | - | 选择器取消按钮回调 |
| onChange | MultiPickerCallback? | - | todo 选择器数据改变时回调 |
| onConfirm | MultiPickerCallback? | - | 选择器确认按钮回调 |
| padding | EdgeInsets? | - | 适配padding |
| pickerHeight | double | 200 |  |
| pickerItemCount | int | 5 | 选择器List视窗中item个数，pickerHeight / pickerItemCount，即item高度 |
| rightPadding | double? | - | 右边填充 |
| rightText | String? | - | 右侧按钮文案 |
| rightTextStyle | TextStyle? | - | 自定义右侧文案样式 |
| selectedData | List | - | 选中数据 |
| title | String? | - | 选择器标题 |
| titleDividerColor | Color? | - | 标题分割线颜色 |
| titleHeight | double? | - | 标题高度 |
| topPadding | double? | - | 顶部填充 |
| topRadius | double? | - | 顶部圆角 |

```
```
 ### MultiLinkedPickerModel
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| columnNum | int | - | 总列数 |
| data | Map | - | 总的数据 |
| initialData |  | - |  |
| keepSameSelection | bool | false | 是否保留相同选项 |

```
```
 ### TDPicker

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showDatePicker |  |   required null context,  String? title,  double? titleHeight,  Color? titleDividerColor,  required DatePickerCallback? onConfirm,  DatePickerCallback? onCancel,  DatePickerCallback? onChange,   Function(int wheelIndex, int index)? onSelectedItemChanged,  String? leftText,  TextStyle? leftTextStyle,  TextStyle? centerTextStyle,  String? rightText,  TextStyle? rightTextStyle,  EdgeInsets? padding,  double? leftPadding,  double? topPadding,  double? rightPadding,  double? topRadius,  Color? backgroundColor,  Widget? customSelectWidget,  bool useYear,  bool useMonth,  bool useDay,  bool useHour,  bool useMinute,  bool useSecond,  bool useWeekDay,  List<int> dateStart,  List<int>? dateEnd,  List<int>? initialDate,  List<int> Function(DateTypeKey key, List<int> nums)? filterItems,  double pickerHeight,  int pickerItemCount,  bool isTimeUnit,  ItemBuilderType? itemBuilder,  Color? barrierColor,  Duration duration, | 显示时间选择器 |
| showMultiLinkedPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required List initialData,  required Map data,  required int columnNum,  double pickerHeight,  int pickerItemCount,  Widget? customSelectWidget,  String? rightText,  String? leftText,  TextStyle? leftTextStyle,  TextStyle? centerTextStyle,  TextStyle? rightTextStyle,  double? titleHeight,  double? topPadding,  double? leftPadding,  double? rightPadding,  Color? titleDividerColor,  Color? backgroundColor,  double? topRadius,  EdgeInsets? padding,  ItemBuilderType? itemBuilder,  bool keepSameSelection,  Color? barrierColor,  Duration duration, | 显示多级联动选择器 |
| showMultiPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required List<List<String>> data,  double pickerHeight,  int pickerItemCount,  List<int>? initialIndexes,  String? rightText,  String? leftText,  TextStyle? leftTextStyle,  TextStyle? centerTextStyle,  TextStyle? rightTextStyle,  double? titleHeight,  double? topPadding,  double? leftPadding,  double? rightPadding,  Color? titleDividerColor,  Color? backgroundColor,  double? topRadius,  EdgeInsets? padding,  Widget? customSelectWidget,  ItemBuilderType? itemBuilder,  Duration duration,  Color? barrierColor, | 显示多级选择器 |


  