## API

### TSideBar

受控的侧边导航栏。

`value` 由调用方持有；用户选择可用项时通过 `onChanged` 报告新的值。
未提供 `onChanged` 时，整个侧边栏以禁用态展示。

#### 构造方法

##### TSideBar

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| children | List&lt;TSideBarItem&gt; | const [] | 侧边栏项。 | 否 |
| height | double? | - | 高度；未设置时占满当前可用屏幕高度，不从 Theme 读取。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| loading | bool | false | 是否展示加载态。 | 否 |
| loadingWidget | Widget? | - | 自定义加载态内容。 | 否 |
| onChanged | ValueChanged&lt;int&gt;? | - | 选中值变化回调；为 null 时禁用整栏。 | 否 |
| value | int | - | 当前选中项值。 | 是 |
| variant | TSideBarVariant | TSideBarVariant.line | 展示变体；属于组件实例的结构状态，不从 Theme 读取。 | 否 |
| width | double | 103 | 侧边栏宽度，默认 103。 | 否 |


### TSideBarItem

侧边导航栏的不可变配置项。

这是数据配置而非 Widget，不参与 Flutter Key 匹配。
`value` 应在同一个侧边导航栏的 children 列表中保持唯一，以便组件稳定地
保留选中状态和滚动目标。

#### 构造方法

##### TSideBarItem

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| badge | TBadgeConfig? | - | 展示在标签文字右上角的徽标；为空时不显示。 SideBar 会将标签文字作为徽标锚点，并使用 `TBadgeConfig` 描述徽标内容、 形态和可选位置覆盖。调用方已经拥有目标 Widget 时，应直接使用 `TBadge` 包装该 Widget。 | 否 |
| disabled | bool | false | 是否禁用 | 否 |
| icon | IconData? | - | 图标 | 否 |
| label | String | '' | 标签 | 否 |
| value | int | -1 | 值 | 否 |


### TSideBarThemeData

侧边栏组件 ThemeExtension

管理 TSideBar 的子树级视觉样式（内边距、选中/未选中颜色等）。
实例参数负责选中值、形态和交互；具体视觉值由本组件 Theme 配置。

#### 构造方法

##### TSideBarThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| contentPadding | EdgeInsetsGeometry? | - | 默认自定义文本框内边距 | 否 |
| selectedBgColor | Color? | - | 默认选中背景颜色 | 否 |
| selectedTextStyle | TextStyle? | - | 选中文字样式；其中的 color 同时控制选中图标和指示线。 未指定 color 时读取全局品牌色；禁用态始终使用全局禁用色。 | 否 |
| textStyle | TextStyle? | - | 未选中标签文字样式；颜色同时用于未选中图标。 选中项只继承排版字段，不继承这里的颜色；禁用态使用全局禁用色。 未指定颜色时使用全局正文色。 | 否 |
| unSelectedBgColor | Color? | - | 默认未选中背景颜色 | 否 |


#### 实例方法

##### TSideBarThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| contentPadding | EdgeInsetsGeometry? | - | 字段含义：默认自定义文本框内边距 调用时的空值行为见方法说明。 | 否 |
| textStyle | TextStyle? | - | 字段含义：未选中标签文字样式；颜色同时用于未选中图标。 选中项只继承排版字段，不继承这里的颜色；禁用态使用全局禁用色。 未指定颜色时使用全局正文色。 调用时的空值行为见方法说明。 | 否 |
| selectedTextStyle | TextStyle? | - | 字段含义：选中文字样式；其中的 color 同时控制选中图标和指示线。 未指定 color 时读取全局品牌色；禁用态始终使用全局禁用色。 调用时的空值行为见方法说明。 | 否 |
| selectedBgColor | Color? | - | 字段含义：默认选中背景颜色 调用时的空值行为见方法说明。 | 否 |
| unSelectedBgColor | Color? | - | 字段含义：默认未选中背景颜色 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSideBarThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TSideBarThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TSideBarThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSideBarThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


### TSideBarVariant

侧边栏样式
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| line | TSideBarVariant | - | 左侧品牌色指示线样式 | - |
| tag | TSideBarVariant | - | 选中项为圆角标签样式 | - |
