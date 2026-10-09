## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TDrawer
#### 简介
TDesign 抽屉内容组件，可放入 `Scaffold.drawer` 或 `Scaffold.endDrawer`。
需要通过浮层展示时，使用 `showTDrawer`。
### 主题配置
组件主题通过 `TDrawerThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TDrawerThemeData` 说明。

#### 声明

```dart
class TDrawer extends StatelessWidget
```

#### 默认构造方法


```dart
const TDrawer({
  super.key,
  this.showDivider = true,
  this.footer,
  this.items,
  this.enableFeedback = true,
  this.showLastDivider = true,
  this.title,
  this.onItemClick,
  this.child,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget? | - | 自定义内容，优先级高于`items`/`footer`/`title` | 否 |
| enableFeedback | bool | true | 点击时是否显示背景按压反馈，默认 true。 | 否 |
| footer | Widget? | - | 抽屉的底部 | 否 |
| items | List&lt;TDrawerItem&gt;? | - | 抽屉里的列表项 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onItemClick | TDrawerItemClickCallback? | - | 点击抽屉里的列表项触发 | 否 |
| showDivider | bool | true | 是否显示菜单项分隔线，默认 true。 | 否 |
| showLastDivider | bool | true | 是否显示最后一行分隔线，默认 true。 | 否 |
| title | Widget? | - | 抽屉的标题组件 | 否 |


### TDrawerHandle
#### 简介
`showTDrawer` 返回的抽屉生命周期控制句柄。

#### 声明

```dart
class TDrawerHandle
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| isShowing | bool | - | 当前抽屉是否仍显示在路由中。 |


#### 实例方法

##### TDrawerHandle.close

```dart
void close()
```


关闭当前抽屉；重复调用安全。

返回类型：`void`

### TDrawerThemeData
#### 简介
抽屉组件 ThemeExtension。
只保存子树级具体视觉默认值。方向、蒙层与展示生命周期由 `showTDrawer`
负责；分隔线和按压反馈由组件实例负责；构造器具体视觉参数优先级高于 ThemeData。

#### 声明

```dart
class TDrawerThemeData extends ThemeExtension<TDrawerThemeData>
```

#### 默认构造方法


```dart
const TDrawerThemeData({
  this.width,
  this.backgroundColor,
  this.titleStyle,
  this.titlePadding,
  this.itemTextStyle,
  this.itemBackgroundColor,
  this.itemPressedColor,
  this.itemPadding,
  this.itemIconColor,
  this.itemIconSize,
  this.itemIconGap,
  this.dividerColor,
  this.dividerIndent,
  this.dividerThickness,
  this.footerPadding,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认背景颜色。 | 否 |
| dividerColor | Color? | - | 菜单项分隔线颜色。 null 时使用 componentStroke Token。 | 否 |
| dividerIndent | double? | - | 菜单项分隔线起始缩进，默认 16。 | 否 |
| dividerThickness | double? | - | 菜单项分隔线厚度，默认 0.5。 | 否 |
| footerPadding | EdgeInsetsGeometry? | - | 底部区内边距，默认仅保留 20 的底边距。 | 否 |
| itemBackgroundColor | Color? | - | 菜单项背景色。 null 时沿用抽屉实际面板背景色。 | 否 |
| itemIconColor | Color? | - | 菜单项图标颜色。 null 时使用 textColorPrimary Token。 | 否 |
| itemIconGap | double? | - | 菜单项图标与正文间距，默认 8。 | 否 |
| itemIconSize | double? | - | 菜单项图标尺寸，默认 24。 | 否 |
| itemPadding | EdgeInsetsGeometry? | - | 菜单项内边距，默认 `EdgeInsets.fromLTRB(16, 16, 0, 16)`。 | 否 |
| itemPressedColor | Color? | - | 菜单项按压背景色。 null 时使用 bgColorSecondaryContainer Token。 | 否 |
| itemTextStyle | TextStyle? | - | 菜单正文样式。 | 否 |
| titlePadding | EdgeInsetsGeometry? | - | 标题内边距，默认 `EdgeInsets.fromLTRB(16, 24, 16, 8)`。 | 否 |
| titleStyle | TextStyle? | - | 抽屉标题样式。 | 否 |
| width | double? | - | 默认宽度，默认 280。 | 否 |


#### 实例方法

##### TDrawerThemeData.copyWith

```dart
TDrawerThemeData copyWith({
  double? width,
  Color? backgroundColor,
  TextStyle? titleStyle,
  EdgeInsetsGeometry? titlePadding,
  TextStyle? itemTextStyle,
  Color? itemBackgroundColor,
  Color? itemPressedColor,
  EdgeInsetsGeometry? itemPadding,
  Color? itemIconColor,
  double? itemIconSize,
  double? itemIconGap,
  Color? dividerColor,
  double? dividerIndent,
  double? dividerThickness,
  EdgeInsetsGeometry? footerPadding,
})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TDrawerThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| width | double? | - | 默认宽度，默认 280。 | 否 |
| backgroundColor | Color? | - | 默认背景颜色。 | 否 |
| titleStyle | TextStyle? | - | 抽屉标题样式。 | 否 |
| titlePadding | EdgeInsetsGeometry? | - | 标题内边距，默认 `EdgeInsets.fromLTRB(16, 24, 16, 8)`。 | 否 |
| itemTextStyle | TextStyle? | - | 菜单正文样式。 | 否 |
| itemBackgroundColor | Color? | - | 菜单项背景色。 null 时沿用抽屉实际面板背景色。 | 否 |
| itemPressedColor | Color? | - | 菜单项按压背景色。 null 时使用 bgColorSecondaryContainer Token。 | 否 |
| itemPadding | EdgeInsetsGeometry? | - | 菜单项内边距，默认 `EdgeInsets.fromLTRB(16, 16, 0, 16)`。 | 否 |
| itemIconColor | Color? | - | 菜单项图标颜色。 null 时使用 textColorPrimary Token。 | 否 |
| itemIconSize | double? | - | 菜单项图标尺寸，默认 24。 | 否 |
| itemIconGap | double? | - | 菜单项图标与正文间距，默认 8。 | 否 |
| dividerColor | Color? | - | 菜单项分隔线颜色。 null 时使用 componentStroke Token。 | 否 |
| dividerIndent | double? | - | 菜单项分隔线起始缩进，默认 16。 | 否 |
| dividerThickness | double? | - | 菜单项分隔线厚度，默认 0.5。 | 否 |
| footerPadding | EdgeInsetsGeometry? | - | 底部区内边距，默认仅保留 20 的底边距。 | 否 |


