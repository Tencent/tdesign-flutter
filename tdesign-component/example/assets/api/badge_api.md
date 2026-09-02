## API
### TBadge
#### 简介
在内容边角或独立位置展示短文本、圆点或角标状态。
默认使用 `TBadgeVariant.normal` 与 `TBadgeSize.medium`。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| border | bool | false | 是否为徽标增加对比色描边，默认为 false，适用于全部形态。 |
| child | Widget? | - | 被徽标标记的内容；为空时徽标可独立展示。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | '0' | 徽标实际展示的短文本，例如 `8`、`99+` 或 `NEW`。 文本形态下为 null 时隐藏徽标；`TBadgeVariant.dot` 不读取该字段。 |
| offset | Offset? | - | 相对默认锚点的逐实例位置偏移；未设置时读取 `BadgeThemeData.offset`。 |
| onTap | GestureTapCallback? | - | 点击徽标及其 `child` 时触发；为空时不创建点击语义。 |
| showZero | bool | true | `label` 恰好为字符串 `0` 时是否显示徽标，默认为 true。 `TBadgeVariant.dot` 始终显示，不受该字段影响。 |
| size | TBadgeSize | TBadgeSize.medium | 徽标的预设尺寸，默认为 `TBadgeSize.medium`。 |
| variant | TBadgeVariant | TBadgeVariant.normal | 徽标的结构形态，默认为 `TBadgeVariant.normal`。 |


### TBadgeThemeData
#### 简介
Material `BadgeThemeData` 未覆盖的 TDesign 徽标视觉默认值。
只保存描边的视觉默认值，不保存形态、尺寸、内容或交互状态。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| borderColor | Color? | - | 开启描边时使用的颜色；为空时回退到当前容器背景色。 |
| borderWidth | double? | - | 开启描边时使用的宽度；为空时使用 1 逻辑像素。 |


### TBadgeVariant
#### 简介
徽标的结构形态；尺寸与描边分别由 `TBadge.size`、`TBadge.border` 控制。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 标准文本徽标；单字符呈圆形，多字符随内容扩展为胶囊形。 |
| dot | 不显示文本的圆点徽标，默认直径为 8 逻辑像素。 |
| square | 小圆角方形文本徽标；多字符时随内容横向扩展为矩形。 |
| bubble | 左下角收紧、其余角为圆角的气泡徽标。 |
| ribbonRight | 位于内容物理右上角的带状角标；RTL 下不交换方位。 |
| ribbonLeft | 位于内容物理左上角的带状角标；RTL 下不交换方位。 |
| triangleRight | 位于内容物理右上角的三角角标；RTL 下不交换方位。 |
| triangleLeft | 位于内容物理左上角的三角角标；RTL 下不交换方位。 |


### TBadgeSize
#### 简介
徽标的预设尺寸，控制文字 Token 与标签行盒高度。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| medium | 中尺寸，使用 `fontMarkExtraSmall` 与 16 逻辑像素标签行盒。 |
| large | 大尺寸，使用 `fontMarkSmall` 与 20 逻辑像素标签行盒。 |
