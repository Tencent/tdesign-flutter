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
              onChange: (v) => setState(() => selectedCity = v.labels.first)),
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
              onChange: (v) => setState(() => selectedTime =
                  '${v.values[0]}:${v.values[1].toString().padLeft(2, '0')}:${v.values[2].toString().padLeft(2, '0')}')),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

联动选择(省市区)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildLinked(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('选中地区: ${selectedLinked.isEmpty ? "未选择" : selectedLinked}',
            style: TextStyle(
                fontSize: 14, color: TTheme.of(context).textColorSecondary)),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
              items: linkedItems,
              initialValue: const ['GD', 'SZ', 'NS'],
              onChange: (v) =>
                  setState(() => selectedLinked = v.labels.join(' / '))),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 按需请求

模拟网络请求加载更多
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildLazyLoad(BuildContext context) {
    return StatefulBuilder(
      builder: (ctx, setInner) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _lazyData.isEmpty
                  ? '暂无数据'
                  : '已加载 ${_lazyData.length} 条（滚动到底部自动加载更多）',
              style: TextStyle(
                  fontSize: 14, color: TTheme.of(context).textColorSecondary),
            ),
            const SizedBox(height: 8),
            _pickerCard(
              context,
              child: TPicker(
                items: TPickerColumns([_lazyData]),
                onLoad: (e) async {
                  // 业务层自行判断触发时机：距底部 5 项以内 + 未在加载中
                  if (e.remaining > 5 || _isLoading) {
                    return;
                  }
                  setInner(() => _isLoading = true);
                  // 模拟网络请求延迟 1.5s
                  await Future.delayed(const Duration(milliseconds: 1500));
                  final start = _lazyData.length + 1;
                  final more = [
                    for (int i = start; i < start + 20; i++)
                      TPickerOption(label: '选项 $i', value: 'opt_$i'),
                  ];
                  setInner(() {
                    _lazyData.addAll(more);
                    _isLoading = false;
                  });
                },
                onChange: (v) => debugPrint('选中: ${v.labels.first}'),
              ),
            ),
            const SizedBox(height: 4),
            if (_isLoading)
              Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 6),
                  Text('正在加载更多数据...',
                      style: TextStyle(
                          fontSize: 12,
                          color: TTheme.of(context).textColorPlaceholder)),
                ],
              )
            else
              Text('在 onLoad 里判断 e.remaining <= 5 时加载，模拟 1.5s 网络延迟',
                  style: TextStyle(
                      fontSize: 12,
                      color: TTheme.of(context).textColorPlaceholder)),
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
              onChange: (v) => setState(() =>
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
              onChange: (v) => debugPrint('选中: $v'),
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
        _showPickerPopup(
          context,
          picker: TPicker(
            items: linkedItems,
            initialValue: _popupLinkedValue?.values ?? _popupLinkedInitial,
            title: '请选择地区',
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (value) {
              setState(() => _popupLinkedValue = value);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  

弹窗-多列选择(性别/偏好)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildPopupMultiColumn(BuildContext context) {
    final label = _popupMultiColValue?.labels.join(' ') ?? '';
    return TCell(
      title: '弹窗-多列选择(性别/偏好)',
      note: label.isEmpty ? '请选择' : label,
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TPicker(
            items: TPickerColumns(preferenceData),
            initialValue: _popupMultiColValue?.values ?? _popupMultiColInitial,
            title: '选择性别和偏好',
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (value) {
              setState(() => _popupMultiColValue = value);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 自定义按钮/标题插槽

自定义按钮（图标 / 文字）
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildCustomSlot(BuildContext context) {
    final theme = TTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'cancel / confirm / titleWidget 参数类型均为 Widget，可自定义图标、文字或组合',
          style: TextStyle(fontSize: 12, color: theme.textColorPlaceholder),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: linkedItems,
            initialValue: const ['GD', 'SZ', 'NS'],
            titleWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(TIcons.location, size: 18, color: theme.brandNormalColor),
                const SizedBox(width: 4),
                Text('选择地区',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.fontGyColor1,
                    )),
              ],
            ),
            cancel: Icon(TIcons.close, size: 22, color: theme.fontGyColor2),
            confirm:
                Icon(TIcons.check, size: 22, color: theme.brandNormalColor),
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 自定义字段映射(keys)

数据字段非 label/value 时，用 keys 映射
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget buildCustomKeys(BuildContext context) {
    // 用 keys 告诉组件「city 映射为 label，code 是 value，readonly 是 disabled」
    const keys =
        TPickerKeys(label: 'city', value: 'code', disabled: 'readonly');
    final label = _customKeysValue?.labels.join() ?? '';
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
          '当前选中：${label.isEmpty ? "未选择" : label}',
          style: TextStyle(
              fontSize: 14, color: TTheme.of(context).textColorSecondary),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: TPickerColumns.fromRaw(_rawCityData, keys: keys),
            initialValue: _customKeysValue?.values ?? _customKeysInitial,
            onChange: (v) => setState(() => _customKeysValue = v),
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
          '示例：height(300) + itemCount(7)，每屏显示 7 项',
          style: TextStyle(
              fontSize: 12, color: TTheme.of(context).textColorPlaceholder),
        ),
        const SizedBox(height: 8),
        _pickerCard(
          context,
          child: TPicker(
            items: cityItems,
            height: 300,
            itemCount: 7,
            onChange: (v) => debugPrint('选中: ${v.labels.first}'),
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
            onChange: (v) =>
                setState(() => _customItemBuilderValue = v.labels.first),
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  


## API
### TPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cancel | Widget? | - | 工具栏左侧自定义插槽，默认使用 [TResourceDelegate.cancel] 可用于渲染图标、图标+文字组合等。点击事件依然由外层 [GestureDetector] 处理，触发 [onCancel] 回调——所以插槽内的 Widget 不需要自己处理点击。 ```dart // 简单改文字 TPicker( cancel: const Text('关闭'), onCancel: () => Navigator.of(context).pop(), ) // 带图标 TPicker( cancel: const Icon(Icons.close, size: 22), onCancel: () => Navigator.of(context).pop(), ) ``` |
| confirm | Widget? | - | 工具栏右侧自定义插槽，默认使用 [TResourceDelegate.confirm] 可用于渲染图标、图标+文字组合等。点击事件依然由外层 [GestureDetector] 处理，触发 [onConfirm] 回调——所以插槽内的 Widget 不需要自己处理点击。 ```dart // 简单改文字 TPicker( confirm: const Text('确定'), onConfirm: (v) => Navigator.of(context).pop(v), ) // 带图标 TPicker( confirm: const Icon(Icons.check, size: 22), onConfirm: (v) => Navigator.of(context).pop(v), ) ``` |
| disabled | bool | false | 是否禁用整个选择器（禁止滚动和操作），默认 false |
| height | double | 200 | 视窗高度，默认 200 |
| initialValue | List<dynamic>? | - | 初始选中值列表（按 value 匹配） |
| itemBuilder | ItemBuilderType? | - | 自定义子项构建器（disabled 项仍由内部统一渲染，不会走此 builder） |
| itemCount | int | 5 | 每屏显示 item 数，默认 5 |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 自定义距离计算器（控制颜色/字重/字号随"离中心距离"的变化） |
| items | TPickerItems | - | 数据源（必填） 使用密封类 [TPickerItems] 编译期强制二选一： - [TPickerColumns] → 多列独立选择 - [TPickerLinked] → 联动选择 自由结构数据通过 `.fromRaw()` 工厂构造归一化。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onCancel | VoidCallback? | - | 点击「取消」按钮回调 仅作为点击事件通知，不携带任何参数。组件本身不会做任何 popup 操作，业务层可在此自行决定是否关闭弹窗、重置状态等。 |
| onChange | void Function(TPickerValue)? | - | 值改变回调（滚动时实时触发） 触发时机： - 用户滚动经过某个 enabled 项并稳定时 - disabled 修正动画完成后，回调最终落点 **注意**：此回调代表"滚动时实时变化"，不代表"用户已确认选择"。 如需"已确认"语义，请使用 [onConfirm]。 如需做网络请求/埋点等去抖处理，请在业务层自行 debounce。 |
| onConfirm | void Function(TPickerValue)? | - | 点击「确认」按钮回调 携带当前选中的完整 [TPickerValue]，包含： - `selectedOptions`: 当前选中的所有 [TPickerOption] - `values`: 各列选中项的 value 列表 - `labels`: 各列选中项的 label 列表 - `indexes`: 各列选中项的索引 与 [onChange] 不同——只有用户点击「确认」时才触发，代表"已确认选择"。 组件本身不会做任何 popup 操作，业务层可在此自行决定是否关闭弹窗、 提交表单等。 |
| onLoad | void Function(TPickerLoadEvent)? | - | 列选中项变化的事件回调 **触发时机**：每次用户滚动到一个 enabled 项后都会触发（联动模式下还会 在新展开的列就位后触发）。组件本身不做"距底部多少项"的阈值判断——把 决策权交给业务层。 **事件参数**包含： - [TPickerLoadEvent.column]：触发列索引 - [TPickerLoadEvent.remaining]：当前列距底部剩余项数 - [TPickerLoadEvent.displayedCount]：当前列总项数 - [TPickerLoadEvent.parentValue]：联动模式下父级选中值（首列为 null） **典型用法**：业务层根据 [TPickerLoadEvent.remaining] 自行判断是否加载更多。 ```dart onLoad: (e) async { if (e.remaining > 5 \|\| _isLoading) return; // 距底部还远 / 已在加载，跳过 _isLoading = true; final more = await fetchMore(parent: e.parentValue); setState(() { _data.addAll(more); _isLoading = false; }); } ``` |
| title | String? | - | 工具栏中部标题（可选，不传时中部留白） 顶部工具栏永远显示，包含「取消」「标题」「确认」三块。 用户点击「取消」触发 [onCancel]，点击「确认」触发 [onConfirm]。 选择器与弹窗（popup）完全解耦——关闭/打开弹窗的逻辑由业务层在 这两个回调中自行控制。 典型用法（与 popup 弹窗组合）： ```dart TPicker( items: items, title: '请选择地区', onCancel: () => setState(() => visible = false), onConfirm: (value) { setState(() { selected = value; visible = false; }); }, ) ``` |
| titleWidget | Widget? | - | 工具栏中部自定义标题插槽 传入后会**完全替换**默认的 [title] 文字，可用于渲染更复杂的标题（副标题、图标+文字等）。 标题区域不响应点击。 |


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
| indexes | List<int> | - | 每列选中项的索引 |
| selectedOptions | List<TPickerOption> | - | 每列选中的完整 option |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| labels | List<String> | - | 所有选中项的 label（展示用） 顺序与列顺序对应，可直接用于 UI 展示。 懒计算并缓存，生命周期内只计算一次。 |
| values | List<dynamic> | - | 所有选中项的 value（提交表单用） 顺序与列顺序对应，可直接用于表单提交。 懒计算并缓存，生命周期内只计算一次。 |


### TPickerLoadEvent
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| column | int | - | 触发事件的列索引（0 表示第一列） |
| displayedCount | int | - | 当前列已展示的选项总数 |
| parentValue | dynamic | - | 当前列的父级选中值（联动模式下使用） 第一列时为 null；业务层可用此值从原始数据中筛选子级选项。 |
| remaining | int | - | 距底部剩余的选项数（业务可用此值做"接近底部时加载"判断） |


### TPickerColumns
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| columns | List<List<TPickerOption>> | - | 每列的选项列表 |


#### 工厂构造方法

##### TPickerColumns.fromRaw

从自由结构的 raw 数据创建，自动归一化

 ```dart
 TPickerColumns.fromRaw(
   [['北京', '上海', '广州']],
   keys: const TPickerKeys(label: 'name', value: 'code'),
 )
 ```

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rawColumns | List | - | - |
| keys | TPickerKeys | TPickerKeys.defaults | - |


### TPickerLinked
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| tree | Map<TPickerOption, dynamic> | - | 联动树结构：`Map<TPickerOption, dynamic>` value 可以是： - `Map<TPickerOption, dynamic>` → 下一级联动 - `List<TPickerOption>` → 叶子级选项 |


#### 工厂构造方法

##### TPickerLinked.fromRaw

从自由结构的 raw Map 数据创建，自动归一化

 ```dart
 TPickerLinked.fromRaw({
   '广东': {'深圳': ['南山', '福田'], '广州': ['天河']},
   '浙江': {'杭州': ['西湖']},
 })
 ```

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rawTree | Map | - | - |
| keys | TPickerKeys | TPickerKeys.defaults | - |


### TPickerItems
#### 简介
选择器数据源密封类

 编译期强制二选一，消除运行时类型错误：
 - [TPickerColumns] → 多列独立选择
 - [TPickerLinked] → 联动选择

### TPickerKeys
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | String | 'children' | 联动模式下子级数据对应的字段名，默认 `children` |
| disabled | String | 'disabled' | 禁用标记对应的字段名，默认 `disabled` |
| label | String | 'label' | 展示文案对应的字段名，默认 `label` |
| value | String | 'value' | 业务值对应的字段名，默认 `value` |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaults | TPickerKeys | - | 默认配置（`label / value / disabled / children`） |


  