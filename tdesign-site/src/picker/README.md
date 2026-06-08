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
纯滚轮选择器组件。
与 ``TCalendar``、``TDateTimePicker`` 为三个独立对外组件；``TDateTimePicker``
经内部滚轮复用本组件能力，``TCalendar`` 与本组件无代码耦合。
不包含工具栏、确认按钮或内置 loading；弹窗场景请配合 `TPopup` 在用户确认后再提交。
数据形态（编译期二选一）：
- `TPickerColumns`：多列独立，各列选项互不影响
- `TPickerLinked`：联动树，上游变更后下游列裁剪并按新分支展开，默认选中各列首项
`items` 相对上一帧值不相等时会释放全部 ScrollController 并重新初始化；
内容相等的新实例不会触发重建。
### 多列独立模式（`TPickerColumns`）数据更新契约
| 场景 | 推荐做法 | 避免 |
|------|----------|------|
| 列尾分页 append | 原地 `addAll` 或 immutable 追加；组件会走列增长路径 | 每帧回写 `initialValue` |
| 联动换子列 | 仅替换后续某一列；旧 controller 位置会被 clamp 到新列范围 | 双列全量替换导致主列 controller 重建 |
| 实时选中 | 由 `onChange` / 业务 draft 维护 | 用 `initialValue` 当滚动中的选中源 |
多列独立模式下若仅为列尾追加，会原地刷新 `WheelColumn` 并保留当前滚动位置；
若首列不变且仅后续某一列整列替换，则只刷新该列并保留首列 ScrollController。
`onChange` 在选中项变化时触发（惯性滚动中会多次回调），适合维护 draft；
`col` 为本次触发的列索引（0-based，从左到右），可用于按列响应；
按需分页加载更推荐配合 `onColumnScrollEnd` 在滚动结束时判定是否接近列底。
详细选型与能力边界见站点文档「Picker - 能力边界」。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用整个选择器（禁止滚动和操作），默认 false - **禁用态**：同时屏蔽无障碍手势与列级语义聚焦（`Semantics.enabled = false`） - **视觉**：组件整体叠加 `_kDisabledOpacity` 透明层 |
| height | double | 200 | 滚轮视窗高度（像素），默认 200 |
| initialValue | List<dynamic>? | - | 初始选中值列表（按 `value` 匹配各列），仅在首次构建时生效。 - **语义**：initState-only —— 仅首次构建生效，后续传入被忽略 - **机制**：`FixedExtentScrollController` 拥有滚动位置所有权，频繁回灌会触发 `dispose+reinit`，破坏惯性滚动 - **典型症状**：滚轮"每次只能滚 1 项" - **正确做法**：选中态用 `onChange` 维护 draft；"重置"时用 `Key` 强制重建；数据源变更时改 `items` |
| itemBuilder | ItemBuilderType? | - | 自定义子项构建器 - **不接管**：disabled 项仍由内部统一渲染，不会走此 builder - **典型用法**：emoji、单位、富文本、动态颜色等场景 - **距离样式**：通过回调的 `itemDistanceCalculator` 参数复用 4 档默认颜色/字号 |
| itemCount | int | 5 | 每屏显示 item 数（奇数更利于中央高亮），默认 5 |
| items | TPickerItems | - | 数据源（必填） - **类型**：密封类 `TPickerItems`，编译期强制二选一 - **多列独立**：`TPickerColumns` —— 各列候选项互不影响 - **联动选择**：`TPickerLinked` —— 上游列变更后下游列自动裁剪并按新分支展开 - **自由结构**：通过 `.fromRaw()` 工厂构造并自动归一化 - **重建语义**：实例值与上一帧不等时整组重初始化；内容相等的新实例不重建 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChange | void Function(int col, TPickerValue value)? | - | 值改变回调（滚动时实时触发，不代表用户已确认选择） - **触发时机**：用户滚动经过 enabled 项时 / disabled 修正动画完成后 - **频率**：多列独立模式下惯性滚动可能连续触发多次（每经过一项一次）； 联动模式同帧内合并为一次，且相同 `TPickerValue` 快照不会重复通知 - **`col`**：本次触发的列索引（0-based）；联动模式下仅指用户手滚列 - **`value`**：当前各列选中快照 - **与 `onColumnScrollEnd` 关系**：两者独立、互不阻塞；同一次滚动可能先多次 `onChange` 再触发一次 `onColumnScrollEnd`（滚停时） - **典型用法**：维护 draft 状态 / 联动缓存 - **分页加载**：更推荐 `onColumnScrollEnd` 在滚停后判定列底 |
| onColumnScrollEnd | void Function(int col, TPickerValue value)? | - | 指定列滚动结束回调（惯性停止或手指抬起后） - **触发时机**：该列 `ScrollEndNotification` 到达时，每列独立 - **`col`**：滚停的那一列索引 - **`value`**：滚停时刻的各列选中快照（与最后一次 `onChange` 通常一致） - **与 `onChange` 关系**：两者独立；本回调仅在滚停时触发一次，适合分页加载 - **典型用法**：判断 `value.indexes[col]` 是否接近列底并触发分页 |


