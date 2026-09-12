## API
### TSideBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TSideBarItem> | const [] | 侧边栏项。 |
| contentPadding | EdgeInsetsGeometry? | - | 自定义文本框内边距（优先级高于 ThemeData）。 |
| height | double? | - | 高度；未设置时占满当前可用屏幕高度，不从 Theme 读取。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loading | bool | false | 是否展示加载态。 |
| loadingWidget | Widget? | - | 自定义加载态内容。 |
| onChanged | ValueChanged<int>? | - | 选中值变化回调；为 null 时禁用整栏。 |
| selectedBgColor | Color? | - | 选择的背景颜色（优先级高于 ThemeData）。 |
| selectedColor | Color? | - | 选中文字、图标与指示线颜色；优先于组件 Theme，同层 selectedTextStyle.color 优先。 |
| selectedTextStyle | TextStyle? | - | 选中文字样式；按 TextStyle.merge 合并组件 Theme，实例显式字段优先。 未指定颜色时依次回退实例 selectedColor、组件 Theme 的文字颜色与 selectedColor、品牌色 Token。 |
| unSelectedBgColor | Color? | - | 未选择的背景颜色（优先级高于 ThemeData）。 |
| unSelectedColor | Color? | - | 未选中颜色（优先级高于 ThemeData）。 |
| value | int | - | 当前选中项值。 |
| variant | TSideBarVariant | TSideBarVariant.line | 展示变体；属于组件实例的结构状态，不从 Theme 读取。 |
| width | double | 103 | 侧边栏宽度，默认 103。 |


### TSideBarItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TBadge? | - | 徽标 |
| disabled | bool | false | 是否禁用 |
| icon | IconData? | - | 图标 |
| label | String | '' | 标签 |
| textStyle | TextStyle? | - | 标签样式 |
| value | int | -1 | 值 |
