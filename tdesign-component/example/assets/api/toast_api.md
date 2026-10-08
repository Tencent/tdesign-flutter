## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TToast

#### 声明

```dart
class TToast
```


#### 静态方法

##### TToast.dismissAll

```dart
static void dismissAll()
```


关闭所有Toast

返回类型：`void`

##### TToast.dismissToast

```dart
static void dismissToast(String toastId)
```


关闭指定的Toast

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| toastId | String | - | 要关闭的 Toast 实例 ID。 | 是 |


##### TToast.showFail

```dart
static String showFail(
  String? text, {
  IconTextDirection direction = IconTextDirection.horizontal,
  required BuildContext context,
  Duration duration = const Duration(milliseconds: 2000),
  TOverlayConfig? overlay,
  TToastPlacement placement = TToastPlacement.middle,
  Color? backgroundColor,
  int? maxLines,
  TextStyle? textStyle,
  double? iconSize,
  Color? iconColor,
  String? toastId,
})
```


失败提示Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案。 | 是 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 | 否 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


##### TToast.showIconText

```dart
static String showIconText(
  String? text, {
  IconData? icon,
  IconTextDirection direction = IconTextDirection.horizontal,
  required BuildContext context,
  Duration duration = const Duration(milliseconds: 2000),
  TOverlayConfig? overlay,
  TToastPlacement placement = TToastPlacement.middle,
  Color? backgroundColor,
  int? maxLines,
  TextStyle? textStyle,
  double? iconSize,
  Color? iconColor,
  String? toastId,
})
```


带图标的Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案。 | 是 |
| icon | IconData? | - | 左侧或上方图标。 | 否 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 | 否 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


##### TToast.showLoading

```dart
static String showLoading({
  required BuildContext context,
  String? text,
  Duration duration = TToast.infiniteDuration,
  TOverlayConfig? overlay,
  TToastPlacement placement = TToastPlacement.middle,
  Widget? customWidget,
  Color? backgroundColor,
  TextStyle? textStyle,
  double? iconSize,
  Color? iconColor,
  String? toastId,
})
```


带文案的加载Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| text | String? | - | 加载提示文案。 | 否 |
| duration | Duration | TToast.infiniteDuration | 自动关闭时长。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| customWidget | Widget? | - | 自定义加载内容；传入后优先展示。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 加载图标尺寸。 | 否 |
| iconColor | Color? | - | 加载图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


##### TToast.showLoadingWithoutText

```dart
static String showLoadingWithoutText({
  required BuildContext context,
  Duration duration = TToast.infiniteDuration,
  TOverlayConfig? overlay,
  TToastPlacement placement = TToastPlacement.middle,
  Color? backgroundColor,
  double? iconSize,
  Color? iconColor,
  String? toastId,
})
```


不带文案的加载Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | TToast.infiniteDuration | 自动关闭时长。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| iconSize | double? | - | 加载图标尺寸。 | 否 |
| iconColor | Color? | - | 加载图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


##### TToast.showSuccess

```dart
static String showSuccess(
  String? text, {
  IconTextDirection direction = IconTextDirection.horizontal,
  required BuildContext context,
  Duration duration = const Duration(milliseconds: 2000),
  TOverlayConfig? overlay,
  TToastPlacement placement = TToastPlacement.middle,
  Color? backgroundColor,
  int? maxLines,
  TextStyle? textStyle,
  double? iconSize,
  Color? iconColor,
  String? toastId,
})
```


成功提示Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案。 | 是 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 | 否 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


##### TToast.showText

```dart
static String showText(
  String? text, {
  required BuildContext context,
  Duration duration = const Duration(milliseconds: 2000),
  int? maxLines,
  BoxConstraints? constraints,
  TOverlayConfig? overlay,
  TToastPlacement placement = TToastPlacement.middle,
  Widget? customWidget,
  Color? backgroundColor,
  TextStyle? textStyle,
  String? toastId,
})
```


普通文本Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案；为 null 时只展示自定义内容。 | 是 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| constraints | BoxConstraints? | - | Toast 内容约束。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| customWidget | Widget? | - | 自定义内容；传入后优先展示。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |


##### TToast.showWarning

```dart
static String showWarning(
  String? text, {
  IconTextDirection direction = IconTextDirection.horizontal,
  required BuildContext context,
  Duration duration = const Duration(milliseconds: 2000),
  TOverlayConfig? overlay,
  TToastPlacement placement = TToastPlacement.middle,
  Color? backgroundColor,
  int? maxLines,
  TextStyle? textStyle,
  double? iconSize,
  Color? iconColor,
  String? toastId,
})
```


警告Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| text | String? | - | 提示文案。 | 是 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 | 否 |
| context | BuildContext | - | 用于查找 Overlay 的上下文。 | 是 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 | 否 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 | 否 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 | 否 |
| backgroundColor | Color? | - | Toast 背景色。 | 否 |
| maxLines | int? | - | 文案最大行数。 | 否 |
| textStyle | TextStyle? | - | Toast 文案样式。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| toastId | String? | - | 指定实例 ID；不传时自动生成。 | 否 |

#### 默认构造方法


```dart
TToast()
```

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| infiniteDuration | Duration | Duration(seconds: 99999999) | 无限时长哨兵值：加载类 Toast 使用，表示"永不自动消失"。 封装为具名常量，避免魔法数字导致用户传入相近的超长 duration 时被误判为无限。 |


### IconTextDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 横向 |
| vertical | 竖向 |


### TToastPlacement
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| top | 顶部（距屏幕顶部 25%，水平居中） |
| middle | 居中（屏幕正中） |
| bottom | 底部（距屏幕底部 25%，水平居中） |
