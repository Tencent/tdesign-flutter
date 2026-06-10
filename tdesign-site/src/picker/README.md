---
title: Picker 选择器
description: 纯滚轮选择器组件，支持多列独立和联动两种模式
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

### 1 基础用法

单列选择
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildSingleColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('选中城市: ${selectedCity.isEmpty ? "未选择" : selectedCity}',
            style: TextStyle(
                fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
              items: cityItems,
              onChange: (_, v) => setState(() => selectedCity = v.labels.first)),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

时间选择(时分秒)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildTimeSelect(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('选中时间: ${selectedTime.isEmpty ? "未选择" : selectedTime}',
            style: TextStyle(
                fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
              items: timeItems,
              itemCount: 5,
              onChange: (_, v) => setState(() => selectedTime =
                  '${v.values[0]}:${v.values[1].toString().padLeft(2, '0')}:${v.values[2].toString().padLeft(2, '0')}')),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

月日选择(联动)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildMonthDaySelect(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TPickerLinked：切换月份后日列自动变为 28 / 30 / 31 天（demo 平年，2 月固定 28 天）',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 4),
        Text(
          '选中: ${selectedMonthDay.isEmpty ? "未选择" : selectedMonthDay}',
          style: TextStyle(
              fontSize: 14, color: TTheme.of(context).textColorSecondary),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: _monthDayItems,
            initialValue: const [1, 1],
            onChange: (_, v) =>
                setState(() => selectedMonthDay = v.labels.join(' / ')),
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

五级联动选择
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildLinkedFiveLevel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '五级联动：${_kFiveLevelNames.join(' → ')}（切换第 1 级后，第 2–5 级数据全部刷新）',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 4),
        Text(
          '适用 TPickerLinked 静态树：整树在内存、每级项数可控；label 用 1 / 1.1 / 1.1.1 便于窄列展示',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 4),
        Text(
          '选中: ${selectedFiveLevel.isEmpty ? "未选择" : selectedFiveLevel}',
          style: TextStyle(
              fontSize: 14, color: TTheme.of(context).textColorSecondary),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: _fiveLevelItems,
            initialValue: const [
              '1',
              '1.1',
              '1.1.1',
              '1.1.1.1',
              '1.1.1.1.1',
            ],
            onChange: (_, v) =>
                setState(() => selectedFiveLevel = v.labels.join(' / ')),
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 按需请求

滚近底部自动分页（主列 + 联动子列）
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildLazyLoad(BuildContext context) {
    const initialPrimaryValue = 'cat_1';
    final initialLinked = [
      for (int i = 1; i <= _kLazyDemoPageSize; i++)
        TPickerOption(
          label: '分类1 · 条目 $i',
          value: '${initialPrimaryValue}_item_$i',
        ),
    ];

    return LinkedLazyPickerScope(
      threshold: 8,
      primaryLabel: '分类',
      linkedLabel: '条目',
      initialPrimary: _mockLazyCategories(1, _kLazyDemoPageSize),
      initialPrimaryValue: initialPrimaryValue,
      initialLinked: initialLinked,
      onLoadPrimary: _mockLazyPrimaryPage,
      onLoadLinked: _mockLazyLinkedPage,
      builder: (ctx, vm) {
        final loadingHint = vm.loadingHint;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '在 onColumnScrollEnd 里判断接近列底后 append items；onChange 仅维护 draft',
              style: TextStyle(
                  fontSize: 12,
                  color: TTheme.of(context).textColorPlaceholder),
            ),
            const SizedBox(height: 4),
            Text(
              vm.statusLine,
              style: TextStyle(
                  fontSize: 14, color: TTheme.of(context).textColorSecondary),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                _pickerCard(context, child: vm.buildPicker()),
                if (loadingHint != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 8,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: TTheme.of(context)
                              .fontGyColor1
                              .withOpacity(0.72),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '加载$loadingHint…',
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '滚近底部每次追加 10 条（无总量上限）；切换分类时子列读缓存或按需拉取',
              style: TextStyle(
                  fontSize: 12,
                  color: TTheme.of(context).textColorPlaceholder),
            ),
          ],
        );
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 禁用状态

项级 disabled（部分选项不可选）
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildItemDisabled(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            '选中: ${selectedItemDisabled.isEmpty ? "未选择" : selectedItemDisabled}',
            style: TextStyle(
                fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        const SizedBox(height: 4),
        Text('提示: 标灰的选项不可选（第1列「保密」、第2列「A排1座/A排6座/A排7座/A排8座/A排12座」）',
            style: TextStyle(
                fontSize: 12, color: TTheme.of(context).textColorPlaceholder)),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
              items: itemDisabledItems,
              initialValue: const ['M', 'A5'],
              onChange: (_, v) => setState(() =>
                  selectedItemDisabled = '${v.labels.first} ${v.labels.last}')),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

全局 disabled（整组不可操作）
            
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
            const SizedBox(width: 8),
            Text(globalDisabled ? '已禁用' : '已启用',
                style: TextStyle(
                    fontSize: 14,
                    color: globalDisabled
                        ? TTheme.of(context).errorNormalColor
                        : TTheme.of(context).successNormalColor)),
          ],
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
              items: cityItems,
              initialValue: const ['GZ'],
              onChange: (_, v) => debugPrint('选中: $v'),
              disabled: globalDisabled),
        ),
        const SizedBox(height: 4),
        Text('切换开关可控制整个选择器的禁用/启用状态',
            style: TextStyle(
                fontSize: 12, color: TTheme.of(context).textColorPlaceholder)),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 弹窗模式(TPopup)

弹窗-联动选择(省市区)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildPopupLinked(BuildContext context) {
    final label = _popupLinkedValue?.labels.join(' / ') ?? '';
    return TCell(
      title: '弹窗-联动选择(省市区)',
      note: label.isEmpty ? '请选择' : label,
      arrow: true,
      onClick: (_) {
        TPickerValue? draft;
        final initial =
            _popupLinkedValue?.values ?? List<dynamic>.from(_popupLinkedInitial);
        _showPickerPopup(
          context,
          title: '请选择地区',
          onConfirm: () {
            setState(() {
              _popupLinkedValue = draft ??
                  _popupLinkedValue ??
                  _linkedValueFromPath(linkedItems.tree, initial);
            });
          },
          picker: TPicker(
            items: linkedItems,
            initialValue: initial,
            onChange: (_, value) => draft = value,
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 自定义字段映射(keys)

数据字段非 label/value 时，用 keys 映射
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildCustomKeys(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '后端原始字段：city / code / readonly。通过 keys(label: "city") 映射为 label',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 4),
        Text(
          '当前选中：${_customKeysSelectionText()}',
          style: TextStyle(
              fontSize: 14, color: TTheme.of(context).textColorSecondary),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: _customKeysItems,
            initialValue: _kCustomKeysInitial,
            onChange: (_, v) => setState(() => _customKeysValue = v),
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 尺寸与样式

自定义高度和每屏显示数量
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildCustomSize(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '示例：height(350) + itemCount(7)，每屏显示 7 项',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: cityItems,
            height: 350,
            itemCount: 7,
            onChange: (_, v) => debugPrint('选中: ${v.labels.first}'),
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

自定义子项渲染（itemBuilder）
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildCustomItemBuilder(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '示例：itemBuilder 自定义子项渲染，可添加图标、背景色等',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 4),
        Text(
          '选中: ${_customItemBuilderValue.isEmpty ? "未选择" : _customItemBuilderValue}',
          style: TextStyle(
              fontSize: 14, color: TTheme.of(context).textColorSecondary),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: cityItems,
            itemBuilder: (ctx, content, colIndex, index, calculator, distance) {
              final theme = TTheme.of(ctx);
              final selected = distance == 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? theme.brandLightColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(TIcons.location, size: 20, color: theme.fontGyColor3),
                    const SizedBox(width: 8),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.normal,
                        color: selected
                            ? theme.brandNormalColor
                            : theme.fontGyColor1,
                      ),
                    ),
                  ],
                ),
              );
            },
            onChange: (_, v) =>
                setState(() => _customItemBuilderValue = v.labels.first),
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  


## API
### TPicker
#### 简介
纯滚轮选择器。数据用 `TPickerColumns`（多列独立）或 `TPickerLinked`（联动）。
选中变化通过 `onChange`；列底分页建议用 `onColumnScrollEnd`。弹窗确认请配合 `TPopup`。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用整个选择器（禁止滚动与无障碍操作），默认 false |
| height | double | 200 | 滚轮视窗高度（像素），默认 200 |
| initialValue | List<dynamic>? | - | 初始选中（按各列 `value` 匹配），仅首次构建生效；运行期请用 `onChange` 维护选中态。 |
| itemBuilder | ItemBuilderType? | - | 自定义子项构建器 `(context, content, colIndex, index, itemDistanceCalculator, distance) => Widget?`；`distance` 为 0 表示选中项，返回 null 用默认样式，disabled 项不走此 builder。 |
| itemCount | int | 5 | 每屏显示项数（奇数更利于中央高亮），默认 5 |
| items | TPickerItems | - | 数据源（必填）。独立选 `TPickerColumns`，内存联动树选 `TPickerLinked`；接口/字面量用对应 `fromRaw`。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChange | void Function(int col, TPickerValue value)? | - | 值改变回调（滚动实时触发，非确认）。`col` 为触发列；`value` 为各列选中快照。 |
| onColumnScrollEnd | void Function(int col, TPickerValue value)? | - | 列滚动结束回调（滚停时触发，适合列底分页）。`col` 为滚停列；`value` 为当前选中快照。 |


### TPickerOption
#### 简介
选择器选项。`label` 用于展示，`value` 用于 onChange 回传。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用该项（置灰且不可选中），默认 false |
| label | String | - | 展示文字（可含 emoji、单位等） |
| value | dynamic | - | 业务值（`TPickerValue.values` 按列回传） |


### TPickerValue
#### 简介
onChange 回传的各列选中快照
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| indexes | List<int> | - | 每列选中项索引 |
| selectedOptions | List<TPickerOption> | - | 每列选中的完整 `TPickerOption` |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| labels | List<String> | - | 各列选中项的 label（展示用，懒计算） |
| values | List<dynamic> | - | 各列选中项的 value（提交表单用，懒计算） |


### TPickerColumns
#### 简介
多列独立数据源，各列互不影响。松散数据（String/Map 等）用 `fromRaw`；已全是 `TPickerOption` 时用 `TPickerColumns([...])`。

#### 工厂构造方法

##### TPickerColumns.fromRaw

松散数据入口：将多列原始数据归一化为 `TPickerOption`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rawColumns | List | - | 外层为列，内层元素可为 String / Map / `TPickerOption`。 |
| keys | TPickerKeys | TPickerKeys.defaults | 接口字段名映射，默认 `TPickerKeys.defaults`。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| columns | List<List<TPickerOption>> | - | 每列候选项（外层列、内层选项） |


### TPickerLinked
#### 简介
联动树数据源，改上游会刷新下游列。整树在内存时用（如省市区）；远程分页请改用 `TPickerColumns`。

#### 工厂构造方法

##### TPickerLinked.fromRaw

松散数据入口：将嵌套 Map/List 联动树归一化为 `TPickerOption`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rawTree | Map | - | Map 为上级，子 Map 继续下钻，List 为叶子列；元素可为 String / Map / List / `TPickerOption`。 |
| keys | TPickerKeys | TPickerKeys.defaults | 接口字段名映射，默认 `TPickerKeys.defaults`。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| tree | Map<TPickerOption, dynamic> | - | 联动树；key 为候选项，value 为子级 Map 或叶子 List |


### TPickerKeys
#### 简介
`fromRaw` 字段名映射；接口字段非默认 label/value/disabled/children 时使用。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | String | 'children' | 联动子级字段名，默认 `children` |
| disabled | String | 'disabled' | 禁用标记字段名，默认 `disabled` |
| label | String | 'label' | 展示文案字段名，默认 `label` |
| value | String | 'value' | 业务值字段名，默认 `value` |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaults | TPickerKeys | - | 默认配置 |


  