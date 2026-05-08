## API
### TPickerOption
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用（不可选中/置灰显示），默认 false |
| label | String | - | 显示文字（可包含 emoji、单位、国际化等） |
| value | dynamic | - | 实际值（onChange 回调返回此字段） |

```
```

### TPickerValue
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| indexes | List<int> | - | 每列在当前数据列表中的索引（便捷访问） |
| selectedOptions | List<TPickerOption> | - | 每列选中的完整 option（顺序对应列号） |

```
```

### TPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用整个选择器（禁止滚动和操作），默认 false |
| height | double | 200 | 视窗高度，默认 200 |
| initialValue | List? | - | 初始选中值列表（按 value 匹配） |
| itemCount | int | 5 | 每屏显示 item 数，默认 5 |
| items | dynamic | - | 数据源（必填） |
| key |  | - |  |
| onChange | void Function(TPickerValue)? | - | 值改变回调 |
| onLoad | void Function(TPickerLoadEvent)? | - | 接近底部时加载回调 |
| preloadThreshold | int | 5 | 预加载阈值（距底部剩余 N 项时触发），默认 5 |

```
```

### TPickerScrollPhysics
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| parent |  | - |  |
