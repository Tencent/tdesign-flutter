## API
### BadgeConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| showBadge | bool | - | 是否展示消息 |
| tdBadge | TDBadge? | - | 消息样式(未设置但showBadge为true，则默认使用红点) |
| badgeTopOffset | double? | - | 消息顶部偏移量 |
| badgeRightOffset | double? | - | 消息右侧偏移量 |

```
```
 ### TDBottomTabBarTabConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| onTap | GestureTapCallback? | - | tab点击事件 |
| selectedIcon | Widget? | - | 选中时图标 |
| unselectedIcon | Widget? | - | 未选中时图标 |
| tabText | String? | - | tab文本 |
| selectTabTextStyle | TextStyle? | - | 文本已选择样式 basicType为text时必填 |
| unselectTabTextStyle | TextStyle? | - | 文本未选择样式 basicType为text时必填 |
| badgeConfig | BadgeConfig? | - | 消息配置 |
| popUpButtonConfig | TDBottomTabBarPopUpBtnConfig? | - | 弹窗配置 |
| onLongPress | GestureLongPressCallback? | - | 长按事件 |

```
```
 ### TDBottomTabBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| basicType | TDBottomTabBarBasicType | basicType | 基本样式（纯文本、纯图标、图标+文本） |
| key |  | - |  |
| componentType | TDBottomTabBarComponentType? | TDBottomTabBarComponentType.label | 选项样式 默认label |
| outlineType | TDBottomTabBarOutlineType? | TDBottomTabBarOutlineType.filled | 标签栏样式 默认filled |
| navigationTabs | List<TDBottomTabBarTabConfig> | - | tabs配置 |
| barHeight | double? | _kDefaultTabBarHeight | tab高度 |
| useVerticalDivider | bool? | - | 是否使用竖线分隔(如果选项样式为label则强制为false) |
| dividerHeight | double? | - | 分割线高度（可选） |
| dividerThickness | double? | - | 分割线厚度（可选） |
| dividerColor | Color? | - | 分割线颜色（可选） |
| showTopBorder | bool? | true | 是否展示bar上边线（设置为true 但是topBorder样式未设置，则使用默认值,非胶囊型才生效） |
| topBorder | BorderSide? | - | 上边线样式 |
| useSafeArea | bool | true | 使用安全区域 |
| selectedBgColor | Color? | - | 选中时背景颜色 |
| unselectedBgColor | Color? | - | 未选中时背景颜色 |
| backgroundColor | Color? | - | 背景颜色 （可选） |
| centerDistance | double? | - | icon与文本中间距离（可选） |
| currentIndex | int? | - | 选中的index（可选） |

```
```
 ### TDBottomTabBarPopUpBtnConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| items | List<PopUpMenuItem> | - | 选项list |
| onChanged | ValueChanged<String> | - | 统一在 onChanged 中处理各item点击事件 |
| popUpDialogConfig | TDBottomTabBarPopUpShapeConfig? | - | 弹窗UI配置 |

```
```
 ### TDBottomTabBarPopUpShapeConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| popUpWidth | double? | - | 弹窗宽度（不设置，默认为按钮宽度 - 20） |
| popUpitemHeight | double? | _kDefaultMenuItemHeight | 单个选项高度 所有选项等高 不设置则使用默认值 48 |
| backgroundColor | Color? | - | 弹窗背景颜色 |
| radius | double? | - | panel圆角 默认0 |
| arrowWidth | double? | - | 箭头宽度 默认13.5 |
| arrowHeight | double? | - | 箭头高度 默认8 |

```
```
 ### PopUpMenuItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| itemWidget | Widget? | - | 选项widget |
| value | String | - | 选项值 |
| alignment | AlignmentGeometry | AlignmentDirectional.center | 对齐方式 |
