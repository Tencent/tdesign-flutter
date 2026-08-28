## API
### TButton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 内容（纯文案用 `Text('...')`） |
| colorScheme | TButtonColorScheme? | - | 配色方案，未传时使用 Theme 默认解析 |
| icon | Widget? | - | 图标（Widget 类型，IconData 需包裹为 `Icon(...)`） |
| iconPosition | TButtonIconPosition | TButtonIconPosition.left | 图标位置 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onLongPress | VoidCallback? | - | 长按回调。 仅在 `onPressed` 非空时生效；当 `onPressed` 为空时按钮保持禁用态， 不会触发点击或长按回调。 |
| onPressed | VoidCallback? | - | 点击回调，`null` 表示禁用 |
| size | TButtonSize? | - | 尺寸，未传时使用 Theme `TButtonThemeData.defaultSize`。 默认按 48、40、32、28dp 的 TDesign 视觉高度参与布局。 |
| style | ButtonStyle? | - | P0 逃逸舱：`ButtonStyle` 覆盖所有 resolve 结果。 组件默认使用 `MaterialTapTargetSize.shrinkWrap` 保持 TDesign 精确尺寸； 需要至少 48dp 点击区时可将 `ButtonStyle.tapTargetSize` 设为 `MaterialTapTargetSize.padded`。 |
| variant | TButtonVariant? | - | 变体（fill / outline / text / ghost），未传时使用 Theme `TButtonThemeData.defaultVariant` |
