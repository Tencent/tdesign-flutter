## API

### TTabsBar

标签栏

支持滚动、指示器自定义，以及 Line、Tag、Card 三种 TDesign 形态。

#### 构造方法

##### TTabsBar

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| controller | TabController? | - | 可选的标签控制器；为空时使用最近的 `DefaultTabController`。 仅在需要读取当前索引、命令式切换或跨组件共享状态时显式传入。 必须存在显式控制器或祖先 DefaultTabController，其 length 须等于 tabs.length。显式控制器由调用方释放。 | 否 |
| isScrollable | bool | false | 是否横向滚动。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onTap | ValueChanged&lt;int&gt;? | - | 点击事件 仅用于点击通知；为 null 时仍可切换标签，禁用单项请使用 TTab.enabled。 | 否 |
| size | TTabsBarSize | TTabsBarSize.small | 选项卡文字尺寸，默认为 `TTabsBarSize.small`。 | 否 |
| tabs | List&lt;TTab&gt; | - | tab数组 | 是 |
| variant | TTabsBarVariant | TTabsBarVariant.line | 选项卡结构形态，默认为 `TTabsBarVariant.line`。 | 否 |


### TTab

Tab 组件

TDesign 选项卡标签，通常作为 `TTabsBar.tabs` 的子项使用。

#### 构造方法

##### TTab

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| child | Widget? | - | 自定义标签内容；与 text 互斥，可与 icon 同时提供。 | 否 |
| enabled | bool | true | 是否可用，默认 true。 设为 `false` 时使用禁用样式，并由 `TTabsBar` 阻止该项被选择。 Material `TabBar` 不识别此扩展字段；直接将 `TTab` 用作 Material `TabBar.tabs` 时只会呈现禁用样式，不会阻止其切换。 | 否 |
| icon | Widget? | - | 图标 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| text | String? | - | 文字内容；与 child 互斥，text、child、icon 至少提供一个。 | 否 |


### TTabsBarView

TabBarView 组件

展示与标签栏控制器同步的分页内容。
`physics` 为空时默认不可滑动。

#### 构造方法

##### TTabsBarView

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| children | List&lt;Widget&gt; | - | 子widget列表 | 是 |
| controller | TabController? | - | 可选的内容区控制器；为空时使用最近的 `DefaultTabController`。 与 `TTabsBar` 放在同一 `DefaultTabController` 下即可共享选中状态。 必须存在显式控制器或祖先 DefaultTabController，其 length 须等于 children.length。显式控制器由调用方释放。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| physics | ScrollPhysics? | - | 滑动物理特性；未传时默认不可滑动。 | 否 |


### TTabsBarIndicator

TDesign自定义下标

#### 构造方法

##### TTabsBarIndicator

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| indicatorColor | Color | - | 指示器颜色 | 是 |
| indicatorHeight | double? | - | 指示器高度 | 否 |
| indicatorWidth | double? | - | 指示器宽度 | 否 |


### TTabsBarThemeData

TabBar 组件 ThemeExtension

管理 TTabsBar 的子树级视觉默认样式。

#### 构造方法

##### TTabsBarThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 栏背景色。 | 否 |
| disabledLabelStyle | TextStyle? | - | 禁用标签文字和图标样式。 | 否 |
| dividerColor | Color? | - | 分割线颜色。 | 否 |
| dividerHeight | double? | - | 分割线高度；小于等于 0 时不展示。 | 否 |
| indicator | Decoration? | - | 组件主题指示器；非空时覆盖内置形态指示器。 为空时 Line 使用 TDesign 默认指示器，Tag 与 Card 不展示指示器。 | 否 |
| labelPadding | EdgeInsetsGeometry? | - | 标签内容边距。 | 否 |
| labelStyle | TextStyle? | - | 选中标签文字样式。 | 否 |
| selectedTagBackgroundColor | Color? | - | Tag 形态下的选中背景色。 | 否 |
| tagBackgroundColor | Color? | - | Tag 形态下的默认背景色。 | 否 |
| unselectedLabelStyle | TextStyle? | - | 未选中标签文字样式。 | 否 |


#### 实例方法

##### TTabsBarThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 字段含义：栏背景色。 调用时的空值行为见方法说明。 | 否 |
| labelStyle | TextStyle? | - | 字段含义：选中标签文字样式。 调用时的空值行为见方法说明。 | 否 |
| unselectedLabelStyle | TextStyle? | - | 字段含义：未选中标签文字样式。 调用时的空值行为见方法说明。 | 否 |
| disabledLabelStyle | TextStyle? | - | 字段含义：禁用标签文字和图标样式。 调用时的空值行为见方法说明。 | 否 |
| labelPadding | EdgeInsetsGeometry? | - | 字段含义：标签内容边距。 调用时的空值行为见方法说明。 | 否 |
| indicator | Decoration? | - | 字段含义：组件主题指示器；非空时覆盖内置形态指示器。 为空时 Line 使用 TDesign 默认指示器，Tag 与 Card 不展示指示器。 调用时的空值行为见方法说明。 | 否 |
| dividerColor | Color? | - | 字段含义：分割线颜色。 调用时的空值行为见方法说明。 | 否 |
| dividerHeight | double? | - | 字段含义：分割线高度；小于等于 0 时不展示。 调用时的空值行为见方法说明。 | 否 |
| selectedTagBackgroundColor | Color? | - | 字段含义：Tag 形态下的选中背景色。 调用时的空值行为见方法说明。 | 否 |
| tagBackgroundColor | Color? | - | 字段含义：Tag 形态下的默认背景色。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TTabsBarThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TTabsBarThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TTabsBarThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TTabsBarThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


### TTabsBarVariant

TabsBar 形态枚举。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| line | TTabsBarVariant | - | 底部指示器样式。 | - |
| tag | TTabsBarVariant | - | 胶囊标签样式。 | - |
| card | TTabsBarVariant | - | 卡片样式。 | - |


### TTabsBarSize

选项卡文字尺寸。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| small | TTabsBarSize | - | 小尺寸，使用 14px 字体 Token。 | - |
| large | TTabsBarSize | - | 大尺寸，使用 16px 字体 Token。 | - |
