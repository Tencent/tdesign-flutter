## API
### TIcon
#### 简介
TIcon 图标组件
Material `Icon` 的薄包装，提供 TDesign 默认颜色和组件级 Theme 注入能力。
图标数据由 `tdesign_flutter_icons` 资源包提供，通过 `TIcons.xxx` 常量引用。
优先级链：
构造器参数 > `TIconThemeData` > `IconTheme` > ThemeData.iconTheme >
TDesign token 颜色兜底。

#### 工厂构造方法

##### TIcon.fromName

通过图标名称构造，并在 `TIcons.allIconsMap` 中查找对应图标。
如果名称不存在，抛出 `ArgumentError`。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| name | String | - | 图标名称，对应 `TIcons.allIconsMap` 中的 key。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| size | double? | - | 图标尺寸，单位为逻辑像素。 未设置时依次读取 `TIconThemeData.size`、显式 `IconTheme`，最后由 Flutter 原生 `Icon` 使用其默认尺寸。 |
| color | Color? | - | 图标颜色。 未设置时依次读取 `TIconThemeData.color`、显式 `IconTheme`，最后回退到 TDesign 的 `textColorPrimary` Token。 |
| semanticLabel | String? | - | 无障碍语义标签。 非空时由原生 `Icon` 暴露给辅助技术；为空时图标不单独提供语义节点。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| icon | IconData | - | 要绘制的图标数据，通常使用 `tdesign_flutter_icons` 提供的 `TIcons.xxx`。 |
| color | Color? | - | 图标颜色。 未设置时依次读取 `TIconThemeData.color`、显式 `IconTheme`，最后回退到 TDesign 的 `textColorPrimary` Token。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| semanticLabel | String? | - | 无障碍语义标签。 非空时由原生 `Icon` 暴露给辅助技术；为空时图标不单独提供语义节点。 |
| size | double? | - | 图标尺寸，单位为逻辑像素。 未设置时依次读取 `TIconThemeData.size`、显式 `IconTheme`，最后由 Flutter 原生 `Icon` 使用其默认尺寸。 |


### TIconThemeData
#### 简介
TIcon 组件级 ThemeExtension
通过 Material Theme 子树注入，控制 `TIcon` 的默认尺寸和颜色。
未配置的字段继续回退显式 `IconTheme` 和 TDesign Token，不会覆盖其它组件主题。
`TIcon` 构造器参数始终具有最高优先级。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| color | Color? | - | 图标默认颜色；为空时回退显式 `IconTheme`，最终回退 `textColorPrimary` Token。 |
| size | double? | - | 图标默认尺寸，单位为逻辑像素；为空时回退显式 `IconTheme`。 |
