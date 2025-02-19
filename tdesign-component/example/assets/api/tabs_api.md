## API
### TDTabBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| tabs | List<TDTab> | - | tab数组 |
| controller | TabController? | - | tab控制器 |
| decoration | Decoration? | - | tabBar修饰 |
| backgroundColor | Color? | - | tabBar背景色，当outlineType为card时控制选中tab颜色 |
| indicatorColor | Color? | - | tabBar下标颜色 |
| indicatorWidth | double? | - | tabBar下标宽度 |
| indicatorHeight | double? | - | tabBar下标高度 |
| labelColor | Color? | - | tabBar 已选标签颜色 |
| unselectedLabelColor | Color? | - | tabBar未选标签颜色 |
| isScrollable | bool | false | 是否滚动 |
| unselectedLabelStyle | TextStyle? | - | unselectedLabel字体 |
| labelStyle | TextStyle? | - | 已选label字体 |
| width | double? | - | tabBar宽度 |
| height | double? | - | tabBar高度 |
| indicatorPadding | EdgeInsets? | - | 引导padding |
| labelPadding | EdgeInsetsGeometry? | - | tab间距 |
| indicator | Decoration? | - | 自定义引导控件 |
| physics | ScrollPhysics? | - | 自定义滑动 |
| onTap |  Function(int)? | - | 点击事件 |
| outlineType | TDTabBarOutlineType | TDTabBarOutlineType.filled | 选项卡样式 |
| showIndicator | bool | false | 是否展示引导控件 |
| dividerColor | Color? | - | 分割线颜色 |
| dividerHeight | double | 0.5 | 分割线高度,小于等于0则不展示分割线 |
| selectedBgColor | Color? | - | 被选中背景色，只有outlineType为capsule时有效 |
| unSelectedBgColor | Color? | - | 未选中背景色，只有outlineType为capsule时有效 |
| tabAlignment |  | - |  |

```
```
 ### TDTabBarView
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| children | List<Widget> | - | 子widget列表 |
| controller | TabController? | - | 控制器 |
| isSlideSwitch | bool | false | 是否可以滑动切换 |

```
```
 ### TDTab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| text | String? | - | 文字内容 |
| child | Widget? | - | 子widget |
| icon | Widget? | - | 图标 |
| badge | TDBadge? | - | 图标 |
| height | double? | - | tab高度 |
| contentHeight | double? | - | 中间内容高度 |
| textMargin | EdgeInsetsGeometry? | - | 中间内容宽度 |
| size | TDTabSize | TDTabSize.small | 选项卡尺寸 |
| outlineType | TDTabOutlineType | TDTabOutlineType.filled | 选项卡样式 |
| enable | bool | true | 是否可用，默认true |
| iconMargin | EdgeInsetsGeometry | const EdgeInsets.only(bottom: 4.0, right: 4.0) | 图标间距 |
