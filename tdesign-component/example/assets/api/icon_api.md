## API

### TIcon

TIcon 图标组件

Material `Icon` 的薄包装，提供 TDesign 默认尺寸和颜色。
图标数据由 `tdesign_flutter_icons` 资源包提供，通过 `TIcons.xxx` 常量引用。

构造器参数优先，其次使用 TDesign 组合组件的内部样式；独立使用时
默认尺寸为 24dp，默认颜色读取 TDesign 全局 Token。
外层 Material `IconTheme` 不控制 TDesign 图标。

#### 构造方法

##### TIcon

位置参数：`icon`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| icon | IconData | - | 要绘制的图标数据，通常使用 `tdesign_flutter_icons` 提供的 `TIcons.xxx`。 | 是 |
| color | Color? | - | 图标颜色。 未设置时读取 TDesign 的 `textColorPrimary` Token。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| semanticLabel | String? | - | 无障碍语义标签。 非空时由原生 `Icon` 暴露给辅助技术；为空时图标不单独提供语义节点。 | 否 |
| size | double? | - | 图标尺寸，单位为逻辑像素。 未设置时使用 24dp。 | 否 |


##### TIcon.fromName

位置参数：`name`


通过图标名称构造，并在 `TIcons.allIconsMap` 中查找对应图标。

如果名称不存在，抛出 `ArgumentError`。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| name | String | - | 图标名称，对应 `TIcons.allIconsMap` 中的 key。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| size | double? | - | 图标尺寸，单位为逻辑像素。 未设置时使用 24dp。 | 否 |
| color | Color? | - | 图标颜色。 未设置时读取 TDesign 的 `textColorPrimary` Token。 | 否 |
| semanticLabel | String? | - | 无障碍语义标签。 非空时由原生 `Icon` 暴露给辅助技术；为空时图标不单独提供语义节点。 | 否 |
