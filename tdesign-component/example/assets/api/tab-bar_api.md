## API
### TBottomTabBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| basicType | TBottomTabBarBasicType | - | 基本样式（纯文本、纯图标、图标+文本） |
| animationCurve | Curve | Curves.easeInOutCubic | 动画曲线 |
| animationDuration | Duration | const Duration(milliseconds: 300) | 动画时长 |
| backgroundColor | Color? | - | 背景颜色 （可选） |
| barHeight | double? | _kDefaultTabBarHeight | tab高度 |
| centerDistance | double? | - | icon与文本中间距离（可选） |
| componentType | TBottomTabBarComponentType? | TBottomTabBarComponentType.label | 选项样式 默认label |
| currentIndex | int? | - | 选中的index（可选） |
| dividerColor | Color? | - | 分割线颜色（可选） |
| dividerHeight | double? | - | 分割线高度（可选） |
| dividerThickness | double? | - | 分割线厚度（可选） |
| indicatorAnimation | TBottomTabBarIndicatorAnimation | TBottomTabBarIndicatorAnimation.none | 指示器动画类型 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| navigationTabs | List<TBottomTabBarTabConfig> | - | tabs配置 |
| needInkWell | bool | false | 是否需要水波纹效果 |
| outlineType | TBottomTabBarOutlineType? | TBottomTabBarOutlineType.filled | 标签栏样式 默认filled |
| placeholder | bool | true | 是否添加安全区域占位 |
| selectedBgColor | Color? | - | 选中时背景颜色 |
| showTopBorder | bool? | true | 是否展示bar上边线（设置为true 但是topBorder样式未设置，则使用默认值，非胶囊型才生效） |
| topBorder | BorderSide? | - | 上边线样式 |
| unselectedBgColor | Color? | - | 未选中时背景颜色 |
| useSafeArea | bool | true | 使用安全区域 |
| useVerticalDivider | bool? | - | 是否使用竖线分隔（如果选项样式为 label，则强制为 false） |


### BadgeConfig
#### 简介
飘新配置
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badgeRightOffset | double? | - | 消息右侧偏移量 |
| badgeTopOffset | double? | - | 消息顶部偏移量 |
| showBadge | bool | - | 是否展示消息 |
| tBadge | TBadge? | - | 消息样式（未设置但 showBadge 为 true，则默认使用红点） |


### TBottomTabBarTabConfig
#### 简介
单个 tab 配置
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| allowMultipleTaps | bool | false | onTap 方法允许点击多次 |
| badgeConfig | BadgeConfig? | - | 消息配置 |
| onLongPress | GestureLongPressCallback? | - | 长按事件 |
| onTap | GestureTapCallback? | - | tab点击事件 |
| popUpButtonConfig | TBottomTabBarPopUpBtnConfig? | - | 弹窗配置 |
| selectedIcon | Widget? | - | 选中时图标 |
| selectTabTextStyle | TextStyle? | - | 文本已选择样式 basicType为text时必填 |
| tabText | String? | - | tab 文本 |
| unselectedIcon | Widget? | - | 未选中时图标 |
| unselectTabTextStyle | TextStyle? | - | 文本未选择样式 basicType为text时必填 |


### TBottomTabBarPopUpBtnConfig
#### 简介
展开项配置
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| items | List<PopUpMenuItem> | - | 选项list |
| onChanged | ValueChanged<String> | - | 统一在 onChanged 中处理各item点击事件 |
| popUpDialogConfig | TBottomTabBarPopUpShapeConfig? | - | 弹窗UI配置 |


### TBottomTabBarPopUpShapeConfig
#### 简介
弹窗UI配置
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowHeight | double? | - | 箭头高度 默认8 |
| arrowWidth | double? | - | 箭头宽度 默认13.5 |
| backgroundColor | Color? | - | 弹窗背景颜色 |
| popUpItemHeight | double? | _kDefaultMenuItemHeight | 单个选项高度 所有选项等高 不设置则使用默认值 48 |
| popUpWidth | double? | - | 弹窗宽度（不设置，默认为按钮宽度 - 20） |
| radius | double? | - | panel圆角 默认0 |


### PopUpMenuItem
#### 简介
弹窗菜单item
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | AlignmentGeometry | AlignmentDirectional.center | 对齐方式 |
| itemWidget | Widget? | - | 选项widget |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| value | String | - | 选项值 |


### TBottomTabBarBasicType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| text | 单层级纯文本标签栏 |
| iconText | 文本加图标标签栏 |
| icon | 纯图标标签栏 |
| expansionPanel | 双层级纯文本标签栏 |


### TBottomTabBarComponentType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 普通样式 |
| label | 带胶囊背景的item选中样式 |


### TBottomTabBarOutlineType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| filled | 填充样式 |
| capsule | 胶囊样式 |


### TBottomTabBarIndicatorAnimation
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| none | 无动画，瞬间切换 |
| linear | 线性滑动：指示器匀速从一个 tab 滑到另一个 |
| elastic | 弹性动画：指示器先拉伸后收缩 |
