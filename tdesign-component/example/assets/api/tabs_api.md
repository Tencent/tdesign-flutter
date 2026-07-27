## API
### TTabsBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| controller | TabController? | - | tab控制器 |
| decoration | Decoration? | - | tabBar 修饰；非空时覆盖 Theme 的背景和分割线。 |
| indicator | Decoration? | - | 自定义指示器；非空时覆盖 Theme 指示器。 |
| isScrollable | bool | false | 是否横向滚动。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onTap | ValueChanged<int>? | - | 点击事件 |
| tabs | List<TTab> | - | tab数组 |
| variant | TTabsBarVariant | TTabsBarVariant.filled | 选项卡样式。 |


### TTab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TBadge? | - | 徽标 |
| child | Widget? | - | 子widget |
| enabled | bool | true | 是否可用，默认 true；`false` 即禁用 |
| icon | Widget? | - | 图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| text | String? | - | 文字内容 |


### TTabsBarView
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<Widget> | - | 子widget列表 |
| controller | TabController? | - | 控制器 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| physics | ScrollPhysics? | - | 滑动物理特性；未传时默认不可滑动。 |


### TTabsBarIndicator
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| indicatorColor | Color | - | 指示器颜色 |
| indicatorHeight | double? | - | 指示器高度 |
| indicatorWidth | double? | - | 指示器宽度 |
