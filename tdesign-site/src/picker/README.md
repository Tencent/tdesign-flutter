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
            onChange: (v) =>
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
            onChange: (v) =>
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
      onLoadPrimary: (nextStart) async {
        await Future.delayed(_kLazyDemoLoadDelay);
        return _mockLazyCategories(nextStart, _kLazyDemoPageSize);
      },
      onLoadLinked: (primaryValue, nextStart) =>
          _mockLazyItems(primaryValue, nextStart, _kLazyDemoPageSize),
      builder: (ctx, vm) {
        final loadingHint = vm.loadingHint;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '在 onChange 里判断 indexes 接近列底后更新 items，无需 TPicker 内置 onLoad',
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
              '滚近底部自动追加；切换分类时子列读缓存或按需拉取（示例封装见 LinkedLazyPickerScope）',
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
            onChange: (value) => draft = value,
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
    // 用 keys 告诉组件「city 映射为 label，code 是 value，readonly 是 disabled」
    const keys =
        TPickerKeys(label: 'city', value: 'code', disabled: 'readonly');
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
| disabled | bool | false | 是否禁用整个选择器（禁止滚动和操作），默认 false |
| height | double | 200 | 视窗高度，默认 200 |
| initialValue | List<dynamic>? | - | 初始选中值列表（按 value 匹配各列） 与 `items` 一并参与重建判断：相对上一帧值不相等时会重新初始化。 |
| itemBuilder | ItemBuilderType? | - | 自定义子项构建器（disabled 项仍由内部统一渲染，不会走此 builder） |
| itemCount | int | 5 | 每屏显示 item 数，默认 5 |
| items | TPickerItems | - | 数据源（必填） 使用密封类 `TPickerItems` 编译期强制二选一： - `TPickerColumns` → 多列独立选择 - `TPickerLinked` → 联动选择 自由结构数据通过 `.fromRaw()` 工厂构造归一化。 相对上一帧值不相等时会触发组件重新初始化；内容相等的新实例不会重建。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChange | void Function(TPickerValue)? | - | 值改变回调（滚动时实时触发） 触发时机： - 用户滚动经过某个 enabled 项并稳定时 - disabled 修正动画完成后，回调最终落点 注意：此回调代表滚动时实时变化，不代表用户已确认选择。 弹窗场景请配合 `TPopup` 头部确认按钮，在关闭前读取 draft 值提交。 如需做网络请求/埋点等去抖处理，请在业务层自行 debounce。 按需加载更多：在回调里根据 `TPickerValue.indexes` 判断是否接近列底， 请求完成后更新 `items` 即可（无需组件内置加载 API）。 |


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

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| columns | List<List<TPickerOption>> | - | 每列的选项列表 |


### TPickerLinked

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

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| tree | Map<TPickerOption, dynamic> | - | 联动树结构：`Map<TPickerOption, dynamic>` value 可以是： - `Map<TPickerOption, dynamic>` → 下一级联动 - `List<TPickerOption>` → 叶子级选项 |


### TPickerItems

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


  