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
| context | BuildContext | - | - |
| dialog | Widget | - | - |
| barrierDismissible | bool | false | 默认为 false，点击蒙层不会关闭。 |
| barrierResult | T? | - | - |
| barrierColor | Color? | - | - |
| useRootNavigator | bool | true | - |
| useSafeArea | bool | true | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| actions | List<TDialogAction> | const <TDialogAction>[] | 操作列表；1～2 个横向排列，更多操作纵向排列。 纵向排列时，`TDialogAction.role` 为 `TDialogActionRole.primary` 或 `TDialogActionRole.destructive` 的强调操作优先展示，同类操作保持声明顺序。 |
| actionSpacing | double? | - | 操作之间的间距。未设置时使用主题 token 默认值。 |
| actionsPadding | EdgeInsetsGeometry? | - | 操作区内边距。未设置时使用主题 token 默认值。 |
| actionsWidget | Widget? | - | 完全自定义操作区。 |
| backgroundColor | Color? | - | 面板背景色。 |
| closeButtonResult | Object? | - | 点击内置关闭按钮并成功关闭时的返回值，默认为 null。 类型应与 `show` 的泛型一致。可与 `TDialogAction.result` 和 `show` 的 `barrierResult` 配合，通过同一个 Future 区分关闭来源。 不影响系统返回或业务调用 Navigator.pop 的返回值。 |
| content | Widget? | - | 内容槽位。 |
| contentPadding | EdgeInsetsGeometry? | - | 标题和内容区域内边距。 |
| elevation | double? | - | 面板阴影高度。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxHeight | double? | - | 面板最大高度。 |
| semanticLabel | String? | - | 无障碍语义标签。 |
| shape | ShapeBorder? | - | 面板形状。 |
| showCloseButton | bool | false | 是否显示右上角关闭按钮。 |
| title | Widget? | - | 标题槽位。 |
| width | double? | - | 面板宽度。 |


### TDialogAction
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 按钮内容。 |
| closeOnPressed | bool | true | 点击后是否自动关闭。 |
| colorScheme | TButtonColorScheme? | - | 显式按钮配色；未指定时由角色和最终变体解析。 普通操作的填充变体使用 `TButtonColorScheme.light`，其他变体使用 `TButtonColorScheme.defaultTheme`；主要和危险操作分别使用 `TButtonColorScheme.primary`、`TButtonColorScheme.danger`。 |
| disabled | bool | false | 是否禁用。 |
| onPressed | VoidCallback? | - | 点击回调，在自动关闭前执行。 |
| result | Object? | - | 关闭 Dialog 时返回的结果。 |
| role | TDialogActionRole | TDialogActionRole.normal | 操作语义角色，默认为 `TDialogActionRole.normal`。 未指定变体时使用填充按钮：普通操作采用浅色配色，主要操作采用品牌配色， 危险操作采用危险配色。显式变体、配色和样式优先于角色默认值。 |
| style | ButtonStyle? | - | 显式按钮样式。 |
| variant | TButtonVariant? | - | 显式按钮变体；未指定时使用 `TButtonVariant.fill`。 |


### TConfirmDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | - |
| buttonStyle | ButtonStyle? | - | - |
| buttonText | String? | - | - |
| closeButtonResult | Object? | - | 内置关闭按钮成功关闭时返回的值，默认 null；透传至 `TDialog.closeButtonResult`。 |
| closeOnPressed | bool | true | - |
| content | String? | - | - |
| contentPadding | EdgeInsetsGeometry? | - | - |
| contentWidget | Widget? | - | - |
| elevation | double? | - | - |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxHeight | double? | - | - |
| onPressed | VoidCallback? | - | - |
| result | Object? | true | - |
| semanticLabel | String? | - | - |
| shape | ShapeBorder? | - | - |
| showCloseButton | bool | false | - |
| title | String? | - | - |
| width | double? | - | - |


### TDialogThemeData

#### 静态方法

##### TDialogThemeData.lerpDouble

返回类型：`double?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| a | double? | - | - |
| b | double? | - | - |
| t | double | - | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| actionButtonStyle | ButtonStyle? | - | 按钮区样式（对应 Material `TextButtonThemeData`；TDesign 扩展） |
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
