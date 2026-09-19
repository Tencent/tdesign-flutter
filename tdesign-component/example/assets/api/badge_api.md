## API
### TBadge
#### 简介
在内容边角或独立位置展示短文本、圆点或角标状态。
默认使用 `TBadgeVariant.circle` 与 `TBadgeSize.medium`。当 `child` 非空时，
徽标叠加在 `child` 上；当 `child` 为空时，只渲染徽标本体。
TabBar、SideBar、ActionSheet 等内部拥有锚点的组合组件使用
`TBadgeConfig`，调用方不应向这些组件传入一个待拆解的 `TBadge`。

#### 工厂构造方法

##### TBadge.custom

创建完全自定义外观的徽标；`badge` 是徽标本体，`child` 是可选锚点，未提供锚点时直接展示徽标本体。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| badge | Widget? | - | `TBadge.custom` 提供的完整徽标外观。 普通构造下为 null。该 Widget 仅表示徽标本体，不包含 `child`。 |
| alignment | AlignmentGeometry? | - | 徽标相对 `child` 的对齐方式。 为空时依次读取局部与全局 `BadgeThemeData.alignment`，最终回退为右上角。 ribbon、triangle 的方位已编码在 `variant` 中，不读取该字段。 当 `child` 为空时不参与布局。 |
| offset | Offset? | - | 相对默认锚点的逐实例位置偏移；未设置时读取 `BadgeThemeData.offset`， 再读取组合组件提供的默认偏移，最终回退为 `Offset.zero`。 默认右上角徽标以中心点对齐内容右上角。当 `child` 为空时不参与布局。 |
| child | Widget? | - | 被徽标标记的内容；为空时徽标可独立展示。 |
| onTap | GestureTapCallback? | - | 点击徽标及其 `child` 时触发；为空时不创建点击语义。 |


##### TBadge.fromConfig

使用组合组件提供的 `config` 创建徽标；回退位置只在配置与 `BadgeThemeData` 均未指定位置时生效。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| config | TBadgeConfig | - | - |
| child | Widget? | - | 被徽标标记的内容；为空时徽标可独立展示。 |
| onTap | GestureTapCallback? | - | 点击徽标及其 `child` 时触发；为空时不创建点击语义。 |
| fallbackAlignment | AlignmentGeometry? | - | 消费组件为自身锚点定义的默认对齐方式。 |
| fallbackOffset | Offset? | - | 消费组件为自身锚点定义的默认偏移。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | AlignmentGeometry? | - | 徽标相对 `child` 的对齐方式。 为空时依次读取局部与全局 `BadgeThemeData.alignment`，最终回退为右上角。 ribbon、triangle 的方位已编码在 `variant` 中，不读取该字段。 当 `child` 为空时不参与布局。 |
| border | bool | false | 是否为徽标增加对比色描边，默认为 false，适用于全部形态。 |
| child | Widget? | - | 被徽标标记的内容；为空时徽标可独立展示。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | '0' | 徽标实际展示的短文本，例如 `8`、`99+` 或 `NEW`。 文本形态下为 null 时隐藏徽标；`TBadgeVariant.dot` 不读取该字段。 |
| offset | Offset? | - | 相对默认锚点的逐实例位置偏移；未设置时读取 `BadgeThemeData.offset`， 再读取组合组件提供的默认偏移，最终回退为 `Offset.zero`。 默认右上角徽标以中心点对齐内容右上角。当 `child` 为空时不参与布局。 |
| onTap | GestureTapCallback? | - | 点击徽标及其 `child` 时触发；为空时不创建点击语义。 |
| showZero | bool | true | `label` 恰好为字符串 `0` 时是否显示徽标，默认为 true。 `TBadgeVariant.dot` 始终显示，不受该字段影响。 |
| size | TBadgeSize | TBadgeSize.medium | 徽标的预设尺寸，默认为 `TBadgeSize.medium`。 `TBadgeVariant.dot` 与 `TBadge.custom` 不读取该字段。 |
| variant | TBadgeVariant | TBadgeVariant.circle | 徽标的结构形态，默认为 `TBadgeVariant.circle`。 `TBadge.custom` 不读取该字段。 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | Widget? | - | `TBadge.custom` 提供的完整徽标外观。 普通构造下为 null。该 Widget 仅表示徽标本体，不包含 `child`。 |


