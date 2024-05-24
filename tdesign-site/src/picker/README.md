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

### 1 组件类型

基础选择器--地区
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildArea(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showMultiPicker(context, title: '选择地区',
            onConfirm: (selected) {
              setState(() {
                selected_1 = '${data_1[selected[0]]}';
              });
              Navigator.of(context).pop();
            }, data: [data_1]);
      },
      child: buildSelectRow(context, selected_1, '选择地区'),
    );
  }</pre>

</td-code-block>
                                  

基础选择器--时间
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildTime(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showMultiPicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_2 = '${data_2[0][selected[0]]} ${data_2[1][selected[1]]}';
              });
              Navigator.of(context).pop();
            }, data: data_2);
      },
      child: buildSelectRow(context, selected_2, '选择时间'),
    );
  }</pre>

</td-code-block>
                                  

基础选择器--地区--联动
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildMultiArea(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showMultiLinkedPicker(context, title: '选择地区',
            onConfirm: (selected) {
              setState(() {
                selected_3 = '${selected[0]} ${selected[1]} ${selected[2]}';
              });
              Navigator.of(context).pop();
            },
            data: data_3,
            columnNum: 3,
            initialData: ['浙江省', '杭州市', '西湖区']);
      },
      child: buildSelectRow(context, selected_3, '选择地区'),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

带标题选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildAreaWithTitle(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showMultiPicker(context, title: '选择地区',
            onConfirm: (selected) {
              setState(() {
                selected_4 = '${data_1[selected[0]]}';
              });
              Navigator.of(context).pop();
            }, data: [data_1]);
      },
      child: buildSelectRow(context, selected_4, '带标题选择器'),
    );
  }</pre>

</td-code-block>
                                  

无标题选择器
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildAreaWithoutTitle(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showMultiPicker(context, title: '',
            onConfirm: (selected) {
              setState(() {
                selected_5 = '${data_1[selected[0]]}';
              });
              Navigator.of(context).pop();
            }, data: [data_1]);
      },
      child: buildSelectRow(context, selected_5, '无标题选择器'),
    );
  }</pre>

</td-code-block>
                                  


## API
### TDMultiPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | String? | - | 选择器标题 |
| onConfirm | MultiPickerCallback? | - | 选择器确认按钮回调 |
| onCancel | MultiPickerCallback? | - | 选择器取消按钮回调 |
| data | Map | - | 总的数据 |
| pickerHeight | double | - |  |
| pickerItemCount | int | - | 选择器List视窗中item个数，pickerHeight / pickerItemCount即item高度 |
| initialIndexes | List<int>? | - | 若为null表示全部从零开始 |
| leftTextStyle | TextStyle? | - | 自定义左侧文案样式 |
| rightTextStyle | TextStyle? | - | 自定义右侧文案样式 |
| centerTextStyle | TextStyle? | - | 自定义中间文案样式 |
| titleHeight | double? | - | 标题高度 |
| topPadding | double? | - | 顶部填充 |
| leftPadding | double? | - | 左边填充 |
| rightPadding | double? | - | 右边填充 |
| titleDividerColor | Color? | - | 标题分割线颜色 |
| backgroundColor | Color? | - | 背景颜色 |
| topRadius | double? | - | 顶部圆角 |
| padding | EdgeInsets? | - | 适配padding |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 不同距离自选项计算策略 |
| customSelectWidget | Widget? | - | 自定义选择框样式 |
| key |  | - |  |

```
```
 ### TDMultiLinkedPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | String? | - | 选择器标题 |
| onConfirm | MultiPickerCallback? | - | 选择器确认按钮回调 |
| onCancel | MultiPickerCallback? | - | 选择器取消按钮回调 |
| selectedData | List | - | 选中数据 |
| data | Map | - | 总的数据 |
| columnNum | int | - | 总列数 |
| pickerHeight | double | 200 |  |
| pickerItemCount | int | 5 | 选择器List视窗中item个数，pickerHeight / pickerItemCount即item高度 |
| customSelectWidget | Widget? | - | 自定义选择框样式 |
| leftTextStyle | TextStyle? | - | 自定义左侧文案样式 |
| rightTextStyle | TextStyle? | - | 自定义右侧文案样式 |
| centerTextStyle | TextStyle? | - | 自定义中间文案样式 |
| titleHeight | double? | - | 标题高度 |
| topPadding | double? | - | 顶部填充 |
| leftPadding | double? | - | 左边填充 |
| rightPadding | double? | - | 右边填充 |
| titleDividerColor | Color? | - | 标题分割线颜色 |
| backgroundColor | Color? | - | 背景颜色 |
| topRadius | double? | - | 顶部圆角 |
| padding | EdgeInsets? | - | 适配padding |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 不同距离自选项计算策略 |
| key |  | - |  |

```
```
 ### MultiLinkedPickerModel
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| data | Map | - | 总的数据 |
| columnNum | int | - | 总列数 |
| initialData |  | - |  |

```
```
 ### TDPicker

#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showDatePicker |  |   required null context,  required String title,  required DatePickerCallback? onConfirm,  DatePickerCallback? onCancel,  bool useYear,  bool useMonth,  bool useDay,  bool useHour,  bool useMinute,  bool useSecond,  bool useWeekDay,  Color? barrierColor,  List<int> dateStart,  List<int>? dateEnd,  List<int>? initialDate,  String? rightText,  String? leftText,  Duration duration,  double pickerHeight,  int pickerItemCount, | 显示时间选择器 |
| showMultiPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required List<List<String>> data,  List<int>? initialIndexes,  Duration duration,  Color? barrierColor,  double pickerHeight,  int pickerItemCount, | 显示多级选择器 |
| showMultiLinkedPicker |  |   required null context,  String? title,  required MultiPickerCallback? onConfirm,  MultiPickerCallback? onCancel,  required Map data,  required int columnNum,  required List initialData,  Duration duration,  Color? barrierColor,  double pickerHeight,  int pickerItemCount, | 显示多级联动选择器 |


  