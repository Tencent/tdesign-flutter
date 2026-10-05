## API
### TDialog

#### 静态方法

##### TDialog.show

使用居中模态路由展示 Dialog。
显式开启后，蒙层关闭成功时返回 `barrierResult`（默认 null）；
操作按钮与内置关闭按钮分别返回各自配置的结果。
蒙层与内置关闭按钮通过 Navigator.maybePop 关闭，遵守 PopScope。
系统返回及未携带结果的 Navigator.pop 仍返回 null，不使用 `barrierResult`。

返回类型：`Future<T?>`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Navigator 并捕获主题。 |
| dialog | Widget | - | 弹层内容，通常为 TDialog 或 TConfirmDialog。 |
| barrierDismissible | bool | false | 默认为 false，点击蒙层不会关闭。 |
| barrierResult | T? | - | 蒙层成功关闭时返回的值，默认 null。 |
| barrierColor | Color? | - | 蒙层颜色，null 时使用 Colors.black54。 |
| useRootNavigator | bool | true | 是否使用根 Navigator，默认 true。 |
| useSafeArea | bool | true | 是否避让安全区，默认 true。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| actions | List<TDialogAction> | const <TDialogAction>[] | 操作列表；一到两个操作横向排列，更多操作纵向排列。 一到两个操作全部显式使用 `TButtonVariant.text` 时，操作区使用带分隔线的 贴边文字按钮 Footer；其他情况使用带内边距的普通操作区。 纵向排列时，`TDialogAction.role` 为 `TDialogActionRole.primary` 或 `TDialogActionRole.destructive` 的强调操作优先展示，同类操作保持声明顺序。 |
| actionSpacing | double? | - | 操作之间的间距。未设置时使用主题 token 默认值。 |
| actionsPadding | EdgeInsetsGeometry? | - | 操作区内边距。未设置时使用主题 token 默认值。 一到两个操作全部显式使用 `TButtonVariant.text` 时，默认仅保留 32dp 顶部间距，使文字按钮 Footer 横向贴边；显式设置后使用传入的内边距。 |
| actionsWidget | Widget? | - | 完全自定义操作区。 使用后 `actions` 必须为空；仅在标准操作列表无法表达布局时使用。 |
| closeButtonResult | Object? | - | 点击内置关闭按钮并成功关闭时的返回值，默认为 null。 类型应与 `show` 的泛型一致。可与 `TDialogAction.result` 和 `show` 的 `barrierResult` 配合，通过同一个 Future 区分关闭来源。 不影响系统返回或业务调用 Navigator.pop 的返回值。 |
| content | Widget? | - | 内容槽位。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| semanticLabel | String? | - | 无障碍语义标签。 |
| showCloseButton | bool | false | 是否显示右上角关闭按钮。 |
| title | Widget? | - | 标题槽位。 |


### TDialogAction
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 按钮内容。 |
| closeOnPressed | bool | true | 点击后是否自动关闭。 |
| colorPreset | TButtonColorPreset? | - | 显式按钮配色；未指定时由角色和最终变体解析。 普通操作的填充变体使用 `TButtonColorPreset.light`，其他变体使用 `TButtonColorPreset.defaultTheme`；主要和危险操作分别使用 `TButtonColorPreset.primary`、`TButtonColorPreset.danger`。 |
| disabled | bool | false | 是否禁用。 |
| onPressed | VoidCallback? | - | 点击回调，在自动关闭前执行。 |
| result | Object? | - | 关闭 Dialog 时返回的结果。 |
| role | TDialogActionRole | TDialogActionRole.normal | 操作语义角色，默认为 `TDialogActionRole.normal`。 未指定 `variant` 时使用填充按钮：普通操作采用 `TButtonColorPreset.light`， 主要操作采用 `TButtonColorPreset.primary`，危险操作采用 `TButtonColorPreset.danger`。显式设置的 `variant`、`colorPreset` 和 `style` 优先于角色提供的默认值。 |
| style | ButtonStyle? | - | 显式按钮样式；用于覆盖单个操作，未设置时使用 Dialog Theme 和角色默认样式。 |
| variant | TButtonVariant? | - | 显式按钮变体；未指定时使用 `TButtonVariant.fill`。 当 `TDialog.actions` 中有一到两个操作，且所有操作都显式使用 `TButtonVariant.text` 时，Dialog 自动切换为带分隔线的贴边文字按钮 Footer。 混合使用不同变体时仍采用普通操作区布局，每个按钮保留各自的变体。 |


### TConfirmDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| buttonStyle | ButtonStyle? | - | 确认按钮样式覆盖，null 时使用组件主题。 |
| buttonText | String? | - | 确认按钮文案，null 时使用当前语言默认文案。 |
| closeButtonResult | Object? | - | 内置关闭按钮成功关闭时返回的值，默认 null；透传至 `TDialog.closeButtonResult`。 |
| closeOnPressed | bool | true | 确认按钮是否自动关闭，默认 true。 |
| content | String? | - | 正文文字，与 contentWidget 互斥。 |
| contentWidget | Widget? | - | 自定义正文，与 content 互斥。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback? | - | 确认按钮动作，在自动关闭前调用；null 不禁用按钮。 |
| result | Object? | true | 确认按钮自动关闭时返回的结果，默认 true。 |
| semanticLabel | String? | - | 无障碍标签，null 时回退到标题。 |
| showCloseButton | bool | false | 是否显示右上角关闭按钮，默认 false。 |
| title | String? | - | 标题文字，null 时不展示。 |


### TDialogThemeData

#### 静态方法

##### TDialogThemeData.lerpDouble

插值可空数值，两端均为 null 时返回 null，单端 null 按 0 计算。

返回类型：`double?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| a | double? | - | 起始数值。 |
| b | double? | - | 结束数值。 |
| t | double | - | 插值比例，可用于外插。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色（对应 Material `DialogThemeData.backgroundColor`） |
| contentPadding | EdgeInsetsGeometry? | - | 内容内边距（对应 Material `Dialog` 的 contentPadding；TDesign 扩展） |
| contentTextStyle | TextStyle? | - | 内容文案样式（对应 Material `DialogThemeData.contentTextStyle`） |
| elevation | double? | - | 阴影（对应 Material `DialogThemeData.elevation`） |
| maxHeight | double? | - | 面板最大高度。 |
| shape | ShapeBorder? | - | 形状（圆角；对应 Material `DialogThemeData.shape`） |
| titleTextStyle | TextStyle? | - | 标题文案样式（对应 Material `DialogThemeData.titleTextStyle`） |
| width | double? | - | 弹窗宽度 |


### TDialogActionRole
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 次要操作。 |
| primary | 主要操作。 |
| destructive | 危险操作。 |
