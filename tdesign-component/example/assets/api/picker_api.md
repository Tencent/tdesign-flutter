## API
### TPicker
#### 简介
严格受控的滚轮选择器。
独立多列使用 `TPickerColumns`，层级联动使用 `TPickerLinked`。弹层和确认
操作由调用方组合，组件本身只负责滚轮选择。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| itemBuilder | TPickerItemBuilder? | - | 自定义选项构建器。 |
| items | TPickerItems | - | 不可变数据源；更新选项时创建新的数据源与列表，不原地修改。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<TPickerValue>? | - | 值变化回调；为 null 时禁用。 |
| onColumnScrollEnd | void Function(int columnIndex, TPickerValue value)? | - | 某列滚动结束回调。 |
| value | List<Object?> | - | 各列受控值。使用不可变列表，更新时提供新列表。 拖动期间可显示候选值；滚动结束后父级未接受 `onChanged` 的值时， 恢复到此值。父级接受变化时，应通过重建回传新的值。 |


### TPickerOption
#### 简介
选择器选项。
选项及 `children` 按不可变数据使用；更新时创建新选项和新列表。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TPickerOption> | const [] | 联动模式下的子选项。 |
| disabled | bool | false | 是否禁用。 |
| label | String | - | 展示文案。 |
| value | Object? | - | 业务值。 |


### TPickerValue
#### 简介
各列当前选中项的只读快照。
组件回调产生的列表不可修改。手工构造时，调用方须提供不可变列表；
const 构造不会复制或冻结传入的 `selectedOptions` 和 `indexes`。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| indexes | List<int> | - | 各列选中索引。 |
| selectedOptions | List<TPickerOption> | - | 各列选中的完整选项。 |


### TPickerColumns
#### 简介
互不联动的多列数据源。
`columns` 及每列列表不得原地修改；变更时传入新的数据源和列表。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| columns | List<List<TPickerOption>> | - | 各列选项。 |


### TPickerLinked
#### 简介
由 `TPickerOption.children` 描述层级关系的联动数据源。
`options` 及所有子选项列表不得原地修改；变更时创建新的数据源。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| options | List<TPickerOption> | - | 根选项。 |


### TPickerItemBuilder
#### 简介
选择器子项构建器。
#### 类型定义

```dart
typedef TPickerItemBuilder = Widget? Function(BuildContext context, TPickerOption option, int columnIndex, int itemIndex, double distance);
```
