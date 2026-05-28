## API
### TPicker
#### 简介
纯滚轮选择器组件
数据决定形态（编译期类型安全）：
- `TPickerColumns` → 多列独立选择
- `TPickerLinked` → 联动选择
```dart
// 多列独立
TPicker(
  items: TPickerColumns.fromRaw([['北京', '上海', '广州']]),
)
// 联动
TPicker(
  items: TPickerLinked.fromRaw({'广东': {'深圳': ['南山', '福田']}}),
)
```
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cancel | Widget? | - | 工具栏左侧自定义插槽，默认使用 `TResourceDelegate.cancel` 可用于渲染图标、图标+文字组合等。点击事件依然由外层 `GestureDetector` 处理，触发 `onCancel` 回调——所以插槽内的 Widget 不需要自己处理点击。 ```dart // 简单改文字 TPicker( cancel: const Text('关闭'), onCancel: () => Navigator.of(context).pop(), ) // 带图标 TPicker( cancel: const Icon(Icons.close, size: 22), onCancel: () => Navigator.of(context).pop(), ) ``` |
| confirm | Widget? | - | 工具栏右侧自定义插槽，默认使用 `TResourceDelegate.confirm` 可用于渲染图标、图标+文字组合等。点击事件依然由外层 `GestureDetector` 处理，触发 `onConfirm` 回调——所以插槽内的 Widget 不需要自己处理点击。 ```dart // 简单改文字 TPicker( confirm: const Text('确定'), onConfirm: (v) => Navigator.of(context).pop(v), ) // 带图标 TPicker( confirm: const Icon(Icons.check, size: 22), onConfirm: (v) => Navigator.of(context).pop(v), ) ``` |
| disabled | bool | false | 是否禁用整个选择器（禁止滚动和操作），默认 false |
| height | double | 200 | 视窗高度，默认 200 |
| initialValue | List<dynamic>? | - | 初始选中值列表（按 value 匹配） |
| itemBuilder | ItemBuilderType? | - | 自定义子项构建器（disabled 项仍由内部统一渲染，不会走此 builder） |
| itemCount | int | 5 | 每屏显示 item 数，默认 5 |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 自定义距离计算器（控制颜色/字重/字号随"离中心距离"的变化） |
| items | TPickerItems | - | 数据源（必填） 使用密封类 `TPickerItems` 编译期强制二选一： - `TPickerColumns` → 多列独立选择 - `TPickerLinked` → 联动选择 自由结构数据通过 `.fromRaw()` 工厂构造归一化。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onCancel | VoidCallback? | - | 点击「取消」按钮回调 仅作为点击事件通知，不携带任何参数。组件本身不会做任何 popup 操作，业务层可在此自行决定是否关闭弹窗、重置状态等。 |
| onChange | void Function(TPickerValue)? | - | 值改变回调（滚动时实时触发） 触发时机： - 用户滚动经过某个 enabled 项并稳定时 - disabled 修正动画完成后，回调最终落点 **注意**：此回调代表"滚动时实时变化"，不代表"用户已确认选择"。 如需"已确认"语义，请使用 `onConfirm`。 如需做网络请求/埋点等去抖处理，请在业务层自行 debounce。 |
| onConfirm | void Function(TPickerValue)? | - | 点击「确认」按钮回调 携带当前选中的完整 `TPickerValue`，包含： - `selectedOptions`: 当前选中的所有 `TPickerOption` - `values`: 各列选中项的 value 列表 - `labels`: 各列选中项的 label 列表 - `indexes`: 各列选中项的索引 与 `onChange` 不同——只有用户点击「确认」时才触发，代表"已确认选择"。 组件本身不会做任何 popup 操作，业务层可在此自行决定是否关闭弹窗、 提交表单等。 |
| onLoad | void Function(TPickerLoadEvent)? | - | 列选中项变化的事件回调 **触发时机**：每次用户滚动到一个 enabled 项后都会触发（联动模式下还会 在新展开的列就位后触发）。组件本身不做"距底部多少项"的阈值判断——把 决策权交给业务层。 **事件参数**包含： - `TPickerLoadEvent.column`：触发列索引 - `TPickerLoadEvent.remaining`：当前列距底部剩余项数 - `TPickerLoadEvent.displayedCount`：当前列总项数 - `TPickerLoadEvent.parentValue`：联动模式下父级选中值（首列为 null） **典型用法**：业务层根据 `TPickerLoadEvent.remaining` 自行判断是否加载更多。 ```dart onLoad: (e) async { if (e.remaining > 5 \|\| _isLoading) return; // 距底部还远 / 已在加载，跳过 _isLoading = true; final more = await fetchMore(parent: e.parentValue); setState(() { _data.addAll(more); _isLoading = false; }); } ``` |
| title | String? | - | 工具栏中部标题（可选，不传时中部留白） 顶部工具栏永远显示，包含「取消」「标题」「确认」三块。 用户点击「取消」触发 `onCancel`，点击「确认」触发 `onConfirm`。 选择器与弹窗（popup）完全解耦——关闭/打开弹窗的逻辑由业务层在 这两个回调中自行控制。 典型用法（与 popup 弹窗组合）： ```dart TPicker( items: items, title: '请选择地区', onCancel: () => setState(() => visible = false), onConfirm: (value) { setState(() { selected = value; visible = false; }); }, ) ``` |
| titleWidget | Widget? | - | 工具栏中部自定义标题插槽 传入后会**完全替换**默认的 `title` 文字，可用于渲染更复杂的标题（副标题、图标+文字等）。 标题区域不响应点击。 |


### TPickerOption
#### 简介
选择器选项
label 用于显示，value 用于 onChange 返回，两者分离以便自定义展示
（emoji、单位、国际化）同时保持纯净的业务值。
```dart
TPickerOption(label: '👨 男性', value: 'M')
TPickerOption(label: '广东省', value: 'GD', disabled: true)
```
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用（不可选中/置灰显示），默认 false |
| label | String | - | 展示文字（可包含 emoji、单位、国际化等） |
| value | dynamic | - | 业务值（onChange 回调返回此字段） |


### TPickerValue
#### 简介
onChange 回调返回的选中信息
```dart
onChange: (v) => setState(() => _lastValue = v);
Text(_lastValue?.labels.join(' / ') ?? '');
```
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
#### 简介
列选中变化的事件参数
每当用户在某一列滚动到一个 enabled 项后，`TPicker.onLoad` 会收到一个该事件实例。
事件里携带了"列索引、当前列总数、距底部剩余项数、联动模式下父级选中值"等
上下文信息，业务层据此自行决定是否加载更多数据（例如：
`if (e.remaining > 5) return;`）。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| column | int | - | 触发事件的列索引（0 表示第一列） |
| displayedCount | int | - | 当前列已展示的选项总数 |
| parentValue | dynamic | - | 当前列的父级选中值（联动模式下使用） 第一列时为 null；业务层可用此值从原始数据中筛选子级选项。 |
| remaining | int | - | 距底部剩余的选项数（业务可用此值做"接近底部时加载"判断） |


### TPickerColumns
#### 简介
多列独立选择的数据源
```dart
TPicker(
  items: TPickerColumns([
    [TPickerOption(label: '北京', value: 'BJ'), ...],
    [TPickerOption(label: '朝阳区', value: 'CY'), ...],
  ]),
)
```

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
#### 简介
联动选择的数据源
```dart
TPicker(
  items: TPickerLinked({
    TPickerOption(label: '广东', value: 'GD'): {
      TPickerOption(label: '深圳', value: 'SZ'): [
        TPickerOption(label: '南山', value: 'NS'),
      ],
    },
  }),
)
```

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
#### 简介
选择器数据源密封类
编译期强制二选一，消除运行时类型错误：
- `TPickerColumns` → 多列独立选择
- `TPickerLinked` → 联动选择

### TPickerKeys
#### 简介
字段映射配置
当 picker 数据源不是 `TPickerOption` 时，用于声明原始结构中的字段名。
```dart
// 数据：[{ id: '1', name: '选项A', readonly: false }]
const keys = TPickerKeys(label: 'name', value: 'id', disabled: 'readonly');
```
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
