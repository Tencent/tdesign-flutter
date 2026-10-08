## API

### TTreeSelect

严格受控的树形选择器。

`value` 中每一项都是从根到叶子的完整路径。单选模式最多保留一条路径，
多选模式可同时保留多条路径。

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

#### 构造方法

##### TTreeSelectThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 面板背景色。 | 否 |
| columnWidth | double? | - | 所有非根列的固定宽度；为 null 时由组件按可用宽度自动布局。 设置后每个非根列均使用该宽度，面板总宽度超过可用宽度时可横向滚动。 | 否 |
| disabledTextStyle | TextStyle? | - | 禁用文案样式。 | 否 |
| height | double? | - | 面板高度。 未配置时为 336 逻辑像素。 | 否 |
| indicatorColor | Color? | - | 选中图标颜色。 | 否 |
| itemHeight | double? | - | 单项最小高度。 未配置时为 56 逻辑像素。 | 否 |
| rootBackgroundColor | Color? | - | 根列背景色。 | 否 |
| rootColumnWidth | double? | - | 根列宽度。 未配置时为 103 逻辑像素。 | 否 |
| selectedBackgroundColor | Color? | - | 选中项背景色。 | 否 |
| selectedTextStyle | TextStyle? | - | 选中文案样式。 | 否 |
| textStyle | TextStyle? | - | 普通文案样式。 | 否 |


#### 实例方法

##### TTreeSelectThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| height | double? | - | 字段含义：面板高度。 未配置时为 336 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| rootColumnWidth | double? | - | 字段含义：根列宽度。 未配置时为 103 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| columnWidth | double? | - | 字段含义：所有非根列的固定宽度；为 null 时由组件按可用宽度自动布局。 设置后每个非根列均使用该宽度，面板总宽度超过可用宽度时可横向滚动。 调用时的空值行为见方法说明。 | 否 |
| itemHeight | double? | - | 字段含义：单项最小高度。 未配置时为 56 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| backgroundColor | Color? | - | 字段含义：面板背景色。 调用时的空值行为见方法说明。 | 否 |
| rootBackgroundColor | Color? | - | 字段含义：根列背景色。 调用时的空值行为见方法说明。 | 否 |
| selectedBackgroundColor | Color? | - | 字段含义：选中项背景色。 调用时的空值行为见方法说明。 | 否 |
| textStyle | TextStyle? | - | 字段含义：普通文案样式。 调用时的空值行为见方法说明。 | 否 |
| selectedTextStyle | TextStyle? | - | 字段含义：选中文案样式。 调用时的空值行为见方法说明。 | 否 |
| disabledTextStyle | TextStyle? | - | 字段含义：禁用文案样式。 调用时的空值行为见方法说明。 | 否 |
| indicatorColor | Color? | - | 字段含义：选中图标颜色。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TTreeSelectThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TTreeSelectThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TTreeSelectThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TTreeSelectThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |
