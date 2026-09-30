## API
### TSideBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TSideBarItem> | const [] | 侧边栏项。 |
| height | double? | - | 高度；未设置时占满当前可用屏幕高度，不从 Theme 读取。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loading | bool | false | 是否展示加载态。 |
| loadingWidget | Widget? | - | 自定义加载态内容。 |
| onChanged | ValueChanged<int>? | - | 选中值变化回调；为 null 时禁用整栏。 |
| value | int | - | 当前选中项值。 |
| variant | TSideBarVariant | TSideBarVariant.line | 展示变体；属于组件实例的结构状态，不从 Theme 读取。 |
| width | double | 103 | 侧边栏宽度，默认 103。 |


### TSideBarItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TBadgeConfig? | - | 展示在标签文字右上角的徽标；为空时不显示。 SideBar 会将标签文字作为徽标锚点，并使用 `TBadgeConfig` 描述徽标内容、 形态和可选位置覆盖。调用方已经拥有目标 Widget 时，应直接使用 `TBadge` 包装该 Widget。 |
| disabled | bool | false | 是否禁用 |
| icon | IconData? | - | 图标 |
| label | String | '' | 标签 |
| textStyle | TextStyle? | - | 标签样式 |
| value | int | -1 | 值 |


### TSideBarThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| contentPadding | EdgeInsetsGeometry? | - | 默认自定义文本框内边距 |
| selectedBgColor | Color? | - | 默认选中背景颜色 |
| selectedTextStyle | TextStyle? | - | 选中文字样式；其中的 color 同时控制选中图标和指示线。 未指定 color 时读取全局品牌色。 |
| unSelectedBgColor | Color? | - | 默认未选中背景颜色 |
| unSelectedColor | Color? | - | 默认未选中颜色 |


### TSideBarVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| line | 左侧品牌色指示线样式 |
| tag | 选中项为圆角标签样式 |
