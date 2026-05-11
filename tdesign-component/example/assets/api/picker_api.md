## API
### TPickerOption
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用（不可选中/置灰显示），默认 false |
| label | String | - | 展示文字（可包含 emoji、单位、国际化等） |
| value | dynamic | - | 业务值（onChange 回调返回此字段） |

```
```

### TPickerValue
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| indexes | List<int> | - | 每列选中项的索引 |
| selectedOptions | List<TPickerOption> | - | 每列选中的完整 option |

```
```

### TPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cancel | Widget? | - | 工具栏左侧自定义插槽，默认使用 [TResourceDelegate.cancel] |
| confirm | Widget? | - | 工具栏右侧自定义插槽，默认使用 [TResourceDelegate.confirm] |
| disabled | bool | false | 是否禁用整个选择器（禁止滚动和操作），默认 false |
| height | double | 200 | 视窗高度，默认 200 |
| initialValue | List<dynamic>? | - | 初始选中值列表（按 value 匹配） |
| itemBuilder | ItemBuilderType? | - | 自定义子项构建器（disabled 项仍由内部统一渲染，不会走此 builder） |
| itemCount | int | 5 | 每屏显示 item 数，默认 5 |
| itemDistanceCalculator | ItemDistanceCalculator? | - | 自定义距离计算器（控制颜色/字重/字号随"离中心距离"的变化） |
| items | TPickerItems | - | 数据源（必填） |
| key |  | - |  |
| onCancel | VoidCallback? | - | 点击「取消」按钮回调 |
| onChange | void Function(TPickerValue)? | - | 值改变回调（滚动时实时触发） |
| onConfirm | void Function(TPickerValue)? | - | 点击「确认」按钮回调 |
| onLoad | void Function(TPickerLoadEvent)? | - | 列选中项变化的事件回调 |
| title | String? | - | 工具栏中部标题（可选，不传时中部留白） |
| titleWidget | Widget? | - | 工具栏中部自定义标题插槽 |

```
```

### TPickerItems
```
```

### TPickerColumns
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| columns | List<List<TPickerOption>> | columns | 每列的选项列表 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TPickerColumns.fromRaw  | 从自由结构的 raw 数据创建，自动归一化

 ```dart
 TPickerColumns.fromRaw(
   [['北京', '上海', '广州']],
   keys: const TPickerKeys(label: 'name', value: 'code'),
 )
 ``` |

```
```

### TPickerLinked
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| tree | Map<TPickerOption, dynamic> | tree | 联动树结构：`Map<TPickerOption, dynamic>` |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TPickerLinked.fromRaw  | 从自由结构的 raw Map 数据创建，自动归一化

 ```dart
 TPickerLinked.fromRaw({
   '广东': {'深圳': ['南山', '福田'], '广州': ['天河']},
   '浙江': {'杭州': ['西湖']},
 })
 ``` |

```
```

### TPickerKeys
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | String | 'children' | 联动模式下子级数据对应的字段名，默认 `children` |
| disabled | String | 'disabled' | 禁用标记对应的字段名，默认 `disabled` |
| label | String | 'label' | 展示文案对应的字段名，默认 `label` |
| value | String | 'value' | 业务值对应的字段名，默认 `value` |

```
```

### TPickerLoadEvent
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| column | int | - | 触发事件的列索引（0 表示第一列） |
| displayedCount | int | - | 当前列已展示的选项总数 |
| parentValue | dynamic | - | 当前列的父级选中值（联动模式下使用） |
| remaining | int | - | 距底部剩余的选项数（业务可用此值做"接近底部时加载"判断） |