##### TDrawerThemeData.lerp

```dart
TDrawerThemeData lerp(ThemeExtension<TDrawerThemeData>? other, double t)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TDrawerThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TDrawerThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TDrawerItem
#### 简介
抽屉里的列表项。

#### 声明

```dart
class TDrawerItem
```

#### 默认构造方法


```dart
const TDrawerItem({this.title, this.icon, this.content})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| content | Widget? | - | 自定义菜单项正文，优先于 `title`；仍与 `icon`、菜单项间距和分隔线组合。 | 否 |
| icon | Widget? | - | 每列图标 | 否 |
| title | String? | - | 每列标题 | 否 |


### showTDrawer
#### 顶层函数

通过 Popup 展示一个 `TDrawer`。
被其他不透明路由覆盖时可释放内容 State。关闭路由后内容始终会释放。
返回的 `TDrawerHandle` 可用于查询显示状态或主动关闭抽屉。
## 返回值
已经发起打开的抽屉控制句柄，可用于查询状态与关闭抽屉。

返回类型：`TDrawerHandle`

```dart
TDrawerHandle showTDrawer( BuildContext context, { required TDrawer drawer, TDrawerPlacement placement = TDrawerPlacement.right, bool showOverlay = true, bool closeOnOverlayClick = true, VoidCallback? onOverlayClick, double? topInset, bool useSafeArea = true, bool destroyOnClose = false, VoidCallback? onClose, })
```


#### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找承载抽屉浮层的 Navigator。 | 是 |
| drawer | TDrawer | - | 只描述抽屉内容；方向、蒙层、顶部偏移和生命周期由本函数负责。 | 是 |
| placement | TDrawerPlacement | TDrawerPlacement.right | 控制抽屉从左侧或右侧滑出，默认从右侧滑出。 | 否 |
| showOverlay | bool | true | 控制是否显示蒙层，默认 true。 | 否 |
| closeOnOverlayClick | bool | true | 控制点击蒙层时是否关闭抽屉，默认 true。 | 否 |
| onOverlayClick | VoidCallback? | - | 在蒙层被点击时触发，不受是否自动关闭影响。 | 否 |
| topInset | double? | - | 设置抽屉相对屏幕顶部的可选偏移，默认 0，必须大于或等于 0。 | 否 |
| useSafeArea | bool | true | 控制浮层是否避让系统安全区域，默认 true。 | 否 |
| destroyOnClose | bool | false | 默认 false；为 true 时路由 maintainState 为 false， | 否 |
| onClose | VoidCallback? | - | 在抽屉浮层关闭后触发。 | 否 |


### TDrawerPlacement
#### 简介
抽屉方向。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 从左侧滑出。 |
| right | 从右侧滑出。 |


### TDrawerItemClickCallback
#### 简介
点击抽屉列表项时的回调。
`index` 被点击项在列表中的索引，从 0 开始。
`item` 被点击的配置项。
## 返回值
无返回值。
#### 类型定义

```dart
typedef TDrawerItemClickCallback = void Function(int index, TDrawerItem item);
```