### TBadgeConfig
#### 简介
由组合组件消费的徽标配置。
该对象不参与 Widget 树，也不拥有被标记的内容。仅当 TabBar、SideBar、
ActionSheet 等组件在内部创建徽标锚点时使用；组件会把配置和自己的锚点交给
与 `TBadge` 相同的渲染实现。
调用方已经拥有锚点 Widget 时，应直接使用 `TBadge`：

完全自定义徽标外观时使用 `TBadgeConfig.custom`。传入的 `badge` 是徽标本体，
不应包含锚点或自行使用 `Positioned` 定位。

#### 工厂构造方法

##### TBadgeConfig.custom

创建完全自定义外观的徽标配置。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | Widget? | - | 仅定义徽标本体；最终锚点和默认位置由消费该配置的组合组件决定。 |
| alignment | AlignmentGeometry? | - | 徽标相对锚点的对齐方式。 为空时依次使用当前 `BadgeThemeData.alignment` 和消费组件的默认值。 ribbon、triangle 的方位已编码在 `variant` 中，不读取该字段。 |
| offset | Offset? | - | 在最终对齐位置上追加的偏移。 为空时依次使用当前 `BadgeThemeData.offset` 和消费组件的默认值。 ribbon、triangle 始终贴住锚点的物理左上角或右上角，但仍读取该偏移。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | AlignmentGeometry? | - | 徽标相对锚点的对齐方式。 为空时依次使用当前 `BadgeThemeData.alignment` 和消费组件的默认值。 ribbon、triangle 的方位已编码在 `variant` 中，不读取该字段。 |
| border | bool | false | 是否为预设徽标增加对比色描边，默认为 false。 `TBadgeConfig.custom` 不读取该字段。 |
| label | String? | '0' | 预设徽标展示的短文本，例如 `8`、`99+` 或 `NEW`。 文本形态下为 null 时隐藏徽标；`TBadgeVariant.dot` 不读取该字段。 `TBadgeConfig.custom` 下固定为 null。 |
| offset | Offset? | - | 在最终对齐位置上追加的偏移。 为空时依次使用当前 `BadgeThemeData.offset` 和消费组件的默认值。 ribbon、triangle 始终贴住锚点的物理左上角或右上角，但仍读取该偏移。 |
| showZero | bool | true | `label` 恰好为字符串 `0` 时是否显示，默认为 true。 `TBadgeVariant.dot` 与 `TBadgeConfig.custom` 不读取该字段。 |
| size | TBadgeSize | TBadgeSize.medium | 预设徽标尺寸，默认为 `TBadgeSize.medium`。 `TBadgeVariant.dot` 与 `TBadgeConfig.custom` 不读取该字段。 |
| variant | TBadgeVariant | TBadgeVariant.circle | 预设徽标的结构形态，默认为 `TBadgeVariant.circle`。 `TBadgeConfig.custom` 不读取该字段。 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | Widget? | - | `TBadgeConfig.custom` 提供的完整徽标外观。 普通构造下为 null。该 Widget 不包含锚点，定位由消费组件负责。 |


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
| circle | 标准文本徽标；单字符呈圆形，多字符随内容扩展为胶囊形。 |
| dot | 不显示文本的圆点徽标，默认直径为 8 逻辑像素。 |
| square | 小圆角方形文本徽标；多字符时随内容横向扩展为矩形。 |
| bubble | 左下角收紧、其余角为圆角的气泡徽标。 |
| ribbonRight | 位于内容物理右上角的带状角标；RTL 下不交换方位。 |
| ribbonLeft | 位于内容物理左上角的带状角标；RTL 下不交换方位。 |
| triangleRight | 位于内容物理右上角的三角角标；RTL 下不交换方位。 |
| triangleLeft | 位于内容物理左上角的三角角标；RTL 下不交换方位。 |


### TBadgeSize
#### 简介
徽标的预设尺寸，控制文本徽标的文字 Token、标签行盒高度与水平内边距。
`TBadgeVariant.dot` 的直径由 `BadgeThemeData.smallSize` 控制，不读取该值；
角标形态会按该值在 32 与 40 逻辑像素两档尺寸之间切换。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| medium | 中尺寸，使用 `fontMarkExtraSmall` 与 16 逻辑像素标签行盒。 |
| large | 大尺寸，使用 `fontMarkSmall` 与 20 逻辑像素标签行盒。 |
