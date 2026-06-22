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
| onPressed | VoidCallback? | - | 点击回调，`null` 表示禁用 |
| size | TButtonSize | TButtonSize.medium | 尺寸，未传时使用 Theme `TButtonThemeData.defaultSize` |
| style | ButtonStyle? | - | P0 逃逸舱：`ButtonStyle` 覆盖所有 resolve 结果 |
| variant | TButtonVariant? | - | 变体（fill / outline / text / ghost），未传时使用 Theme `TButtonThemeData.defaultVariant` |


### TButtonThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaultSize | TButtonSize | TButtonSize.medium | 未传 `TButton.size` 时的默认尺寸 |
| defaultVariant | TButtonVariant | TButtonVariant.fill | 未传 `TButton.variant` 时的默认变体 |
| filledStyle | ButtonStyle? | - | P2 色板：fill 变体的 `ButtonStyle`（仅颜色相关字段，不含 shape） |
| ghostStyle | ButtonStyle? | - | P2 色板：ghost 变体的 `ButtonStyle`（仅颜色相关字段，不含 shape） |
| gradient | Gradient? | - | 渐变背景色（装饰层，非 ButtonStyle 字段） |
| iconSpacing | double? | - | 图标与文案之间的间距 |
| margin | EdgeInsetsGeometry? | - | 外边距 |
| outlinedStyle | ButtonStyle? | - | P2 色板：outline 变体的 `ButtonStyle`（仅颜色相关字段，不含 shape） |
| padding | EdgeInsetsGeometry? | - | 覆盖默认 padding（null 时由 resolve 按 size/shape 推导） |
| shape | TButtonShape? | - | 外形，会展开进 resolves `ButtonStyle.shape` |
| textButtonStyle | ButtonStyle? | - | P2 色板：text 变体的 `ButtonStyle`（仅颜色相关字段，不含 shape） |
| textStyle | TextStyle? | - | 默认文案样式 |


### TButtonResolve

#### 静态方法

##### TButtonResolve.resolve

解析最终的 `ButtonStyle`

返回类型：`ButtonStyle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| variant | TButtonVariant | - | - |
| colorScheme | TButtonColorScheme? | - | - |
| size | TButtonSize | - | - |
| icon | Widget? | - | - |
| iconPosition | TButtonIconPosition | - | - |
| theme | TButtonThemeData? | - | - |
| instanceStyle | ButtonStyle? | - | - |
| context | BuildContext | - | - |


### TButtonShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| rectangle | - |
| round | - |
| square | - |
| circle | - |
| filled | - |


### TButtonSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | - |
| medium | - |
| small | - |
| extraSmall | - |


### TButtonVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| fill | - |
| outline | - |
| text | - |
| ghost | - |


### TButtonColorScheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | - |
| primary | - |
| danger | - |
| light | - |


### TButtonIconPosition
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | - |
| right | - |
