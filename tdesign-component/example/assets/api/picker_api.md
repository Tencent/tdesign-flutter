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
