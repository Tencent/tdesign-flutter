## API
### TButton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 内容（纯文案用 `Text('...')`） |
| colorPreset | TButtonColorPreset? | - | 内置配色预设；未传时使用 `TButtonColorPreset.defaultTheme`。 不改变 `variant` 的绘制方式，也不覆写显式 Material 按钮主题； 当前按钮的具体颜色、边框和文字样式通过 `style` 配置。 |
| icon | Widget? | - | 图标（Widget 类型，IconData 需包裹为 `Icon(...)`） |
| iconPosition | TButtonIconPosition | TButtonIconPosition.left | 图标位置 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onLongPress | VoidCallback? | - | 长按回调。 可以独立于 `onPressed` 使用，长按不会同时触发点击。 禁用按钮须同时将 `onPressed` 和本回调置空。 |
| onPressed | VoidCallback? | - | 点击动作回调；与 `onLongPress` 均为空时禁用。 |
| shape | TButtonShape | TButtonShape.rectangle | 按钮结构形状；纯图标的 square/circle 同时决定等宽高布局。 具体边框及圆角仍可通过 `style` 配置。 |
| size | TButtonSize? | - | 尺寸，未传时使用 `TButtonSize.medium`。 默认按 48、40、32、28dp 的 TDesign 视觉高度参与布局。 |
| style | ButtonStyle? | - | 当前按钮的完整 `ButtonStyle` 视觉配置入口，不影响其他按钮。 组件默认使用 `MaterialTapTargetSize.shrinkWrap` 保持 TDesign 精确尺寸； 需要至少 48dp 点击区时可将 `ButtonStyle.tapTargetSize` 设为 `MaterialTapTargetSize.padded`。 |
| variant | TButtonVariant? | - | 变体（fill / outline / text / ghost），未传时使用 `TButtonVariant.fill`。 |


### TButtonThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| gradient | Gradient? | - | 渐变背景色（装饰层，非 ButtonStyle 字段） |
| iconTextSpacing | double? | - | 图标与文案之间的间距，单位为逻辑像素。 仅在按钮同时提供 icon 和 child 时生效；该值控制两者 之间的实际间隔，不会改变按钮整体内边距。为空时使用组件内置 默认值 4dp；全局 `spacer4` 对应 32dp，不用于此间距。 |


### TButtonColorPreset
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认配色 |
| primary | 品牌主色 |
| danger | 危险操作配色 |
| light | 浅色品牌配色；不改变填充/描边等 `TButtonVariant` 绘制方式。 |


### TButtonSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | 大尺寸按钮 |
| medium | 中尺寸按钮 |
| small | 小尺寸按钮 |
| extraSmall | 超小尺寸按钮 |


### TButtonVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| fill | 填充按钮 |
| outline | 描边按钮 |
| text | 文字按钮 |
| ghost | 幽灵按钮 |


### TButtonIconPosition
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 图标在文本左侧 |
| right | 图标在文本右侧 |


### TButtonShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| rectangle | 矩形按钮 |
| round | 圆角按钮 |
| square | 纯图标场景保持等宽高和默认圆角；图文内容不会被裁剪。 |
| circle | 圆形按钮 |
