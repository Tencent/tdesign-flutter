## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TToast
#### 简介
轻提示组件
支持文本、图标、加载中等样式。
实例语义：
- 未指定 `toastId` 时，所有匿名 Toast 共用同一个内部实例，
后一次展示会替换前一次，避免重复点击叠加多个 Toast 导致半透明背景
不断加深；
- 指定不同 `toastId` 时，可多实例并存；
- 指定相同 `toastId` 时，后一次替换前一次。

#### 静态方法

##### TToast.dismissAll

关闭所有Toast

返回类型：`void`

##### TToast.dismissToast

关闭指定的Toast

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| toastId | String | - | 要关闭的 Toast 实例 ID。 | 是 |


##### TToast.showFail

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
`TToast()`

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| infiniteDuration | Duration | Duration(seconds: 99999999) | 无限时长哨兵值：加载类 Toast 使用，表示"永不自动消失"。 封装为具名常量，避免魔法数字导致用户传入相近的超长 duration 时被误判为无限。 |


### TOverlayConfig
#### 简介
蒙层行为配置
统一收敛 Toast 展示期间遮罩层的各项行为：
- `showOverlay`：是否显示可见半透明蒙层（与 `preventTap` 解耦，
`true` 时展示半透明黑色蒙层遮住背景）；
- `color` / `opacity`：蒙层颜色与透明度，`color` 为 null 时由
`Colors.black.withValues(alpha: opacity)` 派生黑色蒙层；
- `preventTap`：是否拦截背景点击（与蒙层是否可见解耦，
`true` 时展示期间背景不可点击）。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| color | Color? | - | 蒙层颜色；为 null 时由 `opacity` 派生黑色蒙层。 | 否 |
| opacity | double | 0.2 | 蒙层透明度（0~1，默认 0.2）。 | 否 |
| preventTap | bool | false | 是否拦截背景点击（默认 false）。 | 否 |
| showOverlay | bool | false | 是否显示可见半透明蒙层（默认 false）。 | 否 |


### TToastThemeData
#### 简介
TToast 组件级 ThemeExtension

#### 静态方法

##### TToastThemeData.lerpDouble

对 `a` 和 `b` 按 `t` 线性插值；两端均为 null 时返回 null，仅一端为 null 时按 0 参与计算。

返回类型：`double?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| a | double? | - | 插值起始值；单端为空时按 0 参与插值。 | 是 |
| b | double? | - | 插值目标值；单端为空时按 0 参与插值。 | 是 |
| t | double | - | 插值进度；0 表示起点，1 表示终点。 | 是 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色 | 否 |
| borderRadius | double? | - | 圆角 | 否 |
| iconColor | Color? | - | 图标颜色 | 否 |
| iconSize | double? | - | 图标尺寸 | 否 |
| maxWidth | double? | - | 最大宽度 | 否 |
| padding | EdgeInsetsGeometry? | - | 内边距 | 否 |
| textStyle | TextStyle? | - | 文案样式 | 否 |


#### 实例方法

##### TToastThemeData.merge

合并其他 ThemeData，非空字段优先取 `other`

返回类型：`TToastThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TToastThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


### IconTextDirection
#### 简介
Toast 文案排列方向
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 横向 |
| vertical | 竖向 |


### TToastPlacement
#### 简介
Toast 展示位置
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| top | 顶部（距屏幕顶部 25%，水平居中） |
| middle | 居中（屏幕正中） |
| bottom | 底部（距屏幕底部 25%，水平居中） |
