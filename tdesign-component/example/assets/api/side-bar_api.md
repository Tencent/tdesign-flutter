## API
### TSideBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TSideBarItem> | const [] | 侧边栏项。 |
| contentPadding | EdgeInsetsGeometry? | - | 自定义文本框内边距（优先级高于 ThemeData）。 |
| height | double? | - | 高度（优先级高于 ThemeData）。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loading | bool | false | 是否展示加载态。 |
| loadingWidget | Widget? | - | 自定义加载态内容。 |
| onChanged | ValueChanged<int>? | - | 选中值变化回调；为 null 时禁用整栏。 |
| selectedBgColor | Color? | - | 选择的背景颜色（优先级高于 ThemeData）。 |
| selectedColor | Color? | - | 选中值后颜色（优先级高于 ThemeData）。 |
| selectedTextStyle | TextStyle? | - | 选中样式（优先级高于 ThemeData）。 |
| style | TSideBarVariant? | - | 样式（优先级高于 ThemeData）。 |
| unSelectedBgColor | Color? | - | 未选择的背景颜色（优先级高于 ThemeData）。 |
| unSelectedColor | Color? | - | 未选中颜色（优先级高于 ThemeData）。 |
| value | int | - | 当前选中项值。 |


### TSideBarItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TBadge? | - | 徽标 |
| disabled | bool | false | 是否禁用 |
| icon | IconData? | - | 图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String | '' | 标签 |
| textStyle | TextStyle? | - | 标签样式 |
| value | int | -1 | 值 |
