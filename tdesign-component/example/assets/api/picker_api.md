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
| disabled | bool | false | 是否禁用整个选择器（禁止滚动和操作），默认 false - **禁用态**：同时屏蔽无障碍手势（`onIncrease` / `onDecrease` 不再触发） - **视觉**：组件整体叠加 `_kDisabledOpacity` 透明层 |
| height | double | 200 | 滚轮视窗高度（像素），默认 200 |
| initialValue | List<dynamic>? | - | 初始选中值列表（按 `value` 匹配各列），仅在首次构建时生效。 - **语义**：initState-only —— 仅首次构建生效，后续传入被忽略 - **机制**：`FixedExtentScrollController` 拥有滚动位置所有权，频繁回灌会触发 `dispose+reinit`，破坏惯性滚动 - **典型症状**：滚轮"每次只能滚 1 项" - **正确做法**：选中态用 `onChange` 维护 draft；"重置"时用 `Key` 强制重建；数据源变更时改 `items` |
| itemBuilder | ItemBuilderType? | - | 自定义子项构建器 - **不接管**：disabled 项仍由内部统一渲染，不会走此 builder - **典型用法**：emoji、单位、富文本、动态颜色等场景 - **距离样式**：通过回调的 `itemDistanceCalculator` 参数复用 4 档默认颜色/字号 |
| itemCount | int | 5 | 每屏显示 item 数（奇数更利于中央高亮），默认 5 |
| items | TPickerItems | - | 数据源（必填） - **类型**：密封类 `TPickerItems`，编译期强制二选一 - **多列独立**：`TPickerColumns` —— 各列候选项互不影响 - **联动选择**：`TPickerLinked` —— 上游列变更后下游列自动裁剪并按新分支展开 - **自由结构**：通过 `.fromRaw()` 工厂构造并自动归一化 - **重建语义**：实例值与上一帧不等时整组重初始化；内容相等的新实例不重建 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChange | void Function(int col, TPickerValue value)? | - | 值改变回调（滚动时实时触发，不代表用户已确认选择） - **触发时机**：用户滚动经过 enabled 项时 / disabled 修正动画完成后 - **`col`**：本次触发的列索引（0-based），联动模式下仅指用户实际滚动的列（下游列联动刷新是结果，不是触发源） - **`value`**：当前各列选中快照 - **典型用法**：维护 draft 状态 / 联动缓存 / 列底分页判定 - **弹窗建议**：配合 `TPopup` 头部确认按钮，关闭前读取 draft 提交 |
| onColumnScrollEnd | void Function(int col, TPickerValue value)? | - | 指定列滚动结束回调（惯性停止或手指抬起后） - **`col`**：列索引 - **`value`**：当前各列选中快照 - **典型用法**：判断 `value.indexes[col]` 是否接近列底并触发分页，避免在 `onChange` 里对每一项做高频加载判定 |


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
