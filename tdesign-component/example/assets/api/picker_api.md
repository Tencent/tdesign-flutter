## API
### TPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| items | dynamic | - | 数据源（必填）：`List<List<TPickerOption>>` 多列独立 / `Map` 联动选择 |
| initialValue | List? | - | 初始选中值列表（按 value 匹配） |
| onChange | void Function(TPickerValue)? | - | 值改变回调，返回 `TPickerValue`（含 selectedOptions、indexes、values/labels 便捷属性） |
| onLoad | void Function(TPickerLoadEvent)? | - | 接近底部时加载回调（用于无限滚动） |
| preloadThreshold | int | 5 | 预加载阈值（距底部剩余 N 项时触发） |
| height | double | 200 | 视窗高度 |
| itemCount | int | 5 | 每屏显示 item 数量 |
| disabled | bool | false | 是否禁用整个选择器 |

### TPickerOption
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| label | String (required) | - | 显示文字（可包含 emoji、单位等） |
| value | dynamic (required) | - | 实际值（onChange 回调返回此字段） |
| disabled | bool | false | 是否禁用（不可选中） |

#### 使用示例
```dart
TPickerOption(label: '👨 男性', value: 'M')
TPickerOption(label: '18岁', value: 18)
TPickerOption(label: '广东省', value: 'GD', disabled: true)
```

### TPickerValue
#### onChange 回调返回对象

| 属性 | 类型 | 说明 |
| --- | --- | --- |
| selectedOptions | List\<TPickerOption\> | 每列选中的完整 option（顺序对应列号） |
| indexes | List\<int\> | 每列在当前数据列表中的索引 |
| values (getter) | List\<dynamic\> | 所有 value 的便捷列表 |
| labels (getter) | List\<String\> | 所有 label 的便捷列表 |

#### 使用示例
```dart
TPicker(
  items: data,
  onChange: (v) {
    // 显示文本：v.labels.join(' / ')
    // 业务值：v.values
    // 完整选项：v.selectedOptions
  },
)
```

### TPickerLoadEvent
#### onLoad 回调参数

| 属性 | 类型 | 说明 |
| --- | --- | --- |
| column | int | 当前列索引（从 0 开始） |
| parentValue | dynamic | 该列父级选中值（第一列为 null） |
| displayedCount | int | 该列当前已显示的数据量 |
| remaining | int | 距离底部还有多少项 |
