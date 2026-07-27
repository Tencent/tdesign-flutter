## API
### TTabBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationCurve | Curve? | - | 动画曲线 |
| animationDuration | Duration? | - | 动画时长 |
| backgroundColor | Color? | - | 背景颜色 （可选） |
| barHeight | double? | - | tab高度 |
| centerDistance | double? | - | icon与文本中间距离（可选） |
| dividerColor | Color? | - | 分割线颜色（可选） |
| dividerHeight | double? | - | 分割线高度（可选） |
| dividerThickness | double? | - | 分割线厚度（可选） |
| indicatorAnimation | TTabBarIndicatorAnimation | TTabBarIndicatorAnimation.none | 指示器动画类型 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| navigationTabs | List<TTabBarItemConfig> | - | tabs配置 |
| needInkWell | bool? | - | 是否需要水波纹效果 |
| onChanged | ValueChanged<int>? | - | 选中项变化；null 时整栏禁用 |
| placeholder | bool | true | 是否添加安全区域占位 |
| selectedBgColor | Color? | - | 选中时背景颜色 |
| showTopBorder | bool? | - | 是否展示bar上边线（设置为true 但是topBorder样式未设置，则使用默认值，非胶囊型才生效） |
| topBorder | BorderSide? | - | 上边线样式 |
| unselectedBgColor | Color? | - | 未选中时背景颜色 |
| useSafeArea | bool | true | 使用安全区域 |
| useVerticalDivider | bool? | - | 是否使用竖线分隔（如果选项样式为 label，则强制为 false） |
| value | int | - | 选中的 index |
| variant | TTabBarVariant | - | 标签栏形态 |


### TTabBarBadgeConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badgeRightOffset | double? | - | 消息右侧偏移量 |
| badgeTopOffset | double? | - | 消息顶部偏移量 |
| showBadge | bool | - | 是否展示消息 |
| tBadge | TBadge? | - | 消息样式（未设置但 showBadge 为 true，则默认使用红点） |


### TTabBarItemConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| allowMultipleTaps | bool | false | onTap 方法允许点击多次 |
| badgeConfig | TTabBarBadgeConfig? | - | 消息配置 |
| onLongPress | GestureLongPressCallback? | - | 长按事件 |
| onTap | GestureTapCallback? | - | tab点击事件 |
| popUpButtonConfig | TTabBarPopUpBtnConfig? | - | 弹窗配置 |
| selectedIcon | Widget? | - | 选中时图标 |
| selectTabTextStyle | TextStyle? | - | 文本已选择样式 basicType为text时必填 |
| tabText | String? | - | tab 文本 |
| unselectedIcon | Widget? | - | 未选中时图标 |
| unselectTabTextStyle | TextStyle? | - | 文本未选择样式 basicType为text时必填 |


### TTabBarPopUpBtnConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| items | List<TTabBarMenuItem> | - | 选项list |
| onChanged | ValueChanged<String> | - | 统一在 onChanged 中处理各item点击事件 |
| popUpDialogConfig | TTabBarPopUpShapeConfig? | - | 弹窗UI配置 |


### TTabBarPopUpShapeConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowHeight | double? | - | 箭头高度 默认8 |
| arrowWidth | double? | - | 箭头宽度 默认13.5 |
| backgroundColor | Color? | - | 弹窗背景颜色 |
| popUpItemHeight | double? | _kDefaultMenuItemHeight | 单个选项高度 所有选项等高 不设置则使用默认值 48 |
| popUpWidth | double? | - | 弹窗宽度（不设置，默认为按钮宽度 - 20） |
| radius | double? | - | panel圆角 默认0 |


### TTabBarMenuItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | AlignmentGeometry | AlignmentDirectional.center | 对齐方式 |
| itemWidget | Widget? | - | 选项widget |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| value | String | - | 选项值 |


### TTabBarVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| text | 单层级纯文本标签栏 |
| iconText | 文本加图标标签栏 |
| icon | 纯图标标签栏 |
| expansionPanel | 双层级纯文本标签栏 |
| weakText | 弱选中纯文本标签栏 |
| weakIcon | 弱选中纯图标标签栏 |
| weakIconText | 弱选中文本加图标标签栏 |
| capsule | 胶囊文本加图标标签栏 |


### TTabBarIndicatorAnimation
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| none | 无动画，瞬间切换 |
| linear | 线性滑动：指示器匀速从一个 tab 滑到另一个 |
| elastic | 弹性动画：指示器先拉伸后收缩 |
