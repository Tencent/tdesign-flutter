## API

### TButton

TD 常规按钮

`onPressed: null` 表示禁用；禁用时不会触发
`onLongPress`。

外观分别由以下选项控制：
- `variant`：变体类型（fill / outline / text / ghost）
- `colorPreset`：配色方案（defaultTheme / primary / danger / light）
- `shape`：按钮结构形状；具体边框样式由 `style` 控制

#### 构造方法

##### TButton

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| child | Widget? | - | 内容（纯文案用 `Text('...')`） | 否 |
| colorPreset | TButtonColorPreset? | - | 内置配色预设；未传时使用 `TButtonColorPreset.defaultTheme`。 不改变 `variant` 的绘制方式，也不覆写显式 Material 按钮主题； 当前按钮的具体颜色、边框和文字样式通过 `style` 配置。 | 否 |
| icon | Widget? | - | 图标（Widget 类型，IconData 需包裹为 `Icon(...)`） | 否 |
| iconPosition | TButtonIconPosition | TButtonIconPosition.left | 图标位置 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onLongPress | VoidCallback? | - | 长按回调。 仅在 `onPressed` 非空时生效；当 `onPressed` 为空时按钮保持禁用态， 不会触发点击或长按回调。 | 否 |
| onPressed | VoidCallback? | - | 点击回调，`null` 表示禁用 | 否 |
| shape | TButtonShape | TButtonShape.rectangle | 按钮结构形状；纯图标的 square/circle 同时决定等宽高布局。 具体边框及圆角仍可通过 `style` 配置。 | 否 |
| size | TButtonSize? | - | 尺寸，未传时使用 `TButtonSize.medium`。 默认按 48、40、32、28dp 的 TDesign 视觉高度参与布局。 | 否 |
| style | ButtonStyle? | - | 当前按钮的完整 `ButtonStyle` 视觉配置入口，不影响其他按钮。 组件默认使用 `MaterialTapTargetSize.shrinkWrap` 保持 TDesign 精确尺寸； 需要至少 48dp 点击区时可将 `ButtonStyle.tapTargetSize` 设为 `MaterialTapTargetSize.padded`。 | 否 |
| variant | TButtonVariant? | - | 变体（fill / outline / text / ghost），未传时使用 `TButtonVariant.fill`。 | 否 |


### TButtonThemeData

TButton 组件级 ThemeExtension

只承载 `ButtonStyle` 不能表达的按钮子树默认视觉值。

#### 构造方法

##### TButtonThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| gradient | Gradient? | - | 渐变背景色（装饰层，非 ButtonStyle 字段） | 否 |
| iconTextSpacing | double? | - | 图标与文案之间的间距，单位为逻辑像素。 仅在按钮同时提供 icon 和 child 时生效；该值控制两者 之间的实际间隔，不会改变按钮整体内边距。为空时使用组件内置 默认值 4dp；全局 `spacer4` 对应 32dp，不用于此间距。 | 否 |


#### 实例方法

##### TButtonThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| iconTextSpacing | double? | - | 字段含义：图标与文案之间的间距，单位为逻辑像素。 仅在按钮同时提供 icon 和 child 时生效；该值控制两者 之间的实际间隔，不会改变按钮整体内边距。为空时使用组件内置 默认值 4dp；全局 `spacer4` 对应 32dp，不用于此间距。 调用时的空值行为见方法说明。 | 否 |
| gradient | Gradient? | - | 字段含义：渐变背景色（装饰层，非 ButtonStyle 字段） 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TButtonThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TButtonThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TButtonThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TButtonThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


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
