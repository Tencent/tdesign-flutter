## API

### TDialog

#### 构造方法

##### TDialog

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| actions | List&lt;TDialogAction&gt; | const &lt;TDialogAction&gt;[] | 操作列表；一到两个操作横向排列，更多操作纵向排列。 一到两个操作全部显式使用 `TButtonVariant.text` 时，操作区使用带分隔线的 贴边文字按钮 Footer；其他情况使用带内边距的普通操作区。 纵向排列时，`TDialogAction.role` 为 `TDialogActionRole.primary` 或 `TDialogActionRole.destructive` 的强调操作优先展示，同类操作保持声明顺序。 | 否 |
| actionSpacing | double? | - | 操作之间的间距。未设置时使用主题 token 默认值。 | 否 |
| actionsPadding | EdgeInsetsGeometry? | - | 操作区内边距。未设置时使用主题 token 默认值。 一到两个操作全部显式使用 `TButtonVariant.text` 时，默认仅保留 32dp 顶部间距，使文字按钮 Footer 横向贴边；显式设置后使用传入的内边距。 | 否 |
| actionsWidget | Widget? | - | 完全自定义操作区。 使用后 `actions` 必须为空；仅在标准操作列表无法表达布局时使用。 | 否 |
| closeButtonResult | Object? | - | 点击内置关闭按钮并成功关闭时的返回值，默认为 null。 类型应与 `show` 的泛型一致。可与 `TDialogAction.result` 和 `show` 的 `barrierResult` 配合，通过同一个 Future 区分关闭来源。 不影响系统返回或业务调用 Navigator.pop 的返回值。 | 否 |
| content | Widget? | - | 内容槽位。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| semanticLabel | String? | - | 无障碍语义标签。 | 否 |
| showCloseButton | bool | false | 是否显示右上角关闭按钮。 | 否 |
| title | Widget? | - | 标题槽位。 | 否 |


#### 静态方法

##### TDialog.show

类型参数：`T`


位置参数：`context`


使用居中模态路由展示 Dialog。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| dialog | Widget | - | - | 是 |
| barrierDismissible | bool | false | 默认为 false，点击蒙层不会关闭。 显式开启后，蒙层关闭成功时返回 `barrierResult`（默认 null）； 操作按钮与内置关闭按钮分别返回各自配置的结果。 蒙层与内置关闭按钮通过 Navigator.maybePop 关闭，遵守 PopScope。 系统返回及未携带结果的 Navigator.pop 仍返回 null，不使用 `barrierResult`。 | 否 |
| barrierResult | T? | - | - | 否 |
| barrierColor | Color? | - | - | 否 |
| useRootNavigator | bool | true | - | 否 |
| useSafeArea | bool | true | - | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;T?&gt; | - | - | - |


### TDialogAction

#### 构造方法

##### TDialogAction

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 按钮内容。 | 是 |
| closeOnPressed | bool | true | 点击后是否自动关闭。 | 否 |
| colorPreset | TButtonColorPreset? | - | 显式按钮配色；未指定时由角色和最终变体解析。 普通操作的填充变体使用 `TButtonColorPreset.light`，其他变体使用 `TButtonColorPreset.defaultTheme`；主要和危险操作分别使用 `TButtonColorPreset.primary`、`TButtonColorPreset.danger`。 | 否 |
| disabled | bool | false | 是否禁用。 | 否 |
| onPressed | VoidCallback? | - | 点击回调，在自动关闭前执行。 | 否 |
| result | Object? | - | 关闭 Dialog 时返回的结果。 | 否 |
| role | TDialogActionRole | TDialogActionRole.normal | 操作语义角色，默认为 `TDialogActionRole.normal`。 未指定 `variant` 时使用填充按钮：普通操作采用 `TButtonColorPreset.light`， 主要操作采用 `TButtonColorPreset.primary`，危险操作采用 `TButtonColorPreset.danger`。显式设置的 `variant`、`colorPreset` 和 `style` 优先于角色提供的默认值。 | 否 |
| style | ButtonStyle? | - | 显式按钮样式；用于覆盖单个操作，未设置时使用 Dialog Theme 和角色默认样式。 | 否 |
| variant | TButtonVariant? | - | 显式按钮变体；未指定时使用 `TButtonVariant.fill`。 当 `TDialog.actions` 中有一到两个操作，且所有操作都显式使用 `TButtonVariant.text` 时，Dialog 自动切换为带分隔线的贴边文字按钮 Footer。 混合使用不同变体时仍采用普通操作区布局，每个按钮保留各自的变体。 | 否 |


