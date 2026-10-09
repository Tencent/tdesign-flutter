## API

### TTabsBar

#### 构造方法

##### TTabsBar

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| controller | TabController? | - | 可选的标签控制器；为空时使用最近的 `DefaultTabController`。 仅在需要读取当前索引、命令式切换或跨组件共享状态时显式传入。 | 否 |
| isScrollable | bool | false | 是否横向滚动。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onTap | ValueChanged&lt;int&gt;? | - | 点击事件 | 否 |
| size | TTabsBarSize | TTabsBarSize.small | 选项卡文字尺寸，默认为 `TTabsBarSize.small`。 | 否 |
| tabs | List&lt;TTab&gt; | - | tab数组 | 是 |
| variant | TTabsBarVariant | TTabsBarVariant.line | 选项卡结构形态，默认为 `TTabsBarVariant.line`。 | 否 |


### TTab

#### 构造方法

##### TTab

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| child | Widget? | - | 子widget | 否 |
| enabled | bool | true | 是否可用，默认 true。 设为 `false` 时使用禁用样式，并由 `TTabsBar` 阻止该项被选择。 Material `TabBar` 不识别此扩展字段；直接将 `TTab` 用作 Material `TabBar.tabs` 时只会呈现禁用样式，不会阻止其切换。 | 否 |
| icon | Widget? | - | 图标 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| text | String? | - | 文字内容 | 否 |


### TTabsBarView

#### 构造方法

##### TTabsBarView

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| children | List&lt;Widget&gt; | - | 子widget列表 | 是 |
| controller | TabController? | - | 可选的内容区控制器；为空时使用最近的 `DefaultTabController`。 与 `TTabsBar` 放在同一 `DefaultTabController` 下即可共享选中状态。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| physics | ScrollPhysics? | - | 滑动物理特性；未传时默认不可滑动。 | 否 |


### TTabsBarIndicator

#### 构造方法

##### TTabsBarIndicator

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| indicatorColor | Color | - | 指示器颜色 | 是 |
| indicatorHeight | double? | - | 指示器高度 | 否 |
| indicatorWidth | double? | - | 指示器宽度 | 否 |


### TTabsBarThemeData

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
| 返回值 | TTabsBarThemeData | - | - | - |


##### TTabsBarThemeData.lerp

位置参数：`other, t`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TTabsBarThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TTabsBarThemeData | - | - | - |


### TTabsBarVariant
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| line | TTabsBarVariant | - | 底部指示器样式。 | - |
| tag | TTabsBarVariant | - | 胶囊标签样式。 | - |
| card | TTabsBarVariant | - | 卡片样式。 | - |


### TTabsBarSize
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| small | TTabsBarSize | - | 小尺寸，使用 14px 字体 Token。 | - |
| large | TTabsBarSize | - | 大尺寸，使用 16px 字体 Token。 | - |