### TPickerOption
#### 简介
选择器选项
label 用于显示，value 用于 onChange 返回，两者分离以便自定义展示
（emoji、单位、国际化）同时保持纯净的业务值。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用（不可选中 / 置灰显示），默认 false - **禁用态**：滚动经过时不立刻修正，等滚动结束由 `TPicker.onColumnScrollEnd` 收口 - **视觉**：透明度降为 0.5，文字色降为 `textDisabledColor` |
| label | String | - | 展示文字（可包含 emoji、单位、国际化等） - **用途**：用户可见的选项文案 - **建议**：emoji / 单位放在 label 保持纯净的业务值 |
| value | dynamic | - | 业务值（onChange 回调返回此字段） - **类型**：`dynamic` 以兼容 `String` / `int` / 枚举 / 自定义 model - **回传**：`TPickerValue.values` 中按列顺序返回该字段 |


### TPickerValue
#### 简介
onChange 回调返回的选中信息
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| indexes | List<int> | - | 每列选中项的索引 - **类型**：`List<int>`，顺序与列顺序对应 - **典型用法**：`value.indexes[col]` 配合 `TPicker.onColumnScrollEnd` 判定是否接近列底触发分页 |
| selectedOptions | List<TPickerOption> | - | 每列选中的完整 option - **类型**：`List<TPickerOption>`，顺序与列顺序对应 - **用途**：拿到原始 option 以便读取 `disabled`、自定义展示等扩展字段 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| labels | List<String> | - | 所有选中项的 label（展示用） - **类型**：`List<String>`，顺序与列顺序对应 - **懒计算**：同 `values` - **典型用法**：`labels.join(' / ')` 直接渲染为 "广东 / 深圳 / 南山" |
| values | List<dynamic> | - | 所有选中项的 value（提交表单用） - **类型**：`List<dynamic>`，顺序与列顺序对应 - **懒计算**：`late final` 首次访问时构造 `UnmodifiableListView` 并缓存 - **不可变**：禁止外部赋值（违反 `late final` 契约会抛 `LateInitializationError`），如需新值请构造新 `TPickerValue` |


### TPickerColumns
#### 简介
多列独立选择的数据源

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
| rawColumns | List | - | 原始多列数据；每列元素可为 `String` / `Map` / `TPickerOption`。 |
| keys | TPickerKeys | TPickerKeys.defaults | 字段映射配置，默认 `TPickerKeys.defaults`。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| columns | List<List<TPickerOption>> | - | 每列的选项列表 - **类型**：`List<List<TPickerOption>>`（外层为列，内层为该列候选项） - **空列**：保留列数与位置；组件内会做范围保护，越界访问回落首项 - **不可变**：内容比较用 `==` 判等，原地 `addAll` 与 immutable 追加都会触发"列增长"路径 |