### TConfirmDialog

#### 构造方法

##### TConfirmDialog

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| buttonStyle | ButtonStyle? | - | - | 否 |
| buttonText | String? | - | - | 否 |
| closeButtonResult | Object? | - | 内置关闭按钮成功关闭时返回的值，默认 null；透传至 `TDialog.closeButtonResult`。 | 否 |
| closeOnPressed | bool | true | - | 否 |
| content | String? | - | - | 否 |
| contentWidget | Widget? | - | - | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onPressed | VoidCallback? | - | - | 否 |
| result | Object? | true | - | 否 |
| semanticLabel | String? | - | - | 否 |
| showCloseButton | bool | false | - | 否 |
| title | String? | - | - | 否 |


### TDialogThemeData

#### 构造方法

##### TDialogThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色（对应 Material `DialogThemeData.backgroundColor`） | 否 |
| contentPadding | EdgeInsetsGeometry? | - | 内容内边距（对应 Material `Dialog` 的 contentPadding；TDesign 扩展） | 否 |
| contentTextStyle | TextStyle? | - | 内容文案样式（对应 Material `DialogThemeData.contentTextStyle`） | 否 |
| elevation | double? | - | 阴影（对应 Material `DialogThemeData.elevation`） | 否 |
| maxHeight | double? | - | 面板最大高度。 | 否 |
| shape | ShapeBorder? | - | 形状（圆角；对应 Material `DialogThemeData.shape`） | 否 |
| titleTextStyle | TextStyle? | - | 标题文案样式（对应 Material `DialogThemeData.titleTextStyle`） | 否 |
| width | double? | - | 弹窗宽度 | 否 |


#### 静态方法

##### TDialogThemeData.lerpDouble

位置参数：`a, b, t`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| a | double? | - | - | 是 |
| b | double? | - | - | 是 |
| t | double | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | double? | - | - | - |


#### 实例方法

##### TDialogThemeData.copyWith

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 字段含义：背景色（对应 Material `DialogThemeData.backgroundColor`） 调用时的空值行为见方法说明。 | 否 |
| shape | ShapeBorder? | - | 字段含义：形状（圆角；对应 Material `DialogThemeData.shape`） 调用时的空值行为见方法说明。 | 否 |
| elevation | double? | - | 字段含义：阴影（对应 Material `DialogThemeData.elevation`） 调用时的空值行为见方法说明。 | 否 |
| titleTextStyle | TextStyle? | - | 字段含义：标题文案样式（对应 Material `DialogThemeData.titleTextStyle`） 调用时的空值行为见方法说明。 | 否 |
| contentTextStyle | TextStyle? | - | 字段含义：内容文案样式（对应 Material `DialogThemeData.contentTextStyle`） 调用时的空值行为见方法说明。 | 否 |
| contentPadding | EdgeInsetsGeometry? | - | 字段含义：内容内边距（对应 Material `Dialog` 的 contentPadding；TDesign 扩展） 调用时的空值行为见方法说明。 | 否 |
| maxHeight | double? | - | 字段含义：面板最大高度。 调用时的空值行为见方法说明。 | 否 |
| width | double? | - | 字段含义：弹窗宽度 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TDialogThemeData | - | - | - |


##### TDialogThemeData.lerp

位置参数：`other, t`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TDialogThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TDialogThemeData | - | - | - |


##### TDialogThemeData.merge

位置参数：`other`


合并两个 ThemeExtension，`other` 优先于 this

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | TDialogThemeData? | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TDialogThemeData | - | - | - |


### TDialogActionRole
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| normal | TDialogActionRole | - | 次要操作。 | - |
| primary | TDialogActionRole | - | 主要操作。 | - |
| destructive | TDialogActionRole | - | 危险操作。 | - |
