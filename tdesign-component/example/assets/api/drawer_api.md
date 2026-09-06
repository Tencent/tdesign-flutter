## API
### TDrawer
#### 简介
TDesign 抽屉内容组件，可放入 `Scaffold.drawer` 或 `Scaffold.endDrawer`。
需要通过浮层展示时，使用 `showTDrawer`。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 组件背景颜色；优先级高于 ThemeData 和默认值。 |
| child | Widget? | - | 自定义内容，优先级高于`items`/`footer`/`title` |
| enableFeedback | bool | true | 点击时是否显示背景按压反馈，默认 true。 |
| footer | Widget? | - | 抽屉的底部 |
| items | List<TDrawerItem>? | - | 抽屉里的列表项 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onItemClick | TDrawerItemClickCallback? | - | 点击抽屉里的列表项触发 |
| showDivider | bool | true | 是否显示菜单项分隔线，默认 true。 |
| showLastDivider | bool | true | 是否显示最后一行分隔线，默认 true。 |
| title | Widget? | - | 抽屉的标题组件 |
| width | double? | - | 宽度；优先级高于 ThemeData，默认使用 280。 |


### TDrawerHandle
#### 简介
`showTDrawer` 返回的抽屉生命周期控制句柄。

### TDrawerThemeData
#### 简介
抽屉组件 ThemeExtension。
只保存子树级具体视觉默认值。方向、蒙层与展示生命周期由 `showTDrawer`
负责；分隔线和按压反馈由组件实例负责；构造器具体视觉参数优先级高于 ThemeData。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认背景颜色。 |
| dividerColor | Color? | - | 菜单项分隔线颜色。 |
| dividerIndent | double? | - | 菜单项分隔线起始缩进，默认 16。 |
| dividerThickness | double? | - | 菜单项分隔线厚度，默认 0.5。 |
| footerPadding | EdgeInsetsGeometry? | - | 底部区内边距，默认仅保留 20 的底边距。 |
| itemBackgroundColor | Color? | - | 菜单项背景色。 |
| itemIconColor | Color? | - | 菜单项图标颜色。 |
| itemIconGap | double? | - | 菜单项图标与正文间距，默认 8。 |
| itemIconSize | double? | - | 菜单项图标尺寸，默认 24。 |
| itemPadding | EdgeInsetsGeometry? | - | 菜单项内边距，默认 `EdgeInsets.fromLTRB(16, 16, 0, 16)`。 |
| itemPressedColor | Color? | - | 菜单项按压背景色。 |
| itemTextStyle | TextStyle? | - | 菜单正文样式。 |
| titlePadding | EdgeInsetsGeometry? | - | 标题内边距，默认 `EdgeInsets.fromLTRB(16, 24, 16, 8)`。 |
| titleStyle | TextStyle? | - | 抽屉标题样式。 |
| width | double? | - | 默认宽度，默认 280。 |


### TDrawerItem
#### 简介
抽屉里的列表项。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | Widget? | - | 自定义菜单项正文，优先于 `title`；仍与 `icon`、菜单项间距和分隔线组合。 |
| icon | Widget? | - | 每列图标 |
| title | String? | - | 每列标题 |


### showTDrawer
#### 顶层函数

通过 Popup 展示一个 `TDrawer`。
返回的 `TDrawerHandle` 可用于查询显示状态或主动关闭抽屉。

返回类型：`TDrawerHandle`

#### 参数

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找承载抽屉浮层的 Navigator。 |
| drawer | TDrawer | - | 只描述抽屉内容；方向、蒙层、顶部偏移和生命周期由本函数负责。 |
| placement | TDrawerPlacement | TDrawerPlacement.right | 控制抽屉从左侧或右侧滑出，默认从右侧滑出。 |
| showOverlay | bool | true | 控制是否显示蒙层，默认 true。 |
| closeOnOverlayClick | bool | true | 控制点击蒙层时是否关闭抽屉，默认 true。 |
| onOverlayClick | VoidCallback? | - | 在蒙层被点击时触发，不受是否自动关闭影响。 |
| topInset | double? | - | 设置抽屉相对屏幕顶部的可选偏移，默认 0。 |
| useSafeArea | bool | true | 控制浮层是否避让系统安全区域，默认 true。 |
| destroyOnClose | bool | false | 控制关闭后是否立即销毁浮层路由，默认 false。 |
| onClose | VoidCallback? | - | 在抽屉浮层关闭后触发。 |


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
`index` 是列表下标，`item` 是被点击的配置项。
#### 类型定义

```dart
typedef TDrawerItemClickCallback = void Function(int index, TDrawerItem item);
```
