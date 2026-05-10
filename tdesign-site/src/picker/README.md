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

[td_picker_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_picker_page.dart)

### 1 组件类型

#### 单列选择

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildSingleColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('选中城市: ${selectedCity.isEmpty ? "未选择" : selectedCity}',
            style: TextStyle(fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(items: cityData,
              onChange: (v) => setState(() => selectedCity = v.labels.first)),
        ),
      ],
    );
  }</pre>

</td-code-block>


#### 时间选择（时分秒）

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  // 数据定义：24小时 × 60分钟 × 60秒
  final timeData = [
    [for (int i = 0; i < 24; i++) TPickerOption(label: '${i.toString().padLeft(2, '0')}时', value: i)],
    [for (int i = 0; i < 60; i++) TPickerOption(label: '${i.toString().padLeft(2, '0')}分', value: i)],
    [for (int i = 0; i < 60; i++) TPickerOption(label: '${i.toString().padLeft(2, '0')}秒', value: i)],
  ];

  Widget buildTimeSelect(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('选中时间: ${selectedTime.isEmpty ? "未选择" : selectedTime}',
            style: TextStyle(fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(items: timeData, itemCount: 5,
              onChange: (v) => setState(() =>
                  selectedTime = '${v.values[0]}:${v.values[1].toString().padLeft(2, '0')}:${v.values[2].toString().padLeft(2, '0')}')),
        ),
      ],
    );
  }</pre>

</td-code-block>


#### 联动选择（省市区）

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildLinked(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('选中地区: ${selectedLinked.isEmpty ? "未选择" : selectedLinked}',
            style: TextStyle(fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(items: linkedData, initialValue: ['GD'],
              onChange: (v) => setState(() => selectedLinked = v.labels.join(' / '))),
        ),
      ],
    );
  }</pre>

</td-code-block>


### 2 禁用状态

#### 项级 disabled（部分选项不可选）

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildItemDisabled(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('选中: ${selectedItemDisabled.isEmpty ? "未选择" : selectedItemDisabled}',
            style: TextStyle(fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        SizedBox(height: 4),
        Text('提示: 标灰的选项不可选（如 <16岁、40岁+、50岁+、保密）',
            style: TextStyle(fontSize: 12, color: TTheme.of(context).textColorPlaceholder)),
        SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(items: itemDisabledData, initialValue: ['M', 25],
              onChange: (v) => setState(() =>
                  selectedItemDisabled = '${v.labels.first} ${v.labels.last}')),
        ),
      ],
    );
  }</pre>

</td-code-block>


#### 全局 disabled（整组不可操作）

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildGlobalDisabled(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Switch(
              value: globalDisabled,
              onChanged: (v) => setState(() => globalDisabled = v),
            ),
            SizedBox(width: 8),
            Text(globalDisabled ? '已禁用' : '已启用',
                style: TextStyle(
                    fontSize: 14,
                    color: globalDisabled
                        ? TTheme.of(context).errorNormalColor
                        : TTheme.of(context).successNormalColor)),
          ],
        ),
        SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(items: cityData, initialValue: ['GZ'],
              onChange: (v) => debugPrint('选中: $v'),
              disabled: globalDisabled),
        ),
        SizedBox(height: 4),
        Text('切换开关可控制整个选择器的禁用/启用状态',
            style: TextStyle(fontSize: 12, color: TTheme.of(context).textColorPlaceholder)),
      ],
    );
  }</pre>

</td-code-block>


### 3 弹窗模式（TPopup）

> 弹窗模式下，`onChange` 仅用于记录临时选中值，点击「确认」按钮后才正式更新显示。

#### 弹窗-联动选择(省市区)

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildPopupLinked(BuildContext context) {
    return TCell(
      title: '弹窗-联动选择(省市区)',
      note: selectedLinked.isEmpty ? '请选择' : selectedLinked,
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          title: '请选择地区',
          picker: TPicker(
            items: linkedData,
            initialValue: selectedLinked.isNotEmpty
                ? selectedLinked.split(' / ')
                : ['GD'],
            onChange: (v) => setState(() => _popupLinkedTemp = v.labels.join(' / ')),
          ),
          onConfirm: () => setState(() => selectedLinked = _popupLinkedTemp),
        );
      },
    );
  }</pre>

</td-code-block>


#### 弹窗-多列选择(性别/偏好)

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  // 数据定义
  final preferenceData = [
    [
      TPickerOption(label: '男', value: 'M'),
      TPickerOption(label: '女', value: 'F'),
      TPickerOption(label: '其他', value: 'O'),
    ],
    [
      TPickerOption(label: '科技', value: 'tech'),
      TPickerOption(label: '运动', value: 'sport'),
      TPickerOption(label: '音乐', value: 'music'),
      TPickerOption(label: '阅读', value: 'book'),
      TPickerOption(label: '旅行', value: 'travel'),
      TPickerOption(label: '美食', value: 'food'),
    ],
  ];

  Widget buildPopupMultiColumn(BuildContext context) {
    return TCell(
      title: '弹窗-多列选择(性别/偏好)',
      note: selectedPreference.isEmpty ? '请选择' : selectedPreference,
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          title: '选择性别和偏好',
          picker: TPicker(
            items: preferenceData,
            initialValue: selectedPreference.isNotEmpty
                ? selectedPreference.split(' ')
                : ['M', 'tech'],
            onChange: (v) => setState(() =>
                _popupMultiColTemp = '${v.labels.first} ${v.labels.last}'),
          ),
          onConfirm: () => setState(() => selectedPreference = _popupMultiColTemp),
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
| cancel | Widget | const Text('取消') | 工具栏左侧自定义插槽，默认为 `Text('取消')` |
| confirm | Widget | const Text('确认') | 工具栏右侧自定义插槽，默认为 `Text('确认')` |
| disabled | bool | false | 是否禁用整个选择器（禁止滚动和操作），默认 false |
| height | double | 200 | 视窗高度，默认 200 |
| initialValue | List\<dynamic\>? | - | 初始选中值列表（按 value 匹配） |
| itemBuilder | ItemBuilderType? | - | 自定义子项构建器（disabled 项仍由内部统一渲染，不会走此 builder） |
| itemCount | int | 5 | 每屏显示 item 数，默认 5 |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 自定义距离计算器（控制颜色/字重/字号随"离中心距离"的变化） |
| items | TPickerItems | - | 数据源（必填） |
| onCancel | VoidCallback? | - | 点击「取消」按钮回调 |
| onChange | void Function(TPickerValue)? | - | 值改变回调（滚动时实时触发） |
| onConfirm | void Function(TPickerValue)? | - | 点击「确认」按钮回调 |
| onLoad | void Function(TPickerLoadEvent)? | - | 列选中项变化的事件回调 |
| title | String? | - | 工具栏中部标题（可选，不传时中部留白） |
| titleWidget | Widget? | - | 工具栏中部自定义标题插槽 |

### TPickerOption
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用（不可选中/置灰显示），默认 false |
| label | String | - | 展示文字（可包含 emoji、单位、国际化等） |
| value | dynamic | - | 业务值（onChange 回调返回此字段） |

### TPickerValue
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| indexes | List\<int\> | - | 每列选中项的索引 |
| selectedOptions | List\<TPickerOption\> | - | 每列选中的完整 option |

### TPickerLoadEvent
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| column | int | - | 触发事件的列索引（0 表示第一列） |
| displayedCount | int | - | 当前列已展示的选项总数 |
| parentValue | dynamic | - | 当前列的父级选中值（联动模式下使用） |
| remaining | int | - | 距底部剩余的选项数（业务可用此值做"接近底部时加载"判断） |