### TPickerLinked
#### 简介
联动选择的数据源
适用于整棵联动树已在内存的场景（如省市区、月日联动、多级地址）；
每列候选项建议在百级以内。上游列变更后，`TPicker` 会裁剪下游列并按新分支
重新展开，默认选中各列首项。
若需接口分页或远程逐级拉取，请改用 `TPickerColumns` 并在业务层封装 Scope
（见 example `LinkedLazyPickerScope`）。

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
| rawTree | Map | - | 原始联动树；key / value 可为 `String` / `Map` / `List` / `TPickerOption`。 |
| keys | TPickerKeys | TPickerKeys.defaults | 字段映射配置，默认 `TPickerKeys.defaults`。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| tree | Map<TPickerOption, dynamic> | - | 联动树结构：`Map<TPickerOption, dynamic>` - **类型**：`Map<TPickerOption, dynamic>`，key 为该列候选项 - **下一级联动**：value 为 `Map<TPickerOption, dynamic>` 时继续下钻 - **叶子级选项**：value 为 `List<TPickerOption>` 时结束递归 - **顺序敏感**：插入顺序即展示顺序；`==` 判等按 entry 顺序遍历 |


### TPickerItems
#### 简介
选择器数据源密封类
编译期强制二选一，消除运行时类型错误：
- `TPickerColumns` → 多列独立选择（各列候选项互不影响）
- `TPickerLinked` → 联动选择（上游列变更后下游列自动裁剪并按新分支展开）
自由结构数据（`List<List<String>>` / `Map<String, dynamic>` 等）请用
对应子类的 `.fromRaw(...)` 工厂，**避免在 build 阶段直接 `new` 出已
规范化的实例** —— `.fromRaw` 内部会做类型短路，传入已规范化的实例
不产生额外拷贝；手动 `new` 时需要自行保证数据形态合规。

### TPickerKeys
#### 简介
字段映射配置
当 picker 数据源不是 `TPickerOption` 时，用于声明原始结构中的字段名。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | String | 'children' | 联动模式下子级数据对应的字段名，默认 `children` - **生效范围**：`TPickerLinked.fromRaw` 解析 raw `Map` value 时 - **要求**：子级 value 须为 `Map`（继续下钻）或 `List`（叶子级选项） |
| disabled | String | 'disabled' | 禁用标记对应的字段名，默认 `disabled` - **生效范围**：`TPickerColumns.fromRaw` / `TPickerLinked.fromRaw` 解析 raw 元素时 - **判别**：字段值必须为 `bool`；非 `bool` 视为未禁用 |
| label | String | 'label' | 展示文案对应的字段名，默认 `label` - **生效范围**：`TPickerColumns.fromRaw` / `TPickerLinked.fromRaw` 解析 raw 元素时 - **回退**：raw 为非 Map 时使用 `raw.toString()` 作为 label |
| value | String | 'value' | 业务值对应的字段名，默认 `value` - **生效范围**：`TPickerColumns.fromRaw` / `TPickerLinked.fromRaw` 解析 raw 元素时 - **类型**：`dynamic`，保留原始类型（`int` / `String` / enum 等） |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaults | TPickerKeys | - | 默认配置（`label / value / disabled / children`） |


### ItemBuilderType
#### 简介
自定义子项构建器类型
- **`context`**：构建上下文
- **`content`**：文字内容（已由内部组合 label 与单位）
- **`colIndex`**：列号
- **`index`**：行号
- **`itemDistanceCalculator`**：默认距离样式计算器，可在自定义渲染中复用 4 档默认颜色/字号
- **`distance`**：子项此时离中心的距离（0 = 选中项）
- **返回**：`null` 时回退到默认 `TText` 渲染
#### 类型定义

```dart
typedef ItemBuilderType = Widget? Function(BuildContext context, String content, int colIndex, int index, ItemDistanceCalculator itemDistanceCalculator, double distance);
```


  