## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TDialog
#### 简介
通用居中模态对话框。
title 与 content 至少提供一个；actionsWidget 与非空 actions 互斥。
组件负责面板内容和操作区；使用 `show` 时，通过 Flutter 模态路由处理
蒙层、动画和安全区。

#### 声明

```dart
class TDialog extends StatelessWidget
```


#### 静态方法

##### TDialog.show

```dart
static Future<T?> show<T>(
  BuildContext context, {
  required Widget dialog,
  bool barrierDismissible = false,
  T? barrierResult,
  Color? barrierColor,
  bool useRootNavigator = true,
  bool useSafeArea = true,
})
```


使用居中模态路由展示 Dialog。
显式开启后，蒙层关闭成功时返回 `barrierResult`（默认 null）；
操作按钮与内置关闭按钮分别返回各自配置的结果。
蒙层与内置关闭按钮通过 Navigator.maybePop 关闭，遵守 PopScope。
系统返回及未携带结果的 Navigator.pop 仍返回 null，不使用 `barrierResult`。

返回类型：`Future<T?>`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 当前构建上下文，用于读取祖先配置。 | 是 |
| dialog | Widget | - | 要放入模态路由的弹窗内容。 | 是 |
| barrierDismissible | bool | false | 默认为 false，点击蒙层不会关闭。 | 否 |
| barrierResult | T? | - | 开启蒙层关闭后，由蒙层成功关闭路由时返回的结果；默认 null。 | 否 |
| barrierColor | Color? | - | 蒙层颜色；为空时使用 Colors.black54。 | 否 |
| useRootNavigator | bool | true | 是否将弹窗推入根 Navigator，默认 true。 | 否 |
| useSafeArea | bool | true | 是否使用 SafeArea 避让系统区域，默认 true。 | 否 |

#### 默认构造方法


