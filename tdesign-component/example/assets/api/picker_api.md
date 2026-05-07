## API

### TPickerOption

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| label | String | - | 显示文字 |
| value | dynamic | - | 实际值（onChange 返回此字段） |
| disabled | bool | false | 是否禁用（不可选中/置灰显示） |

### TPickerValue

`onChange` 回调的返回值类型。

| 属性 | 类型 | 说明 |
| --- | --- | --- |
| selectedOptions | List<TPickerOption> | 每列选中的完整 option（顺序对应列号） |
| indexes | List<int> | 每列在当前数据列表中的索引 |
| values | List<dynamic> | 便捷属性：所有 value 的列表 |
| labels | List<String> | 便捷属性：所有 label 的列表 |

### TPickerLoadEvent

`onLoad` 回调的参数类型。

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| column | int | 当前是第几列（从 0 开始） |
| parentValue | dynamic | 该列的父级选中值（第一列为 null） |
| displayedCount | int | 该列当前已显示的数据量 |
| remaining | int | 距离底部还有多少项 |

### TPicker

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| items | dynamic | - | 数据源（必填）。`List<List<TPickerOption>>` → 多列独立选择；`Map` → 联动选择（Key 必须是 `TPickerOption`） |
| initialValue | List? | - | 初始选中值列表（按 value 匹配） |
| onChange | Function(TPickerValue)? | - | 值改变回调 |
| onLoad | Function(TPickerLoadEvent)? | - | 接近底部时加载回调 |
| preloadThreshold | int | 5 | 预加载阈值（距底部剩余 N 项时触发） |
| height | double | 200 | 视窗高度 |
| itemCount | int | 5 | 每屏显示 item 数 |
| disabled | bool | false | 是否禁用整个选择器（禁止滚动和操作） |
