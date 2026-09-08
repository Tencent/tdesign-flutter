## API
### TTabsBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| controller | TabController? | - | 可选的标签控制器；为空时使用最近的 `DefaultTabController`。 仅在需要读取当前索引、命令式切换或跨组件共享状态时显式传入。 |
| decoration | Decoration? | - | tabBar 修饰；非空时覆盖 Theme 的背景和分割线。 |
| indicator | Decoration? | - | 自定义指示器；非空时覆盖 Theme 指示器。 `TTabsBarVariant.line` 默认使用 TDesign 品牌色指示器，Tag 与 Card 默认不显示指示器。 |
| isScrollable | bool | false | 是否横向滚动。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onTap | ValueChanged<int>? | - | 点击事件 |
| tabs | List<TTab> | - | tab数组 |
| variant | TTabsBarVariant | TTabsBarVariant.line | 选项卡结构形态，默认为 `TTabsBarVariant.line`。 |


### TTab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 子widget |
| enabled | bool | true | 是否可用，默认 true。 设为 `false` 时使用禁用样式，并由 `TTabsBar` 阻止该项被选择。 Material `TabBar` 不识别此扩展字段；直接将 `TTab` 用作 Material `TabBar.tabs` 时只会呈现禁用样式，不会阻止其切换。 |
| icon | Widget? | - | 图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| text | String? | - | 文字内容 |


### TTabsBarView
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<Widget> | - | 子widget列表 |
| controller | TabController? | - | 可选的内容区控制器；为空时使用最近的 `DefaultTabController`。 与 `TTabsBar` 放在同一 `DefaultTabController` 下即可共享选中状态。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| physics | ScrollPhysics? | - | 滑动物理特性；未传时默认不可滑动。 |


### TTabsBarIndicator
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| indicatorColor | Color | - | 指示器颜色 |
| indicatorHeight | double? | - | 指示器高度 |
| indicatorWidth | double? | - | 指示器宽度 |


### TTabsBarThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 栏背景色。 |
| disabledLabelStyle | TextStyle? | - | 禁用标签文字和图标样式。 |
| dividerColor | Color? | - | 分割线颜色。 |
| dividerHeight | double? | - | 分割线高度；小于等于 0 时不展示。 |
| indicator | Decoration? | - | 组件主题指示器；非空时覆盖内置形态指示器。 为空时 Line 使用 TDesign 默认指示器，Tag 与 Card 不展示指示器。 |
| labelPadding | EdgeInsetsGeometry? | - | 标签内容边距。 |
| labelStyle | TextStyle? | - | 选中标签文字样式。 |
| selectedTagBackgroundColor | Color? | - | Tag 形态下的选中背景色。 |
| tagBackgroundColor | Color? | - | Tag 形态下的默认背景色。 |
| unselectedLabelStyle | TextStyle? | - | 未选中标签文字样式。 |


### TTabsBarVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| line | 底部指示器样式。 |
| tag | 胶囊标签样式。 |
| card | 卡片样式。 |
