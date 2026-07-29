## API
### TDialog

#### 静态方法

##### TDialog.show

使用 Popup 的居中模态路由展示 Dialog。

返回类型：`Future<T?>`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| dialog | Widget | - | - |
| barrierDismissible | bool | false | - |
| barrierColor | Color? | - | - |
| useRootNavigator | bool | true | - |
| useSafeArea | bool | true | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| actions | List<TDialogAction> | const <TDialogAction>[] | 操作列表；1～2 个横向排列，更多操作纵向排列。 |
| actionSpacing | double | 12 | 操作之间的间距。 |
| actionsPadding | EdgeInsetsGeometry | const EdgeInsets.fromLTRB(24, 24, 24, 24) | 操作区内边距。 |
| actionsWidget | Widget? | - | 完全自定义操作区。 |
| backgroundColor | Color? | - | 面板背景色。 |
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
| colorScheme | TButtonColorScheme? | - | 显式按钮配色。 |
| disabled | bool | false | 是否禁用。 |
| onPressed | VoidCallback? | - | 点击回调，在自动关闭前执行。 |
| result | Object? | - | 关闭 Dialog 时返回的结果。 |
| role | TDialogActionRole | TDialogActionRole.normal | 操作语义角色。 |
| style | ButtonStyle? | - | 显式按钮样式。 |
| variant | TButtonVariant? | - | 显式按钮变体。 |


### TConfirmDialog
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | - |
| buttonStyle | ButtonStyle? | - | - |
| buttonText | String? | - | - |
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
