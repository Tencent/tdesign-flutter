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
| items | dynamic | - | 数据源（必填）：`List<List<TPickerOption>>` 多列独立 / `Map` 联动选择 |
| initialValue | List? | - | 初始选中值列表（按 value 匹配） |
| onChange | void Function(TPickerValue)? | - | 值改变回调，返回 `TPickerValue`（含 selectedOptions、indexes、values/labels 便捷属性） |
| onLoad | void Function(TPickerLoadEvent)? | - | 接近底部时加载回调（用于无限滚动） |
| preloadThreshold | int | 5 | 预加载阈值（距底部剩余 N 项时触发） |
| height | double | 200 | 视窗高度 |
| itemCount | int | 5 | 每屏显示 item 数量 |
| disabled | bool | false | 是否禁用整个选择器 |

### TPickerOption
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| label | String (required) | - | 显示文字（可包含 emoji、单位等） |
| value | dynamic (required) | - | 实际值（onChange 回调返回此字段） |
| disabled | bool | false | 是否禁用（不可选中） |

#### 使用示例

```dart
TPickerOption(label: '👨 男性', value: 'M')
TPickerOption(label: '18岁', value: 18)
TPickerOption(label: '广东省', value: 'GD', disabled: true)
```

### TPickerValue
#### onChange 回调返回对象

| 属性 | 类型 | 说明 |
| --- | --- | --- |
| selectedOptions | List\<TPickerOption\> | 每列选中的完整 option（顺序对应列号） |
| indexes | List\<int\> | 每列在当前数据列表中的索引 |
| values (getter) | List\<dynamic\> | 所有 value 的便捷列表 |
| labels (getter) | List\<String\> | 所有 label 的便捷列表 |

#### 使用示例

```dart
TPicker(
  items: data,
  onChange: (v) {
    // 显示文本：v.labels.join(' / ')
    // 业务值：v.values
    // 完整选项：v.selectedOptions
  },
)
```

### TPickerLoadEvent
#### onLoad 回调参数

| 属性 | 类型 | 说明 |
| --- | --- | --- |
| column | int | 当前列索引（从 0 开始） |
| parentValue | dynamic | 该列父级选中值（第一列为 null） |
| displayedCount | int | 该列当前已显示的数据量 |
| remaining | int | 距离底部还有多少项 |
