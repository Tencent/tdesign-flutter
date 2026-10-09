## API

### TButton

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


### TButtonColorPreset
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| defaultTheme | TButtonColorPreset | - | 默认配色 | - |
| primary | TButtonColorPreset | - | 品牌主色 | - |
| danger | TButtonColorPreset | - | 危险操作配色 | - |
| light | TButtonColorPreset | - | 浅色品牌配色；不改变填充/描边等 `TButtonVariant` 绘制方式。 | - |
