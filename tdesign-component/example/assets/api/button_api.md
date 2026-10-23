## API

### TButton

#### 构造方法

##### TButton

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| child | Widget? | - | 按钮内容，纯文案可使用 `Text('...')` 或 `TText('...')`。 内容文字默认使用按钮尺寸、配色与当前状态解析的文案样式。 Text/TText 的实例显式样式优先；仅设置部分字段时，其余字段使用按钮默认值。 内容内部可通过更近的 TTextThemeData 自行定制；其他调用方主题保持原有行为。 外层通用 TTextThemeData 的同名字段由本槽默认覆盖；需保持旧外观时显式指定。 | 否 |
| colorPreset | TButtonColorPreset? | - | 内置配色预设；未传时使用 `TButtonColorPreset.defaultTheme`。 不改变 `variant` 的绘制方式，仅选择 TD 默认色板； 当前按钮的具体颜色、边框和文字样式通过 `style` 配置。 | 否 |
| icon | Widget? | - | 图标（Widget 类型，IconData 需包裹为 `Icon(...)`） | 否 |
| iconPosition | TButtonIconPosition | TButtonIconPosition.left | 图标位置 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onLongPress | VoidCallback? | - | 长按回调。 仅在 `onPressed` 非空时生效；当 `onPressed` 为空时按钮保持禁用态， 不会触发点击或长按回调。 | 否 |
| onPressed | VoidCallback? | - | 点击回调，`null` 表示禁用 | 否 |
| shape | TButtonShape | TButtonShape.rectangle | 按钮结构形状；纯图标的 square/circle 同时决定等宽高布局。 具体边框及圆角仍可通过 `style` 配置。 | 否 |
| size | TButtonSize? | - | 尺寸，未传时使用 `TButtonSize.medium`。 默认按 48、40、32、28dp 的 TDesign 视觉高度参与布局。 | 否 |
| style | ButtonStyle? | - | 当前按钮的完整 `ButtonStyle` 视觉配置入口，不影响其他按钮。 外部 Material 按钮主题不控制内置样式；请通过此实例 style 或 TD Theme 定制。 `ButtonStyle.visualDensity` 不生效；内置布局始终使用标准密度， 尺寸由 `size` 规格、全局尺寸刻度与显式内边距、宽高配置决定。 反馈和鼠标指针仅由实例 style、TD Theme 或内置默认值控制。 状态属性返回 null 时回退该状态的 TD 默认值；不读取 Material 按钮主题。 调用方内容保留原主题；child 的默认文字样式由按钮提供，显式文字样式优先。 组件默认使用 `MaterialTapTargetSize.shrinkWrap` 保持 TDesign 精确尺寸； 需要至少 48dp 点击区时可将 `ButtonStyle.tapTargetSize` 设为 `MaterialTapTargetSize.padded`。 | 否 |
| variant | TButtonVariant? | - | 变体（fill / outline / text / ghost），未传时使用 `TButtonVariant.fill`。 | 否 |


### TButtonColorPreset

按钮内置配色预设，不是 Material ColorScheme。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| defaultTheme | TButtonColorPreset | - | 默认配色 | - |
| primary | TButtonColorPreset | - | 品牌主色 | - |
| danger | TButtonColorPreset | - | 危险操作配色 | - |
| light | TButtonColorPreset | - | 浅色品牌配色；不改变填充/描边等 `TButtonVariant` 绘制方式。 | - |


### TButtonSize

按钮尺寸
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| large | TButtonSize | - | 大尺寸按钮 | - |
| medium | TButtonSize | - | 中尺寸按钮 | - |
| small | TButtonSize | - | 小尺寸按钮 | - |
| extraSmall | TButtonSize | - | 超小尺寸按钮 | - |


### TButtonVariant

按钮变体（fill / outline / text / ghost）
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| fill | TButtonVariant | - | 填充按钮 | - |
| outline | TButtonVariant | - | 描边按钮 | - |
| text | TButtonVariant | - | 文字按钮 | - |
| ghost | TButtonVariant | - | 幽灵按钮 | - |


### TButtonIconPosition

图标位置
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| left | TButtonIconPosition | - | 图标在文本左侧 | - |
| right | TButtonIconPosition | - | 图标在文本右侧 | - |


### TButtonShape

按钮形状
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| rectangle | TButtonShape | - | 矩形按钮 | - |
| round | TButtonShape | - | 圆角按钮 | - |
| square | TButtonShape | - | 纯图标场景保持等宽高和默认圆角；图文内容不会被裁剪。 | - |
| circle | TButtonShape | - | 圆形按钮 | - |


### TButtonThemeData

TButton 组件级 ThemeExtension

承载按钮子树的分档图标默认值、图文间距与渐变。
实例 ButtonStyle 的显式字段优先于对应组件默认值。

分档默认值示例（实例 style 仍可覆盖）：

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| extraSmallIconSize | double? | - | 超小尺寸按钮的图标大小，单位为逻辑像素。 未设置时使用独立默认 18dp；实例 ButtonStyle.iconSize 优先。 必须是有限非负数；仅改变内置图标及纯图标按钮的默认居中间距，不改变按钮高度。 | 否 |
| gradient | Gradient? | - | 渐变背景色（装饰层，非 ButtonStyle 字段） | 否 |
| iconTextSpacing | double? | - | 图标与文案之间的间距，单位为逻辑像素。 仅在按钮同时提供 icon 和 child 时生效；该值控制两者 之间的实际间隔，不会改变按钮整体内边距。为空时使用组件内置 默认值 4dp；全局 `spacer4` 对应 32dp，不用于此间距。 | 否 |
| largeIconSize | double? | - | 大尺寸按钮的图标大小，单位为逻辑像素。 未设置时使用 size8（默认 24dp）；实例 ButtonStyle.iconSize 优先。 必须是有限非负数；仅改变内置图标及纯图标按钮的默认居中间距，不改变按钮高度。 | 否 |
| mediumIconSize | double? | - | 中尺寸按钮的图标大小，单位为逻辑像素。 未设置时使用 size7（默认 20dp）；实例 ButtonStyle.iconSize 优先。 必须是有限非负数；仅改变内置图标及纯图标按钮的默认居中间距，不改变按钮高度。 | 否 |
| smallIconSize | double? | - | 小尺寸按钮的图标大小，单位为逻辑像素。 未设置时使用独立默认 18dp；实例 ButtonStyle.iconSize 优先。 必须是有限非负数；仅改变内置图标及纯图标按钮的默认居中间距，不改变按钮高度。 | 否 |