```dart
const TDialog({
  super.key,
  this.title,
  this.content,
  this.actions = const <TDialogAction>[],
  this.actionsWidget,
  this.showCloseButton = false,
  this.closeButtonResult,
  this.semanticLabel,
  EdgeInsetsGeometry? actionsPadding,
  double? actionSpacing,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
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


### TDialogAction
#### 简介
Dialog 操作项。
`role` 表达操作语义，并决定未显式覆盖时的默认配色；`variant` 表达按钮的
视觉形态。普通、主要和危险操作默认分别渲染为浅色、品牌色和危险色填充按钮。
`colorPreset` 和 `style` 用于确有需要时覆盖单个操作的默认样式。
一到两个操作全部显式使用 `TButtonVariant.text` 时，`TDialog` 会使用带分隔线的
贴边文字按钮 Footer；只改变某一个操作的变体不会切换整个 Footer 布局。

#### 声明

```dart
class TDialogAction
```

#### 默认构造方法


```dart
const TDialogAction({
  required this.child,
  this.result,
  this.onPressed,
  this.role = TDialogActionRole.normal,
  this.closeOnPressed = true,
  this.disabled = false,
  this.variant,
  this.colorPreset,
  this.style,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
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
#### 简介
单操作确认弹窗，是 `TDialog` 的便捷封装。
内置操作使用 `TDialogActionRole.primary`，默认渲染为品牌色填充按钮。需要多个
操作、文字按钮 Footer 或其他按钮变体时，使用 `TDialog` 和
`TDialog.actions` 组合 `TDialogAction`。

#### 声明

```dart
class TConfirmDialog extends StatelessWidget
```

#### 默认构造方法


```dart
const TConfirmDialog({
  super.key,
  this.title,
  this.content,
  this.contentWidget,
  this.buttonText,
  this.onPressed,
  this.result = true,
  this.closeOnPressed = true,
  this.showCloseButton = false,
  this.closeButtonResult,
  this.semanticLabel,
  this.buttonStyle,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| buttonStyle | ButtonStyle? | - | 内置确认按钮的显式 Material 样式；透传至 TDialogAction.style。 | 否 |
| buttonText | String? | - | 确认按钮文案；为空时使用资源代理的 knew 文案。 | 否 |
| closeButtonResult | Object? | - | 内置关闭按钮成功关闭时返回的值，默认 null；透传至 `TDialog.closeButtonResult`。 | 否 |
| closeOnPressed | bool | true | 确认按钮点击后是否关闭弹窗，默认 true。 | 否 |
| content | String? | - | 正文文案，与 `contentWidget` 互斥；为空时不显示文字正文。 | 否 |
| contentWidget | Widget? | - | 自定义正文组件，与 `content` 互斥。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onPressed | VoidCallback? | - | 确认按钮点击回调；关闭行为由 `closeOnPressed` 决定。 | 否 |
| result | Object? | true | 确认操作成功关闭弹窗时返回给路由的值，默认 true。 | 否 |
| semanticLabel | String? | - | 弹窗的无障碍语义标签；为空时使用 `title`。 | 否 |
| showCloseButton | bool | false | 是否显示内置关闭按钮，默认 false。 | 否 |
| title | String? | - | 标题文案；为空时不显示标题。 | 否 |


### TDialogThemeData
#### 简介
TDialog 组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认对话框样式。
面板视觉值由本扩展统一配置；未设置时回退 TDesign Token 或组件内置值，
不从 Flutter DialogTheme 读取。

#### 声明

```dart
class TDialogThemeData extends ThemeExtension<TDialogThemeData>
```


#### 静态方法

##### TDialogThemeData.lerpDouble

```dart
static double? lerpDouble(double? a, double? b, double t)
```


对 `a` 和 `b` 按 `t` 线性插值；两端均为 null 时返回 null，仅一端为 null 时按 0 参与计算。

返回类型：`double?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| a | double? | - | 插值起始值；单端为空时按 0 参与插值。 | 是 |
| b | double? | - | 插值目标值；单端为空时按 0 参与插值。 | 是 |
| t | double | - | 插值进度；0 表示起点，1 表示终点。 | 是 |

#### 默认构造方法


```dart
const TDialogThemeData({
  this.backgroundColor,
  this.shape,
  this.elevation,
  this.titleTextStyle,
  this.contentTextStyle,
  this.contentPadding,
  this.maxHeight,
  this.width,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色（对应 Material `DialogThemeData.backgroundColor`） 未配置时使用 bgColorContainer Token。 | 否 |
| contentPadding | EdgeInsetsGeometry? | - | 内容内边距（对应 Material `Dialog` 的 contentPadding；TDesign 扩展） 未配置时左、上、右均使用 spacer3，底部为 0。 | 否 |
| contentTextStyle | TextStyle? | - | 内容文案样式（对应 Material `DialogThemeData.contentTextStyle`） 未配置时使用 fontBodyLarge / textColorSecondary Token。 | 否 |
| elevation | double? | - | 阴影（对应 Material `DialogThemeData.elevation`） 未配置时为 0。 | 否 |
| maxHeight | double? | - | 面板最大高度。 未配置时为视口高度的 80%；同时不超过视口高度减 spacer4，最小为 0。 | 否 |
| shape | ShapeBorder? | - | 形状（圆角；对应 Material `DialogThemeData.shape`） 未配置时使用 radiusExtraLarge Token 构造圆角矩形。 | 否 |
| titleTextStyle | TextStyle? | - | 标题文案样式（对应 Material `DialogThemeData.titleTextStyle`） 未配置时使用 fontTitleLarge / textColorPrimary Token。 | 否 |
| width | double? | - | 弹窗宽度 未配置时为 311 逻辑像素，实际布局仍受可用宽度限制。 | 否 |


#### 实例方法

##### TDialogThemeData.copyWith

```dart
TDialogThemeData copyWith({
  Color? backgroundColor,
  ShapeBorder? shape,
  double? elevation,
  TextStyle? titleTextStyle,
  TextStyle? contentTextStyle,
  EdgeInsetsGeometry? contentPadding,
  double? maxHeight,
  double? width,
})
```


返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TDialogThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色（对应 Material `DialogThemeData.backgroundColor`） 未配置时使用 bgColorContainer Token。 | 否 |
| shape | ShapeBorder? | - | 形状（圆角；对应 Material `DialogThemeData.shape`） 未配置时使用 radiusExtraLarge Token 构造圆角矩形。 | 否 |
| elevation | double? | - | 阴影（对应 Material `DialogThemeData.elevation`） 未配置时为 0。 | 否 |
| titleTextStyle | TextStyle? | - | 标题文案样式（对应 Material `DialogThemeData.titleTextStyle`） 未配置时使用 fontTitleLarge / textColorPrimary Token。 | 否 |
| contentTextStyle | TextStyle? | - | 内容文案样式（对应 Material `DialogThemeData.contentTextStyle`） 未配置时使用 fontBodyLarge / textColorSecondary Token。 | 否 |
| contentPadding | EdgeInsetsGeometry? | - | 内容内边距（对应 Material `Dialog` 的 contentPadding；TDesign 扩展） 未配置时左、上、右均使用 spacer3，底部为 0。 | 否 |
| maxHeight | double? | - | 面板最大高度。 未配置时为视口高度的 80%；同时不超过视口高度减 spacer4，最小为 0。 | 否 |
| width | double? | - | 弹窗宽度 未配置时为 311 逻辑像素，实际布局仍受可用宽度限制。 | 否 |


##### TDialogThemeData.lerp

```dart
TDialogThemeData lerp(ThemeExtension<TDialogThemeData>? other, double t)
```


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TDialogThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TDialogThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


##### TDialogThemeData.merge

```dart
TDialogThemeData merge(TDialogThemeData? other)
```


合并两个 ThemeExtension，`other` 优先于 this

返回类型：`TDialogThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TDialogThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


### TDialogActionRole
#### 简介
Dialog 操作的语义角色。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 次要操作。 |
| primary | 主要操作。 |
| destructive | 危险操作。 |
