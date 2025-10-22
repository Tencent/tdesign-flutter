## API
### TDTab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TDBadge? | - | 图标 |
| child | Widget? | - | 子widget |
| contentHeight | double? | - | 中间内容高度 |
| enable | bool | true | 是否可用，默认true |
| height | double? | - | tab高度 |
| icon | Widget? | - | 图标 |
| iconMargin | EdgeInsetsGeometry | const EdgeInsets.only(bottom: 4.0, right: 4.0) | 图标间距 |
| key |  | - |  |
| outlineType | TDTabOutlineType | TDTabOutlineType.filled | 选项卡样式 |
| size | TDTabSize | TDTabSize.small | 选项卡尺寸 |
| text | String? | - | 文字内容 |
| textMargin | EdgeInsetsGeometry? | - | 中间内容宽度 |

```
```
 ### TDTabBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | tabBar背景色，当outlineType为card时控制选中tab颜色 |
| controller | TabController? | - | tab控制器 |
| decoration | Decoration? | - | tabBar修饰 |
| dividerColor | Color? | - | 分割线颜色 |
| dividerHeight | double | 0.5 | 分割线高度,小于等于0则不展示分割线 |
| height | double? | - | tabBar高度 |
| indicator | Decoration? | - | 自定义引导控件 |
| indicatorColor | Color? | - | tabBar下标颜色 |
| indicatorHeight | double? | - | tabBar下标高度 |
| indicatorPadding | EdgeInsets? | - | 引导padding |
| indicatorWidth | double? | - | tabBar下标宽度 |
| isScrollable | bool | false | 是否滚动 |
| key |  | - |  |
| labelColor | Color? | - | tabBar 已选标签颜色 |
| labelPadding | EdgeInsetsGeometry? | - | tab间距 |
| labelStyle | TextStyle? | - | 已选label字体 |
| onTap |  Function(int)? | - | 点击事件 |
| outlineType | TDTabBarOutlineType | TDTabBarOutlineType.filled | 选项卡样式 |
| physics | ScrollPhysics? | - | 自定义滑动 |
| selectedBgColor | Color? | - | 被选中背景色，只有outlineType为capsule时有效 |
| showIndicator | bool | false | 是否展示引导控件 |
| tabAlignment |  | - |  |
| tabs | List<TDTab> | - | tab数组 |
| unSelectedBgColor | Color? | - | 未选中背景色，只有outlineType为capsule时有效 |
| unselectedLabelColor | Color? | - | tabBar未选标签颜色 |
| unselectedLabelStyle | TextStyle? | - | unselectedLabel字体 |
| width | double? | - | tabBar宽度 |

```
```
 ### TDTabBarView
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<Widget> | - | 子widget列表 |
| controller | TabController? | - | 控制器 |
| isSlideSwitch | bool | false | 是否可以滑动切换 |
| key |  | - |  |
