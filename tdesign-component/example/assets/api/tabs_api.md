## API
### TTabsBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | tabBar背景色，当 variant 为 card 时控制选中tab颜色（可覆盖 Theme） |
| controller | TabController? | - | tab控制器 |
| decoration | Decoration? | - | tabBar修饰（可覆盖 Theme） |
| dividerColor | Color? | - | 分割线颜色（可覆盖 Theme） |
| dividerHeight | double | 0.5 | 分割线高度，小于等于0则不展示分割线（可覆盖 Theme） |
| height | double? | - | tabBar高度（可覆盖 Theme） |
| indicator | Decoration? | - | 自定义引导控件（可覆盖 Theme） |
| indicatorColor | Color? | - | tabBar下标颜色（可覆盖 Theme） |
| indicatorHeight | double? | - | tabBar下标高度（可覆盖 Theme） |
| indicatorPadding | EdgeInsets? | - | 引导padding（可覆盖 Theme） |
| indicatorWidth | double? | - | tabBar下标宽度（可覆盖 Theme） |
| isScrollable | bool | false | 是否滚动（可覆盖 Theme） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| labelColor | Color? | - | tabBar 已选标签颜色（可覆盖 Theme） |
| labelPadding | EdgeInsetsGeometry? | - | tab间距（可覆盖 Theme） |
| labelStyle | TextStyle? | - | 已选label字体（可覆盖 Theme） |
| onTap | Function(int)? | - | 点击事件 |
| physics | ScrollPhysics? | - | 自定义滑动（可覆盖 Theme） |
| selectedBgColor | Color? | - | 被选中背景色，只有 variant 为 capsule 时有效（可覆盖 Theme） |
| showIndicator | bool | false | 是否展示引导控件（可覆盖 Theme） |
| tabAlignment | TabAlignment? | - | Tab 对齐方式 |
| tabs | List<TTab> | - | tab数组 |
| unSelectedBgColor | Color? | - | 未选中背景色，只有 variant 为 capsule 时有效（可覆盖 Theme） |
| unselectedLabelColor | Color? | - | tabBar未选标签颜色（可覆盖 Theme） |
| unselectedLabelStyle | TextStyle? | - | unselectedLabel字体（可覆盖 Theme） |
| variant | TTabsBarVariant | TTabsBarVariant.filled | 选项卡样式（可覆盖 Theme） |
| width | double? | - | tabBar宽度 |


### TTab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TBadge? | - | 徽标 |
| child | Widget? | - | 子widget |
| contentHeight | double? | - | 中间内容高度（可覆盖 Theme） |
| enabled | bool | true | 是否可用，默认 true；`false` 即禁用 |
| height | double? | - | tab高度（可覆盖 Theme） |
| icon | Widget? | - | 图标 |
| iconMargin | EdgeInsetsGeometry | const EdgeInsets.only(bottom: 4.0, right: 4.0) | 图标间距（可覆盖 Theme） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| size | TTabSize | TTabSize.small | 选项卡尺寸 |
| text | String? | - | 文字内容 |
| textMargin | EdgeInsetsGeometry? | - | 文本边距（可覆盖 Theme） |


### TTabsBarView
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<Widget> | - | 子widget列表 |
| controller | TabController? | - | 控制器 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| physics | ScrollPhysics? | - | 滑动物理特性；未传时取 Theme `defaultPhysics`，Theme 也未配时默认不可滑动 |
