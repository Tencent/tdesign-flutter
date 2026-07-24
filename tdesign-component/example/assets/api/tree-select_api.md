## API
### TTreeSelect
#### 简介
严格受控的树形选择器。
`value` 中每一项都是从根到叶子的完整路径。单选模式最多保留一条路径，
多选模式可同时保留多条路径。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| multiple | bool | false | 是否允许选择多个叶子节点。 |
| onChanged | ValueChanged<List<List<Object?>>>? | - | 选中路径变化回调；为 null 时禁用。 |
| options | List<TTreeSelectOption> | - | 根选项。 |
| value | List<List<Object?>> | - | 受控选中路径。 |


### TTreeSelectOption
#### 简介
不可变的树形选择选项。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TTreeSelectOption> | const [] | 子选项。 |
| disabled | bool | false | 是否禁用。 |
| label | String | - | 展示文案。 |
| value | Object? | - | 业务值。 |


### TTreeSelectThemeData
#### 简介
TTreeSelect 组件级 ThemeExtension。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 面板背景色。 |
| columnWidth | double? | - | 子列宽度。 |
| disabledTextStyle | TextStyle? | - | 禁用文案样式。 |
| height | double? | - | 面板高度。 |
| indicatorColor | Color? | - | 选中图标颜色。 |
| itemHeight | double? | - | 单项最小高度。 |
| rootBackgroundColor | Color? | - | 根列背景色。 |
| rootColumnWidth | double? | - | 根列宽度。 |
| selectedBackgroundColor | Color? | - | 选中项背景色。 |
| selectedTextStyle | TextStyle? | - | 选中文案样式。 |
| textStyle | TextStyle? | - | 普通文案样式。 |
