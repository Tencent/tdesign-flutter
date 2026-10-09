## API

### TTreeSelect

严格受控的树形选择器。

`value` 中每一项都是从根到叶子的完整路径。单选模式最多保留一条路径，
多选模式可同时保留多条路径。

#### 主题配置

组件主题通过 `TTreeSelectThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。可配置字段和未设置时的回退见本页的
`TTreeSelectThemeData` 配置项。

#### 构造方法

##### TTreeSelect

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| multiple | bool | false | 是否允许选择多个叶子节点。 为 false 时，`value` 最多包含一条路径。 | 否 |
| onChanged | ValueChanged&lt;List&lt;List&lt;Object?&gt;&gt;&gt;? | - | 选中路径变化回调；为 null 时禁用。 | 否 |
| options | List&lt;TTreeSelectOption&gt; | - | 根选项。 | 是 |
| value | List&lt;List&lt;Object?&gt;&gt; | - | 受控选中路径。 每一项应为从根到叶子的完整 `TTreeSelectOption.value` 路径。 暂时无法在 `options` 中解析到叶子的路径不会显示选中态。 组件会回退到首个可用分支。单选模式最多传入一条，多选模式可传入多条且不得重复。 | 是 |


### TTreeSelectOption

不可变的树形选择选项。

#### 构造方法

##### TTreeSelectOption

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| children | List&lt;TTreeSelectOption&gt; | const [] | 子选项。 | 否 |
| disabled | bool | false | 是否禁用。 | 否 |
| label | String | - | 展示文案。 | 是 |
| value | Object? | - | 业务值；同一层级的选项必须保持唯一。 值可为 null，但同一层级最多只能有一个 null 值。 | 是 |


### TTreeSelectThemeData

TTreeSelect 组件级 ThemeExtension。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 面板背景色。 null 时使用 bgColorContainer Token。 | 否 |
| columnWidth | double? | - | 所有非根列的固定宽度；为 null 时由组件按可用宽度自动布局。 设置后每个非根列均使用该宽度，面板总宽度超过可用宽度时可横向滚动。 | 否 |
| disabledTextStyle | TextStyle? | - | 禁用文案样式。 null 时沿用默认文字样式并使用 textColorDisabled Token。 | 否 |
| height | double? | - | 面板高度。 未配置时为 336 逻辑像素。 | 否 |
| indicatorColor | Color? | - | 选中图标颜色。 null 时使用 brandColor Token。 | 否 |
| itemHeight | double? | - | 单项最小高度。 未配置时为 56 逻辑像素。 | 否 |
| rootBackgroundColor | Color? | - | 根列背景色。 null 时使用 bgColorSecondaryContainer Token。 | 否 |
| rootColumnWidth | double? | - | 根列宽度。 未配置时为 103 逻辑像素。 | 否 |
| selectedBackgroundColor | Color? | - | 选中项背景色。 null 时使用 bgColorContainer Token。 | 否 |
| selectedTextStyle | TextStyle? | - | 选中文案样式。 | 否 |
| textStyle | TextStyle? | - | 普通文案样式。 null 时使用当前全局 Token 解析的文字样式。 | 否 |
