## API

### TDrawer

#### 构造方法

##### TDrawer

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

`showTDrawer` 返回的抽屉生命周期控制句柄。

#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| isShowing | bool | - | 当前抽屉是否仍显示在路由中。 | - |


#### 实例方法

##### TDrawerHandle.close

无参数。

关闭当前抽屉；重复调用安全。

### TDrawerItem

抽屉里的列表项。

#### 构造方法

##### TDrawerItem

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| content | Widget? | - | 自定义菜单项正文，优先于 `title`；仍与 `icon`、菜单项间距和分隔线组合。 | 否 |
| icon | Widget? | - | 每列图标 | 否 |
| title | String? | - | 每列标题 | 否 |


### TDrawerPlacement

抽屉方向。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| left | TDrawerPlacement | - | 从左侧滑出。 | - |
| right | TDrawerPlacement | - | 从右侧滑出。 | - |


### TDrawerItemClickCallback

点击抽屉列表项时的回调。

位置参数：`index, item`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| index | int | - | 被点击项在列表中的索引，从 0 开始。 | 是 |
| item | TDrawerItem | - | 被点击的配置项。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | void | - | 无返回值。 | - |


### TDrawerThemeData

抽屉组件 ThemeExtension。

只保存子树级具体视觉默认值。方向、蒙层与展示生命周期由 `showTDrawer`
负责；分隔线和按压反馈由组件实例负责；构造器具体视觉参数优先级高于 ThemeData。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认背景颜色。 | 否 |
| dividerColor | Color? | - | 菜单项分隔线颜色。 null 时使用 componentStroke Token。 | 否 |
| dividerIndent | double? | - | 菜单项分隔线起始缩进，默认 16。 | 否 |
| dividerThickness | double? | - | 菜单项分隔线厚度，默认 0.5。 | 否 |
| footerPadding | EdgeInsetsGeometry? | - | 底部区内边距，默认仅保留 20 的底边距。 | 否 |
| itemBackgroundColor | Color? | - | 菜单项背景色。 null 时沿用抽屉实际面板背景色。 | 否 |
| itemIconColor | Color? | - | 菜单项图标颜色。 null 时使用 textColorPrimary Token。 | 否 |
| itemIconGap | double? | - | 菜单项图标与正文间距，默认 8。 | 否 |
| itemIconSize | double? | - | 菜单项图标尺寸；为空时读取 size8，默认 24。 | 否 |
| itemPadding | EdgeInsetsGeometry? | - | 菜单项内边距，默认 `EdgeInsets.fromLTRB(16, 16, 0, 16)`。 | 否 |
| itemPressedColor | Color? | - | 菜单项按压背景色。 null 时使用 bgColorSecondaryContainer Token。 | 否 |
| itemTextStyle | TextStyle? | - | 菜单正文样式。 | 否 |
| titlePadding | EdgeInsetsGeometry? | - | 标题内边距，默认 `EdgeInsets.fromLTRB(16, 24, 16, 8)`。 | 否 |
| titleStyle | TextStyle? | - | 抽屉标题样式。 | 否 |
| width | double? | - | 默认宽度，默认 280。 | 否 |
