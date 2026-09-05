## API
### TDrawer
#### 简介
命令式抽屉组件。
调用 `show` 打开抽屉，并使用返回的 `TDrawerHandle` 查询或关闭当前展示周期。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| child | Widget? | - | 自定义内容，优先级高于`items`/`footer`/`title` |
| closeOnOverlayClick | bool | true | 点击可见蒙层时是否关闭抽屉，默认 true。 |
| destroyOnClose | bool | false | 关闭后是否销毁 Popup 路由内状态，默认 false。 |
| drawerTop | double? | - | 距离顶部的距离，默认 0；组件参数优先于默认值。 |
| footer | Widget? | - | 抽屉的底部 |
| items | List<TDrawerItem>? | - | 抽屉里的列表项 |
| onClose | VoidCallback? | - | 当前展示周期真正结束时触发。 |
| onItemClick | TDrawerItemClickCallback? | - | 点击抽屉里的列表项触发 |
| onOverlayClick | VoidCallback? | - | 点击可见蒙层时触发。 是否同时关闭由 `closeOnOverlayClick` 决定。 |
| placement | TDrawerPlacement | TDrawerPlacement.right | 抽屉方向，默认 `TDrawerPlacement.right`。 |
| showOverlay | bool | true | 是否显示可见遮罩层，默认 true。 |
| title | Widget? | - | 抽屉的标题组件 |
| useSafeArea | bool | true | 是否避让系统安全区域，默认 true。 |
| width | double? | - | 宽度；优先级高于 ThemeData，默认使用 280。 |


### TDrawerHandle
#### 简介
`TDrawer.show` 返回的抽屉生命周期控制句柄。

### TDrawerThemeData
#### 简介
抽屉组件 ThemeExtension。
只保存子树级具体视觉默认值。方向、蒙层、边框开关、末行边框和按压反馈
由组件实例唯一拥有；构造器具体视觉参数优先级高于 ThemeData。
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


### TDrawerWidget
#### 简介
抽屉内容组件，可用于 Scaffold 的 `drawer` 属性。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 组件背景颜色；优先级高于 ThemeData 和默认值。 |
| bordered | bool | true | 是否显示菜单项分隔线，默认 true。 |
| child | Widget? | - | 自定义内容，优先级高于`items`/`footer`/`title` |
| enableFeedback | bool | true | 点击时是否显示背景按压反馈，默认 true。 |
| footer | Widget? | - | 抽屉的底部 |
| isShowLastBordered | bool | true | 是否显示最后一行分隔线，默认 true。 |
| items | List<TDrawerItem>? | - | 抽屉里的列表项 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onItemClick | TDrawerItemClickCallback? | - | 点击抽屉里的列表项触发 |
| title | Widget? | - | 抽屉的标题组件 |
| width | double? | - | 宽度；优先级高于 ThemeData，默认使用 280。 |


### TDrawerItem
#### 简介
抽屉里的列表项。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | Widget? | - | 完全自定义 |
| icon | Widget? | - | 每列图标 |
| title | String? | - | 每列标题 |


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
