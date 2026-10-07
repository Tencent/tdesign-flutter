## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TLoading
#### 简介
展示局部或全屏加载状态的组件。

#### 声明

```dart
class TLoading extends StatelessWidget
```

#### 默认构造方法


```dart
const TLoading({
  Key? key,
  this.size = 20,
  this.icon = TLoadingIcon.circle,
  this.text,
  this.customIcon,
  this.refreshWidget,
})
```

#### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| customIcon | Widget? | - | 自定义加载图标，优先于 `icon`，并按当前 Loading 动画时长持续旋转。 | 否 |
| icon | TLoadingIcon? | TLoadingIcon.circle | 预设图标，支持圆形、点状、菊花状；为 null 时不显示预设图标。 `customIcon` 不为 null 时仍优先显示自定义图标。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| refreshWidget | Widget? | - | 文案后的自定义操作内容 | 否 |
| size | double | 20 | 加载指示器的外部尺寸，单位为逻辑像素，默认为 20。 | 否 |
| text | String? | - | 文案 | 否 |


### TLoadingController
#### 简介
用于命令式显示和关闭加载状态的控制器。

#### 声明

```dart
class TLoadingController
```


#### 静态方法

##### TLoadingController.dismiss

```dart
static void dismiss()
```


移除并释放全局加载层；没有加载层时调用无效，可重复调用。

返回类型：`void`

##### TLoadingController.show

```dart
static void show(
  BuildContext context, {
  Widget? child,
  double size = 20,
  TLoadingIcon? icon = TLoadingIcon.circle,
  String? text,
  TLoadingThemeData? theme,
})
```


在 `context` 的 Overlay 中显示全局加载层。
已有加载层或找不到 Overlay 时不重复创建。`child` 非空时替代内置 TLoading；
否则使用 `size`、`icon` 和 `text` 构建加载内容，text 为空时读取资源代理。

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 当前构建上下文，用于读取祖先配置。 | 是 |
| child | Widget? | - | 替代默认加载内容的自定义组件；为空时由 size、icon 和 text 构建 TLoading。 | 否 |
| size | double | 20 | 加载指示器的外部尺寸，单位为逻辑像素，默认为 20。 | 否 |
| icon | TLoadingIcon? | TLoadingIcon.circle | 预设图标，支持圆形、点状、菊花状；为 null 时不显示预设图标。 `customIcon` 不为 null 时仍优先显示自定义图标。 | 否 |
| text | String? | - | 加载文案；为空时使用资源代理的 loading 文案。 | 否 |
| theme | TLoadingThemeData? | - | 仅作用于本次加载层，未提供时保留捕获的祖先主题。 | 否 |

#### 默认构造方法


```dart
TLoadingController()
```


### TLoadingThemeData
#### 简介
TLoading 组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认加载样式。

#### 声明

```dart
class TLoadingThemeData extends ThemeExtension<TLoadingThemeData>
```

#### 默认构造方法


```dart
const TLoadingThemeData({
  this.iconColor,
  this.textColor,
  this.axis,
  this.duration,
})
```

#### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| axis | Axis? | - | 文案和图标相对方向 | 否 |
| duration | int? | - | 一次刷新的时间（毫秒），控制动画速度。 未指定时默认 `800`ms（对齐 TDesign 小程序 / Mobile Vue 的 `duration` 默认值）。 | 否 |
| iconColor | Color? | - | 图标颜色。 未指定时 circle / point 使用品牌主色，activity 使用主文字色； Flutter `ProgressIndicatorThemeData.color` 或显式 `ColorScheme` 仍优先于内置默认色。 | 否 |
| textColor | Color? | - | 文案颜色 | 否 |


#### 实例方法

##### TLoadingThemeData.copyWith

```dart
TLoadingThemeData copyWith({
  Color? iconColor,
  Color? textColor,
  Axis? axis,
  int? duration,
})
```


返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TLoadingThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| iconColor | Color? | - | 图标颜色。 未指定时 circle / point 使用品牌主色，activity 使用主文字色； Flutter `ProgressIndicatorThemeData.color` 或显式 `ColorScheme` 仍优先于内置默认色。 | 否 |
| textColor | Color? | - | 文案颜色 | 否 |
| axis | Axis? | - | 文案和图标相对方向 | 否 |
| duration | int? | - | 一次刷新的时间（毫秒），控制动画速度。 未指定时默认 `800`ms（对齐 TDesign 小程序 / Mobile Vue 的 `duration` 默认值）。 | 否 |


##### TLoadingThemeData.lerp

```dart
TLoadingThemeData lerp(ThemeExtension<TLoadingThemeData>? other, double t)
```


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TLoadingThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TLoadingThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


##### TLoadingThemeData.merge

```dart
TLoadingThemeData merge(TLoadingThemeData? other)
```


合并两个 ThemeExtension，`other` 优先于 this

返回类型：`TLoadingThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TLoadingThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


### TLoadingIcon
#### 简介
Loading图标
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形 |
| point | 点状 |
| activity | 菊花状 |
