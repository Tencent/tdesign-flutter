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
| itemStyle | TTabBarItemStyle | TTabBarItemStyle.label | 单个标签项的选中样式。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| navigationTabs | List<TTabBarItemConfig> | - | tabs配置 |
| needInkWell | bool | false | 是否需要水波纹效果 |
| onChanged | ValueChanged<int>? | - | 选中项变化；null 时整栏禁用 |
| placeholder | bool | true | 是否添加安全区域占位 |
| selectedBgColor | Color? | - | 选中时背景颜色 |
| showTopBorder | bool | true | 是否展示bar上边线（设置为true 但是topBorder样式未设置，则使用默认值，非胶囊型才生效） |
| split | bool | false | 是否使用竖线分隔；`itemStyle` 为 `TTabBarItemStyle.label` 时不显示。 |
| style | TTabBarStyle | TTabBarStyle.filled | 标签栏容器样式。 |
| topBorder | BorderSide? | - | 上边线样式 |
| type | TTabBarType | - | 标签栏内容类型。 |
| unselectedBgColor | Color? | - | 未选中时背景颜色 |
| useSafeArea | bool | true | 使用安全区域 |
| value | int | - | 选中的 index |


### TTabBarItemConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| allowMultipleTaps | bool | false | 是否允许重复点击当前选中项时再次调用 `onTap`，默认为 false。 该字段不影响点击未选中项，也不会让 `TTabBar.onChanged` 重复通知当前值。 |
| badge | TBadgeConfig? | - | 展示在标签内容右上角的徽标；为空时不显示。 徽标内容和样式由 `TBadgeConfig` 描述，`TBadgeConfig.offset` 可用于逐项 调整默认位置。纯文本项未设置实例或 BadgeTheme offset 时使用 TabBar 的 文本徽标默认位置；纯图标项与图文项均以图标作为锚点，使用徽标的默认 右上角位置， 图文项下方的文字宽度不会改变徽标位置。 TabBar 自己拥有徽标锚点与点击区域；点击行为通过 `onTap` 配置。调用方 已经拥有目标 Widget 时，应直接使用 `TBadge` 包装该 Widget。 |
| onLongPress | GestureLongPressCallback? | - | 长按事件 |
| onTap | GestureTapCallback? | - | 标签项被选中时的附加点击回调。 点击未选中项时，在 `TTabBar.onChanged` 之前调用；重复点击当前选中项时， 仅当 `allowMultipleTaps` 为 true 才调用。整栏禁用时不会调用。 |
| popUpButtonConfig | TTabBarPopUpBtnConfig? | - | 弹窗配置 |
| selectedIcon | Widget? | - | 选中时图标 |
| selectTabTextStyle | TextStyle? | - | 选中时的文字样式，按字段覆盖继承主题与内置默认值。 |
| tabText | String? | - | tab 文本 |
| unselectedIcon | Widget? | - | 未选中时图标 |
| unselectTabTextStyle | TextStyle? | - | 未选中时的文字样式，按字段覆盖继承主题与内置默认值。 |


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
| popUpWidth | double? | - | 弹窗宽度。 不设置时使用 `max(107, 标签项宽度 - 20)`；显式设置时覆盖该默认值。 |
| radius | double? | - | panel圆角 默认0 |


### TTabBarMenuItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | AlignmentGeometry | AlignmentDirectional.center | 对齐方式 |
| itemWidget | Widget? | - | 选项widget |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| value | String | - | 选项值 |


### TTabBarType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| text | 纯文本标签栏。 |
| iconText | 图标加文本标签栏。 |
| icon | 纯图标标签栏。 |
| doubleLayer | 带弹出菜单的双层级文本标签栏。 |


### TTabBarItemStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 仅改变前景色。 |
| label | 使用浅色胶囊背景强调选中项。 |


### TTabBarStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| filled | 铺满父容器。 |
| capsule | 带外边距、圆角和阴影的悬浮胶囊。 |


### TTabBarIndicatorAnimation
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| none | 无动画，瞬间切换 |
| linear | 线性滑动：指示器匀速从一个 tab 滑到另一个 |
| elastic | 弹性动画：指示器先拉伸后收缩 |
