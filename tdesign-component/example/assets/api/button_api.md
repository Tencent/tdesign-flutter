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
| size | TButtonSize? | - | 尺寸，未传时使用 Theme `TButtonThemeData.defaultSize` |
| style | ButtonStyle? | - | P0 逃逸舱：`ButtonStyle` 覆盖所有 resolve 结果 |
| variant | TButtonVariant? | - | 变体（fill / outline / text / ghost），未传时使用 Theme `TButtonThemeData.defaultVariant` |


### TButtonThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaultSize | TButtonSize | TButtonSize.medium | 未传按钮 size 时的默认尺寸 |
| defaultVariant | TButtonVariant | TButtonVariant.fill | 未传按钮 variant 时的默认变体 |
| filledStyle | ButtonStyle? | - | P2 色板：fill 变体的 `ButtonStyle`（仅颜色相关字段，不含 shape） |
| ghostStyle | ButtonStyle? | - | P2 色板：ghost 变体的 `ButtonStyle`（仅颜色相关字段，不含 shape） |
| gradient | Gradient? | - | 渐变背景色（装饰层，非 ButtonStyle 字段） |
| iconSpacing | double? | - | 图标与文案之间的间距 |
| margin | EdgeInsetsGeometry? | - | 外边距 |
| outlinedStyle | ButtonStyle? | - | P2 色板：outline 变体的 `ButtonStyle`（仅颜色相关字段，不含 shape） |
| padding | EdgeInsetsGeometry? | - | 覆盖默认 padding（null 时由 resolve 按 size/shape 推导） |
| shape | TButtonShape? | - | 外形，会展开进 resolves `ButtonStyle.shape` |
| textButtonStyle | ButtonStyle? | - | P2 色板：text 变体的 `ButtonStyle`（仅颜色相关字段，不含 shape） |


### TButtonResolve

#### 静态方法

##### TButtonResolve.resolve

解析最终的 `ButtonStyle`

返回类型：`ButtonStyle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| variant | TButtonVariant | - | 按钮形态，决定 fill / outline / text / ghost 的基础样式链路。 |
| colorScheme | TButtonColorScheme? | - | 语义色方案；为 null 时使用默认色方案。 |
| size | TButtonSize | - | 尺寸规格，用于推导最小尺寸、内边距和默认字号。 |
| icon | Widget? | - | 图标内容；与 `hasChild`、`iconPosition` 一起决定图标间距和尺寸。 |
| hasChild | bool | - | 是否存在文本或自定义内容，用于区分纯图标按钮与图文按钮。 |
| iconPosition | TButtonIconPosition | - | 图标位置，用于计算图标和内容之间的间距。 |
| theme | TButtonThemeData? | - | P1 组件主题，提供默认形态、色板、间距、渐变等配置。 |
| instanceStyle | ButtonStyle? | - | P0 实例样式，优先级最高，会覆盖所有 resolve 结果。 |
| context | BuildContext | - | 当前构建上下文，用于读取 TDesign 全局 Token。 |
| hasGradient | bool | - | 是否启用渐变背景；启用时会清理 Material 默认背景和阴影污染。 |


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


### TButtonColorScheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认配色 |
| primary | 品牌主色 |
| danger | 危险操作配色 |
| light | 浅色配色 |


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
| square | 方形按钮 |
| circle | 圆形按钮 |
| filled | 填满容器的按钮 |
