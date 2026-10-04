## API
### TToast

#### 静态方法

##### TToast.dismissAll

关闭所有Toast

返回类型：`void`

##### TToast.dismissToast

关闭指定的Toast

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| toastId | String | - | 要关闭的 Toast 实例 ID。 |


##### TToast.showFail

失败提示Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | 提示文案。 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 |
| context | BuildContext | - | 用于查找 Overlay 并捕获当前主题。 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| maxLines | int? | - | 文案最大行数。 |
| textStyle | TextStyle? | - | Toast 文案样式。 |
| iconSize | double? | - | 图标尺寸。 |
| iconColor | Color? | - | 图标颜色。 |
| toastId | String? | - | 指定实例 ID；不传时使用共享匿名 ID，并替换上一条匿名 Toast。 |


##### TToast.showIconText

带图标的Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | 提示文案。 |
| icon | IconData? | - | 左侧或上方图标。 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 |
| context | BuildContext | - | 用于查找 Overlay 并捕获当前主题。 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| maxLines | int? | - | 文案最大行数。 |
| textStyle | TextStyle? | - | Toast 文案样式。 |
| iconSize | double? | - | 图标尺寸。 |
| iconColor | Color? | - | 图标颜色。 |
| toastId | String? | - | 指定实例 ID；不传时使用共享匿名 ID，并替换上一条匿名 Toast。 |


##### TToast.showLoading

带文案的加载Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 并捕获当前主题。 |
| text | String? | - | 加载提示文案。 |
| duration | Duration | TToast.infiniteDuration | 自动关闭时长。 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 |
| customWidget | Widget? | - | 自定义加载内容；传入后优先展示。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| textStyle | TextStyle? | - | Toast 文案样式。 |
| iconSize | double? | - | 加载图标尺寸。 |
| iconColor | Color? | - | 加载图标颜色。 |
| toastId | String? | - | 指定实例 ID；不传时使用共享匿名 ID，并替换上一条匿名 Toast。 |


##### TToast.showLoadingWithoutText

不带文案的加载Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 并捕获当前主题。 |
| duration | Duration | TToast.infiniteDuration | 自动关闭时长。 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| iconSize | double? | - | 加载图标尺寸。 |
| iconColor | Color? | - | 加载图标颜色。 |
| toastId | String? | - | 指定实例 ID；不传时使用共享匿名 ID，并替换上一条匿名 Toast。 |


##### TToast.showSuccess

成功提示Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | 提示文案。 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 |
| context | BuildContext | - | 用于查找 Overlay 并捕获当前主题。 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| maxLines | int? | - | 文案最大行数。 |
| textStyle | TextStyle? | - | Toast 文案样式。 |
| iconSize | double? | - | 图标尺寸。 |
| iconColor | Color? | - | 图标颜色。 |
| toastId | String? | - | 指定实例 ID；不传时使用共享匿名 ID，并替换上一条匿名 Toast。 |


##### TToast.showText

普通文本Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | 提示文案；为 null 时只展示自定义内容。 |
| context | BuildContext | - | 用于查找 Overlay 并捕获当前主题。 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 |
| maxLines | int? | - | 文案最大行数。 |
| constraints | BoxConstraints? | - | Toast 内容约束。 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 |
| customWidget | Widget? | - | 自定义内容；传入后优先展示。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| textStyle | TextStyle? | - | Toast 文案样式。 |
| toastId | String? | - | 指定实例 ID；不传时使用共享匿名 ID，并替换上一条匿名 Toast。 |


##### TToast.showWarning

警告Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | 提示文案。 |
| direction | IconTextDirection | IconTextDirection.horizontal | 图标与文案排列方向。 |
| context | BuildContext | - | 用于查找 Overlay 并捕获当前主题。 |
| duration | Duration | const Duration(milliseconds: 2000) | 自动关闭时长。 |
| overlay | TOverlayConfig? | - | 蒙层行为配置（可见遮罩、拦截点击等）。 |
| placement | TToastPlacement | TToastPlacement.middle | Toast 展示位置。 |
| backgroundColor | Color? | - | Toast 背景色。 |
| maxLines | int? | - | 文案最大行数。 |
| textStyle | TextStyle? | - | Toast 文案样式。 |
| iconSize | double? | - | 图标尺寸。 |
| iconColor | Color? | - | 图标颜色。 |
| toastId | String? | - | 指定实例 ID；不传时使用共享匿名 ID，并替换上一条匿名 Toast。 |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| infiniteDuration | Duration | - | 无限时长哨兵值：加载类 Toast 使用，表示"永不自动消失"。 封装为具名常量，避免魔法数字导致用户传入相近的超长 duration 时被误判为无限。 |


### TOverlayConfig
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| color | Color? | - | 蒙层颜色；为 null 时由 `opacity` 派生黑色蒙层。 |
| opacity | double | 0.2 | 蒙层透明度（0~1，默认 0.2）。 |
| preventTap | bool | false | 是否拦截背景点击（默认 false）。 |
| showOverlay | bool | false | 是否显示可见半透明蒙层（默认 false）。 |


### TToastThemeData

#### 静态方法

##### TToastThemeData.lerpDouble

返回类型：`double?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| a | double? | - | - |
| b | double? | - | - |
| t | double | - | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色 |
| borderRadius | double? | - | 圆角 |
| iconColor | Color? | - | 图标颜色 |
| iconSize | double? | - | 图标尺寸 |
| maxWidth | double? | - | 最大宽度 |
| padding | EdgeInsetsGeometry? | - | 内边距 |
| textStyle | TextStyle? | - | 文案样式 |


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
