## API
### TTreeSelect
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| multiple | bool | false | 是否允许选择多个叶子节点。 为 false 时，`value` 最多包含一条路径。 |
| onChanged | ValueChanged<List<List<Object?>>>? | - | 选中路径变化回调；为 null 时禁用。 |
| options | List<TTreeSelectOption> | - | 根选项。 |
| value | List<List<Object?>> | - | 受控选中路径。 每一项应为从根到叶子的完整 `TTreeSelectOption.value` 路径。 暂时无法在 `options` 中解析到叶子的路径不会显示选中态。 组件会回退到首个可用分支。单选模式最多传入一条，多选模式可传入多条且不得重复。 |


### TTreeSelectOption
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TTreeSelectOption> | const [] | 子选项。 |
| disabled | bool | false | 是否禁用。 |
| label | String | - | 展示文案。 |
| value | Object? | - | 业务值；同一层级的选项必须保持唯一。 值可为 null，但同一层级最多只能有一个 null 值。 |


### TTreeSelectThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 面板背景色。 |
| columnWidth | double? | - | 所有非根列的固定宽度；为 null 时由组件按可用宽度自动布局。 |
| disabledTextStyle | TextStyle? | - | 禁用文案样式。 |
| height | double? | - | 面板高度。 |
| indicatorColor | Color? | - | 选中图标颜色。 |
| itemHeight | double? | - | 单项最小高度。 |
| rootBackgroundColor | Color? | - | 根列背景色。 |
| rootColumnWidth | double? | - | 根列宽度。 |
| selectedBackgroundColor | Color? | - | 选中项背景色。 |
| selectedTextStyle | TextStyle? | - | 选中文案样式。 |
| textStyle | TextStyle? | - | 普通文案样式。 |
