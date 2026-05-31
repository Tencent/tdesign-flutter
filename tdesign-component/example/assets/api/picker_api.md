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
